#!/bin/bash
# Copy the version of MathJax in the sub-module to the MATHJAX_OUTPUT_DIR.
# If you want to change the version of MathJax used, checkout that
# version in the submodule.

MATHJAX_OUTPUT_DIR=./site/assets/mathjax

set -euo pipefail
shopt -s inherit_errexit

if [[ ! -f update-mathjax.sh ]]; then
    echo This script must be run from the top level directory that contains update-mathjax.sh
    exit 1
fi

echo "Updating MathJax repository"
git submodule update --init --recursive

if [[ -e "$MATHJAX_OUTPUT_DIR" ]]; then
    echo Deleting $MATHJAX_OUTPUT_DIR
    rm -r "$MATHJAX_OUTPUT_DIR"
fi


# Instructions from https://github.com/mathjax/MathJax#hosting-your-own-copy-of-the-mathjax-components
echo "Copying MathJax/cs5 to $MATHJAX_OUTPUT_DIR"
cp -R MathJax/es5 "$MATHJAX_OUTPUT_DIR"
