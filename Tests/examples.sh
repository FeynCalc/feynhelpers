#!/bin/bash

# This small bash script provides a nice way to check that
# FeynHelpers is working properly using real-life examples.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

if [ -z ${MATH+x} ]; then MATH=math; else echo $MATH; fi

#QED Examples
$MATH -nopromt -script ../Examples/QED/QEDABJAxialAnomaly.m
$MATH -nopromt -script ../Examples/QED/QEDElectronGMinusTwoOneLoop.m

#QCD Examples
$MATH -nopromt -script ../Examples/QCD/QCDQuarkSelfEnergyOneLoop.m
$MATH -nopromt -script ../Examples/QCD/QCDGluonSelfEnergyOneLoop.m

#Other Examples
$MATH -nopromt -script ../Examples/UVCheck.m
