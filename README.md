# dougrichardson.org
Personal web site built using [jekyll](https://jekyllrb.com/).

## Pre-requisites

### Website Compute Engine Instance

See webserver/README.md for information on instance setup.

### Software

```bash
gem install bundler
cd site
bundle install

```

### Muffet

Install muffet for dead link checking and ruby gems defined in site/Gemfile
which is used to generate the sitemap.

  go get github.com/raviqqe/muffet
  cd site
  bundle


## To deploy

    ./deploy.sh

## Development

To serve locally:

    ./serve.sh

or if you're running from a VM and viewing from a browser on another computer:

    cd site
    bundle exec jekyll serve -H 0.0.0.0

If you're working on a draft (in the _drafts directory):

    cd site
    bundle exec jekyll serve --drafts

## TLS Setup with Let's Encrypt
TLS is setup using [Let's Encrypt](https://letsencrypt.org/). The configuration occurs in the
webserver instance setup. See webserver/README.md for more information.

