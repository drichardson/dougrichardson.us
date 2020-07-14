#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit

SITES="dougrichardson.us"

cat <<'EOF'
#!/bin/bash
set -xeuo pipefail
shopt -s inherit_errexit

# Give everyone permission to /var/www so the deploy.sh script can run
# as any user.
echo Setup /var/www
mkdir -p /var/www
chmod 777 /var/www

apt-get -y update
apt-get -y install nginx certbot python-certbot-nginx

echo Disable certbot default timer and service, using our own.
systemctl stop certbot.service
systemctl stop certbot.timer
EOF

#
# This script requires the working directory to be the one that contains this script.
#
SCRIPTDIR=$(dirname $BASH_SOURCE)
cd $SCRIPTDIR

# Add the nginx configurations

addsite() {
	local SITE=$1
	echo
	echo echo BEGIN: Install nginx configuration for $SITE
	# Use quoted here document delimiters to prevent any variable expansion in
	# nginx config files in the built script.
	local HEREDOCDELIM=$(uuidgen)
	echo mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled
	echo "cat > /etc/nginx/sites-available/$SITE <<'$HEREDOCDELIM'"
	cat ./nginx-sites-available/$SITE
	echo $HEREDOCDELIM

	cat <<-EOF_OUTER
	cat > /usr/bin/renew-certificate-$SITE.sh <<EOF
	#!/bin/bash
	echo Renewing certificate for $SITE
	certbot certonly -n --standalone -m doug@rekt.email --agree-tos -d $SITE
	EOF
	chmod 755 /usr/bin/renew-certificate-$SITE.sh

	ln -sf /etc/nginx/sites-available/$SITE /etc/nginx/sites-enabled/$SITE
	echo DONE: Install nginx configuration for $SITE
	EOF_OUTER
}


for SITE in $SITES; do
	addsite $SITE
done

cat <<'EOF_OUTER'
if [[ -f /etc/nginx/sites-enabled/default ]]; then
	rm /etc/nginx/sites-enabled/default
fi

# dhparams from https://ssl-config.mozilla.org/#server=nginx&server-version=1.17.0&config=intermediate
# curl https://ssl-config.mozilla.org/ffdhe2048.txt > /path/to/dhparam.pem
cat > /etc/nginx/mozilla-dhparam.pem <<'EOF'
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA//////////+t+FRYortKmq/cViAnPTzx2LnFg84tNpWp4TZBFGQz
+8yTnc4kmz75fS/jY2MMddj2gbICrsRhetPfHtXV/WVhJDP1H18GbtCFY2VVPe0a
87VXE15/V8k1mE8McODmi3fipona8+/och3xWKE2rec1MKzKT0g6eXq8CrGCsyT7
YdEIqUuyyOP7uWrat2DX9GgdT0Kj3jlN9K5W7edjcrsZCwenyO4KbXCeAvzhzffi
7MA0BM0oNC9hkXL+nOmFg/+OTxIy7vKBg8P+OxtMb61zO7X8vC7CIAXFjvGDfRaD
ssbzSibBsu/6iGtCOGEoXJf//////////wIBAg==
-----END DH PARAMETERS-----
EOF

cat > /usr/bin/renew-all-certificates.sh <<'EOF'
#!/bin/bash

systemctl stop nginx

for script in /usr/bin/renew-certificate-*.sh; do
	bash $script
done

systemctl start nginx

EOF
chmod 755 /usr/bin/renew-all-certificates.sh

cat > /etc/systemd/system/renew-all-certificates.service <<'EOF'
[Unit]
Description=Renew Site Certificates
[Service]
Type=oneshot
ExecStart=/usr/bin/renew-all-certificates.sh
EOF

cat > /etc/systemd/system/renew-all-certificates.timer <<'EOF'
[Unit]
Description=Run certbot renewal twice daily

[Timer]
OnCalendar=*-*-* 00,12:00:00
RandomizedDelaySec=43200
Persistent=true

[Install]
WantedBy=timers.target
EOF

echo Renewing/installing certificates...
/usr/bin/renew-all-certificates.sh

echo Starting certificate renewal timers...
systemctl daemon-reload
systemctl start renew-all-certificates.timer

apt-get autoremove -y

echo website startup script completed successfully
EOF_OUTER

