#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

set +e
ps -a -o pid,cmd|grep jekyll|grep -v grep
if [[ $? == 0 ]]; then
    echo "A copy of jekyll is already running (possibly via ./serve.h). Stop it and then re-run this script."
    exit 1
fi
set -e

./update-mathjax.sh

set +e
which muffet
if [[ $? != 0 ]]; then
  echo "muffet not installed. Install with: go get github.com/raviqqe/muffet"
  echo "muffet is used to check links"
  exit 1
fi
set -e

echo "Deploying..."
echo "Make sure your google compute SSH identity is added. If not, use:"
echo "   ssh-add ~/.ssh/google_compute_engine" 
echo "   ssh-add ~/.ssh/google_compute_engine_PERSONAL"

pushd site
bundle exec jekyll clean
JEKYLL_ENV=production bundle exec jekyll build
rsync -av --delete _site/ dougrichardson.org:/var/www/dougrichardson.org
popd

SITE="https://dougrichardson.org"

set +e
./deadlink_check.sh "$SITE"
if [[ $? != 0 ]]; then
  echo Dead link check failed
  exit 1
fi
set -e

echo "Telling Google to check out the sitemap again..."
curl "https://google.com/ping?sitemap=$SITE/sitemap.xml"

echo "OK"
