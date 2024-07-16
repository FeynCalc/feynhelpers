(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: ASyGetLeadingPower											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Prepares input for asy										*)

(* ------------------------------------------------------------------------ *)

ASyGetLeadingPower::usage=
"ASyGetLeadingPower[lmoms, props, kinematics, scalings] calls
the asy routine AlphaRepExpand to obtain raw scalings of given propagators.";

ASyGetLeadingPower::failmsg =
"The asy interface has encountered an error and must abort the evaluation. The \
error description reads: `1`";


Begin["`Package`"]

End[]

Begin["`ASyGetLeadingPower`Private`"]

Options[ASyGetLeadingPower] = {
	ExtraPropagators	-> {},
	FCReplaceD			-> {D -> 4 - 2 Epsilon},
	FCReplaceMomenta 	-> {},
	FCVerbose 			-> False,
	FinalSubstitutions	-> {},
	Names				-> FCGV["x"],
	Series				-> {}
};


ASyGetLeadingPower[int_GLI, topos_, scalingRules_List, scalings_List, scalingVar_Symbol, opts:OptionsPattern[]] :=
	(ASyGetLeadingPower[int, topos, scalingRules, #, scalingVar, opts]&/@scalings) /; MatchQ[scalings, {{__?NumberQ}..}];

ASyGetLeadingPower[int_GLI, topos_, scalingRules_List, scalings_List, scalingVar_Symbol, OptionsPattern[]] :=
	Block[{	res, optFCReplaceMomenta, optFinalSubstitutions, aglpVerbose,
			optExtraPropagators, optASyNormalize, feynParOutput, xVar,
			optFCReplaceD, scalingIntegrand, measure, integrand, la,
			optSeries, integral, optNames},

		If[	OptionValue[FCVerbose]===False,
			aglpVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				aglpVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1, "ASyGetLeadingPower. Entering.", FCDoControl->aglpVerbose];
		FCPrint[2, "ASyGetLeadingPower. Entering with: ", int, FCDoControl->aglpVerbose];
		FCPrint[2, "ASyGetLeadingPower. Propagator scalings: ", scalings, FCDoControl->aglpVerbose];

		optFCReplaceMomenta = OptionValue[FCReplaceMomenta];
		optFinalSubstitutions = OptionValue[FinalSubstitutions];
		optExtraPropagators = OptionValue[ExtraPropagators];
		optFCReplaceD = OptionValue[FCReplaceD];
		optSeries = OptionValue[Series];
		optNames = OptionValue[Names];


		feynParOutput = 	FCFeynmanParametrize[int, topos,
		FCReplaceMomenta -> optFCReplaceMomenta,
		FinalSubstitutions -> optFinalSubstitutions,
		ExtraPropagators -> optExtraPropagators, Names -> optNames,
		FCReplaceD -> optFCReplaceD];


		FCPrint[3, "ASyGetLeadingPower: Feynman-parametric integrand: ", feynParOutput[[1]], FCDoControl->aglpVerbose];

		scalingIntegrand = MapThread[(#1 -> scalingVar^(#2) #1) &, {feynParOutput[[3]],	scalings}];

		FCPrint[1, "ASyGetLeadingPower: Scaling rules for the Feynman parameters ", scalingIntegrand, FCDoControl->aglpVerbose];

		measure = (Times @@ (feynParOutput[[3]] /. scalingIntegrand));

		integrand = (feynParOutput[[1]] /. scalingIntegrand);

		integrand = integrand /. scalingRules;

		res = measure integrand;

		FCPrint[1, "ASyGetLeadingPower: Raw result: ", res, FCDoControl->aglpVerbose];

		If[	optSeries =!= {},

			res = Normal[Series[res, Sequence @@ optSeries]];
			FCPrint[3, "ASyGetLeadingPower: Raw result after the series expansion:", res, FCDoControl->aglpVerbose];
			If[	!MatchQ[res, scalingVar^_. rest_/;FreeQ[rest,scalingVar]] && !FreeQ[res,scalingVar],
				Message[ASyShared::failmsg, "Something went wrong during the expansion."];
				Abort[]
			];
			res = Exponent[res, scalingVar]
		];
		{scalings,res}
		] /; MatchQ[scalings, {__?NumberQ}];



End[]

