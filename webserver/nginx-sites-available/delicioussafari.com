#
# Redirect to github page to prepare for no longer owning delicioussafari.com.
#
server {
    listen 80;
    listen [::]:80;
    server_name delicioussafari.com;
    return 301 https://drichardson.github.io/DeliciousSafari;
}

