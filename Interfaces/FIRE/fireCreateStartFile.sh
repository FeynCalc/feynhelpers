#!/bin/sh

if [[ $# -ne 3 ]] ; then
    echo 'You must specify the Mathematica binary path, the topology directory and the name of the start file'
    exit 0
fi

mathBinary="$1"
topoDir="$2"
startFile="$3"

if [ ! -d "$topoDir" ] 
then
    echo "Directory $topoDir does not exist." 
    exit 1
fi

cd "$topoDir";
"$mathBinary" -noprompt -script "$startFile"
