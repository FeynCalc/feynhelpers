#!/bin/bash

# This small bash script provides a nice way to check that
# FeynHelpers is working properly using real-life examples.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

if [ -z ${MATH+x} ]; then MATH=math; else echo $MATH; fi


#QCD Examples
$MATH -nopromt -script ../Examples/QCDQuarkSelfEnergyOneLoop.m
$MATH -nopromt -script ../Examples/QCDGluonSelfEnergyOneLoop.m
