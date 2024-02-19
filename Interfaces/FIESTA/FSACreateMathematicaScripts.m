(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FSACreateMathematicaScripts											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates FIRE start files out of FCTopology objects		*)

(* ------------------------------------------------------------------------ *)

FSACreateMathematicaScripts::usage=
"FSACreateMathematicaScripts[int, topo, path] creates a Mathematica script 
needed for the evaluation of the integral int (in the GLI representation)
belonging to the topology topo. The files are saved to the directory
path/topoNameXindices. The function returns a list of two strings that point
to the script for FIESTA and the output file.

One can also use the FeynAmpDenominator-representation as in
FSACreateMathematicaScripts[fadInt, lmoms, path], where lmoms is the list of
the loop momenta on which fadInt depends. In this case the FIESTA script will
directly go into path.

Another way to invoke the function would be FSACreateMathematicaScripts[{int1,
int2, ...}, {topo1, topo2, ...}, path] in which case the files will be saved
to path/topoName1Xindices1, path/topoName2Xindices2 etc. The syntax
FSACreateMathematicaScripts[{int1, int2, ...}, {topo1, topo2, ...}, {path1,
path2, ...}] is also possible.

Unless you are computing a single scale integral with the scale variable set
to unity, you must specify all external parameters (e.g. masses and scalar
products of external momenta) and their numerical values via the option
FSAParameterRules.  The option FinalSubstitutions can be used to assign some
kinematic parameters (e.g. scalar products or masses) particular symbolic
values.

Another important option that you most likely would like to specify is
FSAOrderInEps which specifies the order in $\\varepsilon$ up to which the
integral should be evaluated.

The names of the FIESTA script can be changed via the option FSAScriptFileName
with the default value being FIESTAScript.m.

The integrator used for the numerical evaluation of the integral is set by the
option FSAIntegrator, where \"quasiMonteCarlo\" is the default value.
Accordingly, if you want to increase the number of iterations, you should use
the option FSAIntegratorOptions.

If you know in advance that the integral you are computing does not have cuts
(i.e. the result is purely real with no imaginary part), then it is highly
recommended to disable the contour deformation. This will give you a huge
performance boost. The option controlling this FIESTA parameter is called
FSAComplexMode and is set to True by default.

The prefactor of integrals evaluated by pySecDec is given by  $\\frac{1}{i
\\pi^{D/2}} e^{\\gamma_E \\frac{4-D}{2}}$ per loop, which is the standard choice
for multiloop calculations. An extra prefactor can be added using the option
FSAAdditionalPrefactor.

If you want to compute an integral using asymptotic expansion, you need to set
the option FSASDExpandAsy to True and specify the expansion order via
FSASDExpandAsyOrder. Furthermore, the expansion parameter must be made known
using FSAExpandVar.";

FSACreateMathematicaScripts::failmsg =
"Error! FSACreateMathematicaScripts has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FSACreateMathematicaScripts`Private`"]
fspsVerbose::usage="";



Options[FSACreateMathematicaScripts] = {
	DateString							-> False,
	FCI									-> False,
	FCVerbose							-> False,
	FSAAdditionalPrefactor				-> 1,
	FSAAnalyticIntegration 				-> Default,
	FSAAnalyzeWorstPower 				-> Default,
	FSAAssemblyIntegration 				-> Default,
	FSAAsyLP 							-> Default,
	FSABalanceMode 						-> Default,
	FSABalancePower 					-> Default,
	FSABalanceSamplingPoints 			-> Default,
	FSABucketSize 						-> Default,
	FSACIntegratePath			 		-> Default,
	FSAChunkSize 						-> Default,
	FSAComplexMode 						-> True,
	FSAContourShiftCoefficient 			-> Default,
	FSAContourShiftIgnoreFail 			-> Default,
	FSAContourShiftShape 				-> Default,
	FSADataPath 						-> Default,
	FSADebugAllEntries 					-> Default,
	FSADebugMemory 						-> Default,
	FSADebugParallel 					-> Default,
	FSADebugSector  					-> Default,
	FSAEpVarNegativeTermsHandling		-> Default,
	FSAExactIntegrationOrder 			-> Default,
	FSAExactIntegrationTimeout 			-> Default,
	FSAExpandResult 					-> Default,
	FSAExpandVar 						-> Default,
	FSAFixSectors 						-> Default,
	FSAFixedContourShift 				-> Default,
	FSAGPUIntegration 					-> Default,
	FSAGraph 							-> Default,
	FSAIntegrator 						-> "quasiMonteCarlo",
	FSAIntegratorOptions 				-> {{"maxeval","50000"},{"epsrel","1.000000E-05"},{"epsabs","1.000000E-12"},{"integralTransform","korobov"}},
	FSALambdaIterations 				-> Default,
	FSALambdaSplit 						-> Default,
	FSAMPMin 							-> Default,
	FSAMPPrecisionShift 				-> Default,
	FSAMPSmallX 						-> Default,
	FSAMPThreshold 						-> Default,
	FSAMathematicaBinary 				-> Default,
	FSAMinimizeContourTransformation	-> Default,
	FSAMixSectors 						-> Default,
	FSANoAVX 							-> Default,
	FSANoDatabaseLock 					-> Default,
	FSANumberOfLinks 					-> Default,
	FSANumberOfSubkernels 				-> 4,
	FSAOnlyPrepare 						-> Default,
	FSAOnlyPrepareRegions 				-> Default,
	FSAOptimizeIntegrationStrings 		-> Default,
	FSAOrderInEps						-> 0,
	FSAPMVar 							-> Default,
	FSAParameterRules					-> {},
	FSAPath 							-> FileNameJoin[{$UserBaseDirectory, "Applications", "FIESTA5", "FIESTA5.m"}],
	FSAPolesMultiplicity 				-> Default,
	FSAPrecision 						-> 8,
	FSAPrimarySectorCoefficients 		-> Default,
	FSAQHullPath 						-> Default,
	FSARegVar 							-> Default,
	FSARegionNumber 					-> Default,
	FSARemoveDatabases 					-> Default,
	FSAResolutionMode 					-> Default,
	FSAReturnErrorWithBrackets			-> True,
	FSASDExpandAsy						-> False,
	FSASDExpandAsyOrder					-> 0,
	FSAScriptFileName			 		-> "FiestaScript.m",
	FSASectorSplitting 					-> Default,
	FSASectorSymmetries 				-> Default,
	FSASeparateTerms 					-> Default,
	FSAStrategy 						-> Default,
	FSAUsingC 							-> Default,
	FSAXVar 							-> Default,
	FSAZeroCheckCount 					-> Default,
	FSAd0 								-> Default,
	FinalSubstitutions					-> {},
	N									-> MachinePrecision,
	OverwriteTarget						-> False,
	StringReplace						-> {}
};

FSACreateMathematicaScripts[gli_GLI, topos:{__FCTopology}, path_String, opts:OptionsPattern[]] :=
	FSACreateMathematicaScripts[gli, FCLoopSelectTopology[gli,topos], path, opts];

FSACreateMathematicaScripts[gli_GLI, topo_FCTopology, path_String, opts:OptionsPattern[]] :=
	Block[{int, optFinalSubstitutions},

		int = FCLoopFromGLI[gli, topo, FCI->OptionValue[FCI]];

		optFinalSubstitutions			= OptionValue[FinalSubstitutions];


		If[	OptionValue[FCI],
			optFinalSubstitutions = Join[topo[[5]], OptionValue[FinalSubstitutions]],
			optFinalSubstitutions=
				FCI[FRH[Join[SelectFree[topo[[5]],{Polarization,TemporalMomentum}], OptionValue[FinalSubstitutions]]]]
		];

		FSACreateMathematicaScripts[int, topo[[3]], FileNameJoin[{path,ToString[FCLoopGLIToSymbol[gli]]}],
			Join[{FCI->True,FinalSubstitutions->optFinalSubstitutions}, FilterRules[{opts}, Except[FCI | FinalSubstitutions]]]]
	];


FSACreateMathematicaScripts[glis:{__GLI}, topos:{__FCTopology}, paths:{__String}, opts:OptionsPattern[]] :=
	MapThread[FSACreateMathematicaScripts[#1,#2,#3,opts]&,{glis,FCLoopSelectTopology[#,topos]&/@glis,paths}];


FSACreateMathematicaScripts[glis:{__GLI}, topos:{__FCTopology}, path_String, opts:OptionsPattern[]] :=
	Block[{toposOneToOne},
		toposOneToOne=FCLoopSelectTopology[#,topos]&/@glis;
		MapThread[FSACreateMathematicaScripts[#1,#2,path,opts]&,{glis,toposOneToOne}]
	];

FSACreateMathematicaScripts[expr_/;FreeQ[{GLI,FCTopology},expr], lmoms_List /; !OptionQ[lmoms], dirRaw_String, OptionsPattern[]] :=
	Block[{	ex, topo, isCartesian, optNames, newNames, res, dim, file, filePath, optOverwriteTarget, optFSAPath,
			time, optStringReplace, scriptFileString, optFSAOrderInEps, scalarPart, tensorPart, fcProps, fcPref,
			fsaPref, fsaProps, fsaReplacements, fsaLmoms, fsaPowerlist, optFSANumberOfSubkernels, optFSANumberOfLinks,
			optFSAComplexMode, optFSAReturnErrorWithBrackets, optFSAPrecision, fsaOptionsString, fPar, fp, momHold,
			momHoldList, vars, rulesDV, spDownValuesLhs, inverseFiestaMeasure, optFSAParameterRules, parameters,
			parameterValues, optFinalSubstitutions, optFSAAdditionalPrefactor,	optFSAStrategy, optFSASectorSymmetries,
			optFSAd0, optFSAUsingC, optFSARegVar, optFSAExpandVar, optFSAXVar, optFSAEpVarNegativeTermsHandling,
			optFSAPMVar, optFSAGraph,optFSAPrimarySectorCoefficients, optFSAOnlyPrepare, optFSAFixSectors,
			optFSAMixSectors, optFSASectorSplitting, optFSAMinimizeContourTransformation, optFSAContourShiftShape,
			optFSAContourShiftCoefficient, optFSAContourShiftIgnoreFail, optFSAFixedContourShift, optFSALambdaIterations,
			optFSALambdaSplit, optFSAChunkSize, optFSAOptimizeIntegrationStrings, optFSAAnalyzeWorstPower, optFSAZeroCheckCount,
			optFSAExpandResult, optFSADataPath, optFSABucketSize, optFSANoDatabaseLock, optFSARemoveDatabases, optFSASeparateTerms,
			optFSABalanceSamplingPoints, optFSABalanceMode, optFSABalancePower, optFSAResolutionMode, optFSAAnalyticIntegration,
			optFSAOnlyPrepareRegions, optFSAAsyLP, optFSARegionNumber, optFSAPolesMultiplicity, optFSAExactIntegrationOrder,
			optFSAExactIntegrationTimeout, optFSAGPUIntegration, optFSANoAVX, optFSAAssemblyIntegration, optFSAIntegrator,
			optFSAIntegratorOptions, optFSACIntegratePath, optFSAMPSmallX, optFSAMPThreshold, optFSAMPMin, optFSAMPPrecisionShift,
			optFSAMathematicaBinary, optFSAQHullPath, optFSADebugParallel, optFSADebugMemory, optFSADebugAllEntries, optFSADebugSector,
			numResString, optFSASDExpandAsy, optFSASDExpandAsyOrder, check},

		If[	OptionValue[FCVerbose]===False,
			fspsVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fspsVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget					= OptionValue[OverwriteTarget];
		optFSAPath							= OptionValue[FSAPath];
		optFSAOrderInEps					= OptionValue[FSAOrderInEps];
		optFSANumberOfSubkernels			= OptionValue[FSANumberOfSubkernels];
		optFSANumberOfLinks 				= OptionValue[FSANumberOfLinks];
		optFSAComplexMode					= OptionValue[FSAComplexMode];
		optFSAReturnErrorWithBrackets 		= OptionValue[FSAReturnErrorWithBrackets];
		optFSAPrecision 					= OptionValue[FSAPrecision];
		optStringReplace					= OptionValue[StringReplace];
		optFSAParameterRules				= OptionValue[FSAParameterRules];
		optFinalSubstitutions				= OptionValue[FinalSubstitutions];
		optFSAAdditionalPrefactor			= OptionValue[FSAAdditionalPrefactor];
		optFSAStrategy 						= OptionValue[FSAStrategy];
		optFSASectorSymmetries 				= OptionValue[FSASectorSymmetries];
		optFSAd0 							= OptionValue[FSAd0];
		optFSAUsingC 						= OptionValue[FSAUsingC];
		optFSARegVar 						= OptionValue[FSARegVar];
		optFSAExpandVar 					= OptionValue[FSAExpandVar];
		optFSAXVar 							= OptionValue[FSAXVar];
		optFSAEpVarNegativeTermsHandling	= OptionValue[FSAEpVarNegativeTermsHandling];
		optFSAPMVar 						= OptionValue[FSAPMVar];
		optFSAGraph 						= OptionValue[FSAGraph];
		optFSAPrimarySectorCoefficients 	= OptionValue[FSAPrimarySectorCoefficients];
		optFSAOnlyPrepare 					= OptionValue[FSAOnlyPrepare];
		optFSAFixSectors 					= OptionValue[FSAFixSectors];
		optFSAMixSectors 					= OptionValue[FSAMixSectors];
		optFSASectorSplitting 				= OptionValue[FSASectorSplitting];
		optFSAMinimizeContourTransformation = OptionValue[FSAMinimizeContourTransformation];
		optFSAContourShiftShape 			= OptionValue[FSAContourShiftShape];
		optFSAContourShiftCoefficient 		= OptionValue[FSAContourShiftCoefficient];
		optFSAContourShiftIgnoreFail 		= OptionValue[FSAContourShiftIgnoreFail];
		optFSAFixedContourShift 			= OptionValue[FSAFixedContourShift];
		optFSALambdaIterations 				= OptionValue[FSALambdaIterations];
		optFSALambdaSplit 					= OptionValue[FSALambdaSplit];
		optFSAChunkSize 					= OptionValue[FSAChunkSize];
		optFSAOptimizeIntegrationStrings 	= OptionValue[FSAOptimizeIntegrationStrings];
		optFSAAnalyzeWorstPower 			= OptionValue[FSAAnalyzeWorstPower];
		optFSAZeroCheckCount 				= OptionValue[FSAZeroCheckCount];
		optFSAExpandResult 					= OptionValue[FSAExpandResult];
		optFSADataPath 						= OptionValue[FSADataPath];
		optFSABucketSize 					= OptionValue[FSABucketSize];
		optFSANoDatabaseLock 				= OptionValue[FSANoDatabaseLock];
		optFSARemoveDatabases				= OptionValue[FSARemoveDatabases];
		optFSASeparateTerms 				= OptionValue[FSASeparateTerms];
		optFSABalanceSamplingPoints 		= OptionValue[FSABalanceSamplingPoints];
		optFSABalanceMode 					= OptionValue[FSABalanceMode];
		optFSABalancePower 					= OptionValue[FSABalancePower];
		optFSAResolutionMode				= OptionValue[FSAResolutionMode];
		optFSAAnalyticIntegration 			= OptionValue[FSAAnalyticIntegration];
		optFSAOnlyPrepareRegions 			= OptionValue[FSAOnlyPrepareRegions];
		optFSAAsyLP 						= OptionValue[FSAAsyLP];
		optFSARegionNumber 					= OptionValue[FSARegionNumber];
		optFSAPolesMultiplicity 			= OptionValue[FSAPolesMultiplicity];
		optFSAExactIntegrationOrder 		= OptionValue[FSAExactIntegrationOrder];
		optFSAExactIntegrationTimeout 		= OptionValue[FSAExactIntegrationTimeout];
		optFSAGPUIntegration 				= OptionValue[FSAGPUIntegration];
		optFSANoAVX 						= OptionValue[FSANoAVX];
		optFSAAssemblyIntegration 			= OptionValue[FSAAssemblyIntegration];
		optFSAIntegrator 					= OptionValue[FSAIntegrator];
		optFSAIntegratorOptions				= OptionValue[FSAIntegratorOptions];
		optFSACIntegratePath 				= OptionValue[FSACIntegratePath];
		optFSAMPSmallX 						= OptionValue[FSAMPSmallX];
		optFSAMPThreshold 					= OptionValue[FSAMPThreshold];
		optFSAMPMin 						= OptionValue[FSAMPMin];
		optFSAMPPrecisionShift 				= OptionValue[FSAMPPrecisionShift];
		optFSAMathematicaBinary 			= OptionValue[FSAMathematicaBinary];
		optFSAQHullPath 					= OptionValue[FSAQHullPath];
		optFSADebugParallel 				= OptionValue[FSADebugParallel];
		optFSADebugMemory 					= OptionValue[FSADebugMemory];
		optFSADebugAllEntries 				= OptionValue[FSADebugAllEntries];
		optFSADebugSector 					= OptionValue[FSADebugSector];


		optFSASDExpandAsy 					= OptionValue[FSASDExpandAsy];
		optFSASDExpandAsyOrder 				= OptionValue[FSASDExpandAsyOrder];



		FCPrint[1,"FSACreateMathematicaScripts: Entering.", FCDoControl->fspsVerbose];


		If[	OptionValue[FCI],
			ex = expr,
			{ex, optFinalSubstitutions} = FCI[{expr,optFinalSubstitutions}]
		];

		FCPrint[1,"FSACreateMathematicaScripts: Entering with: ", ex, FCDoControl->fspsVerbose];
		FCPrint[1,"FSACreateMathematicaScripts: Final substitutions: ", optFinalSubstitutions, FCDoControl->fspsVerbose];
		FCPrint[1,"FSACreateMathematicaScripts: Parameter rules: ", optFSAParameterRules, FCDoControl->fspsVerbose];

		If [!FreeQ2[$ScalarProducts, lmoms],
			Message[FSACreateMathematicaScripts::failmsg, "Some of the loop momenta have scalar product rules attached to them."];
			Abort[]
		];

		If[	!FCDuplicateFreeQ[lmoms],
			Message[FSACreateMathematicaScripts::failmsg, "The list of the loop momenta may not contain duplicate entries."];
			Abort[]
		];

		If[	!MatchQ[ex,{__}|_. _FeynAmpDenominator],
			Message[FSACreateMathematicaScripts::failmsg, "The input expression is not a proper integral or list of propagators"];
			Abort[]

		];

		If[	!(optFinalSubstitutions==={} || MatchQ[optFinalSubstitutions,{Rule[_,_]..}]),
			Message[FSACreateMathematicaScripts::failmsg, "Incorrect value of the FinalSubstitutions option."];
			Abort[];
		];

		If[	!(optFSAParameterRules==={} || MatchQ[optFSAParameterRules,{Rule[_,_?NumberQ]..}]),
			Message[FSACreateMathematicaScripts::failmsg, "Incorrect value of the FSAParameterRules option."];
			Abort[];
		];

		If[	!(optFSAExpandVar===Default || MatchQ[optFSAExpandVar,_Symbol]),
			Message[FSACreateMathematicaScripts::failmsg, "Incorrect value of the FSAExpandVar option."];
			Abort[];
		];

		If[	!(optFSARegVar===Default || MatchQ[optFSARegVar,_Symbol]),
			Message[FSACreateMathematicaScripts::failmsg, "Incorrect value of the FSARegVar option."];
			Abort[];
		];

		If[	!(optFSAPrecision===Default || MatchQ[optFSAPrecision,_Integer?Positive]),
			Message[FSACreateMathematicaScripts::failmsg, "Incorrect value of the FSAPrecision option."];
			Abort[];
		];

		If[	!MemberQ[{"tensorTrain","quasiMonteCarlo","vegasCuba","suaveCuba","divonneCuba","cuhreCuba"},optFSAIntegrator],
			Message[FSACreateMathematicaScripts::failmsg, "Incorrect value of the FSARegVar option."];
			Abort[];
		];

		If[	!MemberQ[{False,True},optFSAComplexMode],
			Message[FSACreateMathematicaScripts::failmsg, "Incorrect value of the FSARegVar option."];
			Abort[];
		];

		If[	FCLoopGetEtaSigns[ex]=!={-1},
			Message[FSACreateMathematicaScripts::failmsg, "The positive sign of I*eta is incompatible with the FIESTA conventions."];
			Abort[];
		];

		If[	!(MatchQ[optFSAOrderInEps, _Integer]),
			Message[FSACreateMathematicaScripts::failmsg, "Incorrect value of the FSAOrderInEps option."];
			Abort[];
		];

		Which[
			!FreeQ2[ex, {Momentum, LorentzIndex}] && FreeQ2[ex, {CartesianMomentum,CartesianIndex}],
			FCPrint[1,"FSACreateMathematicaScripts: Lorentzian integral. ", FCDoControl->fspsVerbose];
			isCartesian=False,

			FreeQ2[ex, {Momentum, LorentzIndex}] && !FreeQ2[ex, {CartesianMomentum,CartesianIndex}],
			FCPrint[1,"FSACreateMathematicaScripts: Cartesian integral. ", FCDoControl->fspsVerbose];
			isCartesian=True,


			!FreeQ2[ex, {Momentum, LorentzIndex}] && !FreeQ2[ex, {CartesianMomentum,CartesianIndex}],
			FCPrint[1,"FSACreateMathematicaScripts: Mixed integral. ", FCDoControl->fspsVerbose];
			Message[FSACreateMathematicaScripts::failmsg,"Integrals that simultaneously depend on Lorentz and Cartesian vectors are not supported."];
			Abort[]
		];


		dim = FCGetDimensions[ex/. {TemporalPair[_,ExplicitLorentzIndex[0]]:>Unique[]}];

		If[	Length[dim]=!=1,
			Message[FSACreateMathematicaScripts::failmsg,"The loop integrals contains momenta in different dimensions."];
			Abort[]
		];

		dim = First[dim];

		FCPrint[1,"FSACreateMathematicaScripts: Dimension: ", dim, FCDoControl->fspsVerbose];

		If[	Union[FreeQ[ex,#]&/@lmoms]=!={False},
			Message[FSACreateMathematicaScripts::failmsg,"Some of the specified loop momenta are not contained in the input expression."];
			Abort[]
		];

		If[	Head[ex]===List,
			Which[
				FreeQ2[ex,{LorentzIndex,CartesianIndex}],
					scalarPart = ex;
					tensorPart = 1,
				FreeQ2[Most[ex],{LorentzIndex,CartesianIndex}] && !FreeQ2[Last[ex],{LorentzIndex,CartesianIndex}],
					tensorPart = Last[ex];
					scalarPart = Most[ex],
				True,
				Message[FSACreateMathematicaScripts::failmsg,"Failed to parse the supplied list of propagators."];
				Abort[]
			],
			{scalarPart, tensorPart} =  FCProductSplit[ex, {LorentzIndex, CartesianIndex}]
		];

		FCPrint[3,"FSACreateMathematicaScripts: scalarPart: ", scalarPart, FCDoControl->fspsVerbose];
		FCPrint[3,"FSACreateMathematicaScripts: tensorPart: ", tensorPart, FCDoControl->fspsVerbose];

		If[	tensorPart=!=1,
			Message[FSACreateMathematicaScripts::failmsg,"Tensor integrals are currently unsupported."];
			Abort[]
		];

		fPar = FCFeynmanPrepare[MomentumExpand[Abs[scalarPart] /. Abs -> Identity]/. Momentum[x_, d___] /; ! MemberQ[lmoms, x] :>
			Momentum[momHold[x], d], lmoms, Names -> fp, FCI->True, FinalSubstitutions->optFinalSubstitutions][[2]];

		momHoldList = Union[Cases[fPar, (CartesianPair | Pair)[x__] /; ! FreeQ[{x}, momHold], Infinity]];

		FCPrint[2,"FSACreateMathematicaScripts: List of all scalar products: ", momHoldList, FCDoControl->fspsVerbose];

		(*Extract scalar products that have been set via down values*)
		spDownValuesLhs = Map[If[FreeQ2[# /. momHold -> Identity, {Pair, CartesianPair}], # /. {Pair -> Hold[Pair],
			CartesianPair -> Hold[CartesianPair]} /. momHold -> Identity, Unevaluated[Sequence[]]] &, momHoldList];

		(*Remove scalar products set via the FinalSubstitutions option*)
		spDownValuesLhs = Map[If[FreeQ2[# /. Hold -> Identity, {Pair, CartesianPair}], #, Unevaluated[Sequence[]]] &, spDownValuesLhs];

		FCPrint[2,"FSACreateMathematicaScripts: Scalar products specified via down values: ", spDownValuesLhs, FCDoControl->fspsVerbose];

		If[	!SubsetQ[$ScalarProducts, Union[spDownValuesLhs /. Hold[Pair | CartesianPair] ->  List /. (h : Momentum | CartesianMomentum)[xx_, ___] :> h[xx]]],
			Message[FSACreateMathematicaScripts::failmsg, "Missing some scalar products specified via down values."];
			Abort[]
		];

		rulesDV = Thread[Rule[spDownValuesLhs, spDownValuesLhs /. Hold -> Identity/. optFinalSubstitutions]];

		FCPrint[2,"FSACreateMathematicaScripts: Rules from down values: ", rulesDV, FCDoControl->fspsVerbose];

		vars = SelectFree[Variables2[fPar/.momHold->Identity /. optFinalSubstitutions], fp];


		If[optFSAParameterRules=!={},
			vars = Variables2[{Last/@optFSAParameterRules,vars}]
		];


		FCPrint[1,"FSACreateMathematicaScripts: vars: ", vars, FCDoControl->fspsVerbose];


		FCPrint[2,"FSACreateMathematicaScripts: Parameter rules: ", optFSAParameterRules, FCDoControl->fspsVerbose];


		If[	optFSAParameterRules=!={},
			(*Removing irrelevant parameters*)
			optFSAParameterRules = SelectNotFree[optFSAParameterRules,vars];
			(*TODO*)
			{parameters, parameterValues} = N[Transpose[List@@@optFSAParameterRules],OptionValue[N]];
			FCPrint[1,"FSACreateMathematicaScripts: parameterValues:  ", optFSAParameterRules, FCDoControl->fspsVerbose];
			If[	!MatchQ[parameterValues,{__?NumberQ}],
				Message[FSACreateMathematicaScripts::failmsg, "Failed to generate the list of numerical values for the parameters."];
				Abort[];
			],

			{parameters, parameterValues} = {{},{}}
		];

		FCPrint[2,"FSACreateMathematicaScripts: Parameters: ", parameters, FCDoControl->fspsVerbose];

		check = SelectFree[vars/.rulesDV/.optFinalSubstitutions/.optFSAParameterRules,{optFSAExpandVar,optFSARegVar}];

		If[	!(MatchQ[check,{__?NumericQ}] || check==={}),
				Message[FSACreateMathematicaScripts::failmsg, "The integral depends on variables that are not specified via the FinalSubstitutions option."];
				FCPrint[0,"FSACreateMathematicaScripts: Unspecified variables: ", check, FCDoControl->fspsVerbose];
				Abort[];
		];


		fcProps = FCLoopIntegralToPropagators[scalarPart, lmoms, Tally -> True, Rest->True];

		fcPref = fcProps[[2]];
		fcProps = fcProps[[1]]//Transpose;

		FCPrint[3,"FSACreateMathematicaScripts: fcProps: ", fcProps, FCDoControl->fspsVerbose];
		FCPrint[3,"FSACreateMathematicaScripts: fcPref: ", fcPref, FCDoControl->fspsVerbose];

		fsaProps = FCLoopPropagatorsToTopology[fcProps[[1]], FCI->True,MomentumCombine->True];

		FCPrint[3,"FSACreateMathematicaScripts: fsaProps: ", fsaProps, FCDoControl->fspsVerbose];

		If[	!FreeQ[fsaProps,Complex],
			Message[FSACreateMathematicaScripts::failmsg, "The list of obtained propagators for pySecDec contains imaginary parts."];
			Abort[]
		];

		{fsaProps, fsaReplacements} =  {fsaProps, Join[rulesDV,optFinalSubstitutions,optFSAParameterRules]} //. {
			Hold[SPD][a_, b_] -> a b,
			Hold[CSPD][a_, b_] -> a b,
			Pair[Momentum[a_,___],Momentum[b_,___]] -> a b,
			CartesianPair[CartesianMomentum[a_,___],CartesianMomentum[b_,___]] -> a b,
			Hold[Pair][Momentum[a_,___],Momentum[b_,___]] -> a b,
			Hold[CartesianPair][CartesianMomentum[a_,___],CartesianMomentum[b_,___]] -> a b
		};

		If[!FreeQ2[{fsaProps,fsaReplacements},{Pair,CartesianPair,Momentum,CartesianMomentum}],
			Message[FSACreateMathematicaScripts::failmsg,"Failed to create a correct list of propagators or replacements."];
			Abort[]
		];

		fsaPref = optFSAAdditionalPrefactor*fcPref;

		fsaProps		= ToString[fsaProps, InputForm];
		fsaPref			= ToString[fsaPref, InputForm];
		fsaReplacements	= ToString[fsaReplacements, InputForm];
		fsaLmoms		= ToString[lmoms, InputForm];
		fsaPowerlist	= ToString[fcProps[[2]],InputForm];

		If[	!DirectoryQ[dirRaw],
			If[	CreateDirectory[dirRaw]===$Failed,
				Message[FSACreateMathematicaScripts::failmsg, "Failed to create directory ", dirRaw];
				Abort[]
			];
		];

		filePath = FileNameJoin[{dirRaw,OptionValue[FSAScriptFileName]}];

		FCPrint[3,"FSACreateMathematicaScripts: Script path: ", filePath, FCDoControl->fspsVerbose];

		If[	FileExistsQ[filePath] && !optOverwriteTarget,
			Message[FSACreateMathematicaScripts::failmsg, "The file ", filePath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		fsaOptionsString = {

			If[	optFSANumberOfSubkernels=!=Default,
					"\"NumberOfSubkernels\" -> " <> ToString[optFSANumberOfSubkernels],
					Unevaluated[Sequence[]]
			],

			If[	optFSANumberOfLinks=!=Default,
					"\"NumberOfLinks\" -> " <> ToString[optFSANumberOfLinks],
					Unevaluated[Sequence[]]
			],

			If[	optFSAComplexMode=!=Default,
					"\"ComplexMode\" -> " <> ToString[optFSAComplexMode],
					Unevaluated[Sequence[]]
			],

			If[	optFSAReturnErrorWithBrackets=!=Default,
					"\"ReturnErrorWithBrackets\" -> " <> ToString[optFSAReturnErrorWithBrackets],
					Unevaluated[Sequence[]]
			],

			If[	optFSAPrecision=!=Default,
					"\"Precision\" -> " <> ToString[optFSAPrecision],
					Unevaluated[Sequence[]]
			],



			If[	optFSAStrategy=!=Default,
					"\"Strategy\" -> " <> ToString[optFSAStrategy],
					Unevaluated[Sequence[]]
			],

			If[	optFSASectorSymmetries=!=Default,
					"\"SectorSymmetries\" -> " <> ToString[optFSASectorSymmetries],
					Unevaluated[Sequence[]]
			],

			If[	optFSAd0=!=Default,
					"\"d0\" -> " <> ToString[optFSAd0],
					Unevaluated[Sequence[]]
			],

			If[	optFSAUsingC=!=Default,
					"\"UsingC\" -> " <> ToString[optFSAUsingC],
					Unevaluated[Sequence[]]
			],

			If[	optFSARegVar=!=Default,
					"\"RegVar\" -> " <> ToString[optFSARegVar],
					Unevaluated[Sequence[]]
			],

			If[	optFSAExpandVar=!=Default,
					"\"ExpandVar\" -> " <> ToString[optFSAExpandVar],
					Unevaluated[Sequence[]]
			],

			If[	optFSAXVar=!=Default,
					"\"XVar\" -> " <> ToString[optFSAXVar],
					Unevaluated[Sequence[]]
			],

			If[	optFSAEpVarNegativeTermsHandling=!=Default,
					"\"EpVarNegativeTermsHandling\" -> " <> ToString[optFSAEpVarNegativeTermsHandling],
					Unevaluated[Sequence[]]
			],


			If[	optFSAPMVar=!=Default,
					"\"PMVar\" -> " <> ToString[optFSAPMVar],
					Unevaluated[Sequence[]]
			],


			If[	optFSAGraph=!=Default,
					"\"Graph\" -> " <> ToString[optFSAGraph],
					Unevaluated[Sequence[]]
			],

			If[	optFSAPrimarySectorCoefficients=!=Default,
					"\"PrimarySectorCoefficients\" -> " <> ToString[optFSAPrimarySectorCoefficients],
					Unevaluated[Sequence[]]
			],

			If[	optFSAOnlyPrepare=!=Default,
					"\"OnlyPrepare\" -> " <> ToString[optFSAOnlyPrepare],
					Unevaluated[Sequence[]]
			],

			If[	optFSAFixSectors=!=Default,
					"\"FixSectors\" -> " <> ToString[optFSAFixSectors],
					Unevaluated[Sequence[]]
			],

			If[	optFSAMixSectors=!=Default,
					"\"MixSectors\" -> " <> ToString[optFSAMixSectors],
					Unevaluated[Sequence[]]
			],

			If[	optFSASectorSplitting=!=Default,
					"\"SectorSplitting\" -> " <> ToString[optFSASectorSplitting],
					Unevaluated[Sequence[]]
			],

			If[	optFSAMinimizeContourTransformation=!=Default,
					"\"MinimizeContourTransformation\" -> " <> ToString[optFSAMinimizeContourTransformation],
					Unevaluated[Sequence[]]
			],

			If[	optFSAContourShiftShape=!=Default,
					"\"ContourShiftShape\" -> " <> ToString[optFSAContourShiftShape],
					Unevaluated[Sequence[]]
			],

			If[	optFSAContourShiftCoefficient=!=Default,
					"\"ContourShiftCoefficient\" -> " <> ToString[optFSAContourShiftCoefficient],
					Unevaluated[Sequence[]]
			],

			If[	optFSAContourShiftIgnoreFail=!=Default,
					"\"ContourShiftIgnoreFail\" -> " <> ToString[optFSAContourShiftIgnoreFail],
					Unevaluated[Sequence[]]
			],


			If[	optFSAFixedContourShift=!=Default,
					"\"FixedContourShift\" -> " <> ToString[optFSAFixedContourShift],
					Unevaluated[Sequence[]]
			],

			If[	optFSALambdaIterations=!=Default,
					"\"LambdaIterations\" -> " <> ToString[optFSALambdaIterations],
					Unevaluated[Sequence[]]
			],

			If[	optFSALambdaSplit=!=Default,
					"\"LambdaSplit\" -> " <> ToString[optFSALambdaSplit],
					Unevaluated[Sequence[]]
			],

			If[	optFSAChunkSize=!=Default,
					"\"ChunkSize\" -> " <> ToString[optFSAChunkSize],
					Unevaluated[Sequence[]]
			],

			If[	optFSAOptimizeIntegrationStrings=!=Default,
					"\"OptimizeIntegrationStrings\" -> " <> ToString[optFSAOptimizeIntegrationStrings],
					Unevaluated[Sequence[]]
			],

			If[	optFSAAnalyzeWorstPower=!=Default,
					"\"AnalyzeWorstPower\" -> " <> ToString[optFSAAnalyzeWorstPower],
					Unevaluated[Sequence[]]
			],

			If[	optFSAZeroCheckCount=!=Default,
					"\"ZeroCheckCount\" -> " <> ToString[optFSAZeroCheckCount],
					Unevaluated[Sequence[]]
			],

			If[	optFSAExpandResult=!=Default,
					"\"ExpandResult\" -> " <> ToString[optFSAExpandResult],
					Unevaluated[Sequence[]]
			],

			If[	optFSADataPath=!=Default,
					"\"DataPath\" -> " <> ToString[optFSADataPath],
					Unevaluated[Sequence[]]
			],

			If[	optFSABucketSize=!=Default,
					"\"BucketSize\" -> " <> ToString[optFSABucketSize],
					Unevaluated[Sequence[]]
			],


			If[	optFSANoDatabaseLock=!=Default,
					"\"NoDatabaseLock\" -> " <> ToString[optFSANoDatabaseLock],
					Unevaluated[Sequence[]]
			],

			If[	optFSARemoveDatabases=!=Default,
					"\"RemoveDatabases\" -> " <> ToString[optFSARemoveDatabases],
					Unevaluated[Sequence[]]
			],

			If[	optFSASeparateTerms=!=Default,
					"\"SeparateTerms\" -> " <> ToString[optFSASeparateTerms],
					Unevaluated[Sequence[]]
			],

			If[	optFSABalanceSamplingPoints=!=Default,
					"\"BalanceSamplingPoints\" -> " <> ToString[optFSABalanceSamplingPoints],
					Unevaluated[Sequence[]]
			],

			If[	optFSABalanceMode=!=Default,
					"\"BalanceMode\" -> " <> ToString[optFSABalanceMode],
					Unevaluated[Sequence[]]
			],

			If[	optFSABalancePower=!=Default,
					"\"BalancePower\" -> " <> ToString[optFSABalancePower],
					Unevaluated[Sequence[]]
			],

			If[	optFSAResolutionMode=!=Default,
					"\"ResolutionMode\" -> " <> ToString[optFSAResolutionMode],
					Unevaluated[Sequence[]]
			],

			If[	optFSAAnalyticIntegration=!=Default,
					"\"AnalyticIntegration\" -> " <> ToString[optFSAAnalyticIntegration],
					Unevaluated[Sequence[]]
			],

			If[	optFSAOnlyPrepareRegions=!=Default,
					"\"OnlyPrepareRegions\" -> " <> ToString[optFSAOnlyPrepareRegions],
					Unevaluated[Sequence[]]
			],

			If[	optFSAAsyLP=!=Default,
					"\"AsyLP\" -> " <> ToString[optFSAAsyLP],
					Unevaluated[Sequence[]]
			],


			If[	optFSARegionNumber=!=Default,
					"\"RegionNumber\" -> " <> ToString[optFSARegionNumber],
					Unevaluated[Sequence[]]
			],

			If[	optFSAPolesMultiplicity=!=Default,
					"\"PolesMultiplicity\" -> " <> ToString[optFSAPolesMultiplicity],
					Unevaluated[Sequence[]]
			],

			If[	optFSAExactIntegrationOrder=!=Default,
					"\"ExactIntegrationOrder\" -> " <> ToString[optFSAExactIntegrationOrder],
					Unevaluated[Sequence[]]
			],

			If[	optFSAExactIntegrationTimeout=!=Default,
					"\"ExactIntegrationTimeout\" -> " <> ToString[optFSAExactIntegrationTimeout],
					Unevaluated[Sequence[]]
			],

			If[	optFSAGPUIntegration=!=Default,
					"\"GPUIntegration\" -> " <> ToString[optFSAGPUIntegration],
					Unevaluated[Sequence[]]
			],

			If[	optFSANoAVX=!=Default,
					"\"NoAVX\" -> " <> ToString[optFSANoAVX],
					Unevaluated[Sequence[]]
			],

			If[	optFSAAssemblyIntegration=!=Default,
					"\"AssemblyIntegration\" -> " <> ToString[optFSAAssemblyIntegration],
					Unevaluated[Sequence[]]
			],

			If[	optFSAIntegrator=!=Default,
					"\"Integrator\" -> " <> ToString[optFSAIntegrator,InputForm],
					Unevaluated[Sequence[]]
			],

			If[	optFSAIntegratorOptions=!=Default,
					"\"IntegratorOptions\" -> " <> ToString[Map[{ToString[#[[1]], InputForm], ToString[#[[2]],InputForm]} &, optFSAIntegratorOptions]],
					Unevaluated[Sequence[]]
			],

			If[	optFSACIntegratePath=!=Default,
					"\"CIntegratePath\" -> " <> ToString[optFSACIntegratePath],
					Unevaluated[Sequence[]]
			],


			If[	optFSAMPSmallX=!=Default,
					"\"MPSmallX\" -> " <> ToString[optFSAMPSmallX],
					Unevaluated[Sequence[]]
			],

			If[	optFSAMPThreshold=!=Default,
					"\"MPThreshold\" -> " <> ToString[optFSAMPThreshold],
					Unevaluated[Sequence[]]
			],

			If[	optFSAMPMin=!=Default,
					"\"MPMin\" -> " <> ToString[optFSAMPMin],
					Unevaluated[Sequence[]]
			],

			If[	optFSAMPPrecisionShift=!=Default,
					"\"MPPrecisionShift\" -> " <> ToString[optFSAMPPrecisionShift],
					Unevaluated[Sequence[]]
			],

			If[	optFSAMathematicaBinary=!=Default,
					"\"MathematicaBinary\" -> " <> ToString[optFSAMathematicaBinary],
					Unevaluated[Sequence[]]
			],

			If[	optFSAQHullPath=!=Default,
					"\"QHullPath\" -> " <> ToString[optFSAQHullPath],
					Unevaluated[Sequence[]]
			],

			If[	optFSADebugParallel=!=Default,
					"\"DebugParallel\" -> " <> ToString[optFSADebugParallel],
					Unevaluated[Sequence[]]
			],

			If[	optFSADebugMemory=!=Default,
					"\"DebugMemory\" -> " <> ToString[optFSADebugMemory],
					Unevaluated[Sequence[]]
			],

			If[	optFSADebugAllEntries=!=Default,
					"\"DebugAllEntries\" -> " <> ToString[optFSADebugAllEntries],
					Unevaluated[Sequence[]]
			],

			If[	optFSADebugSector=!=Default,
					"\"DebugSector\" -> " <> ToString[optFSADebugSector],
					Unevaluated[Sequence[]]
			]

		};

		fsaOptionsString = StringRiffle[fsaOptionsString,","];

		numResString = "numres_" <> StringRiffle[ToString[#, InputForm]&/@parameterValues, "_"] <> "_fiesta.m";


		scriptFileString = {
			If[	OptionValue[DateString],
				"(* Generated on "<> DateString[] <>" *)\n\n",
				Unevaluated[Sequence[]]
			],
			"Get["<> ToString[optFSAPath,InputForm]  <>"];\n",
			"\n\n",
			"If[$FrontEnd===Null,\n",
			"  projectDirectory=DirectoryName[$InputFileName],\n",
			"  projectDirectory=NotebookDirectory[]\n",
			"];\n",
			"SetDirectory[projectDirectory];\n",
			"resFileName = \"numres_\" <> StringRiffle[ToString[#, InputForm] & /@ " <> ToString[parameterValues,InputForm] <>  ", \"_\"]<>\"_fiesta.m\";\n",
			"Print[\"Working directory: \", projectDirectory];\n",
			"Print[\"The results will be saved to: \", resFileName];\n",
			"\n\n",
			"uf = UF[" <> fsaLmoms <> "," <> fsaProps <> ", " <> fsaReplacements <>	"];\n",

			If[StringJoin[fsaOptionsString]=!="",
				"SetOptions[FIESTA, " <> StringJoin[fsaOptionsString] <>"];\n",
				Unevaluated[Sequence[]]
			],

			"pref = " <> fsaPref <> ";\n",
			If[	!TrueQ[optFSASDExpandAsy],
			"resRaw = SDEvaluate[uf," <> fsaPowerlist <> "," <> ToString[optFSAOrderInEps,InputForm] <> "];\n",
			"resRaw = SDExpandAsy[uf," <> fsaPowerlist <> "," <> ToString[optFSAOrderInEps,InputForm] <> "," <>
				ToString[optFSASDExpandAsyOrder,InputForm] <> "];\n"
			],
			"res = resRaw*pref;\n",
			"Print[\"Final result: \", res];\n",
			"Put[res, resFileName];"
		};

		file = OpenWrite[filePath];
		If[	file===$Failed,
			Message[FSACreateMathematicaScripts::failmsg, "Failed to open ", filePath, " for writing."];
			Abort[]
		];

		If[	optStringReplace=!={},
			scriptFileString = StringReplace[scriptFileString,optStringReplace]
		];

		scriptFileString = StringJoin[scriptFileString];

		WriteString[file, scriptFileString];

		Close[file];

		FCPrint[1,"FSACreateMathematicaScripts: Leaving.\n", FCDoControl->fspsVerbose];

		{filePath,numResString}
	];


End[]
