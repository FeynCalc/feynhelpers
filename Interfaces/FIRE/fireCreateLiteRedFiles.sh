#!/bin/sh

if [[ $# -ne 3 ]] ; then
    echo 'You must specify the Mathematica binary path, the topology directory and the name of the LR file'
    exit 0
fi

mathBinary="$1"
topoDir="$2"
lrFile="$3"

if [ ! -d "$topoDir" ] 
then
    echo "Directory $topoDir does not exist." 
    exit 1
fi

if [ ! -f "$topoDir"/"$lrFile" ] 
then
    echo "Start file $topoDir/$lrFile does not exist." 
    exit 1
fi

cd "$topoDir";

echo "fireCreateLiteRedFiles.sh: Working directory: $(pwd)"
echo "fireCreateLiteRedFiles.sh: LiteRed file: $lrFile"
echo "fireCreateLiteRedFiles.sh: Mathematica binary: $mathBinary"

"$mathBinary" -noprompt -script "$topoDir"/"$lrFile"
