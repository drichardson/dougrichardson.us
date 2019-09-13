# Google Compute Engine Webserver Instance Scripts

These scripts help you create the instance in Google Compute Engine.


Run `./webserver.sh` to create a google compute engine instance to run the website. After
running this script, you can use the deploy scripts to copy the content over.

Note, because Let's Encrypt's certbot is used to obtain the SSL certificates, and the domain
validation it does requires the instanced to be mapped to the DNS address it is validating,
you must first stop any other servers from handling requests at that domain. This is most
easily done by detatching the Static IP address named 
[webserver](https://console.cloud.google.com/networking/addresses/list?project=doug-richardson&addressesTablesize=50)
from the instance that is currently using it, and then running the `./webserver.sh` script.
