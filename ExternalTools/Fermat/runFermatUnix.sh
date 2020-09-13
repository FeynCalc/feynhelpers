#!/bin/sh

# Stop if any of the commands fails
set -e

scriptDir="$(cd "$(dirname "$0")"; pwd)";

OS="`uname`"

case $OS in
  'Linux')
    fermatPath="$scriptDir"/ferl64/fer64
    ;;
  'Darwin') 
    fermatPath="$scriptDir"/ferm64/fer64
    ;;
  *)
    echo "Error, unknown operating system!"
    exit -1
    ;;
esac

cat $1 | $fermatPath
