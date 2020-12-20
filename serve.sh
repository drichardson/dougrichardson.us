#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

./update-mathjax.sh

cd site
bundle exec jekyll serve --drafts -H 0.0.0.0 --livereload

