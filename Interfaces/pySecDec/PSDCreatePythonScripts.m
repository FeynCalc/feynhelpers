(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDCreatePythonScripts									*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates input for LoopIntegralFromPropagators				*)

(* ------------------------------------------------------------------------ *)

PSDCreatePythonScripts::usage=
"PSDCreatePythonScripts[int, topo, path] creates a set of Python scripts needed
for the evaluation of the integral int (in the GLI representation) belonging
to the topology topo. The files are saved to the directory
path/topoNameXindices. The function returns a list of two strings that point
to the generation and integration scripts for pySecDec.

One can also use the FeynAmpDenominator-representation as in
PSDCreatePythonScripts[fadInt, lmoms, path], where lmoms is the list of the
loop momenta on which fadInt depends. In this case the generation and
integration scripts will directly go into path.

Another way to invoke the function would be PSDCreatePythonScripts[{int1,
int2, ...}, {topo1, topo2, ...}, path] in which case the files will be saved
to path/topoName1Xindices1, path/topoName2Xindices2 etc. The syntax
PSDCreatePythonScripts[{int1, int2, ...}, {topo1, topo2, ...}, {path1, path2,
...}] is also possible.

Unless you are computing a single scale integral with the scale variable set
to unity, you must specify all external parameters (e.g. masses and scalar
products of external momenta) and their numerical values via the corresponding
options. For real-valued parameters use the option PSDRealParameterRules as
PSDRealParameterRules->{param1->val1, param2->val2, ...}. For complex-valued
parameters use PSDComplexParameterRuleswith the same syntax. The precise
numerical values do not matter at the generation stage, one only has to
distinguish between real- and complex-valued parameters. As far as the
integration stage is concerned, you can easily change the numerical values
when running the corresponding Python script. The values supplied via
PSDRealParameterRules and PSDComplexParameterRules will be the default,
though.

Notice that the variables passed to pySecDec must be atomic i.e. you can use
qq, m, m2, M etc. but not  something like Pair[Momentum[q],Momentum[q]],
mass[2], or sp[\"p.q\"]. This means that you need to replace scalar products
of external momenta that appear in your integrals with some simple symbols. If
this has not been done on the level of replacement rules attached to your
FCTopology objects (5th argument), you can still use the option
FinalSubstitutions.

Another important option that you most likely would like to specify is
PSDRequestedOrder which specifies the order in $\\varepsilon$ up to which the
integral should be evaluated.

The names of generation and integration scripts can be changed via the options
PSDGenerateFileName and PSDIntegrateFileName with the default values being
generate_int.py and integrate_int.py respectively.

The method used for the sector decomposition is controlled by the option
PSDDecompositionMethod, where \"geometric\" is the default value.

The integrator used for the numerical evaluation of the integral is set by the
option PSDIntegrator, where \"Qmc\" is the default value. Accordingly, if you
want to increase the number of Qmc iterations, you should use the option
PSDMinn.

If you know in advance that the integral you are computing does not have cuts
(i.e. the result is purely real with no imaginary part), then it is highly
recommended to disable the contour deformation. This will give you a huge
performance boost. The option controlling this pySecDec parameter is called
PSDContourDeformation and is set to True by default.

The prefactor of integrals evaluated by pySecDec is given by  $\\frac{1}{i
\\pi^{D/2}}$ per loop, which is the standard choice for multiloop calculations.
However, factors of $\\gamma_E$ and $\\log(4\\pi)$ are not eliminated by default.
The FeynHelpers interface takes care of that by adding  an extra $e^{\\gamma_E
\\frac{4-D}{2}}$ per loop. This is controlled by the value of the
PSDAdditionalPrefactor option. When set to Default, the overall prefactor is
given by $\\frac{e^{\\gamma_E \\frac{4-D}{2}}}{i \\pi^{D/2}}$ per loop. Setting
this option to a different value, say x, will give you
$\\frac{x}{(i \\pi^{D/2})^L}$ as the overall prefactor with $L$ being the number
of loops. Notice that in this case x must be a string using the pySecDec
syntax.

For realistic integrals the generation stage can take a considerable amount of
time, especially when done on a laptop. For this reason PSDCreatePythonScripts
implements some safety measures  to prevent the user from accidentally
overwriting or corrupting the existing files. First of all, if the files
generate_int.py and integrate_int.py already exist, the function will not
overwrite them by default.
To change this behavior you need to set the value of the option
OverwriteTarget to True.  In addition to that, pySecDec by itself will abort
the generation stage if the output directory for the C++ code
(specified by the option PSDOutputDirectory) already exists. However, you can
tweak the corresponding Python script such, that the output directory will be
always overwritten without further warnings. To this aim you need to set the
option PSDOverwritePackageDirectory to True.";

PSDLoopIntegralName::usage=
"PSDLoopIntegralName is an option for PSDCreatePythonScripts and other
functions of the pySecDec interface. It specifies the name assigned to the
output of pySecDec's LoopIntegralFromPropagators function. The default value
is \"li\".";

PSDOutputDirectory::usage=
"PSDOutputDirectory is an option for PSDCreatePythonScripts and other functions
of the pySecDec interface. It specifies the C++ namespace and the output
directory. The default value is \"loopint\".";

PSDRequestedOrder::usage=
"PSDRequestedOrder is an option for PSDCreatePythonScripts and other functions
of the pySecDec interface. It specifies the needed order in the
$\\varepsilon$-expansion. The default value is 0.";

PSDExpansionByRegionsOrder::usage=
"PSDExpansionByRegionsOrder is an option for PSDCreatePythonScripts and other
functions of the pySecDec interface. It specifies up to which order the
expression should be expanded in a small parameter using the method of
regions. The default value is 0.

The small parameter must be specified via the option
PSDExpansionByRegionsParameter.";

PSDExpansionByRegionsParameter::usage=
"PSDExpansionByRegionsParameter is an option for PSDCreatePythonScripts and
other functions of the pySecDec interface. It specifies the small parameter in
which the given loop integral will be expanded using the method of regions.
The default value is None, meaning that no expansion takes place.

The order up to which the expansion should be carried out must be specified
via the option PSDExpansionByRegionsOrder.";

PSDGenerateFileName::usage=
"PSDGenerateFileName is an option for PSDCreatePythonScripts and other
functions of the pySecDec interface. It specifies the name of the Python
script that generates the C++ package needed for the integral evaluation. The
default value \"generate_int.py\".";

PSDIntegrateFileName::usage=
"PSDIntegrateFileName is an option for PSDCreatePythonScripts and other
functions of the pySecDec interface. It specifies the name of the Python
script that performs the numerical integration using the previously generated
C++ package. The default value is \"integrate_int.py\".";

PSDOverwritePackageDirectory::usage=
"PSDOverwritePackageDirectory is an option for PSDCreatePythonScripts and other
functions of the pySecDec interface. If set to True, the pySecDec script
responsible for the generation of the integral will overwrite an existing C++
package directory.";

PSDComplexParameterRules::usage=
"PSDComplexParameterRules is an option for PSDCreatePythonScripts and other
functions of the pySecDec interface. It is a list of replacement rules
containing numerical values for the complex parameters of the integral.";

PSDRealParameterRules::usage=
"PSDRealParameterRules is an option for PSDCreatePythonScripts and other
functions of the pySecDec interface. It is a list of replacement rules
containing numerical values for the real parameters of the integral.";

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
	N										-> MachinePrecision,
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
	PSDOverwritePackageDirectory			-> False,
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
(*Todo regulatrors: Epsilon - eps???*)

PSDCreatePythonScripts[gli_GLI, topos:{__FCTopology}, path_String, opts:OptionsPattern[]] :=
	PSDCreatePythonScripts[gli, FCLoopSelectTopology[gli,topos], path, opts];

PSDCreatePythonScripts[gli_GLI, topo_FCTopology, path_String, opts:OptionsPattern[]] :=
	Block[{int,optFinalSubstitutions, optPSDRealParameterRules, optPSDComplexParameterRules},

		int = FCLoopFromGLI[gli, topo, FCI->OptionValue[FCI]];

		optPSDRealParameterRules			= OptionValue[PSDRealParameterRules];
		optPSDComplexParameterRules			= OptionValue[PSDComplexParameterRules];

		If[	OptionValue[FCI],
			optFinalSubstitutions = Join[topo[[5]], OptionValue[FinalSubstitutions]],
			{optFinalSubstitutions, optPSDRealParameterRules, optPSDComplexParameterRules} =
				FCI[FRH[{Join[SelectFree[topo[[5]],{Polarization,TemporalMomentum}], OptionValue[FinalSubstitutions]], optPSDRealParameterRules, optPSDComplexParameterRules}]]
		];

		PSDCreatePythonScripts[int, topo[[3]], FileNameJoin[{path,ToString[FCLoopGLIToSymbol[gli]]}], Join[{FCI->True,FinalSubstitutions->optFinalSubstitutions,
			PSDRealParameterRules -> optPSDRealParameterRules, PSDComplexParameterRules -> optPSDComplexParameterRules},
			FilterRules[{opts}, Except[FCI | FinalSubstitutions | PSDRealParameterRules | PSDComplexParameterRules]]]]
	];


PSDCreatePythonScripts[glis:{__GLI}, topos:{__FCTopology}, paths:{__String}, opts:OptionsPattern[]] :=
	MapThread[PSDCreatePythonScripts[#1,#2,#3,opts]&,{glis,FCLoopSelectTopology[#,topos]&/@glis,paths}];


PSDCreatePythonScripts[glis:{__GLI}, topos:{__FCTopology}, path_String, opts:OptionsPattern[]] :=
	Block[{toposOneToOne},
		toposOneToOne=FCLoopSelectTopology[#,topos]&/@glis;
		MapThread[PSDCreatePythonScripts[#1,#2,path,opts]&,{glis,toposOneToOne}]
	];

PSDCreatePythonScripts[expr_/;FreeQ2[expr,{GLI,FCTopology}], lmomsRaw_List, dir_String, OptionsPattern[]] :=
	Block[{	ex, loopPackage, loopIntegralFromPropagators, nLoops, optPSDLoopIntegralName, lmoms,
			optPSDOutputDirectory, optPSDRequestedOrder, generateFileString, status,
			optPSDGenerateFileName, optPSDIntegrateFileName, filePath, file,
			integratorString, integrationString, optPSDOverwritePackageDirectory, optPSDAdditionalPrefactor,
			optOverwriteTarget, integrateFileString, numParamsReal, numParamsComplex, sumPackage,
			optFinalSubstitutions, fp, vars, realParameters, optPSDExpansionByRegionsParameter,
			complexParameters, optPSDRealParameterRules, extraPref, optPSDExpansionByRegionsOrder,
			optPSDComplexParameterRules, realParameterValues, complexParameterValues, loopRegions, tmp, momHold,
			fPar, rulesDVReal, rulesDVComplex, rulesDV, momHoldList, spDownValuesLhs},

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
		optPSDAdditionalPrefactor			= OptionValue[PSDAdditionalPrefactor];

		(*Need to validate all options first*)

		If[ !(Head[optPSDLoopIntegralName]===String || optPSDLoopIntegralName===Default),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDLoopIntegralName option."];
			Abort[];
		];

		If[ !(Head[optPSDOutputDirectory]===String || optPSDOutputDirectory===Default),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDOutputDirectory option."];
			Abort[];
		];

		If[ !(Head[optPSDAdditionalPrefactor]===String || optPSDAdditionalPrefactor===Default),
			Message[PSDCreatePythonScripts::failmsg, "Incorrect value of the PSDAdditionalPrefactor option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDRequestedOrder, _Integer]),
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


		optFinalSubstitutions = FRH[optFinalSubstitutions];

		If[	!OptionValue[FCI],
			{ex, optFinalSubstitutions, optPSDRealParameterRules, optPSDComplexParameterRules} =
				FCI[{expr, optFinalSubstitutions, optPSDRealParameterRules, optPSDComplexParameterRules}],
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
		fPar = FCFeynmanPrepare[MomentumExpand[Abs[ex] /. Abs -> Identity]/. Momentum[x_, d___] /; ! MemberQ[lmoms, x] :>
			Momentum[momHold[x], d], lmoms, Names -> fp, FCI->True,FinalSubstitutions->optFinalSubstitutions][[2]];

		momHoldList = Union[Cases[fPar, (CartesianPair | Pair)[x__] /; ! FreeQ[{x}, momHold], Infinity]];

		FCPrint[2,"PSDCreatePythonScripts: List of all scalar products: ", momHoldList, FCDoControl->psdpVerbose];

		(*Extract scalar products that have been set via down values*)
		spDownValuesLhs = Map[If[FreeQ2[# /. momHold -> Identity, {Pair, CartesianPair}], # /. {Pair -> Hold[Pair],
			CartesianPair -> Hold[CartesianPair]} /. momHold -> Identity, Unevaluated[Sequence[]]] &, momHoldList];

		(*Remove scalar products set via the FinalSubstitutions option*)
		spDownValuesLhs = Map[If[FreeQ2[# /. Hold -> Identity, {Pair, CartesianPair}], #, Unevaluated[Sequence[]]] &, spDownValuesLhs];

		FCPrint[2,"PSDCreatePythonScripts: Scalar products specified via down values: ", spDownValuesLhs, FCDoControl->psdpVerbose];

		If[	!SubsetQ[$ScalarProducts, Union[spDownValuesLhs /. Hold[Pair | CartesianPair] ->  List /. (h : Momentum | CartesianMomentum)[xx_, ___] :> h[xx]]],
			Message[PSDCreatePythonScripts::failmsg, "Missing some scalar products specified via down values."];
			Abort[]
		];

		rulesDV = Thread[Rule[spDownValuesLhs, spDownValuesLhs /. Hold -> Identity/. optFinalSubstitutions]];

		FCPrint[2,"PSDCreatePythonScripts: Rules from down values: ", rulesDV, FCDoControl->psdpVerbose];

		vars = SelectFree[Variables2[fPar/.momHold->Identity/.optFinalSubstitutions], fp];

		If[optFinalSubstitutions=!={},
			vars = Variables2[{Last/@optFinalSubstitutions,vars}]
		];
		(*
		If[	rulesDV=!={},
			(*vars = Join[vars,Last/@rulesDV];*)
			rulesDVReal = Select[rulesDV,FreeQ2[#[[2]],{Complex,I}]&];
			rulesDVComplex = Complement[rulesDV,rulesDVReal];

			FCPrint[2,"PSDCreatePythonScripts: Complex valued dv rules: ", rulesDVComplex, FCDoControl->psdpVerbose];
			FCPrint[2,"PSDCreatePythonScripts: Real valued dv rules: ", rulesDVReal, FCDoControl->psdpVerbose];

			(*If[	!(rulesDVReal==={} || MatchQ[rulesDVReal,{Rule[_,_?NumberQ]..}]),
				Message[PSDCreatePythonScripts::failmsg, "Nonnumerical real-valued scalar product down values."];
				Abort[];
			];

			If[	!(rulesDVComplex==={} || MatchQ[rulesDVComplex,{Rule[_,_?NumberQ]..}]),
				Message[PSDCreatePythonScripts::failmsg, "Nonnumerical complex-valued scalar product down values.."];
				Abort[];
			];*)

			optPSDRealParameterRules = Join[optPSDRealParameterRules,rulesDVReal];
			optPSDComplexParameterRules = Join[optPSDComplexParameterRules,rulesDVComplex];

		];*)

		FCPrint[1,"PSDCreatePythonScripts: vars: ", vars, FCDoControl->psdpVerbose];


		FCPrint[2,"PSDCreatePythonScripts: Real parameter rules: ", optPSDRealParameterRules, FCDoControl->psdpVerbose];
		FCPrint[2,"PSDCreatePythonScripts: Complex parameter rules: ", optPSDComplexParameterRules, FCDoControl->psdpVerbose];

		If[	optPSDRealParameterRules=!={},
			(*Removing irrelevant parameters*)
			optPSDRealParameterRules = SelectNotFree[optPSDRealParameterRules,vars];
			(*TODO*)
			{realParameters, realParameterValues} = N[Transpose[List@@@optPSDRealParameterRules],OptionValue[N]];
			FCPrint[1,"PSDCreatePythonScripts: realParameterValues:  ", realParameterValues, FCDoControl->psdpVerbose];
			If[	!MatchQ[realParameterValues,{__?NumberQ}],
				Message[PSDCreatePythonScripts::failmsg, "Failed to generate the list of numerical values for the real parameters."];
				Abort[];
			],

			{realParameters, realParameterValues} = {{},{}}
		];

		If[	optPSDComplexParameterRules=!={},
			(*Removing irrelevant parameters*)
			optPSDComplexParameterRules = SelectNotFree[optPSDComplexParameterRules,vars];

			{complexParameters, complexParameterValues} = N[Transpose[List@@@optPSDComplexParameterRules],OptionValue[N]];
			FCPrint[1,"PSDCreatePythonScripts: complexParameterValues:  ", complexParameterValues, FCDoControl->psdpVerbose];
			If[	!MatchQ[complexParameterValues,{__?NumberQ}],
				Message[PSDCreatePythonScripts::failmsg, "Failed to generate the list of numerical values for the complex parameters."];
				Abort[];
			],

			{complexParameters, complexParameterValues} = {{},{}}
		];

		FCPrint[2,"PSDCreatePythonScripts: Real parameters: ", realParameters, FCDoControl->psdpVerbose];
		FCPrint[2,"PSDCreatePythonScripts: Complex parameters: ", complexParameters, FCDoControl->psdpVerbose];

		(*TODO Could also set all variables to 1 if the user didn't bother to specify them...*)

		If[	!SubsetQ[Union[realParameters,complexParameters],vars],
				Message[PSDCreatePythonScripts::failmsg, "The integral depends on variables that are not specified via the PSDRealParameterRules or PSDComplexParameterRules options."];
				FCPrint[0,"PSDCreatePythonScripts: Unspecified variables: ", Complement[vars, Union[realParameters, complexParameters]], FCDoControl->psdpVerbose];
				Abort[];
		];

		(*generate psd.LoopIntegralFromPropagators() *)
		{loopIntegralFromPropagators, extraPref} = PSDLoopIntegralFromPropagators[ex, lmoms, FinalSubstitutions->Join[optFinalSubstitutions,rulesDV],
			FCReplaceD->OptionValue[FCReplaceD]];

		FCPrint[3,"PSDCreatePythonScripts: loopIntegralFromPropagators: ", loopIntegralFromPropagators, FCDoControl->psdpVerbose];
		FCPrint[3,"PSDCreatePythonScripts: extraPref: ", extraPref, FCDoControl->psdpVerbose];

		If[	optPSDAdditionalPrefactor===Default,
			optPSDAdditionalPrefactor = "("<>ToString[extraPref,InputForm]<>")*exp("<>ToString[nLoops]<>"*EulerGamma*eps)",
			optPSDAdditionalPrefactor = "("<>ToString[extraPref,InputForm]<>")*" <> optPSDAdditionalPrefactor
		];

		If[	optPSDExpansionByRegionsParameter===None,

			(*Normal mode*)
			FCPrint[1,"PSDCreatePythonScripts: Calling PSDLoopPackage", FCDoControl->psdpVerbose];
			loopPackage = PSDLoopPackage[optPSDOutputDirectory, optPSDLoopIntegralName, optPSDRequestedOrder,
				PSDAdditionalPrefactor		-> optPSDAdditionalPrefactor,
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
			];
			FCPrint[1,"PSDCreatePythonScripts: Done calling PSDLoopPackage.", FCDoControl->psdpVerbose],

			(*Expansion by regions*)
			FCPrint[1,"PSDCreatePythonScripts: Calling PSDLoopRegions", FCDoControl->psdpVerbose];
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
			FCPrint[1,"PSDCreatePythonScripts: Done calling PSDLoopRegions.", FCDoControl->psdpVerbose];

			FCPrint[1,"PSDCreatePythonScripts: Calling PSDSumPackage.", FCDoControl->psdpVerbose];
			sumPackage = PSDSumPackage[optPSDOutputDirectory,"regions_generator_args",optPSDRequestedOrder,
				PSDCoefficients				-> OptionValue[PSDCoefficients],
				PSDComplexParameters		-> complexParameters,
				PSDFormExecutable 			-> OptionValue[PSDFormExecutable],
				PSDPyLinkQMCTransforms 		-> OptionValue[PSDPyLinkQMCTransforms],
				PSDRealParameters			-> realParameters,
				PSDRegulators				-> OptionValue[PSDRegulators]
			];
			FCPrint[1,"PSDCreatePythonScripts: Done calling PSDSumPackage.", FCDoControl->psdpVerbose]
		];

		generateFileString = {
			"#!/usr/bin/env python3",
			"if __name__ == \"__main__\":",
			"    from pySecDec import sum_package, loop_package, loop_regions, LoopIntegralFromPropagators",
			"    import pySecDec as psd",
			"",
			"    " <> optPSDLoopIntegralName <>" = " <> Map[("    " <> #) &, StringJoin[StringRiffle[Map["    " <> # &, StringSplit[loopIntegralFromPropagators, "\n"]], "\n"]]],
			"",
			"    import os,shutil",
			"    if os.path.isdir('"<>ToString[optPSDOutputDirectory] <> "'):",
			If[optPSDOverwritePackageDirectory,
				"        shutil.rmtree('"<>ToString[optPSDOutputDirectory]<>"')" <> "\n",
				"        if input('The directory loopint already exists, do you want to overwrite it (y/n)? ') in ['y','Y','j']:"
				<> "\n" <>
				"            shutil.rmtree('"<>ToString[optPSDOutputDirectory]<>"')" <> "\n" <>
				"        else:" <> "\n" <> "            exit(1)"
			],
			"",
			If[	optPSDExpansionByRegionsParameter===None,
				(*Normal mode*)
				StringJoin[StringRiffle[Map["    " <> # &, StringSplit[loopPackage, "\n"]], "\n"]],
				(*Expansion by regions*)
				Sequence@@{
					"    regions_generator_args = " <> loopRegions <> "\n",
					"",
					StringJoin[StringRiffle[Map["    " <> # &, StringSplit[sumPackage, "\n"]], "\n"]],
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
