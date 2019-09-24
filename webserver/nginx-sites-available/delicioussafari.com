#
# Redirect to github page to prepare for no longer owning delicioussafari.com.
#
server {
    listen 80;
    listen [::]:80;
    server_name delicioussafari.com;
    return 301 https://drichardson.github.io/DeliciousSafari;
}

server {
    # for debugging only
    # error_log	/var/log/nginx/delicioussafari.com.error.log debug;

    #
    # SSL configuration
    #
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name delicioussafari.com;

    expires 5m;

    return 301 https://drichardson.github.io/DeliciousSafari;

    ssl_certificate /etc/letsencrypt/live/delicioussafari.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/delicioussafari.com/privkey.pem;
}

