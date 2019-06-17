#!/bin/bash

# This software is covered by the GNU General Public License 3.
# Copyright (C) 1990-2018 Rolf Mertig
# Copyright (C) 1997-2018 Frederik Orellana
# Copyright (C) 2014-2018 Vladyslav Shtabovenko

# Description:

# Checks FeynHelpers using real-life calculations.

# Stop if any of the examples fails
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR
echo $(pwd)

MATH=$1


#QED Examples
#-------------------------------------------------------------------------------
for exFile in 'QEDABJAxialAnomaly.m' 'QEDElectronGMinusTwoOneLoop.m' 'QEDRenormalizationOneLoop.m' 'MasslessQEDSelfEnergiesTwoLoops.m' 'QEDToEulerHeisenbergLagrangianMatching.m'

do
  echo
  echo -e "* \c"
  $MATH -nopromt -script ../Examples/QED/$exFile
done

#QCD Examples
#-------------------------------------------------------------------------------
for exFile in 'QCDQuarkSelfEnergyOneLoop.m' 'QCDGluonSelfEnergyOneLoop.m' 'NRQCDVertexMatchingInTheTwoQuarkSectorOneLoop.m' 'QCDThreeGluonVertexOneLoop.m'

do
  echo
  echo -e "* \c"
  $MATH -nopromt -script ../Examples/QCD/$exFile
done

#EW Examples
#-------------------------------------------------------------------------------
for exFile in 'EWHiggsToTwoGluonsOneLoop.m' 'EWHiggsDecayControversy.m'

do
  echo
  echo -e "* \c"
  $MATH -nopromt -script ../Examples/EW/$exFile
done

#Misc Examples
#-------------------------------------------------------------------------------
for exFile in 'UVCheck.m'

do
  echo
  echo -e "* \c"
  $MATH -nopromt -script ../Examples/$exFile
done

notify-send "Finished running examples for FeynHelpers."
