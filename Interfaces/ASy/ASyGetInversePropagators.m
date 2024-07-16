(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: ASyGetInversePropagators											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Prepares input for asy										*)

(* ------------------------------------------------------------------------ *)

ASyGetInversePropagators::usage=
"ASyGetInversePropagators[int, topo] is an auxiliary function that generates
the input for ASyGetRawScalings and other routines of the asy interface.
It returns a list containing loop momenta, inverse propagators, kinematics
constraints and power of propagators for each integral int.";

ASyGetInversePropagators::failmsg =
"The asy interface has encountered an error and must abort the evaluation. The \
error description reads: `1`";


Begin["`Package`"]

End[]

Begin["`ASyGetInversePropagators`Private`"]

agipVerbose::usage="";


Options[ASyGetInversePropagators] = {
	ExtraPropagators		-> {},
	FCE						-> False,
	FCReplaceMomenta		-> {},
	FCVerbose				-> False,
	FinalSubstitutions		-> {},
	ToLightConeComponents	-> False
}

ASyGetInversePropagators[int_GLI, topos_, OptionsPattern[]] :=
	Block[{	loopInt, lmoms, kinematics, topo, tmp, invProps,
			props, pows, dims, optFCReplaceMomenta, res,
			allSPs, extMomSPs, dim, check, optFinalSubstitutions,
			optExtraPropagators, optToLightConeComponents, n, nb},

		optFCReplaceMomenta 		= OptionValue[FCReplaceMomenta];
		optFinalSubstitutions 		= OptionValue[FinalSubstitutions];
		optExtraPropagators 		= OptionValue[ExtraPropagators];
		optToLightConeComponents	= OptionValue[ToLightConeComponents];

		{optFinalSubstitutions,optExtraPropagators} =
			FCI[{optFinalSubstitutions,optExtraPropagators}];


		If[	OptionValue[FCVerbose]===False,
			agipVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				agipVerbose=OptionValue[FCVerbose]
			];
		];


		topo = FCLoopSelectTopology[int, topos];
		loopInt = FCLoopFromGLI[int, topo];

		lmoms = topo[[3]];
		kinematics = topo[[5]];
		tmp = FCLoopIntegralToPropagators[loopInt, lmoms, Tally -> True];

		{props, pows} = Transpose[tmp];
		invProps = 1/FeynAmpDenominatorExplicit[props];
		invProps = ExpandAll[invProps //. FRH[kinematics] //. optFinalSubstitutions];

		If[	optFCReplaceMomenta=!={},
			If[	TrueQ[MatchQ[optFCReplaceMomenta,{__List}]],
				invProps = Fold[FCReplaceMomenta[#1,#2,ExpandScalarProduct->True]&,invProps,optFCReplaceMomenta],
				invProps = ExpandAll[FCReplaceMomenta[invProps,optFCReplaceMomenta,ExpandScalarProduct->True]]
			]
		];

		If[	optExtraPropagators=!={},
			invProps=Join[1/FeynAmpDenominatorExplicit[optExtraPropagators],invProps];
			pows = Join[pows,ConstantArray[1,Length[optExtraPropagators]]]
		];

		invProps = ExpandAll[invProps //. FRH[kinematics] //. optFinalSubstitutions];

		If[	TrueQ[MatchQ[optToLightConeComponents,{_,_}]],
			{n, nb} = optToLightConeComponents;
			invProps = ToLightConeComponents[invProps,n,nb,FCI->True]
		];

		dim = FCGetDimensions[invProps];

		If[	!MatchQ[dim, {_}],
			Message[ASyGetInversePropagators::failmsg, "Propagators involving different dimensions are not supported."];
			Abort[];
		];

		dim = First[dim];


		allSPs = Cases2[invProps, Pair];
		extMomSPs = SelectFree[allSPs, lmoms];

		FCPrint[3, "AsyGetInversePropagators: Occurring scalar products ", allSPs, FCDoControl->agipVerbose];

		check = MatchQ[#,Pair[Momentum[_Symbol,dim],Momentum[_Symbol,dim]]|
			Pair[LightConePerpendicularComponent[Momentum[_Symbol,dim],__], LightConePerpendicularComponent[Momentum[_Symbol,dim],__]]
		]&/@allSPs;

		If[	!MatchQ[check,{True..}],
			Message[ASyGetInversePropagators::failmsg, "Momenta inside scalar products are not atomic. If you are using replacement rules for 4-momenta," <>
			" did you declare all the occurring scalar variables as FCVariable?"];
			Abort[];
		];

		If[extMomSPs =!= {},
			FCPrint[0, "Warning! Some scalar products of extranal momenta remain unspecified."];
		];

		res = {lmoms, invProps, Join[optFinalSubstitutions,FRH[kinematics]],pows};

		If[ OptionValue[FCE],
			res = FCE[res]
		];

		res
];


End[]

