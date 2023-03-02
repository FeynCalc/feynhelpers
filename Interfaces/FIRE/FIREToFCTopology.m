(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIREToFCTopology													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Converts FIRE topologies to FCTopology objects				*)

(* ------------------------------------------------------------------------ *)

FIREToFCTopology::usage=
"FIREToFCTopology[props, lmoms, emoms] converts the list of FIRE propagators
props that depend on the loop momenta lmoms and external momenta emoms into a
proper FCTopology object.

Use the option Names to specify the id of the resulting topology.";

FIREToFCTopology::failmsg =
"Error! FIREToFCTopology has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIREToFCTopology`Private`"]

ftfVerbose::usage="";
optDimension::usage="";
optComplex::usage="";
optEtaSign::usage="";


Options[FIREToFCTopology] = {
	Check				-> True,
	Dimension 			-> D,
	EtaSign				-> 1,
	FCE 				-> False,
	FCVerbose			-> False,
	FinalSubstitutions	-> {},
	Names 				-> "fctopology"
};


FIREToFCTopology[topos_List, lmoms_List, emoms_List /; (emoms === {} || ! OptionQ[emoms]), opts:OptionsPattern[]] :=
	Block[{	optNames, newNames, res},

		optNames = OptionValue[Names];
		optEtaSign = OptionValue[EtaSign];

		If[	OptionValue[FCVerbose]===False,
			ftfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				ftfVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1,"FIREToFCTopology: Entering with a list of topolies.", FCDoControl->ftfVerbose];

		Switch[
			Head[optNames],
			_String,
				newNames=Table[ToExpression[optNames<>ToString[i]],{i,1,Length[topos]}],
			Function,
				newNames=Table[optNames[i],{i,1,Length[topos]}],
			List,
				If[	Length[optNames]===Length[topos],
					newNames=optNames,
					Message[FIREToFCTopology::failmsg, "The list of the provided topology names does not match the list of the topologies"];
					Abort[]
				],
			_Symbol,
				newNames=Table[ToExpression[ToString[optNames]<>ToString[i]],{i,1,Length[topos]}],
			_,
			Message[FIREToFCTopology::failmsg,"Unknown value of the Names option."];
			Abort[]
		];

		FCPrint[3,"FIREToFCTopology: Topology names: ", newNames, FCDoControl->ftfVerbose];

		res = MapThread[FIREToFCTopology[#1,lmoms, emoms, Names->#2, opts]&,{topos,newNames}];

		res

	]/; MatchQ[topos,{___,_List,___}];

FIREToFCTopology[props_List, lmoms_List, emoms_List /; (emoms === {} || ! OptionQ[emoms]), OptionsPattern[]] :=
	Block[{	vars, propsSplit, res, tmp, chk, optFCVariable, momenta},

		optDimension	= OptionValue[Dimension];
		optEtaSign 		= OptionValue[EtaSign];

		If[	OptionValue[FCVerbose]===False,
			ftfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				ftfVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1,"FIREToFCTopology: Entering.", FCDoControl->ftfVerbose];


		FCPrint[3,"FIREToFCTopology: Entering with: ", props, FCDoControl->ftfVerbose];
		FCPrint[3,"FIREToFCTopology: Loop momenta: ", lmoms, FCDoControl->ftfVerbose];
		FCPrint[3,"FIREToFCTopology: External momenta: ", emoms, FCDoControl->ftfVerbose];

		vars = Variables2[props];

		propsSplit = Switch[
			Head[#],

			Power | Times,
				{#, 0},
			Plus,
				Reverse[FCSplit[#, lmoms,Expanding->False]],
			_,
				Message[FIREToFCTopology::failmsg, "Failed to recognize the structure of the propagator " <> ToString[#, Input]]
			] & /@ props;

		FCPrint[3, "FIREToFCTopology: Split propagators: ", propsSplit, FCDoControl->ftfVerbose];
		tmp = propToSFAD[#, lmoms, emoms] & /@ propsSplit;
		(*Todo add propsToCFAD and custom conversion rules *)
		FCPrint[3, "FIREToFCTopology: After propToSFAD: ", tmp, FCDoControl->ftfVerbose];

		If[	!FreeQ[tmp, propToSFAD],
			Message[FIREToFCTopology::failmsg, "Failed to convert all propagator to the FeynCalc notation."];
			Abort[]
		];

		If[	OptionValue[Check],

			chk = FeynAmpDenominatorExplicit[tmp, FCI->True];
			chk = Map[ReplaceAll[(1/#), Pair[Momentum[a_, ___], Momentum[b_, ___]] :> a b]&, chk];

			If[	!MatchQ[ExpandAll[chk-props],{0..}],
				FCPrint[3, "FIREToFCTopology: Discrepancy between the resulting and original propagators: ", ExpandAll[chk-props], FCDoControl->ftfVerbose];
				Message[FIREToFCTopology::failmsg, "The obtained propagators are incorrect."];
				Abort[]
			];
		];

		momenta = Union[Cases[MomentumExpand[tmp],Momentum[m_,___]:>m,Infinity]];

		res = FCTopology[OptionValue[Names], tmp, Intersection[momenta,lmoms], Intersection[momenta,emoms], OptionValue[FinalSubstitutions], {}];
		FCPrint[2, "FIREToFCTopology: Final FCTopology: ", tmp, FCDoControl->ftfVerbose];

		If[	!FCLoopValidTopologyQ[res],
			Message[FIREToFCTopology::failmsg, "Failed to create a valid topology."];
			Abort[]
		];


		If[	OptionValue[FCE],
			res = FCE[res]
		];

		FCPrint[1, "FIREToFCTopology: Leaving.", FCDoControl->ftfVerbose];
		FCPrint[3, "FIREToFCTopology: Leaving with: ", res, FCDoControl->ftfVerbose];

		res
	]/; !MatchQ[props,{___,_List,___}];

(* (p1+...)^2 +/- m^2*)
propToSFAD[{(c_. mom_ + re_ : 0)^2, mass_}, lmoms_List, emoms_List] :=
	FeynAmpDenominator[StandardPropagatorDenominator[Momentum[c mom + re, optDimension], 0, mass, {1, optEtaSign}]] /;
	(MemberQ[lmoms, mom] && FreeQ2[c,Join[lmoms,emoms]]);

(* -(p1+...)^2 +/- m^2*)
propToSFAD[{-(c_. mom_ + re_ : 0)^2, mass_}, lmoms_List, emoms_List] :=
	FeynAmpDenominator[StandardPropagatorDenominator[I Momentum[c mom+ re, optDimension], 0, mass, {1, optEtaSign}]] /;
	(MemberQ[lmoms, mom] && FreeQ2[c,Join[lmoms,emoms]]);

(* c*(p1+...).x +/- m^2*)
propToSFAD[{c_. (a_+ a1_:0) (b_+b1_:0) , mass_}, lmoms_List, emoms_List] :=
FeynAmpDenominator[StandardPropagatorDenominator[0,	c Pair[Momentum[a+a1, optDimension], Momentum[b+b1, optDimension]], mass, {1, optEtaSign}]] /;
	SubsetQ[Join[lmoms, emoms], {a,b}] && !MemberQ[Join[lmoms, emoms], c];

(* (p1+...)^2 + c*(p1+...).x +/- m^2*)
propToSFAD[{(mom_ + re_ : 0)^2 + c_. (a_+ a1_:0) (b_+b1_:0), mass_}, lmoms_List, emoms_List] :=
	FeynAmpDenominator[StandardPropagatorDenominator[Momentum[mom + re, optDimension], c Pair[Momentum[a+a1, optDimension], Momentum[b+b1, optDimension]], mass, {1, optEtaSign}]] /;
	SubsetQ[Join[lmoms, emoms], {a,b,mom}] && !MemberQ[Join[lmoms, emoms], c];

(* -(p1+...)^2 + c*(p1+...).x +/- m^2*)
propToSFAD[{-(mom_ + re_ : 0)^2 + c_. (a_+ a1_:0) (b_+b1_:0), mass_}, lmoms_List, emoms_List] :=
	FeynAmpDenominator[StandardPropagatorDenominator[I Momentum[mom + re, optDimension], c Pair[Momentum[a+a1, optDimension], Momentum[b+b1, optDimension]], mass, {1, optEtaSign}]] /;
	SubsetQ[Join[lmoms, emoms], {a,b,mom}] && !MemberQ[Join[lmoms, emoms], c];



End[]
