#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

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
jekyll build
rsync -av _site dougrichardson.org:/home/doug
popd

SITE="https://dougrichardson.org"

./deadlink_check.sh "$SITE"

echo "Telling Google to check out the sitemap again..."
curl "https://google.com/ping?sitemap=$SITE/sitemap.xml"

echo "OK"
