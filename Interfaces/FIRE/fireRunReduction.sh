#!/bin/sh

if [[ $# -ne 3 ]] ; then
    echo 'You must specify the FIRE binary path, the topology directory and the name of the config file'
    exit 0
fi

fireBinary="$1"
topoDir="$2"
configFile="$3"

if [ ! -d "$topoDir" ] 
then
    echo "Directory $topoDir does not exist." 
    exit 1
fi

if [ ! -f "$topoDir"/"$configFile".config ] 
then
    echo "Config file $topoDir/$configFile.config does not exist." 
    exit 1
fi

cd "$topoDir";

echo "fireRunReduction.sh: Working directory: $(pwd)"
echo "fireRunReduction.sh: Config file: $configFile"
echo "fireRunReduction.sh: FIRE binary: $fireBinary"

"$fireBinary" -c "$configFile"
