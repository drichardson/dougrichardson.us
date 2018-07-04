#!/bin/bash

unzippedLogs=$(ls -1 logs/access.log*|grep -v ".gz")

zcat logs/access.log*.gz | cat - $unzippedLogs | goaccess -a --log-format '%h %^[%d:%t %^] "%r" %s %b' --date-format '%d/%b/%Y'  --time-format '%H:%M:%S'
