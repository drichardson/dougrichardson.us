#!/bin/bash

set -uoe pipefail

URL=$1
shift

echo "Checking links for $URL"

muffet "$URL" --verbose \
  -e "linkedin.com/in/douglasrichardson" \
  -e "stackexchange.com/a/" \
  -e "http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf" \
  -e "https://github.com/EpicGames/UnrealEngine"

echo "All links okay"
