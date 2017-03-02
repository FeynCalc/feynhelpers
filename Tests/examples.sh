#!/bin/bash

# This small bash script provides a nice way to check that
# FeynHelpers is working properly using real-life examples.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

if [ -z ${MATH+x} ]; then MATH=math; else echo $MATH; fi

#QED Examples
$MATH -nopromt -script ../Examples/QED/QEDABJAxialAnomaly.m
$MATH -nopromt -script ../Examples/QED/QEDElectronGMinusTwoOneLoop.m
$MATH -nopromt -script ../Examples/QED/QEDRenormalizationOneLoop.m
$MATH -nopromt -script ../Examples/QED/MasslessQEDSelfEnergiesTwoLoops.m
$MATH -nopromt -script ../Examples/QED/QEDToEulerHeisenbergLagrangianMatching.m

#QCD Examples
$MATH -nopromt -script ../Examples/QCD/QCDQuarkSelfEnergyOneLoop.m
$MATH -nopromt -script ../Examples/QCD/QCDGluonSelfEnergyOneLoop.m
$MATH -nopromt -script ../Examples/QCD/NRQCDVertexMatchingInTheTwoQuarkSectorOneLoop.m
$MATH -nopromt -script ../Examples/QCD/QCDThreeGluonVertexOneLoop.m

#EW Examples
$MATH -nopromt -script ../Examples/EW/EWHiggsToTwoGluonsOneLoop.m
$MATH -nopromt -script ../Examples/EW/EWHiggsDecayControversy.m

#Other Examples
$MATH -nopromt -script ../Examples/UVCheck.m

notify-send "Finished running examples for FeynHelpers."
