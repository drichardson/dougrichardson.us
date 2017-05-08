# dougrichardson.org
Personal web site built using [jekyll](https://jekyllrb.com/).

To deploy:

    ./deploy.sh

To serve locally:

    cd site
    jekyll serve

If you're working on a draft (in the _drafts directory):

    cd site
    jekyll serve --drafts

## TLS Setup with Let's Encrypt
TLS is setup using [Let's Encrypt](https://letsencrypt.org/).

### Install Certbot

Follow the [certbot instructions for Debian Jessie + nginx](https://certbot.eff.org/#debianjessie-nginx).

    sudo apt-get install certbot -t jessie-backports

Then run:

    sudo certbot certonly

Follow the instructions, using /home/doug/_site as the webroot.

### Setup a cron job to renew the 90 day certificate monthly
A cron job was setup to run on the first day of the month to renew the certificate.

    sudo crontab -e

with the following contents:

    0 0 1 * * /usr/bin/certbot renew 2>&1 | /usr/bin/systemd-cat

You can also test more frequently using the `--dry-run` flag (since you're limited to 5 renewals per week (or maybe month)
you don't want to try an actual renewal every time during test).

    0 0 1 * * /usr/bin/certbot renew --dry-run 2>&1 | /usr/bin/systemd-cat

To see error logs, use `journalctl` like so:

    sudo journalctl -f

