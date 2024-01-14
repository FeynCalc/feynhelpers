(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDSumPackage													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Creates pySecDec sum_package input							*)

(* ------------------------------------------------------------------------ *)

PSDSumPackage::usage=
"PSDSumPackage[name, packageGenerators, order] is an auxiliary function that
creates input for pySecDec's sum_package routine. The result is returned as a
string.";

PSDPyLinkQMCTransforms::usage=
"PSDPyLinkQMCTransforms is an option for PSDSumPackage and other functions of
the pySecDec interface. It specifies the required QMC transformations and will
be passed to pySecDec's pylink_qmc_transforms argument.";

PSDCoefficients::usage=
"PSDCoefficients is an option for PSDSumPackage and other functions of the
pySecDec interface. It specifies coefficients of the integrals in the sum and
will be passed to pySecDec's coefficients argument. The default value is None.";

PSDFormExecutable::usage=
"PSDFormExecutable is an option for PSDSumPackage and other functions of the
pySecDec interface. It specifies the path to the FORM executable and will be
passed to pySecDec's form_executable argument. The default value is None.";

(*TODO add other stuff as well ... *)

PSDSumPackage::failmsg =
"Error! PSDSumPackage has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`PSDSumPackage`Private`"]

lpVerbose::usage="";

Options[PSDSumPackage] = {
	FCVerbose					-> False,
	PSDCoefficients				-> Default,
	PSDComplexParameters		-> {},
	PSDFormExecutable			-> Default,
	PSDLoopIntegralName			-> "li",
	PSDPyLinkQMCTransforms		-> Default,
	PSDRealParameters			-> {},
	PSDRegulators				-> {Epsilon}
};

PSDSumPackage[name_String, packageGenerators_String, order_Integer, OptionsPattern[]] :=
	Block[{	res, optPSDRealParameters, optPSDComplexParameters, optPSDCoefficients,
			optPSDFormExecutable, optPSDPyLinkQMCTransforms, optPSDLoopIntegralName},

		If[	OptionValue[FCVerbose]===False,
			lpVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				lpVerbose=OptionValue[FCVerbose]
			];
		];

		optPSDRealParameters		= OptionValue[PSDRealParameters];
		optPSDComplexParameters		= OptionValue[PSDComplexParameters];
		optPSDCoefficients			= OptionValue[PSDCoefficients];
		optPSDFormExecutable		= OptionValue[PSDFormExecutable];
		optPSDPyLinkQMCTransforms	= OptionValue[PSDPyLinkQMCTransforms];
		optPSDLoopIntegralName		= OptionValue[PSDLoopIntegralName];

		(*Need to validate all options first*)

		If[	!MatchQ[optPSDRealParameters, {(_Symbol | _String) ...}],
			Message[PSDSumPackage::failmsg, "Incorrect value of the PSDRealParameters option."];
			Abort[];
		];

		If[	!MatchQ[optPSDComplexParameters, {(_Symbol | _String) ...}],
			Message[PSDSumPackage::failmsg, "Incorrect value of the PSDComplexParameters option."];
			Abort[];
		];

		(*TODO Fix Coefficients *)
		If[	!(MatchQ[optPSDCoefficients, {{__}..}] || optPSDCoefficients===Default),
			Message[PSDSumPackage::failmsg, "Incorrect value of the PSDCoefficients option."];
			Abort[];
		];

		If[ !(Head[optPSDFormExecutable]===String || optPSDFormExecutable===Default),
			Message[PSDSumPackage::failmsg, "Incorrect value of the PSDFormExecutable option."];
			Abort[];
		];

		If[ !(Head[optPSDLoopIntegralName]===String),
			Message[PSDSumPackage::failmsg, "Incorrect value of the PSDLoopIntegralName option."];
			Abort[];
		];


		If[	!(MemberQ[{"none", "baker",
			"sidi1", "sidi2", "sidi3", "sidi4", "sidi5", "sidi6",
			"korobov1", "korobov2", "korobov3", "korobov4", "korobov5", "korobov6",
			"korobov1#1", "korobov1#2", "korobov1#3", "korobov1#4", "korobov1#5", "korobov1#6",
			"korobov2#1", "korobov2#2", "korobov2#3", "korobov2#4", "korobov2#5", "korobov2#6",
			"korobov3#1", "korobov3#2", "korobov3#3", "korobov3#4", "korobov3#5", "korobov3#6",
			"korobov4#1", "korobov4#2", "korobov4#3", "korobov4#4", "korobov4#5", "korobov4#6",
			"korobov5#1", "korobov5#2", "korobov5#3", "korobov5#4", "korobov5#5", "korobov5#6",
			"korobov6#1", "korobov6#2", "korobov6#3", "korobov6#4", "korobov6#5", "korobov6#6"}, optPSDPyLinkQMCTransforms] || optPSDPyLinkQMCTransforms===Default),
			Message[PSDSumPackage::failmsg, "Incorrect value of the PSDTransform option."];
			Abort[];
		];

		optPSDRealParameters =
			StringReplace[ToString[Map["'" <> ToString[#] <> "'" &, optPSDRealParameters]], {"{" -> "[", "}" -> "]"}];

		optPSDComplexParameters =
			StringReplace[ToString[Map["'" <> ToString[#] <> "'" &, optPSDComplexParameters]], {"{" -> "[", "}" -> "]"}];

		res = {
			"name = " <> FeynCalc`Package`psdToString[name],
			"package_generators = " <> packageGenerators,
			"regulators = " <> optPSDLoopIntegralName <>".regulators",

			"requested_orders = [" <> ToString[order] <> "]",

			If[	optPSDRealParameters=!="[]",
					"real_parameters = " <> optPSDRealParameters,
					""
			],

			If[	optPSDComplexParameters=!="[]",
					"complex_parameters = " <> optPSDComplexParameters,
					""
			],

			(*TODO Fix me*)
			If[	optPSDCoefficients=!=Default,
					"coefficients = " <> ToString[optPSDCoefficients],
					""
			],

			If[	optPSDFormExecutable=!=Default,
					"form_executable = " <> FeynCalc`Package`psdToString[optPSDFormExecutable],
					""
			],

			If[	optPSDPyLinkQMCTransforms=!=Default,
					"decomposition_method = " <> FeynCalc`Package`psdToString[optPSDPyLinkQMCTransforms],
					""
			]
		};


		res = "sum_package(\n"<>StringJoin[StringRiffle[res /. "" -> Unevaluated[Sequence[]], ",\n"]]<>"\n)";

		res

	];

End[]
