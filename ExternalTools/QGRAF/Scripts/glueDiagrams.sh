#!/bin/bash

# This file is a part of FeynHelpers
# FeynHelpers is covered by the GNU General Public License 3.
# Copyright (C) 2017-2024 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

fcScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
fcDiagrams=()

nfiles=$(find ${fcScriptDir} -type f -name "*.pdf" | wc -l)
readarray -d '' fcDiagrams < <(find ${fcScriptDir}/diagrams -type f -name "*.pdf" -print0);

sliceSize=100
nSlices=$(($nfiles / $sliceSize))
nRest=$(($nfiles % $sliceSize))

if [ "$nRest" -eq 0 ]; then
    nSlices=$((nSlices-1))
fi

for i in `seq 0 $nSlices`; do
    from=$((($i)*$sliceSize))    
    curFiles=()
    for j in "${fcDiagrams[@]:$from:$sliceSize}"; do		
      curFiles="${curFiles} $j"
    done    
    pdfunite $curFiles ${fcScriptDir}/temp."$i".pdf
done

# Final gluing
curFiles=()
for i in `seq 0 $nSlices`; do
    curFiles="${curFiles} ${fcScriptDir}/temp."$i".pdf"
done
pdfunite $curFiles  ${fcScriptDir}/allDiagrams.pdf

# Final cleanup
find ${lsclGraphDir} -name 'temp.*.pdf' -type f -delete
