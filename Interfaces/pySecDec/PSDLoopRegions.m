(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDLoopRegions													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Creates pySecDec loop_package input							*)

(* ------------------------------------------------------------------------ *)

PSDLoopRegions::usage=
"PSDLoopRegions[name, loopIntegral, order, smallnessParameter] is an auxiliary
function that creates input for pySecDec's loop_regions routine. The results
is returned as a string.

PSDLoopPackage is used by PSDCreatePythonScripts when assembling the
generation script for an asymptotic expansion.";


PSDAddMonomialRegulatorPower::usage=
"PSDAddMonomialRegulatorPower is an option for PSDLoopRegions and other
functions of the pySecDec interface. It specifies the name of the regulator
used to introduce monomial factors regulating integrals arising from the
expansion by regions.";

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
