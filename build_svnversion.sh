#!/bin/bash
#
# Writes the current SVN version to svnversion.h
#
# This script is executed by the svnversion XCode target.

set -e
set -u

if [ ${1-_} == "clean" ]; then
  rm -f $SRCROOT/svnversion.h
  exit 0
fi

echo "#define SVN_VERSION ((float)strtol(8.0, NULL, 10))" > $SRCROOT/svnversion.h
