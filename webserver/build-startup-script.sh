#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit

SITES="dougrichardson.org delicioussafari.com"

cat <<'EOF'
#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit

echo Entering build-startup-script.sh

# Give everyone permission to /var/www so the deploy.sh script can run
# as any user.
echo Setup /var/www
mkdir -p /var/www
chmod 777 /var/www

echo Installing packages
apt-get update
apt-get upgrade -y

echo Install nginx
apt-get install -y nginx rsync

echo Stopping nginx so certbot can run, if necessary.
systemctl stop nginx

if [[ -f /etc/nginx/sites-enabled/default ]]; then
    rm /etc/nginx/sites-enabled/default
fi

echo Install Certbot packages
apt-get -y install software-properties-common
add-apt-repository universe
add-apt-repository ppa:certbot/certbot
apt-get -y update
apt-get -y install certbot python-certbot-nginx

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

    cat <<EOF

ln -sf /etc/nginx/sites-available/$SITE /etc/nginx/sites-enabled/$SITE
echo DONE: Install nginx configuration for $SITE

if [[ ! -f /etc/letsencrypt/live/$SITE/fullchain.pem ]]; then
    echo "Missing let's encrypt certificate for $SITE. Need to run certbot."
    certbot certonly -n --standalone -m doug@rekt.email --agree-tos -d $SITE
fi

EOF

}


for SITE in $SITES; do
    addsite $SITE
done

cat <<'EOF'

#
# Remove anything unused
#
apt-get autoremove -y

#
# Check for reboot last, so that we make sure to reboot if anything 
# installs that requires a reboot.
#
if [[ -f /var/run/reboot-required ]]; then
    echo Reboot required. Rebooting now.
    reboot
    exit
fi

echo Starting nginx up again...
systemctl start nginx

echo website startup script completed successfully
EOF

