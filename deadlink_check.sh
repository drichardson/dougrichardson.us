#!/bin/bash

set -uoe pipefail

URL=$1
shift

which muffet > /dev/null
if [[ $? -ne 0 ]]; then
	echo muffet not installed. Run:
	echo   go get github.com/raviqqe/muffet
	echo Also make sure muffet is in your PATH.
	exit 1
fi

echo "Checking links for $URL"

# Use an actual browser user agent to get around browser sniffing issues.
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0"

muffet \
	--header="User-Agent: $USER_AGENT" \
	--verbose \
	-e "http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf" \
	-e "https://github.com/EpicGames/UnrealEngine" \
	-e "https://www.linkedin.com" \
	"$URL"

echo "All links okay"
