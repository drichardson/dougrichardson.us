#!/bin/bash
set -euo pipefail
shopt -s inherit_errexit

HOSTNAME="dougrichardson.org"

assert_jekyll_not_running()
{
    set +e
    ps -a -o pid,cmd|grep jekyll|grep -v grep
    if [[ $? == 0 ]]; then
        echo "A copy of jekyll is already running (possibly via ./serve.h). Stop it and then re-run this script."
        exit 1
    fi
    set -e
}

assert_muffet_installed() {
    set +e
    which muffet
    if [[ $? != 0 ]]; then
        echo "muffet not installed. Install with: go get github.com/raviqqe/muffet"
        echo "muffet is used to check links"
        exit 1
    fi
    set -e
}

build() {
    echo Building...

    pushd site
    bundle exec jekyll clean
    JEKYLL_ENV=production bundle exec jekyll build
    popd

    ./update-mathjax.sh
}

validate_xml() {
    echo Validating XML Syntax...
    find site/_site -name '*.xml' -print0 | xargs -0 xmllint --noout

    echo "Validating sitemap against schema..."
    xmllint --noout --schema schemas/sitemap.xsd site/_site/sitemap.xml
}

validate_rss() {
    echo TODO Validating ATOM RSS...
    # xmllint --noout --schema schemas/atom.xsd site/_site/feed.rss
}

validate_html() {
    echo Validating HTML...

    set +e
    for file in $(find site/_site/ -name '*.html'); do
        tidy -errors -quiet $file
        if [[ $? != 0 ]]; then
            echo HTML validation failure in $file
            exit 1
        fi
    done
    set -e
}

validate_jsonld() {
    echo TODO: Validating JSON-LD...
}

validate_css() {
    echo TODO: Validating CSS...
}

validate_all() {
    validate_xml
    # RSS validation disabled due to error about not being deterministic.
    validate_rss
    validate_html
    validate_jsonld
    validate_css
}

deploy() {
    echo "Deploying..."
    echo "Make sure your google compute SSH identity is added. If not, use:"
    echo "   ssh-add ~/.ssh/google_compute_engine" 
    echo "   ssh-add ~/.ssh/google_compute_engine_PERSONAL"
    pushd site
    rsync -av --delete _site/ $HOSTNAME:/var/www/$HOSTNAME
    popd
}

deadlink_check() {
    # Dead link checking has to happen after site is live.
    echo "Dead link checking..."
    SITE="https://$HOSTNAME"

    set +e
    ./deadlink_check.sh "$SITE"
    if [[ $? != 0 ]]; then
        echo Dead link check failed
        exit 1
    fi
    set -e
}

google_request_reindex() {
    echo "Telling Google to check out the sitemap again..."
    curl "https://google.com/ping?sitemap=$SITE/sitemap.xml"
}

main() {
    assert_jekyll_not_running
    assert_muffet_installed
    build
    validate_all
    deploy
    deadlink_check
    google_request_reindex

    echo "OK"
}

main

