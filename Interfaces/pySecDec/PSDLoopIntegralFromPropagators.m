(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDLoopIntegralFromPropagators									*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates input for LoopIntegralFromPropagators				*)

(* ------------------------------------------------------------------------ *)

PSDLoopIntegralFromPropagators::usage=
"PSDLoopIntegralFromPropagators[int, topo] is an auxiliary function that
converts the given loop integral (in the GLI representation) belonging to the
topology topo into input for pySecDec's LoopIntegralFromPropagators routine.
The output is given as a list of two elements, containing a string and the
prefactor of the integral. PSDLoopIntegralFromPropagators

PSDLoopIntegralFromPropagators is used by PSDCreatePythonScripts when
assembling the generation script.";

PSDRegulators::usage=
"PSDRegulators is an option for PSDLoopIntegralFromPropagators and other
functions of the pySecDec interface. It specifies a list of symbols to be used
for the regulators.";

PSDLoopIntegralFromPropagators::failmsg =
"Error! PSDLoopIntegralFromPropagators has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`PSDLoopIntegralFromPropagators`Private`"]

lifpVerbose::usage="";

Options[PSDLoopIntegralFromPropagators] = {
	FCI					-> False,
	FCReplaceD			-> {D->4-2 Epsilon},
	FCVerbose			-> False,
	FinalSubstitutions	-> {},
	Names 				-> "x",
	PSDRegulators		-> {Epsilon}
};


PSDLoopIntegralFromPropagators[gli_GLI, topo_FCTopology, opts:OptionsPattern[]] :=
	Block[{int,optFinalSubstitutions},

		int = FCLoopFromGLI[gli, topo, FCI->OptionValue[FCI]];

		If[	OptionValue[FCI],
			optFinalSubstitutions = Join[topo[[5]], OptionValue[FinalSubstitutions]],
			optFinalSubstitutions = FCI[Join[topo[[5]], OptionValue[FinalSubstitutions]]]
		];

		PSDLoopIntegralFromPropagators[int, topo[[3]], Join[{FCI->True,FinalSubstitutions->optFinalSubstitutions},
			FilterRules[{opts}, Except[FCI | FinalSubstitutions]]]]
	];


PSDLoopIntegralFromPropagators[glis:{__GLI}, topos:{__FCTopology}, opts:OptionsPattern[]] :=
	Block[{ints,finalSubstitutions,relTopos, lmomsList},

		ints = FCLoopFromGLI[glis, topos, FCI->OptionValue[FCI]];

		relTopos=Map[First[Select[topos, Function[x, x[[1]] === #[[1]]]]] &, glis];

		If[	!MatchQ[relTopos,{__FCTopology}],
			Message[PSDLoopIntegralFromPropagators::failmsg, "Something went wrong when extracting topologies relevant for the given GLIs."];
			Abort[]
		];

		finalSubstitutions = #[[5]]&/@relTopos;

		lmomsList = #[[3]]&/@relTopos;

		If[	!OptionValue[FCI],
			finalSubstitutions = FCI[finalSubstitutions]
		];

		MapThread[PSDLoopIntegralFromPropagators[#1, #2, Join[{FCI->True,FinalSubstitutions->#3},
			FilterRules[{opts}, Except[FCI | FinalSubstitutions]]]]&,{ints,lmomsList,finalSubstitutions}]
	];

PSDLoopIntegralFromPropagators[expr_/;FreeQ[{GLI,FCTopology},expr], lmoms_List /; !OptionQ[lmoms], OptionsPattern[]] :=
	Block[{	ex, topo, gliList, optNames, res, vars, id, psdDimensionality,
			optFinalSubstitutions, status, dir, null1, null2, dim, scalarPart, tensorPart,
			psdReplacements, fcProps, psdProps, psdLmoms, isCartesian, psdPowerlist, dimRegEps,
			psdFeynmanParameters, pref, optPSDRegulators},

		optFinalSubstitutions	= OptionValue[FinalSubstitutions];
		optPSDRegulators		= OptionValue[PSDRegulators];


		If[	!(MatchQ[optPSDRegulators, {__Symbol}]),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDRegulators option."];
			Abort[];
		];

		If[	OptionValue[FCVerbose]===False,
			lifpVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				lifpVerbose=OptionValue[FCVerbose]
			];
		];


		If[	OptionValue[FCI],
			ex = expr,
			{ex,optFinalSubstitutions} = FCI[{expr,optFinalSubstitutions}]
		];

		FCPrint[1,"PSDLoopIntegralFromPropagators: Entering.", FCDoControl->lifpVerbose];
		FCPrint[1,"PSDLoopIntegralFromPropagators: Entering with: ", ex, FCDoControl->lifpVerbose];
		FCPrint[1,"PSDLoopIntegralFromPropagators: Replacement rules: ", optFinalSubstitutions, FCDoControl->lifpVerbose];

		If [!FreeQ2[$ScalarProducts, lmoms],
			Message[PSDLoopIntegralFromPropagators::failmsg, "Some of the loop momenta have scalar product rules attached to them."];
			Abort[]
		];

		If[	!FCDuplicateFreeQ[lmoms],
			Message[PSDLoopIntegralFromPropagators::failmsg, "The list of the loop momenta may not contain duplicate entries."];
			Abort[]
		];

		If[	!MatchQ[ex,{__}|_. _FeynAmpDenominator],
			Message[PSDLoopIntegralFromPropagators::failmsg, "The input expression is not a proper integral or list of propagators"];
			Abort[]

		];

		Which[
			!FreeQ2[ex, {Momentum, LorentzIndex}] && FreeQ2[ex, {CartesianMomentum,CartesianIndex}],
			FCPrint[1,"PSDLoopIntegralFromPropagators: Lorentzian integral. ", FCDoControl->lifpVerbose];
			isCartesian=False,

			FreeQ2[ex, {Momentum, LorentzIndex}] && !FreeQ2[ex, {CartesianMomentum,CartesianIndex}],
			FCPrint[1,"PSDLoopIntegralFromPropagators: Cartesian integral. ", FCDoControl->lifpVerbose];
			isCartesian=True,


			!FreeQ2[ex, {Momentum, LorentzIndex}] && !FreeQ2[ex, {CartesianMomentum,CartesianIndex}],
			FCPrint[1,"PSDLoopIntegralFromPropagators: Mixed integral. ", FCDoControl->lifpVerbose];
			Message[PSDLoopIntegralFromPropagators::failmsg,"Integrals that simultaneously depend on Lorentz and Cartesian vectors are not supported."];
			Abort[]
		];


		dim = FCGetDimensions[ex/. {TemporalPair[_,ExplicitLorentzIndex[0]]:>Unique[]}];

		If[	Length[dim]=!=1,
			Message[PSDLoopIntegralFromPropagators::failmsg,"The loop integrals contains momenta in different dimensions."];
			Abort[]
		];

		dim = First[dim] /. OptionValue[FCReplaceD];

		FCPrint[1,"PSDLoopIntegralFromPropagators: Dimension: ", dim, FCDoControl->lifpVerbose];

		dimRegEps = Cases[dim, _Symbol, Infinity];
		FCPrint[1,"PSDLoopIntegralFromPropagators: Dimensional regulator: ", dimRegEps, FCDoControl->lifpVerbose];

		If[	Length[dimRegEps]=!=1,
			Message[PSDLoopIntegralFromPropagators::failmsg,"Failed to extract the dimensional regulator dimRegEps."];
			Abort[]
		];
		dimRegEps = First[dimRegEps];

		{dim, dimRegEps, optPSDRegulators} = {dim, dimRegEps, optPSDRegulators} /. {Epsilon -> "ep", EpsilonUV -> "epUV", EpsilonIR -> "epIR"};

		FCPrint[3,"PSDLoopIntegralFromPropagators: Regulators: ", optPSDRegulators, FCDoControl->lifpVerbose];

		If[	FreeQ[optPSDRegulators, dimRegEps],
			Message[PSDLoopIntegralFromPropagators::failmsg,"The dimensional regulator must be listed in the list of the regulators."];
			Abort[]
		];


		If[	Union[FreeQ[ex,#]&/@lmoms]=!={False},
			Message[PSDLoopIntegralFromPropagators::failmsg,"Some of the specified loop momenta are not contained in the input expression."];
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
				Message[PSDLoopIntegralFromPropagators::failmsg,"Failed to parse the supplied list of propagators."];
				Abort[]
			],
			{scalarPart, tensorPart} =  FCProductSplit[ex, {LorentzIndex, CartesianIndex}]
		];

		FCPrint[3,"PSDLoopIntegralFromPropagators: scalarPart: ", scalarPart, FCDoControl->lifpVerbose];
		FCPrint[3,"PSDLoopIntegralFromPropagators: tensorPart: ", tensorPart, FCDoControl->lifpVerbose];

		If[	tensorPart=!=1,
			Message[PSDLoopIntegralFromPropagators::failmsg,"Tensor integrals are currently unsupported."];
			Abort[]
		];


		fcProps = FCLoopIntegralToPropagators[scalarPart, lmoms, Tally -> True, Rest->True, Negative->True];

		pref = fcProps[[2]];
		fcProps = fcProps[[1]]//Transpose;

		FCPrint[3,"PSDLoopIntegralFromPropagators: fcProps: ", fcProps, FCDoControl->lifpVerbose];

		FCPrint[3,"PSDLoopIntegralFromPropagators: pref: ", pref, FCDoControl->lifpVerbose];

		psdProps = FCLoopPropagatorsToTopology[fcProps[[1]], FCI->True,MomentumCombine->True];

		FCPrint[3,"PSDLoopIntegralFromPropagators: psdProps: ", psdProps, FCDoControl->lifpVerbose];

		If[	!FreeQ[psdProps,Complex],
			Message[PSDLoopIntegralFromPropagators::failmsg, "The list of obtained propagators for pySecDec contains imaginary parts."];
			Abort[]
		];

		{psdProps, psdReplacements} =  {psdProps, optFinalSubstitutions} //. {
			Pair[Momentum[a_,___],Momentum[b_,___]] -> a b,
			CartesianPair[CartesianMomentum[a_,___],CartesianMomentum[b_,___]] -> a b,
			Hold[Pair][Momentum[a_,___],Momentum[b_,___]] -> a b,
			Hold[CartesianPair][CartesianMomentum[a_,___],CartesianMomentum[b_,___]] -> a b
		};

		If[!FreeQ2[{psdProps,psdReplacements},{Pair,CartesianPair,Momentum,CartesianMomentum}],
			Message[PSDLoopIntegralFromPropagators::failmsg,"Failed to create a correct list of propagators or replacements."];
			Abort[]
		];


		psdProps				= StringReplace[ToString[ToString[#, InputForm] & /@ psdProps, InputForm], {"{" -> "[", "}" -> "]", "\"" -> "'", "^"->"**"}];
		psdReplacements			= StringReplace[ToString[Map["('" <> ToString[#[[1]], InputForm] <> "','" <> ToString[#[[2]], InputForm] <> "')" &,
			psdReplacements]],{"{" -> "[", "}" -> "]", "^" -> "**"}];
		psdLmoms				= StringReplace[ToString[ToString[#, InputForm] & /@ lmoms, InputForm], {"{" -> "[", "}" -> "]", "\"" -> "'"}];
		psdPowerlist			= StringReplace[ToString[fcProps[[2]],InputForm], {"{" -> "[", "}" -> "]"}];
		psdDimensionality		= StringReplace[ToString[dim,InputForm],{"\""->""}];
		psdFeynmanParameters	= StringReplace[ToString[OptionValue[Names],InputForm], { "\"" -> "'"}];
		optPSDRegulators 		= StringReplace[ToString[Map["'" <> ToString[#] <> "'" &, optPSDRegulators]], {"{" -> "[", "}" -> "]"}];

		res = "LoopIntegralFromPropagators(\n" <>
				psdProps <> ",\n" <>
				"loop_momenta = " <> psdLmoms <> ",\n" <>
				"powerlist = " <> psdPowerlist <> ",\n" <>
				"dimensionality = '" <> psdDimensionality <> "',\n" <>
				"Feynman_parameters = " <> psdFeynmanParameters <> ",\n" <>
				"replacement_rules = " <> psdReplacements <> ",\n" <>
				"regulators = " <> optPSDRegulators <> "\n)";


		FCPrint[1,"PSDLoopIntegralFromPropagators: Leaving.", FCDoControl->lifpVerbose];
		FCPrint[3,"PSDLoopIntegralFromPropagators: Leaving with: ",res , FCDoControl->lifpVerbose];

		{res,pref}

	];

toString[x_]:=
	StringReplace[ToString[x,InputForm], {"\"" -> "'"}];


End[]
