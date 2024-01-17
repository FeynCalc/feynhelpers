#!/bin/sh

if [[ $# -ne 3 ]] ; then
    echo 'You must specify the Mathematica binary path, the integral directory and the name of the script file'
    exit 0
fi

mathBinary="$1"
intDir="$2"
scriptFile="$3"

if [ ! -d "$intDir" ] 
then
    echo "Directory $intDir does not exist." 
    exit 1
fi

if [ ! -f "$intDir"/"$scriptFile" ] 
then
    echo "Start file $intDir/$scriptFile does not exist." 
    exit 1
fi

cd "$intDir";

echo "fiestaRunIntegration.sh: Working directory: $(pwd)"
echo "fiestaRunIntegration.sh: Script file: $scriptFile"
echo "fiestaRunIntegration.sh: Mathematica binary: $mathBinary"

"$mathBinary" -noprompt -script "$intDir"/"$scriptFile"
