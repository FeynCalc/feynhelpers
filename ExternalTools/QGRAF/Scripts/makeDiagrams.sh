#!/bin/bash

# This file is a part of FeynHelpers
# FeynHelpers is covered by the GNU General Public License 3.
# Copyright (C) 2017-2024 Vladyslav Shtabovenko

# Stop if any of the commands fails
set -e

fcScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
fcDiagrams=()

readarray -d '' fcDiagrams < <(find ${fcScriptDir} -type f -name "*.tex" -print0);
mkdir -p diagrams
parallel --bar --progress -j4 lualatex -interaction=nonstopmode --output-directory=${fcScriptDir}/diagrams {1} ::: "${fcDiagrams[@]}" > ${fcScriptDir}/diagrams/TeXOutput.log
