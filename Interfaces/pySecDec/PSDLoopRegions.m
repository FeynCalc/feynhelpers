(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDLoopRegions													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Creates pySecDec loop_package input							*)

(* ------------------------------------------------------------------------ *)

PSDLoopRegions::usage=
"PSDLoopRegions[name, loopIntegral, order] is an auxiliary function that
creates input for pySecDec's loop_package routine. The results is returned as a string.";

PSDRealParameters::usage=
"PSDRealParameters is an option for PSDLoopRegions and other functions of the
pySecDec interface. It is a list of symbols (or strings) that will be passed to
pySecDec's loop_package argument real_parameters";

PSDComplexParameters::usage=
"PSDComplexParameters is an option for PSDLoopRegions and other functions of the
pySecDec interface. It is a list of symbols (or strings) that will be passed to
pySecDec's loop_package argument real_parameters";

PSDContourDeformation::usage=
"PSDContourDeformation is an option for PSDLoopRegions and other functions of the
pySecDec interface. It is a boolean switch that will be passed to pySecDec's
loop_package argument contour_deformation. The default value is True. However,
if you know in advance that your integral has no imaginary part, setting this option
to False will greatly improve the peformance.";

PSDAdditionalPrefactor::usage=
"PSDAdditionalPrefactor is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies an implicit prefactor multiplying the loop integral
and will be passed to pySecDec's loop_package argument additional_prefactor. The
value should be a string representing a valid pySecDec expression.";

PSDFormOptimizationLevel::usage=
"PSDFormOptimizationLevel is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies the optimization level to be used in FORM
and will be passed to pySecDec's loop_package argument form_optimization_level.
The default value is 2.";

PSDFormWorkSpace::usage=
"PSDFormWorkSpace is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies the size of the FORM WorkSpace and will be
passed to pySecDec's loop_package argument form_work_space.
The default value is '50M'.";

PSDFormMemoryUse::usage=
"PSDFormMemoryUse is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies the target FORM memory usage and will be passed to
pySecDec's loop_package argument form_memory_use. The default value is None.";

PSDFormThreads::usage=
"PSDFormThreads is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies the number of threads (T)FORM will use and
will be passed to pySecDec's form_threads argument. The default value is 2.";

PSDDecompositionMethod::usage=
"PSDDecompositionMethod is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies pySecDec's strategy for decomposing the polynomials
will be passed to the loop_package argument decomposition_method. The default value is \"geometric\".";

PSDNormalizExecutable::usage=
"PSDNormalizExecutable is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies the command to run normaliz and will be passed to the
loop_package argument normaliz_executable";

PSDAddMonomialRegulatorPower::usage=
"PSDEnforceComplex is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies the name of the regulator used to introduce
monomial factors regulating integrals arising from the expansion by regions.";

PSDSplit::usage=
"PSDSplit is an option for PSDLoopRegions and other functions of the
pySecDec interface. It specifies whether or not to split the integration
domain in order to map singularities from 1 to 0.";

(*TODO add other stuff as well ... *)

PSDLoopRegions::failmsg =
"Error! PSDLoopRegions has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`PSDLoopRegions`Private`"]

lpVerbose::usage="";

Options[PSDLoopRegions] = {
	FCVerbose						-> False,
	PSDAddMonomialRegulatorPower	-> Default,
	PSDAdditionalPrefactor			-> Default,
	PSDComplexParameters			-> {},
	PSDContourDeformation 			-> Default,
	PSDDecompositionMethod			-> "geometric",
	PSDEnforceComplex				-> Default,
	PSDFormMemoryUse				-> Default,
	PSDFormOptimizationLevel		-> Default,
	PSDFormThreads					-> Default,
	PSDFormWorkSpace				-> Default,
	PSDNormalizExecutable			-> Default,
	PSDRealParameters				-> {},
	PSDSplit						-> Default
};

PSDLoopRegions[name_String, loopIntegral_String, order_Integer, smallnessParameter_, OptionsPattern[]] :=
	Block[{	res, optPSDContourDeformation, optPSDAdditionalPrefactor,
			optPSDFormOptimizationLevel, optPSDFormWorkSpace, optPSDDecompositionMethod,
			optPSDNormalizExecutable, optPSDEnforceComplex, optPSDSplit,
			optPSDAddMonomialRegulatorPower},

		If[	OptionValue[FCVerbose]===False,
			lpVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				lpVerbose=OptionValue[FCVerbose]
			];
		];

		optPSDContourDeformation		= OptionValue[PSDContourDeformation];
		optPSDAdditionalPrefactor		= OptionValue[PSDAdditionalPrefactor];
		optPSDFormOptimizationLevel		= OptionValue[PSDFormOptimizationLevel];
		optPSDFormWorkSpace				= OptionValue[PSDFormWorkSpace];
		optPSDDecompositionMethod		= OptionValue[PSDDecompositionMethod];
		optPSDNormalizExecutable		= OptionValue[PSDNormalizExecutable];
		optPSDEnforceComplex			= OptionValue[PSDEnforceComplex];
		optPSDSplit						= OptionValue[PSDSplit];
		optPSDAddMonomialRegulatorPower	= OptionValue[PSDAddMonomialRegulatorPower];

		(*Need to validate all options first*)

		If[	!(MatchQ[optPSDContourDeformation, True|False] || optPSDContourDeformation===Default),
			Message[PSDLoopRegions::failmsg, "Incorrect value of the PSDContourDeformation option."];
			Abort[];
		];

		If[ !(Head[optPSDAdditionalPrefactor]===String || optPSDAdditionalPrefactor===Default),
			Message[PSDLoopRegions::failmsg, "Incorrect value of the PSDAdditionalPrefactor option."];
			Abort[];
		];

		If[ !(MemberQ[{0,1,2,3,4}, optPSDFormOptimizationLevel] || optPSDFormOptimizationLevel==Default),
			Message[PSDLoopRegions::failmsg, "Incorrect value of the PSDFormOptimizationLevel option."];
			Abort[];
		];

		If[ !(MemberQ[{"iterative","geometric","geometric_ku"}, optPSDDecompositionMethod] || optPSDDecompositionMethod==Default),
			Message[PSDLoopRegions::failmsg, "Incorrect value of the PSDFormOptimizationLevel option."];
			Abort[];
		];

		If[ !(Head[optPSDNormalizExecutable]===String || optPSDNormalizExecutable === Default),
			Message[PSDLoopRegions::failmsg, "Incorrect value of the PSDNormalizExecutable option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDEnforceComplex, True|False] || optPSDEnforceComplex === Default),
			Message[PSDLoopRegions::failmsg, "Incorrect value of PSDEnforceComplextion option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDSplit, True|False] || optPSDSplit === Default),
			Message[PSDLoopRegions::failmsg, "Incorrect value of the PSDSplit option."];
			Abort[];
		];

		If[	!MatchQ[optPSDAddMonomialRegulatorPower, (_Symbol | _String)],
			Message[PSDLoopRegions::failmsg, "Incorrect value of the PSDAddMonomialRegulatorPower option."];
			Abort[];
		];

		res = {
			"name = " <> FeynCalc`Package`psdToString[name],
			"loop_integral = " <> loopIntegral,
			"smallness_parameter = '" <> ToString[smallnessParameter,InputForm] <>"'",
			"expansion_by_regions_order = " <> ToString[order],

			If[	optPSDContourDeformation=!=Default,
					"contour_deformation = " <> ToString[optPSDContourDeformation],
					""
			],

			If[	optPSDAdditionalPrefactor=!=Default,
					"additional_prefactor = " <> FeynCalc`Package`psdToString[optPSDAdditionalPrefactor],
					""
			],

			If[	optPSDDecompositionMethod=!=Default,
					"decomposition_method = " <> FeynCalc`Package`psdToString[optPSDDecompositionMethod],
					""
			],

			If[	optPSDFormOptimizationLevel=!=Default,
					"form_optimization_level = " <> ToString[optPSDFormOptimizationLevel],
					""
			],

			If[	optPSDFormWorkSpace=!=Default,
					"form_work_space = " <> FeynCalc`Package`psdToString[optPSDFormWorkSpace],
					""
			],

			If[	optPSDNormalizExecutable=!=Default,
					"normaliz_executable = " <> FeynCalc`Package`psdToString[optPSDNormalizExecutable],
					""
			],

			If[	optPSDEnforceComplex=!=Default,
					"enforce_complex = " <> ToString[optPSDEnforceComplex],
					""
			],

			If[	optPSDSplit=!=Default,
					"split = " <> ToString[optPSDSplit],
					""
			]

		};


		res = "loop_regions(\n"<>StringJoin[StringRiffle[res /. "" -> Unevaluated[Sequence[]], ",\n"]]<>"\n)";

		res

	];

End[]
