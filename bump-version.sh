#!/bin/sh
# -*- mode: Shell-script; coding: utf-8; -*-
#
# in:
#   utils/bump-version/bump-version.sh
# update:
#   2017-03-19,
#   2018-10-01,

if [ $# -ne 1 ]; then
    echo usage: $0 VERSION
    exit
else
    VERSION=$1
fi

TODAY=`date +%F`

# linux's sed is gnu sed, macos not.
if [ -e /usr/local/bin/gsed ]; then
    SED=/usr/local/bin/gsed
else
    SED=`which sed`
fi
if [ -z ${SED} ]; then
    echo can not find SED
    exit
fi

for i in *.rkt; do
    ${SED} -i.bak "/(define VERSION/ c\
(define VERSION \"${VERSION}\")" $i
done
