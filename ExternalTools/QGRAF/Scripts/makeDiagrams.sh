#!/bin/bash

# This file is a part of FeynHelpers
# FeynHelpers is covered by the GNU General Public License 3.
# Copyright (C) 2017-2024 Vladyslav Shtabovenko

# Usage examples
# ./makeDiagrams.sh --pjobs 8
# ./makeDiagrams.sh --onlydias 1, 2, 7, 18 --pjobs 4
# Stop if any of the commands fails
set -e

if [[ $# -lt 1 ]] ; then
	echo 'You must specify the number of cores to be used by GNU parallel.'
	exit 0
fi

fcScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
fcDiagrams=()
chosenDiagrams=()
lsclParallelJobs=4
lsclScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

while [[ ${#} -gt 0 ]]; do
case ${1} in
	#Extra shell script parameters
	--onlydias)
	 while (( "$#" >= 2 )) && ! [[ $2 = --* ]]; do
	  chosenDiagrams+=( "$2" )
	  shift
	done
	;;
	 #Number of requested GNU parallel jobs
	--pjobs)
	  lsclParallelJobs=${2}
	  shift
	  shift
	  ;;
	#Basic input parameters
	*)
	  lsclBasicArguments+=("$1")
	  shift;
	  ;;
esac
done

echo "Running with ${lsclParallelJobs} parallel jobs."

if [ ${#chosenDiagrams[@]} -eq 0 ]; then
	echo "Compiling all diagrams"
	readarray -d '' fcDiagrams < <(find ${fcScriptDir} -type f -name "*.tex" -print0);
else
	echo "Only selected diagrams will be compiled: ${chosenDiagrams[*]}"
	for i in "${chosenDiagrams[@]}"; do
	 fcDiagrams+=("dia-${i}.tex")
	done
fi

mkdir -p diagrams
parallel --bar --progress -j${lsclParallelJobs} lualatex -interaction=nonstopmode --output-directory=${fcScriptDir}/diagrams {1} ::: "${fcDiagrams[@]}" > ${fcScriptDir}/TeXOutput.log
find ${fcScriptDir}/diagrams/ -name "*.aux" -delete
find ${fcScriptDir}/diagrams/ -name "*.log" -delete
