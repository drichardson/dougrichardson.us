# dougrichardson.us

Personal web site built using [jekyll](https://jekyllrb.com/).

## Pre-requisites

### Webserver Instance

See webserver/README.md for information on instance setup.

### Software

- [jekyll](https://jekyllrb.com/) - static site generator
- [bundler](https://bundler.io/) - ruby application gem manager
- [tidy](https://www.html-tidy.org/) - HTML validator
- RSS validator? - Try the W3C's [FeedValidator](https://sourceforge.net/projects/feedvalidator/)
- JSON-LD validator? - See [Google Structured Data Testing Tool](https://search.google.com/structured-data/testing-tool).
- [Muffet](https://github.com/raviqqe/muffet) - dead link checker. Requires [Go](https://golang.org/doc/install).

```bash
gem install bundler
cd site
bundle install

sudo apt-get install -y libxml2-utils tidy

go get github.com/raviqqe/muffet
```

## Deploy

    ./deploy.sh

## Run Development Server

    ./serve.sh

