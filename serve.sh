#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

cd site
bundle exec jekyll serve

