FeynHelpers is a collection of interfaces that allow you to use other HEP-related tools from your [FeynCalc](https://feyncalc.github.io) session.

## Useful information

- [How to cite this package and the related tools](Cite.md)
- [Installation instructions](Install.md)
- [Tensor reduction with Fermat](TensorReductionWithFermat.md)

## Tutorials

- [FIESTA usage examples](FiestaUsageExamples.md)  - a small tutorial on using the FIESTA interface
- [pySecDec usage examples](PSDUsageExamples.md) - a small tutorial on using the pySecDec interface
- [QGRAF usage examples](QGRAFUsageExamples.md) - a small tutorial on using the QFRAF interface

## Generic functions and symbols

- [FeynHelpersHowToCite](../FeynHelpersHowToCite.md) - references to be cited when using FeynHelpers
- [\$FeynHelpersDirectory](../\$FeynHelpersDirectory.md), [\$FeynHelpersLastCommitDateHash](../\$FeynHelpersLastCommitDateHash.md), [\$FeynHelpersLoadInterfaces](../\$FeynHelpersLoadInterfaces.md), [\$FeynHelpersVersion](../\$FeynHelpersVersion.md) - global variables needed for the proper functioning of FeynHelpers

## Fermat interface

- [FerImportArrayAsSparseMatrix](../FerImportArrayAsSparseMatrix.md) - converts Fermat arrays into Mathematica sparse arrays
- [FerMatrixToFermatArray](../FerMatrixToFermatArray.md) - converts matrices to Fermat arrays
- [FerCommand](../FerCommand.md) - templates for selected Fermat instruction
- [FerRunScript](../FerRunScript.md) - runs Fermat scripts
- [FerRowReduce](../FerRowReduce.md) - Fermat version of `RowReduce`
- [FerSolve](../FerSolve.md) - Fermat version of `Solve`
- [FerInputFile](../FerInputFile.md), [FerOutputFile](../FerOutputFile.md), [FerPath](../FerPath.md), [FerScriptFile](../FerScriptFile.md) - options of functions related to the Fermat interface

## Package-X interface

- [PaXEvaluate](../PaXEvaluate.md), [PaXEvaluateUV](../PaXEvaluateUV.md), [PaXEvaluateIR](../PaXEvaluateIR.md), [PaXEvaluateUVIRSplit](../PaXEvaluateUVIRSplit.md) - evaluates the given scalar 1-loop integral or Passarino-Veltman function analytically using Package-X
- [PaXContinuedDiLog](../PaXContinuedDiLog.md), [PaXDiLog](../PaXDiLog.md), [PaXDiscB](../PaXDiscB.md), [PaXEpsilonBar](../PaXEpsilonBar.md), [PaXKallenLambda](../PaXKallenLambda.md), [PaXKibblePhi](../PaXKibblePhi.md), [PaXKibblePhi](../PaXKibblePhi.md), [PaXLn](../PaXLn.md), [PaXpvA](../PaXpvA.md), [PaXpvB](../PaXpvB.md), [PaXpvC](../PaXpvC.md), [PaXpvD](../PaXpvD.md) - placeholders for certain Package-X symbols
- [PaXAnalytic](../PaXAnalytic.md), [PaXC0Expand](../PaXC0Expand.md), [PaXD0Expand](../PaXD0Expand.md), [PaXDiscExpand](../PaXDiscExpand.md), [PaXExpandInEpsilon](../PaXExpandInEpsilon.md), [PaXImplicitPrefactor](../PaXImplicitPrefactor.md), [PaXKallenExpand](../PaXKallenExpand.md), [PaXKibbleExpand](../PaXKibbleExpand.md), [PaXLoopRefineOptions](../PaXLoopRefineOptions.md), [PaXSeries](../PaXSeries.md), [PaXSimplifyEpsilon](../PaXSimplifyEpsilon.md), [PaXSubstituteEpsilon](../PaXSubstituteEpsilon.md) - options of functions related to the Package-X interface

## FIESTA interface

- [FSACreateMathematicaScripts](../FSACreateMathematicaScripts.md) - creates Mathematica scripts for evaluating the given integral with FIESTA
- [FSARunIntegration](../FSARunIntegration.md) - runs Mathematica scripts created by the `FSACreateMatehmaticaScripts` routine
- [FSALoadNumericalResults](../FSALoadNumericalResults.md) - loads the numerical result from FIESTA
- [FSAAdditionalPrefactor](../FSAAdditionalPrefactor.md), [FSAAnalyticIntegration](../FSAAnalyticIntegration.md), [FSAAnalyzeWorstPower](../FSAAnalyzeWorstPower.md), [FSAAssemblyIntegration](../FSAAssemblyIntegration.md), [FSAAsyLP](../FSAAsyLP.md), [FSABalanceMode](../FSABalanceMode.md), [FSABalancePower](../FSABalancePower.md), [FSABalanceSamplingPoints](../FSABalanceSamplingPoints.md), [FSABucketSize](../FSABucketSize.md), [FSAChunkSize](../FSAChunkSize.md), [FSACIntegratePath](../FSACIntegratePath.md), [FSAComplexMode](../FSAComplexMode.md), [FSAContourShiftCoefficient](../FSAContourShiftCoefficient.md), [FSAContourShiftIgnoreFail](../FSAContourShiftIgnoreFail.md), [FSAContourShiftShape](../FSAContourShiftShape.md), [FSACreateMathematicaScripts](../FSACreateMathematicaScripts.md), [FSAd0](../FSAd0.md), [FSADataPath](../FSADataPath.md), [FSADebugAllEntries](../FSADebugAllEntries.md), [FSADebugMemory](../FSADebugMemory.md), [FSADebugParallel](../FSADebugParallel.md), [FSADebugSector](../FSADebugSector.md), [FSAEpVarNegativeTermsHandling](../FSAEpVarNegativeTermsHandling.md), [FSAExactIntegrationOrder](../FSAExactIntegrationOrder.md), [FSAExactIntegrationTimeout](../FSAExactIntegrationTimeout.md), [FSAExpandResult](../FSAExpandResult.md), [FSAExpandVar](../FSAExpandVar.md), [FSAFixedContourShift](../FSAFixedContourShift.md), [FSAFixSectors](../FSAFixSectors.md), [FSAGPUIntegration](../FSAGPUIntegration.md), [FSAGraph](../FSAGraph.md), [FSAIntegrator](../FSAIntegrator.md), [FSAIntegratorOptions](../FSAIntegratorOptions.md), [FSALambdaIterations](../FSALambdaIterations.md), [FSALambdaSplit](../FSALambdaSplit.md), [FSAMathematicaBinary](../FSAMathematicaBinary.md), [FSAMathematicaKernelPath](../FSAMathematicaKernelPath.md), [FSAMinimizeContourTransformation](../FSAMinimizeContourTransformation.md), [FSAMixSectors](../FSAMixSectors.md), [FSAMPMin](../FSAMPMin.md), [FSAMPPrecisionShift](../FSAMPPrecisionShift.md), [FSAMPSmallX](../FSAMPSmallX.md), [FSAMPThreshold](../FSAMPThreshold.md), [FSANoAVX](../FSANoAVX.md), [FSANoDatabaseLock](../FSANoDatabaseLock.md), [FSANumberOfLinks](../FSANumberOfLinks.md), [FSANumberOfSubkernels](../FSANumberOfSubkernels.md), [FSAOnlyPrepare](../FSAOnlyPrepare.md), [FSAOnlyPrepareRegions](../FSAOnlyPrepareRegions.md), [FSAOptimizeIntegrationStrings](../FSAOptimizeIntegrationStrings.md), [FSAOrderInEps](../FSAOrderInEps.md), [FSAParameterRules](../FSAParameterRules.md), [FSAPath](../FSAPath.md), [FSAPMVar](../FSAPMVar.md), [FSAPolesMultiplicity](../FSAPolesMultiplicity.md), [FSAPrecision](../FSAPrecision.md), [FSAPrimarySectorCoefficients](../FSAPrimarySectorCoefficients.md), [FSAQHullPath](../FSAQHullPath.md), [FSARegionNumber](../FSARegionNumber.md), [FSARegVar](../FSARegVar.md), [FSARemoveDatabases](../FSARemoveDatabases.md), [FSAResolutionMode](../FSAResolutionMode.md), [FSAReturnErrorWithBrackets](../FSAReturnErrorWithBrackets.md), [FSAScriptFileName](../FSAScriptFileName.md), [FSASDExpandAsy](../FSASDExpandAsy.md), [FSASDExpandAsyOrder](../FSASDExpandAsyOrder.md), [FSASectorSplitting](../FSASectorSplitting.md), [FSASectorSymmetries](../FSASectorSymmetries.md), [FSASeparateTerms](../FSASeparateTerms.md), [FSAShowOutput](../FSAShowOutput.md), [FSAStrategy](../FSAStrategy.md), [FSAUsingC](../FSAUsingC.md), [FSAXVar](../FSAXVar.md), [FSAZeroCheckCount](../FSAZeroCheckCount.md)  - options of functions related to the FIESTA interface

## C++ FIRE interface

- [FIRECreateConfigFile](../FIRECreateConfigFile.md) - creates the FIRE .config file
- [FIRECreateIntegralFile](../FIRECreateIntegralFile.md) - creates list of integrals that need to be reduced
- [FIRECreateLiteRedFiles](../FIRECreateLiteRedFiles.md) - runs Mathematica scripts that creates the relevant lbases file
- [FIRECreateStartFile](../FIRECreateStartFile.md) - runs Mathematica scripts that creates the relevant FIRE .start file
- [FIREImportResults](../FIREImportResults.md) - converts reduction results from .table files to `GLI`s
- [FIREPrepareStartFile](../FIREPrepareStartFile.md) - prepares a Mathematica script that generates the relevant FIRE .start file
- [FIRERunReduction](../FIRERunReduction.md) - starts reduction using C++ FIRE from the current notebook
- [FIREToFCTopology](../FIREToFCTopology.md) - converts the given FIRE topology to `FCTopology`
- [FIREAutoDetectRestrictions](../FIREAutoDetectRestrictions.md), [FIREBinaryPath](../FIREBinaryPath.md), [FIREBucket](../FIREBucket.md), [FIRECompressor](../FIRECompressor.md), [FIREDatabase](../FIREDatabase.md), [FIREFthreads](../FIREFthreads.md), [FIREIntegrals](../FIREIntegrals.md), [FIRELI](../FIRELI.md),, [FIRELthreads](../FIRELthreads.md), [FIREMathematicaKernelPath](../FIREMathematicaKernelPath.md), [FIREParallel](../FIREParallel.md), [FIREProblemId](../FIREProblemId.md), [FIREPosPref](../FIREPosPref.md), [FIREShowOutput](../FIREShowOutput.md), [FIRESthreads](../FIRESthreads.md), [FIREThreads](../FIREThreads.md), [FIREUseLiteRed](../FIREUseLiteRed.md) - options of functions related to the C++ FIRE interface

## Mathematica FIRE interface

- [FIREBurn](../FIREBurn.md) - reduced the given integral using Mathematica version of FIRE
- [FIREAddPropagators](../FIREAddPropagators.md), [FIREConfigFiles](../FIREConfigFiles.md), [FIREPath](../FIREPath.md), [FIRERun](../FIRERun.md), [FIRESilentMode](../FIRESilentMode.md), [FIREStartFile](../FIREStartFile.md), [FIREUsingFermat](../FIREUsingFermat.md) - options of functions related to the Mathematica FIRE interface

## Kira interface

- [KiraCreateConfigFiles](../KiraCreateConfigFiles.md) - creates configuration files for the reduction
- [KiraCreateIntegralFile](../KiraCreateIntegralFile.md) - creates list of integrals that need to be reduced
- [KiraCreateJobFile](../KiraCreateJobFile.md) - creates the job file to rund the redution
- [KiraGetRS](../KiraGetRS.md) - extracts the $r$ and $s$ parameters in the Kira/Reduze syntax
- [KiraImportResults](../KiraImportResults.md) - converts reduction results to `GLI`s
- [KiraLabelSector](../KiraLabelSector.md) - labels sectors using the Reduze notation
- [KiraRunReduction](../KiraRunReduction.md) - starts reduction using Kira from the current notebook
- [KiraBinaryPath](../KiraBinaryPath.md), [KiraFermatPath](../KiraFermatPath.md), [KiraIncomingMomenta](../KiraIncomingMomenta.md), [KiraIntegrals](../KiraIntegrals.md), [KiraJobFileName](../KiraJobFileName.md), [KiraMassDimensions](../KiraMassDimensions.md), [KiraMomentumConservation](../KiraMomentumConservation.md), [KiraOutgoingMomenta](../KiraOutgoingMomenta.md),  [KiraShowOutput](../KiraShowOutput.md) - options of functions related to the KIRA interface

## LoopTools interface

- [LToolsEvaluate](../LToolsEvaluate.md) - evaluates Passarino-Veltman functions numerically using LoopTools
- [LToolsLoadLibrary](../LToolsLoadLibrary.md) - loads the LoopTools library
- [LToolsUnLoadLibrary](../LToolsUnLoadLibrary.md) - unloads the LoopTools library
- [LToolsExpandInEpsilon](../LToolsExpandInEpsilon.md), [LToolsFullResult](../LToolsFullResult.md), [LToolsImplicitPrefactor](../LToolsImplicitPrefactor.md), [LToolsSetLambda](../LToolsSetLambda.md), [LToolsSetMudim](../LToolsSetMudim.md), [LToolsPath](../LToolsPath.md) - options of functions related to the LoopTools interface
- [LToolsA0](../LToolsA0.md), [LToolsA00](../LToolsA00.md), [LToolsA0i](../LToolsA0i.md), [LToolsB0](../LToolsB0.md), [LToolsB00](../LToolsB00.md), [LToolsB0i](../LToolsB0i.md), [LToolsB1](../LToolsB1.md), [LToolsB001](../LToolsB001.md), [LToolsB11](../LToolsB11.md), [LToolsB111](../LToolsB111.md), [LToolsC0](../LToolsC0.md), [LToolsC0i](../LToolsC0i.md), [LToolsClearCache](../LToolsClearCache.md), [LToolsD0](../LToolsD0.md), [LToolsD0i](../LToolsD0i.md), [LToolsDB0](../LToolsDB0.md), [LToolsDB00](../LToolsDB00.md), [LToolsDB1](../LToolsDB1.md), [LToolsDB11](../LToolsDB11.md), [LToolsDebugA](../LToolsDebugA.md), [LToolsDebugAll](../LToolsDebugAll.md), [LToolsDebugB](../LToolsDebugB.md), [LToolsDebugC](../LToolsDebugC.md), [LToolsDebugD](../LToolsDebugD.md), [LToolsDebugE](../LToolsDebugE.md), [LToolsDR1eps](../LToolsDR1eps.md), [LToolsDRResult](../LToolsDRResult.md), [LToolsE0](../LToolsE0.md), [LToolsE0i](../LToolsE0i.md), [LToolsGetCmpBits](../LToolsGetCmpBits.md), [LToolsGetDebugKey](../LToolsGetDebugKey.md), [LToolsGetDelta](../LToolsGetDelta.md), [LToolsGetDiffEps](../LToolsGetDiffEps.md), [LToolsGetErrDigits](../LToolsGetErrDigits.md), [LToolsGetLambda](../LToolsGetLambda.md), [LToolsGetMaxDev](../LToolsGetMaxDev.md), [LToolsGetMinMass](../LToolsGetMinMass.md), [LToolsGetMudim](../LToolsGetMudim.md), [LToolsGetUVDiv](../LToolsGetUVDiv.md), [LToolsGetVersionKey](../LToolsGetVersionKey.md), [LToolsGetWarnDigits](../LToolsGetWarnDigits.md), [LToolsGetZeroEps](../LToolsGetZeroEps.md), [LToolsKeyA0](../LToolsKeyA0.md), [LToolsKeyAll](../LToolsKeyAll.md), [LToolsKeyBget](../LToolsKeyBget.md), [LToolsKeyC0](../LToolsKeyC0.md), [LToolsKeyCEget](../LToolsKeyCEget.md), [LToolsKeyD0](../LToolsKeyD0.md), [LToolsKeyE0](../LToolsKeyE0.md), [LToolsKeyEget](../LToolsKeyEget.md), [LToolsLi2](../LToolsLi2.md), [LToolsLi2omx](../LToolsLi2omx.md), [LToolsMarkCache](../LToolsMarkCache.md), [LToolsPaVe](../LToolsPaVe.md), [LToolsRestoreCache](../LToolsRestoreCache.md), [LToolsSetCmpBits](../LToolsSetCmpBits.md), [LToolsSetDebugKey](../LToolsSetDebugKey.md), [LToolsSetDebugRange](../LToolsSetDebugRange.md), [LToolsSetDelta](../LToolsSetDelta.md), [LToolsSetDiffEps](../LToolsSetDiffEps.md), [LToolsSetErrDigits](../LToolsSetErrDigits.md),  [LToolsSetMaxDev](../LToolsSetMaxDev.md), [LToolsSetMinMass](../LToolsSetMinMass.md), [LToolsSetUVDiv](../LToolsSetUVDiv.md), [LToolsSetVersionKey](../LToolsSetVersionKey.md), [LToolsSetWarnDigits](../LToolsSetWarnDigits.md) - placeholders for certain LoopTools symbols
- [\$LTools](../\$LTools.md) - global variables needed for the proper functioning of the interface

## pySecDec interface 

- [PSDCreatePythonScripts](../PSDCreatePythonScripts.md) - creates Python scripts for evaluating the given integral with pySecDec
- [PSDIntegrate](../PSDIntegrate.md) - creates input for pySecDec's numerical integration routines
- [PSDLoopIntegralFromPropagators](../PSDLoopIntegralFromPropagators.md) - converts the given loop integral into input for pySecDec's `LoopIntegralFromPropagators`
- [PSDLoadNumericalResults](../PSDLoadNumericalResults.md) - loads the numerical result from pySecDec
- [PSDLoopPackage](../PSDLoopPackage.md) - creates input for pySecDec's `loop_package`
- [PSDLoopRegions](../PSDLoopRegions.md) - creates input for pySecDec's `loop_regions`
- [PSDSumPackage](../PSDSumPackage.md) - creates input for pySecDec's `sum_package`
- [PSDAdditionalPrefactor](../PSDAdditionalPrefactor.md), [PSDAddMonomialRegulatorPower](../PSDAddMonomialRegulatorPower.md), [PSDCoefficients](../PSDCoefficients.md), [PSDComplexParameterRules](../PSDComplexParameterRules.md), [PSDComplexParameters](../PSDComplexParameters.md), [PSDComplexParameterValues](../PSDComplexParameterValues.md), [PSDContourDeformation](../PSDContourDeformation.md), [PSDCPUThreads](../PSDCPUThreads.md), [PSDDecompositionMethod](../PSDDecompositionMethod.md), [PSDDecreaseToPercentage](../PSDDecreaseToPercentage.md), [PSDDeformationParametersDecreaseFactor](../PSDDeformationParametersDecreaseFactor.md), [PSDDeformationParametersMaximum](../PSDDeformationParametersMaximum.md), [PSDDeformationParametersMinimum](../PSDDeformationParametersMinimum.md), [PSDEnforceComplex](../PSDEnforceComplex.md), [PSDEpsAbs](../PSDEpsAbs.md), [PSDEpsRel](../PSDEpsRel.md), [PSDErrorMode](../PSDErrorMode.md), [PSDErrorModeQmc](../PSDErrorModeQmc.md), [PSDEvaluateMinn](../PSDEvaluateMinn.md), [PSDExpansionByRegionsOrder](../PSDExpansionByRegionsOrder.md), [PSDExpansionByRegionsParameter](../PSDExpansionByRegionsParameter.md), [PSDFitFunction](../PSDFitFunction.md), [PSDFlags](../PSDFlags.md), [PSDFormExecutable](../PSDFormExecutable.md), [PSDFormMemoryUse](../PSDFormMemoryUse.md), [PSDFormOptimizationLevel](../PSDFormOptimizationLevel.md), [PSDFormThreads](../PSDFormThreads.md), [PSDFormWorkSpace](../PSDFormWorkSpace.md), [PSDGenerateFileName](../PSDGenerateFileName.md), [PSDGeneratingVectors](../PSDGeneratingVectors.md), [PSDIntegrateFileName](../PSDIntegrateFileName.md), [PSDIntegrator](../PSDIntegrator.md), [PSDLoopIntegralName](../PSDLoopIntegralName.md), [PSDMaxEpsAbs](../PSDMaxEpsAbs.md), [PSDMaxEpsRel](../PSDMaxEpsRel.md), [PSDMaxEval](../PSDMaxEval.md), [PSDMaxIncreaseFac](../PSDMaxIncreaseFac.md), [PSDMinDecreaseFactor](../PSDMinDecreaseFactor.md), [PSDMinEpsAbs](../PSDMinEpsAbs.md), [PSDMinEpsRel](../PSDMinEpsRel.md), [PSDMinEval](../PSDMinEval.md), [PSDMinm](../PSDMinm.md), [PSDMinn](../PSDMinn.md), [PSDNormalizExecutable](../PSDNormalizExecutable.md), [PSDNumberOfPresamples](../PSDNumberOfPresamples.md), [PSDNumberOfThreads](../PSDNumberOfThreads.md), [PSDOutputDirectory](../PSDOutputDirectory.md), [PSDOverwritePackageDirectory](../PSDOverwritePackageDirectory.md), [PSDPyLinkQMCTransforms](../PSDPyLinkQMCTransforms.md), [PSDRealParameterRules](../PSDRealParameterRules.md), [PSDRealParameters](../PSDRealParameters.md), [PSDRealParameterValues](../PSDRealParameterValues.md), [PSDRegulators](../PSDRegulators.md), [PSDRequestedOrder](../PSDRequestedOrder.md), [PSDResetCudaAfter](../PSDResetCudaAfter.md), [PSDSplit](../PSDSplit.md), [PSDTransform](../PSDTransform.md), [PSDVerbose](../PSDVerbose.md), [PSDVerbosity](../PSDVerbosity.md) - options of functions related to the pySecDec interface

## QGRAF interface

- [QGConvertToFC](../QGConvertToFC.md) - converts QGRAF output into FeynCalc input
- [QGCreateAmp](../QGCreateAmp.md) - generates Feynman amplitudes and diagrams
- [QGLoadInsertions](../QGLoadInsertions.md) - loads sets of Feynman rules
- [QGTZFCreateFieldStyles](../QGTZFCreateFieldStyles.md) - prepares TikZ-Feynman stylings for the occurring fields
- [QGTZFCreateTeXFiles](../QGTZFCreateTeXFiles.md) - prepares TeX form of Feynman diagrams
- [QGPolarization](../QGPolarization.md) - placeholder for the polarization of a field
- [QGPropagator](../QGPropagator.md) - placeholder for the propagator of a field
- [QGTruncatedPolarization](../QGTruncatedPolarization.md) - placeholder for the truncated external state of a field
- [QGVertex](../QGVertex.md) - placeholder for the interaction vertex of some fields
- [\$QGScriptsDirectory](../\$QGScriptsDirectory.md), [\$QGInsertionsDirectory](../\$QGInsertionsDirectory.md), [\$QGLogOutputAmplitudes](../\$QGLogOutputAmplitudes.md), [\$QGLogOutputDiagrams](../\$QGLogOutputDiagrams.md), [\$QGModelsDirectory](../\$QGModelsDirectory.md), [\$QGStylesDirectory](../\$QGStylesDirectory.md), [\$QGTeXDirectory](../\$QGTeXDirectory.md), [QGAmplitudeStyle](../QGAmplitudeStyle.md), [QGBinaryFile](../QGBinaryFile.md), [QGCleanUpOutputDirectory](../QGCleanUpOutputDirectory.md), [QGDiagramStyle](../QGDiagramStyle.md), [QGInsertionRule](../QGInsertionRule.md), [QGLoopMomentum](../QGLoopMomentum.md), [QGModel](../QGModel.md), [QGOptionalStatements](../QGOptionalStatements.md), [QGOptions](../QGOptions.md), [QGOutputAmplitudes](../QGOutputAmplitudes.md), [QGOutputDiagrams](../QGOutputDiagrams.md), [QGOutputDirectory](../QGOutputDirectory.md), [QGOverwriteExistingAmplitudes](../QGOverwriteExistingAmplitudes.md), [QGOverwriteExistingDiagrams](../QGOverwriteExistingDiagrams.md), [QGSaveInputFile](../QGSaveInputFile.md), [QGShowOutput](../QGShowOutput.md), [QGFieldStyles](../QGFieldStyles.md) - options of functions related to the QGRAF interface
