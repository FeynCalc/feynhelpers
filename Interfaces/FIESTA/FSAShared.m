(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FSAShared														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and FIESTA						*)

(* ------------------------------------------------------------------------ *)

FSAOrderInEps::usage=
"FSAOrderInEps is an option for FSAOrderInEps and other functions of the FIESTA
interface.

It specifies the order in $\\varepsilon$ up to which the integral needs to be
calculated. The default value is 0.";

FSANumberOfSubkernels::usage=
"FSANumberOfSubkernels is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the NumberOfSubkernels option to be passed to the
FIESTA package when evaluating an integral. The default value is 4 meaning
that 4 parallel kernels will be used during the computation.";

FSANumberOfLinks::usage=
"FSANumberOfLinks is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the NumberOfLinks option to be passed to the FIESTA
package when evaluating an integral.";

FSAComplexMode::usage=
"FSAComplexMode is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the ComplexMode option to be passed to the FIESTA
package when evaluating an integral.";

FSAReturnErrorWithBrackets::usage=
"FSAReturnErrorWithBrackets is an option for FSAPrepareMathematicaScripts and
other functions of the FIESTA interface.

It specifies the value of the ReturnErrorWithBrackets option to be passed to
the FIESTA package when evaluating an integral.";

FSAPrecision::usage=
"FSAPrecision is an option for FSAPrepareMathematicaScripts and other functions
of the FIESTA interface.

It specifies the value of the Precision option to be passed to the FIESTA
package when evaluating an integral.";

FSAStrategy::usage=
"FSAStrategy is an option for FSAPrepareMathematicaScripts and other functions
of the FIESTA interface.

It specifies the value of the Strategy option to be passed to the FIESTA
package when evaluating an integral.";

FSASectorSymmetries::usage=
"FSASectorSymmetries is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the SectorSymmetries option to be passed to the
FIESTA package when evaluating an integral.";

FSAd0::usage=
"FSAd0 is an option for FSAPrepareMathematicaScripts and other functions of the
FIESTA interface.

It specifies the value of the d0 option to be passed to the FIESTA package
when evaluating an integral.";

FSAUsingC::usage=
"FSAUsingC is an option for FSAPrepareMathematicaScripts and other functions of
the FIESTA interface.

It specifies the value of the UsingC option to be passed to the FIESTA package
when evaluating an integral.";

FSARegVar::usage=
"FSARegVar is an option for FSAPrepareMathematicaScripts and other functions of
the FIESTA interface.

It specifies the value of the RegVar option to be passed to the FIESTA package
when evaluating an integral.";

FSAExpandVar::usage=
"FSAExpandVar is an option for FSAPrepareMathematicaScripts and other functions
of the FIESTA interface.

It specifies the value of the ExpandVar option to be passed to the FIESTA
package when evaluating an integral.";

FSAXVar::usage=
"FSAXVar is an option for FSAPrepareMathematicaScripts and other functions of
the FIESTA interface.

It specifies the value of the XVar option to be passed to the FIESTA package
when evaluating an integral.";

FSAEpVarNegativeTermsHandling::usage=
"FSAEpVarNegativeTermsHandling is an option for FSAPrepareMathematicaScripts
and other functions of the FIESTA interface.

It specifies the value of the EpVarNegativeTermsHandling option to be passed
to the FIESTA package when evaluating an integral.";

FSAPMVar::usage=
"FSAPMVar is an option for FSAPrepareMathematicaScripts and other functions of
the FIESTA interface.

It specifies the value of the PMVar option to be passed to the FIESTA package
when evaluating an integral.";

FSAGraph::usage=
"FSAGraph is an option for FSAPrepareMathematicaScripts and other functions of
the FIESTA interface.

It specifies the value of the Graph option to be passed to the FIESTA package
when evaluating an integral.";

FSAPrimarySectorCoefficients::usage=
"FSAPrimarySectorCoefficients is an option for FSAPrepareMathematicaScripts and
other functions of the FIESTA interface.

It specifies the value of the PrimarySectorCoefficients option to be passed to
the FIESTA package when evaluating an integral.";

FSAOnlyPrepare::usage=
"FSAOnlyPrepare is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the OnlyPrepare option to be passed to the FIESTA
package when evaluating an integral.";

FSAFixSectors::usage=
"FSAFixSectors is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the FixSectors option to be passed to the FIESTA
package when evaluating an integral.";

FSAMixSectors::usage=
"FSAMixSectors is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the MixSectors option to be passed to the FIESTA
package when evaluating an integral.";

FSASectorSplitting::usage=
"FSASectorSplitting is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the SectorSplitting option to be passed to the
FIESTA package when evaluating an integral.";

FSAMinimizeContourTransformation::usage=
"FSAMinimizeContourTransformation is an option for FSAPrepareMathematicaScripts
and other functions of the FIESTA interface.

It specifies the value of the MinimizeContourTransformation option to be
passed to the FIESTA package when evaluating an integral.";

FSAContourShiftShape::usage=
"FSAContourShiftShape is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the ContourShiftShape option to be passed to the
FIESTA package when evaluating an integral.";

FSAContourShiftCoefficient::usage=
"FSAContourShiftCoefficient is an option for FSAPrepareMathematicaScripts and
other functions of the FIESTA interface.

It specifies the value of the ContourShiftCoefficient option to be passed to
the FIESTA package when evaluating an integral.";

FSAContourShiftIgnoreFail::usage=
"FSAContourShiftIgnoreFail is an option for FSAPrepareMathematicaScripts and
other functions of the FIESTA interface.

It specifies the value of the ContourShiftIgnoreFail option to be passed to
the FIESTA package when evaluating an integral.";

FSAFixedContourShift::usage=
"FSAFixedContourShift is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the FixedContourShift option to be passed to the
FIESTA package when evaluating an integral.";

FSALambdaIterations::usage=
"FSALambdaIterations is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the LambdaIterations option to be passed to the
FIESTA package when evaluating an integral.";

FSALambdaSplit::usage=
"FSALambdaSplit is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the LambdaSplit option to be passed to the FIESTA
package when evaluating an integral.";

FSAChunkSize::usage=
"FSAChunkSize is an option for FSAPrepareMathematicaScripts and other functions
of the FIESTA interface.

It specifies the value of the ChunkSize option to be passed to the FIESTA
package when evaluating an integral.";

FSAOptimizeIntegrationStrings::usage=
"FSAOptimizeIntegrationStrings is an option for FSAPrepareMathematicaScripts
and other functions of the FIESTA interface.

It specifies the value of the OptimizeIntegrationStrings option to be passed
to the FIESTA package when evaluating an integral.";

FSAAnalyzeWorstPower::usage=
"FSAAnalyzeWorstPower is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the AnalyzeWorstPower option to be passed to the
FIESTA package when evaluating an integral.";

FSAZeroCheckCount::usage=
"FSAZeroCheckCount is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the ZeroCheckCount option to be passed to the FIESTA
package when evaluating an integral.";

FSAExpandResult::usage=
"FSAExpandResult is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the ExpandResult option to be passed to the FIESTA
package when evaluating an integral.";

FSADataPath::usage=
"FSADataPath is an option for FSAPrepareMathematicaScripts and other functions
of the FIESTA interface.

It specifies the value of the DataPath option to be passed to the FIESTA
package when evaluating an integral.";

FSABucketSize::usage=
"FSABucketSize is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the BucketSize option to be passed to the FIESTA
package when evaluating an integral.";

FSANoDatabaseLock::usage=
"FSANoDatabaseLock is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the NoDatabaseLock option to be passed to the FIESTA
package when evaluating an integral.";

FSARemoveDatabases::usage=
"FSARemoveDatabases is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the RemoveDatabases option to be passed to the
FIESTA package when evaluating an integral.";

FSASeparateTerms::usage=
"FSASeparateTerms is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the SeparateTerms option to be passed to the FIESTA
package when evaluating an integral.";

FSABalanceSamplingPoints::usage=
"FSABalanceSamplingPoints is an option for FSAPrepareMathematicaScripts and
other functions of the FIESTA interface.

It specifies the value of the BalanceSamplingPoints option to be passed to the
FIESTA package when evaluating an integral.";

FSABalanceMode::usage=
"FSABalanceMode is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the BalanceMode option to be passed to the FIESTA
package when evaluating an integral.";

FSABalancePower::usage=
"FSABalancePower is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the BalancePower option to be passed to the FIESTA
package when evaluating an integral.";

FSAResolutionMode::usage=
"FSAResolutionMode is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the ResolutionMode option to be passed to the FIESTA
package when evaluating an integral.";

FSAAnalyticIntegration::usage=
"FSAAnalyticIntegration is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the AnalyticIntegration option to be passed to the
FIESTA package when evaluating an integral.";

FSAOnlyPrepareRegions::usage=
"FSAOnlyPrepareRegions is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the OnlyPrepareRegions option to be passed to the
FIESTA package when evaluating an integral.";

FSAAsyLP::usage=
"FSAAsyLP is an option for FSAPrepareMathematicaScripts and other functions of
the FIESTA interface.

It specifies the value of the AsyLP option to be passed to the FIESTA package
when evaluating an integral.";

FSARegionNumber::usage=
"FSARegionNumber is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the RegionNumber option to be passed to the FIESTA
package when evaluating an integral.";

FSAPolesMultiplicity::usage=
"FSAPolesMultiplicity is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the PolesMultiplicity option to be passed to the
FIESTA package when evaluating an integral.";

FSAExactIntegrationOrder::usage=
"FSAExactIntegrationOrder is an option for FSAPrepareMathematicaScripts and
other functions of the FIESTA interface.

It specifies the value of the ExactIntegrationOrder option to be passed to the
FIESTA package when evaluating an integral.";

FSAExactIntegrationTimeout::usage=
"FSAExactIntegrationTimeout is an option for FSAPrepareMathematicaScripts and
other functions of the FIESTA interface.

It specifies the value of the ExactIntegrationTimeout option to be passed to
the FIESTA package when evaluating an integral.";

FSAGPUIntegration::usage=
"FSAGPUIntegration is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the GPUIntegration option to be passed to the FIESTA
package when evaluating an integral.";

FSANoAVX::usage=
"FSANoAVX is an option for FSAPrepareMathematicaScripts and other functions of
the FIESTA interface.

It specifies the value of the NoAVX option to be passed to the FIESTA package
when evaluating an integral.";

FSAAssemblyIntegration::usage=
"FSAAssemblyIntegration is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the AssemblyIntegration option to be passed to the
FIESTA package when evaluating an integral.";

FSAIntegrator::usage=
"FSAIntegrator is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the Integrator option to be passed to the FIESTA
package when evaluating an integral. The default value is \"quasiMonteCarlo\".
Other possible values are \"tensorTrain\", \"vegasCuba\", \"suaveCuba\",
\"divonneCuba\" and \"cuhreCuba\".";

FSAIntegratorOptions::usage=
"FSAIntegratorOptions is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the IntegratorOptions option to be passed to the
FIESTA package when evaluating an integral. The default value is
{{\"maxeval\",\"50000\"},{\"epsrel\",\"1.000000E-05\"},
{\"epsabs\",\"1.000000E-12\"},{\"integralTransform\",\"korobov\"}}";

FSACIntegratePath::usage=
"FSACIntegratePath is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the CIntegratePath option to be passed to the FIESTA
package when evaluating an integral.";

FSAMPSmallX::usage=
"FSAMPSmallX is an option for FSAPrepareMathematicaScripts and other functions
of the FIESTA interface.

It specifies the value of the MPSmallX option to be passed to the FIESTA
package when evaluating an integral.";

FSAMPThreshold::usage=
"FSAMPThreshold is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the MPThreshold option to be passed to the FIESTA
package when evaluating an integral.";

FSAMPMin::usage=
"FSAMPMin is an option for FSAPrepareMathematicaScripts and other functions of
the FIESTA interface.

It specifies the value of the MPMin option to be passed to the FIESTA package
when evaluating an integral.";

FSAMPPrecisionShift::usage=
"FSAMPPrecisionShift is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the MPPrecisionShift option to be passed to the
FIESTA package when evaluating an integral.";

FSAMathematicaBinary::usage=
"FSAMathematicaBinary is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the MathematicaBinary option to be passed to the
FIESTA package when evaluating an integral.";

FSAQHullPath::usage=
"FSAQHullPath is an option for FSAPrepareMathematicaScripts and other functions
of the FIESTA interface.

It specifies the value of the QHullPath option to be passed to the FIESTA
package when evaluating an integral.";

FSADebugParallel::usage=
"FSADebugParallel is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the DebugParallel option to be passed to the FIESTA
package when evaluating an integral.";

FSADebugMemory::usage=
"FSADebugMemory is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the DebugMemory option to be passed to the FIESTA
package when evaluating an integral.";

FSADebugAllEntries::usage=
"FSADebugAllEntries is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the DebugAllEntries option to be passed to the
FIESTA package when evaluating an integral.";

FSADebugSector::usage=
"FSADebugSector is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies the value of the DebugSector option to be passed to the FIESTA
package when evaluating an integral.";

FSASDExpandAsy::usage=
"FSASDExpandAsyOrder is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface. When using asymptotic expansion it
specifies the order, to which the integral should be expanded in the
respective variable. The default value is 0.";

FSASDExpandAsyOrder::usage=
"FSASDExpandAsyOrder is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface. When using asymptotic expansion it
specifies the order, to which the integral should be expanded in the
respective variable. The default value is 0.";

FSAAdditionalPrefactor::usage=
"FSASDExpandAsyOrder is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface. When using asymptotic expansion it
specifies the order, to which the integral should be expanded in the
respective variable. The default value is 0.";

FSAPath::usage=
"FSASDExpandAsyOrder is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface. When using asymptotic expansion it
specifies the order, to which the integral should be expanded in the
respective variable. The default value is 0.";

FSAScriptFileName::usage=
"FSASDExpandAsyOrder is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface. When using asymptotic expansion it
specifies the order, to which the integral should be expanded in the
respective variable. The default value is 0.";

FSAMathematicaKernelPath::usage=
"FSAMathematicaKernelPath is an option for FSAPrepareMathematicaScripts and
other functions of the FIESTA interface.

It specifies the full path to the Mathematica Kernel that will be used to run
FIESTA. The default value is Automatic.";

FSAShowOutput::usage=
"FSAShowOutput is an option for FSARunIntegration and other functions of the
FIESTA interface.

When set to True, the output of the current process run will be shown via
Print. When set to False the output is suppressed.";

FSAParameterRules::usage=
"FSAParameterRules is an option for FSAPrepareMathematicaScripts and other
functions of the FIESTA interface.

It specifies numerical values of kinematic parameters passed to FIESTA's UF
function.";

Begin["`Package`"]
End[]

Begin["`FSAShared`Private`"]



End[]

