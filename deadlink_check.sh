#!/bin/bash

set -uoe pipefail

URL=$1
shift

echo "Checking links for $URL"

muffet "$URL" --verbose --exclude "linkedin.com/in/douglasrichardson" -e "stackexchange.com/a/"

echo "All links okay"
