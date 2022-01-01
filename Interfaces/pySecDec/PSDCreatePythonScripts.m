(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDCreatePythonScripts									*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates input for LoopIntegralFromPropagators				*)

(* ------------------------------------------------------------------------ *)

PSDCreatePythonScripts::usage=
"PSDCreatePythonScripts[int, {q1, q2, ...}, dir] creates a set of Python
scripts needed for the evaluation of the integral int using pySecDec. The
scripts are saved to the directory dir.

It is also possible to invoke the function as PSDCreatePythonScripts[GLI[...],
FCTopology[...]] or PSDCreatePythonScripts[FCTopology[...]]. Notice that in this
case the value of the option FinalSubstitutions is ignored, as replacement
rules will be extracted directly from the definition of the topology.
";

PSDLoopIntegralName::usage=
"PSDLoopIntegralName is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It specifies the name assigned to the output of pySecDec's
LoopIntegralFromPropagators function. The default value is \"li\".";

PSDOutputDirectory::usage=
"PSDOutputDirectory is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It specifies the C++ namespace and the output directory.
The default value is \"loopint\".";

PSDRequestedOrder::usage=
"PSDRequestedOrder is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It specifies the needed order in the eps-expansion. The default
value is 0.";

PSDExpansionByRegionsOrder::usage=
"PSDRequestedOrder is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It specifies up to which order the expression should be expanded
in a small parameter using the method of regions. The default value is 0.

The small parameter must be specified via the option PSDExpansionByRegionsParameter.";

PSDExpansionByRegionsParameter::usage=
"PSDRequestedOrder is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It specifies the small parameter in which the given loop integral
will be expanded using the method of regions. The default value is None, meaning that
no expansion takes place.

The order up to which the expansion should be carried out must be specified via the
option PSDExpansionByRegionsOrder.";

PSDGenerateFileName::usage=
"PSDGenerateFileName is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It specifies the name of the Python script that generates the
C++ package needed for the integral evaluation. The default value \"generate_int.py\"";

PSDIntegrateFileName::usage=
"PSDIntegrateFileName is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It specifies the name of the Python script that performs the numerical
integration using the previously generated C++ package. The default value \"integrate_int.py\"";

PSDOverwritePackageDirectory::usage=
"PSDOverwritePackageDirectory is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. If set to True, the pySecDec script responsible for the generation
of the integral will overwrite an existing C++ package directory."

PSDRealParameterRules::usage=
"PSDRealParameterRules is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It is a list of replacement rules containing numerical values for the
real parameters of the integral.";

PSDComplexParameterRules::usage=
"PSDComplexParameterRules is an option for PSDCreatePythonScripts and other functions of the
pySecDec interface. It is a list of replacement rules containing numerical values for the
complex parameters of the integral.";

PSDCreatePythonScripts::failmsg =
"Error! PSDCreatePythonScripts has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`PSDCreatePythonScripts`Private`"]

psdpVerbose::usage="";

Options[PSDCreatePythonScripts] = {
	FCI										-> False,
	FCReplaceD								-> {D->4-2 Epsilon},
	FCVerbose								-> False,
	FinalSubstitutions						-> {},
	Names 									-> "x",
	OverwriteTarget							-> False,
	PSDAdditionalPrefactor					-> Default,
	PSDAddMonomialRegulatorPower			-> Default,
	PSDCPUThreads							-> Default,
	PSDComplexParameterRules				-> {},
	PSDCoefficients							-> Default,
	PSDContourDeformation 					-> True,
	PSDDecompositionMethod					-> "geometric",
	PSDDecreaseToPercentage					-> Default,
	PSDDeformationParametersDecreaseFactor	-> Default,
	PSDDeformationParametersMaximum			-> Default,
	PSDDeformationParametersMinimum			-> Default,
	PSDEnforceComplex						-> Default,
	PSDEpsAbs								-> Default,
	PSDEpsRel								-> Default,
	PSDErrorMode							-> Default,
	PSDEvaluateMinn							-> Default,
	PSDExpansionByRegionsOrder				-> 0,
	PSDExpansionByRegionsParameter			-> None,
	PSDFitFunction							-> Default,
	PSDFlags								-> Default,
	PSDFormExecutable						-> Default,
	PSDFormMemoryUse						-> Default,
	PSDFormOptimizationLevel				-> Default,
	PSDFormThreads							-> Default,
	PSDFormWorkSpace						-> Default,
	PSDGenerateFileName						-> "generate_int.py",
	PSDGeneratingVectors					-> Default,
	PSDIntegrateFileName					-> "integrate_int.py",
	PSDIntegrator							-> "Qmc",
	PSDLoopIntegralName						-> "li",
	PSDMaxEpsAbs							-> Default,
	PSDMaxEpsRel							-> Default,
	PSDMaxEval								-> Default,
	PSDMaxIncreaseFac						-> Default,
	PSDMinDecreaseFactor					-> Default,
	PSDMinEpsAbs							-> Default,
	PSDMinEpsRel							-> Default,
	PSDMinEval								-> Default,
	PSDMinm									-> Default,
	PSDMinn									-> Default,
	PSDNormalizExecutable					-> Default,
	PSDNumberOfPresamples					-> Default,
	PSDNumberOfThreads						-> Default,
	PSDOutputDirectory						-> "loopint",
	PSDOverwritePackageDirectory				-> False,
	PSDPyLinkQMCTransforms					-> Default,
	PSDRealParameterRules					-> {},
	PSDRegulators							-> {Epsilon},
	PSDRequestedOrder						-> 0,
	PSDResetCudaAfter						-> Default,
	PSDSplit								-> Default,
	PSDTransform							-> Default,
	PSDVerbose								-> True,
	PSDVerbosity							-> Default,
	PSDWallClockLimit						-> Default
};


PSDCreatePythonScripts[gli_GLI, topos:{__FCTopology}, path_String, opts:OptionsPattern[]] :=
	PSDCreatePythonScripts[gli, FCLoopSelectTopology[gli,topos], path, opts];

PSDCreatePythonScripts[gli_GLI, topo_FCTopology, path_String, opts:OptionsPattern[]] :=
	Block[{int,optFinalSubstitutions},

		int = FCLoopFromGLI[gli, topo, FCI->OptionValue[FCI]];

		If[	OptionValue[FCI],
			optFinalSubstitutions = topo[[5]],
			optFinalSubstitutions = FCI[topo[[5]]]
		];

		PSDCreatePythonScripts[int, topo[[3]], path, Join[{FCI->True,FinalSubstitutions->optFinalSubstitutions},
			FilterRules[{opts}, Except[FCI | FinalSubstitutions]]]]
	];


PSDCreatePythonScripts[glis:{__GLI}, topos:{__FCTopology}, paths:{__String}, opts:OptionsPattern[]] :=
	MapThread[PSDCreatePythonScripts[#1,#2,#3,opts]&,{glis,FCLoopSelectTopology[#,topos]&/@glis,paths}];


PSDCreatePythonScripts[glis:{__GLI}, topos:{__FCTopology}, path_String, opts:OptionsPattern[]] :=
	Block[{toposOneToOne},
		toposOneToOne=FCLoopSelectTopology[#,topos]&/@glis;
		MapThread[PSDCreatePythonScripts[#1,#2,FileNameJoin[{path,ToString[FCLoopGLIToSymbol[#1]]}],opts]&,{glis,toposOneToOne}]
	];

PSDCreatePythonScripts[expr_/;FreeQ2[expr,{GLI,FCTopology}], lmomsRaw_List, dir_String, OptionsPattern[]] :=
	Block[{	ex, loopPackage, loopIntegralFromPropagators, nLoops, optPSDLoopIntegralName, lmoms,
			optPSDOutputDirectory, optPSDRequestedOrder, generateFileString, status,
			optPSDGenerateFileName, optPSDIntegrateFileName, filePath, file,
			integratorString, integrationString, optPSDOverwritePackageDirectory,
			optOverwriteTarget, integrateFileString, numParamsReal, numParamsComplex, sumPackage,
			optFinalSubstitutions, fp, vars, realParameters, optPSDExpansionByRegionsParameter,
			complexParameters, optPSDRealParameterRules, extraPref, optPSDExpansionByRegionsOrder,
			optPSDComplexParameterRules, realParameterValues, complexParameterValues, loopRegions, tmp},

		optPSDLoopIntegralName				= OptionValue[PSDLoopIntegralName];
		optPSDOutputDirectory				= OptionValue[PSDOutputDirectory];
		optPSDRequestedOrder				= OptionValue[PSDRequestedOrder];
		optPSDGenerateFileName				= OptionValue[PSDGenerateFileName];
		optPSDIntegrateFileName 			= OptionValue[PSDIntegrateFileName];
		optFinalSubstitutions				= OptionValue[FinalSubstitutions];
		optPSDRealParameterRules			= OptionValue[PSDRealParameterRules];
		optPSDComplexParameterRules			= OptionValue[PSDComplexParameterRules];
		optPSDOverwritePackageDirectory		= OptionValue[PSDOverwritePackageDirectory];
		optPSDExpansionByRegionsParameter	= OptionValue[PSDExpansionByRegionsParameter];
		optPSDExpansionByRegionsOrder		= OptionValue[PSDExpansionByRegionsOrder];


		(*Need to validate all options first*)

		If[ !(Head[optPSDLoopIntegralName]===String || optPSDLoopIntegralName===Default),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDLoopIntegralName option."];
			Abort[];
		];

		If[ !(Head[optPSDOutputDirectory]===String || optPSDOutputDirectory===Default),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDOutputDirectory option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDRequestedOrder, _Integer?Positive | 0]),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDRequestedOrder option."];
			Abort[];
		];

		If[ !(Head[optPSDLoopIntegralName]===String),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDLoopIntegralName option."];
			Abort[];
		];

		If[	!MatchQ[optFinalSubstitutions, {___Rule}],
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the FinalSubstitutions option."];
			Abort[];
		];

		If[	!MatchQ[optPSDRealParameterRules, {___Rule}],
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDRealParameterRules option."];
			Abort[];
		];

		If[	!MatchQ[optPSDComplexParameterRules, {___Rule}],
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDComplexParameterRules option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDExpansionByRegionsParameter, _Symbol | _String] || optPSDExpansionByRegionsParameter===None),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDExpansionByRegionsParameter option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDExpansionByRegionsOrder, _Integer?Positive | 0]),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDExpansionByRegionsOrder option."];
			Abort[];
		];


		If[	OptionValue[FCVerbose]===False,
			psdpVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				psdpVerbose=OptionValue[FCVerbose]
			];
		];


		If[	!OptionValue[FCI],
			{ex, optFinalSubstitutions} = FCI[{expr, optFinalSubstitutions}],
			ex = expr
		];

		FCPrint[1,"PSDCreatePythonScripts: Entering.", FCDoControl->psdpVerbose];
		FCPrint[2,"PSDCreatePythonScripts: Entering with: ", ex, FCDoControl->psdpVerbose];
		FCPrint[2,"PSDCreatePythonScripts: Raw loop momenta: ", lmomsRaw, FCDoControl->psdpVerbose];
		FCPrint[1,"PSDCreatePythonScripts: Output directory: ", dir, FCDoControl->psdpVerbose];

		If[	!(optPSDRealParameterRules==={} || MatchQ[optPSDRealParameterRules,{Rule[_,_?NumberQ]..}]),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the optPSDRealParameterValues option."];
			Abort[];
		];

		If[	!(optPSDComplexParameterRules==={} || MatchQ[optPSDComplexParameterRules,{Rule[_,_?NumberQ]..}]),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the optPSDComplexParameterValues option."];
			Abort[];
		];

		If[	FCLoopGetEtaSigns[ex]=!={1},
			Message[PSDCreatePythonScripts::failmsg, "The negative sign of I*eta is incompatible with the pySecDec conventions."];
			Abort[];
		];

		lmoms = Select[lmomsRaw,!FreeQ[ex,#]&];

		FCPrint[2,"PSDCreatePythonScripts: Relevant loop momenta: ", lmoms, FCDoControl->psdpVerbose];

		nLoops = Length[lmoms];

		vars = SelectFree[Variables2[FCFeynmanPrepare[Abs[ex] /. Abs -> Identity, lmoms, Names -> fp, FCI->True,FinalSubstitutions->optFinalSubstitutions][[2]]], fp];

		If[optFinalSubstitutions=!={},
			vars = Variables2[{Last/@optFinalSubstitutions,vars}]
		];

		FCPrint[1,"PSDCreatePythonScripts: vars: ", vars, FCDoControl->psdpVerbose];

		If[	optPSDRealParameterRules=!={},
			(*Removing irrelevant parameters*)
			optPSDRealParameterRules = SelectNotFree[optPSDRealParameterRules,vars];

			{realParameters, realParameterValues} = Transpose[List@@@optPSDRealParameterRules];
			FCPrint[1,"PSDCreatePythonScripts: realParameterValues:  ", realParameterValues, FCDoControl->psdpVerbose];
			If[	!MatchQ[realParameterValues,{__?NumberQ}],
				Message[PSDCreatePythonScripts::failmsg, "Failed to generate the list of numerica values for the real parameters."];
				Abort[];
			],

			{realParameters, realParameterValues} = {{},{}}
		];

		If[	optPSDComplexParameterRules=!={},
			(*Removing irrelevant parameters*)
			optPSDComplexParameterRules = SelectNotFree[optPSDComplexParameterRules,vars];

			{complexParameters, complexParameterValues} = Transpose[List@@@optPSDComplexParameterRules];
			FCPrint[1,"PSDCreatePythonScripts: complexParameterValues:  ", complexParameterValues, FCDoControl->psdpVerbose];
			If[	!MatchQ[complexParameterValues,{__?NumberQ}],
				Message[PSDCreatePythonScripts::failmsg, "Failed to generate the list of numerica values for the complex parameters."];
				Abort[];
			],

			{complexParameters, complexParameterValues} = {{},{}}
		];

		(*TODO Could also set all variables to 1 if the user didn't bother to specify them...*)

		If[	!FCSubsetQ[Union[realParameters,complexParameters],vars],
				Message[PSDCreatePythonScripts::failmsg, "The integral depends on variables that are not specified via the PSDRealParameters or PSDComplexParameters options."];
				Abort[];
		];

		(*generate psd.LoopIntegralFromPropagators() *)
		{loopIntegralFromPropagators, extraPref} = PSDLoopIntegralFromPropagators[ex, lmoms, FinalSubstitutions->optFinalSubstitutions,
			FCReplaceD->OptionValue[FCReplaceD]];

		FCPrint[3,"PSDCreatePythonScripts: loopIntegralFromPropagators: ", loopIntegralFromPropagators, FCDoControl->psdpVerbose];
		FCPrint[3,"PSDCreatePythonScripts: extraPref: ", extraPref, FCDoControl->psdpVerbose];

		If[	optPSDExpansionByRegionsParameter===None,

			(*Normal mode*)

			loopPackage = PSDLoopPackage[optPSDOutputDirectory, optPSDLoopIntegralName, optPSDRequestedOrder,
				PSDAdditionalPrefactor		-> (*OptionValue[PSDAdditionalPrefactor]*) "("<>ToString[extraPref,InputForm]<>")*exp("<>ToString[nLoops]<>"*EulerGamma*eps)",
				PSDComplexParameters		-> complexParameters,
				PSDContourDeformation 		-> OptionValue[PSDContourDeformation],
				PSDDecompositionMethod		-> OptionValue[PSDDecompositionMethod],
				PSDEnforceComplex			-> OptionValue[PSDEnforceComplex],
				PSDFormMemoryUse			-> OptionValue[PSDFormMemoryUse],
				PSDFormOptimizationLevel	-> OptionValue[PSDFormOptimizationLevel],
				PSDFormThreads				-> OptionValue[PSDFormThreads],
				PSDFormWorkSpace			-> OptionValue[PSDFormWorkSpace],
				PSDNormalizExecutable		-> OptionValue[PSDNormalizExecutable],
				PSDRealParameters			-> realParameters,
				PSDSplit					-> OptionValue[PSDSplit]
			],

			(*Expansion by regions*)

			loopRegions = PSDLoopRegions[optPSDOutputDirectory, optPSDLoopIntegralName, optPSDExpansionByRegionsOrder, optPSDExpansionByRegionsParameter,
				PSDAdditionalPrefactor			-> (*OptionValue[PSDAdditionalPrefactor]*) "("<>ToString[extraPref,InputForm]<>")*exp("<>ToString[nLoops]<>"*EulerGamma*eps)",
				PSDAddMonomialRegulatorPower	-> OptionValue[PSDAddMonomialRegulatorPower],
				PSDContourDeformation 			-> OptionValue[PSDContourDeformation],
				PSDDecompositionMethod			-> OptionValue[PSDDecompositionMethod],
				PSDEnforceComplex				-> OptionValue[PSDEnforceComplex],
				PSDFormOptimizationLevel		-> OptionValue[PSDFormOptimizationLevel],
				PSDFormWorkSpace				-> OptionValue[PSDFormWorkSpace],
				PSDNormalizExecutable			-> OptionValue[PSDNormalizExecutable],
				PSDSplit						-> OptionValue[PSDSplit]
			];

			sumPackage = PSDSumPackage[optPSDOutputDirectory,"regions_generator_args",optPSDRequestedOrder,
				PSDCoefficients				-> OptionValue[PSDCoefficients],
				PSDComplexParameters		-> complexParameters,
				PSDFormExecutable 			-> OptionValue[PSDFormExecutable],
				PSDPyLinkQMCTransforms 		-> OptionValue[PSDPyLinkQMCTransforms],
				PSDRealParameters			-> realParameters,
				PSDRegulators				-> OptionValue[PSDRegulators]
			]
		];

		generateFileString = {
			"#!/usr/bin/env python3",
			"from pySecDec import sum_package, loop_package, loop_regions, LoopIntegralFromPropagators",
			"import pySecDec as psd",
			"",
			optPSDLoopIntegralName <>" = " <> loopIntegralFromPropagators,
			"",
			"import os,shutil",
			"if os.path.isdir('"<>ToString[optPSDOutputDirectory] <> "'):",
			If[optPSDOverwritePackageDirectory,
				"    shutil.rmtree('"<>ToString[optPSDOutputDirectory]<>"')" <> "\n",
				"    if input('The directory loopint already exists, do you want to overwrite it (y/n)? ') in ['y','Y','j']:"
				<> "\n" <>
				"        shutil.rmtree('"<>ToString[optPSDOutputDirectory]<>"')" <> "\n" <>
				"    else:" <> "\n" <> "        exit(1)"
			],
			"",
			If[	optPSDExpansionByRegionsParameter===None,
				(*Normal mode*)
				loopPackage,
				(*Expansion by regions*)
				Sequence@@{
					"regions_generator_args = " <> loopRegions <> "\n",
					"",
					sumPackage,
					""
				}
			],


			""
		};


		If[	!DirectoryQ[dir],
			status = CreateDirectory[dir];
			If[	status===$Failed,
				Message[PSDCreatePythonScripts::failmsg, "Failed to create directory ", dir];
				Abort[]
			];
		];

		generateFileString = StringJoin[StringRiffle[generateFileString, "\n"]];
		FCPrint[3,"PSDCreatePythonScripts: Final generate file:\n\n", generateFileString, FCDoControl->psdpVerbose,WriteStringOutput->True];

		(*generate IntegralLibrary() *)
		{integratorString, integrationString, numParamsReal, numParamsComplex} = PSDIntegrate[
				PSDCPUThreads							-> OptionValue[PSDCPUThreads],
				PSDComplexParameterValues				-> complexParameterValues,
				PSDDecreaseToPercentage					-> OptionValue[PSDDecreaseToPercentage],
				PSDDeformationParametersDecreaseFactor	-> OptionValue[PSDDeformationParametersDecreaseFactor],
				PSDDeformationParametersMaximum			-> OptionValue[PSDDeformationParametersMaximum],
				PSDDeformationParametersMinimum			-> OptionValue[PSDDeformationParametersMinimum],
				PSDEpsAbs								-> OptionValue[PSDEpsAbs],
				PSDEpsRel								-> OptionValue[PSDEpsRel],
				PSDErrorMode							-> OptionValue[PSDErrorMode],
				PSDFitFunction							-> OptionValue[PSDFitFunction],
				PSDGeneratingVectors					-> OptionValue[PSDGeneratingVectors],
				PSDIntegrator							-> OptionValue[PSDIntegrator],
				PSDMaxEpsAbs							-> OptionValue[PSDMaxEpsAbs],
				PSDMaxEpsRel							-> OptionValue[PSDMaxEpsRel],
				PSDMaxEval								-> OptionValue[PSDMaxEval],
				PSDMaxIncreaseFac						-> OptionValue[PSDMaxIncreaseFac],
				PSDMinDecreaseFactor					-> OptionValue[PSDMinDecreaseFactor],
				PSDMinEpsAbs							-> OptionValue[PSDMinEpsAbs],
				PSDMinEpsRel							-> OptionValue[PSDMinEpsRel],
				PSDMinEval								-> OptionValue[PSDMinEval],
				PSDNumberOfPresamples					-> OptionValue[PSDNumberOfPresamples],
				PSDNumberOfThreads						-> OptionValue[PSDNumberOfThreads],
				PSDRealParameterValues					-> realParameterValues,
				PSDResetCudaAfter						-> OptionValue[PSDResetCudaAfter],
				PSDTransform							-> OptionValue[PSDTransform],
				PSDVerbose								-> OptionValue[PSDVerbose],
				PSDVerbosity							-> OptionValue[PSDVerbosity],
				PSDWallClockLimit						-> OptionValue[PSDWallClockLimit],
				PSDEvaluateMinn							-> OptionValue[PSDEvaluateMinn],
				PSDMinn									-> OptionValue[PSDMinn],
				PSDMinm									-> OptionValue[PSDMinm],
				PSDFlags								-> OptionValue[PSDMinm]
		];

		integrateFileString = {
			"#!/usr/bin/env python3",
			"from pySecDec.integral_interface import IntegralLibrary, series_to_mathematica, series_to_maple, series_to_sympy",
			"import sympy as sp",
			"",
			optPSDLoopIntegralName <> " = IntegralLibrary(" <> FeynCalc`Package`psdToString[FileNameJoin[{optPSDOutputDirectory,optPSDOutputDirectory<>"_pylink.so"}]] <> ")",
			"",
			optPSDLoopIntegralName <> integratorString,
			"",
			"num_params_real = " <> numParamsReal,
			"num_params_complex = " <> numParamsComplex,
			"",
			"integral_without_prefactor, prefactor, integral_with_prefactor = " <> optPSDLoopIntegralName <> integrationString,
			"",
			"result, error = map(sp.sympify, series_to_sympy(integral_with_prefactor))",
			"",
			"num_params_real_str = '_'.join(str(val) for val in num_params_real)",
			"if num_params_real_str!='':",
			"    num_params_real_str = '_' + num_params_real_str",
			"",
			"num_params_complex_str = '_'.join(str(val) for val in num_params_complex)",
			"if num_params_complex_str!='':",
			"    num_params_complex_str = '_' + num_params_complex_str",
			"",
			"print('Numerical result')",
			"res_file = open(''.join(['numres',num_params_real_str,num_params_complex_str,'_psd.txt']),'w')",

			"for power in " <> StringReplace[ToString[Table[i, {i, -nLoops*2, optPSDRequestedOrder}]], {"{" -> "[", "}" -> "]"}] <>":",

			"    val = complex(result.coeff('eps', power))",

			"    err = complex(error.coeff('eps', power))",
			"    out=(f'eps^{power:<2} {val: .16f} +/- {err: .16e}')",
			"    res_file.write(out)",
			"    res_file.write('\\n')",
			"    print(out)",
			"res_file.close()",
			"",
			"res_mma= series_to_mathematica(integral_with_prefactor)",
			"",
			"res_file = open(''.join(['numres',num_params_real_str,num_params_complex_str,'_mma.m']),'w')",
			"res_file.write(''.join(['{',res_mma[0],',']))",
			"res_file.write(''.join([res_mma[1],'}']))",
			"res_file.close()",
			"",
			"res_maple= series_to_maple(integral_with_prefactor)",
			"res_file = open(''.join(['numres',num_params_real_str,num_params_complex_str,'_maple.mpl']),'w')",
			"res_file.write(''.join(['[',res_maple[0],',']))",
			"res_file.write(''.join([res_maple[1],']']))",
			"res_file.close()"
		};

		integrateFileString = StringRiffle[integrateFileString,"\n"];

		FCPrint[3,"PSDCreatePythonScripts: Final integrate file:\n\n", integrateFileString, FCDoControl->psdpVerbose,WriteStringOutput->True];

		(*Write files to disk*)


		filePath = FileNameJoin[{dir,optPSDGenerateFileName}];
		FCPrint[1,"PSDCreatePythonScripts: Generate file path: ", filePath, FCDoControl->psdpVerbose];

		If[	FileExistsQ[filePath] && !OptionValue[OverwriteTarget],
			Message[PSDCreatePythonScripts::failmsg, "File " <> filePath <> " already exists and the option OverwriteTarget is set to False."];
			(*Abort[]*)
			Return[False]
		];

		file = OpenWrite[filePath];
		If[	file===$Failed,
			Message[PSDCreatePythonScripts::failmsg, "Failed to open ", file, " for writing."];
			Abort[]
		];
		WriteString[file, generateFileString];
		Close[file];

		tmp = {filePath};

		filePath = FileNameJoin[{dir,optPSDIntegrateFileName}];
		FCPrint[1,"PSDCreatePythonScripts: Integrate file path: ", filePath, FCDoControl->psdpVerbose];

		If[	FileExistsQ[filePath] && !OptionValue[OverwriteTarget],
			Message[PSDCreatePythonScripts::failmsg, "File " <> filePath <> " already exists and the option OverwriteTarget is set to False."];
			(*Abort[]*)
			Return[False]
		];

		file = OpenWrite[filePath];
		If[	file===$Failed,
			Message[PSDCreatePythonScripts::failmsg, "Failed to open ", file, " for writing."];
			Abort[]
		];
		WriteString[file, integrateFileString];
		Close[file];

		FCPrint[1,"PSDCreatePythonScripts: Leaving.", FCDoControl->psdpVerbose];

		Join[tmp,{filePath}]

	];

End[]
