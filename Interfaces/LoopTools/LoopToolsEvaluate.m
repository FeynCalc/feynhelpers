(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: LoopToolsEvaluate												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Evaluation of PaVe functions using LoopTools				*)

(* ------------------------------------------------------------------------ *)

LToolsEvaluate::usage=
"LToolsEvaluate[expr,q] evaluates \
Passarino-Veltman functions in expr nuimerically. The evaluation is using \
T. Hahn's LoopTools.";

LToolsExpandInEpsilon::usage=
"";

LToolsImplicitPrefactor::usage=
"LToolsImplicitPrefactor is an option for LToolsEvaluate. It specifies a prefactor \
that doesn't show up explicitly in the input expression, but is understood \
to appear in fron of every Passarino-Veltman function. LToolsEvaluate does not
expand the result in Epsilon..";

LToolsFullResult::usage=
"LToolsFullResult is an option for LToolsEvaluate, LToolsEvaluateUV,
LToolsEvaluateIR and LToolsEvaluateUVIRSplit. When set to True (default),
LToolsEvaluate* functions will return the full result including
singularities and accompanying terms. Otherwise, only the finite part
(standard output of LoopTools) will be provided.";

LToolsEvaluate::failmsg=
"LToolsEvaluate has encountered an error and must abort the evaluation. The \
error description reads: `1`";

LToolsEvaluate::tens=
"Warning! Your input contains tensor loop integrals. Those integrals \
will be ignored, because LoopTools operates only on 1-loop scalar integrals.";

Begin["`Package`"]

End[]

Begin["`LoopTools`Private`"]

lteVerbose::usage="";
dummyLoopMom::usage="";

Options[LToolsEvaluate] = {
	Chop					->	10^(-10),
	Collecting				-> True,
	Factoring 				-> {Factor, 5000},
	FCI						-> False,
	(*LToolsSetDelta 			-> -EulerGamma- Log[Pi],*)
	LToolsExpandInEpsilon	-> True,
	LToolsFullResult 		-> True,
	LToolsImplicitPrefactor -> 1,
	LToolsSetMudim 			-> 1,
	LToolsSetLambda 		-> 0,
	Head					-> Identity,
	PaVeAutoOrder 			-> True,
	FCVerbose 				-> False,
	TimeConstrained 		-> 3,
	InitialSubstitutions	-> {}
};

LToolsEvaluate[expr_, opts:OptionsPattern[]]:=
	LToolsEvaluate[expr, dummyLoopMom, opts];

LToolsEvaluate[expr_, q:Except[_?OptionQ], OptionsPattern[]]:=
	Block[{	ex, fclsOutput, loopIntegral, ints, fcleOutput, resultLT, resEps2, resEps1,
			resFinitePart, lambda, mudim, repRule, res, optLToolsImplicitPrefactor, optChop,
			optInitialSubstitutions, optHead, optLToolsSetLambda, pavePrefactor, time, intsUV,
			extraFinitePieces},

		If [OptionValue[FCVerbose]===False,
			lteVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				lteVerbose=OptionValue[FCVerbose]
			];
		];

		If[	$KeepLogDivergentScalelessIntegrals,
			Message[LToolsEvaluate::failmsg,"LToolsEvaluate is not compatible with $KeepLogDivergentScalelessIntegrals set to True."];
			Abort[]
		];


		optLToolsImplicitPrefactor	= OptionValue[LToolsImplicitPrefactor];
		optHead						= OptionValue[Head];
		optChop						= OptionValue[Chop];
		optLToolsSetLambda			= OptionValue[LToolsSetLambda];


		If[	OptionValue[FCI],
			optInitialSubstitutions = OptionValue[InitialSubstitutions],
			optInitialSubstitutions = FCI[OptionValue[InitialSubstitutions]]
		];

		If[!TrueQ[FeynCalc`Package`ltLoaded],
			LToolsLoadLibrary[];
			FeynCalc`Package`ltLoaded=True
		];

		FCPrint[3,"LToolsEvaluate: Entering with: ", expr, FCDoControl->lteVerbose];

		(*	First of all, let us convert all the scalar integrals to PaVe functions:	*)
		ex = ToPaVe[expr,q,PaVeAutoReduce->False, PaVeAutoOrder -> OptionValue[PaVeAutoOrder]]//ToPaVe2;

		FCPrint[1,"LToolsEvaluate: Applying FCLoopSplit.", FCDoControl->lteVerbose];
		fclsOutput  = FCLoopSplit[ex,{q}];
		FCPrint[3,"LToolsEvaluate: After FCLoopSplit: ", fclsOutput, FCDoControl->lteVerbose];

		If [fclsOutput[[3]]=!=0 || fclsOutput[[4]]=!=0,
			Message[LToolsEvaluate::tens]
		];

		FCPrint[1,"LToolsEvaluate: Applying FCLoopExtract.", FCDoControl-> lteVerbose];
		fcleOutput=FCLoopExtract[fclsOutput[[2]], {q}, loopIntegral, FCI->True];
		FCPrint[3,"LToolsEvaluate: After FCLoopExtract: ", fcleOutput, FCDoControl-> lteVerbose];

		(*	The 3rd element in fcleOutput is our list of unique scalar integrals that
			need to be computed. *)
		ints = fcleOutput[[3]] /. Dispatch[optInitialSubstitutions];

		FCPrint[3,"LToolsEvaluate: Unique integrals with numerical parameters: ", ints, FCDoControl-> lteVerbose];

		If[	!MatchQ[(ints/.loopIntegral[0]->Unevaluated[Sequence[]]/.loopIntegral->Identity), {__PaVe} | {}],
			Message[LToolsEvaluate::failmsg,"List of unique scalar integrals contains integrals that are not written as PaVe functions."];
			FCPrint[1,"LToolsEvaluate: ints: ", (ints/.loopIntegral->Identity), " ", FCDoControl-> lteVerbose];
			Abort[];
		];


		If[	!MatchQ[(ints/.loopIntegral[0]->Unevaluated[Sequence[]]/.loopIntegral->Identity), {PaVe[__?NumberQ, {___?NumberQ}, {__?NumberQ}, OptionsPattern[]] ..}  | {}],
			Message[LToolsEvaluate::failmsg,"Arguments of PaVe functions are not purely numerical."];
			FCPrint[1,"LToolsEvaluate: ints: ", (ints/.loopIntegral->Identity), " ", FCDoControl-> lteVerbose];
			Abort[];
		];


		lambda = LToolsGetLambda[];
		mudim = LToolsGetMudim[];
		(*delta = LToolsGetDelta[];*)

		LToolsSetMudim[OptionValue[LToolsSetMudim]];
		(*LToolsSetDelta[OptionValue[LToolsSetDelta]];*)

		(*
		The prefactor of PaVe functions in FeynCalc is 1/(I*Pi^2). In contrast to that,
		LoopTools uses 1/(I*Pi^(D/2)*r_Gamma) = Pi^Epsilon/(I*Pi^2*r_Gamma) with
		r_Gamma = Gamma[1-Epsilon]^2 Gamma[1+Epsilon] / Gamma[1-2 Epsilon]

		So to compensate for that we need to multiply the LoopTools result by

		Pi^(-Epsilon) Gamma[1-Epsilon]^2 Gamma[1+Epsilon] / Gamma[1-2 Epsilon]

		*)
		pavePrefactor = Pi^(-Epsilon) Gamma[1-Epsilon]^2 Gamma[1+Epsilon] / Gamma[1-2 Epsilon];

		If[	OptionValue[LToolsFullResult],
			(*True*)
			FCPrint[1,"LToolsEvaluate: Calculating the full result.", FCDoControl->lteVerbose];

			LToolsSetLambda[-2];
			resEps2 = ints /. loopIntegral->optHead /. PaVe -> LToolsPaVe;
			FCPrint[3,"LToolsEvaluate: 1/Epsilon^2 term: ", resEps2, " ", FCDoControl->lteVerbose];

			LToolsSetLambda[-1];
			resEps1 = ints /. loopIntegral->optHead /. PaVe -> LToolsPaVe;
			FCPrint[3,"LToolsEvaluate: 1/Epsilon term: ", resEps1, " ", FCDoControl->lteVerbose];

			LToolsSetLambda[0];

			(*
			intsUV = PaVeUVPart[#,Dimension->4-2Epsilon]&/@(ints/.loopIntegral->Identity);
			extraFinitePieces = Map[
				If[	TrueQ[Coefficient[#,Epsilon,-1]=!=0],
					flag(+EulerGamma+ Log[Pi]),
					0
				]&,intsUV];
			FCPrint[3,"LToolsEvaluate: Extra finite pieces for the UV-divergences: ", extraFinitePieces, FCDoControl->lteVerbose];
			*)
			resFinitePart = ints /.loopIntegral->optHead /. PaVe -> LToolsPaVe;
			FCPrint[3,"LToolsEvaluate: finite part: ", resFinitePart, " ", FCDoControl->lteVerbose];

			resultLT = ((resEps2)/Epsilon^2 + (resEps1)/Epsilon + resFinitePart),

			(*False*)
			FCPrint[1,"LToolsEvaluate: Calculating only the finite part.", FCDoControl->lteVerbose];
			LToolsSetLambda[optLToolsSetLambda];
			resultLT = (ints /.loopIntegral->optHead /. PaVe -> LToolsPaVe)
		];

		FCPrint[3,"LToolsEvaluate: resultLT (raw): ", resultLT, FCDoControl->lteVerbose];
		resultLT = optLToolsImplicitPrefactor*pavePrefactor*resultLT;
		FCPrint[3,"LToolsEvaluate: resultLT (with prefactors): ", resultLT, FCDoControl->lteVerbose];

		If[	resultLT=!=Identity,
			resultLT = resultLT /. optHead[0.]->0;

			If[	OptionValue[LToolsExpandInEpsilon],
				time=AbsoluteTime[];
				FCPrint[1, "LToolsEvaluate: Expanding the result in Epsilon", FCDoControl->lteVerbose];
				resultLT = Normal[Series[resultLT,{Epsilon,0,0}]];
				FCPrint[1, "LToolsEvaluate: Done expanding the result, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->lteVerbose];
				FCPrint[3,"LToolsEvaluate: resultLT (expanded): ", resultLT , FCDoControl->lteVerbose];
			]
		];

		LToolsSetLambda[lambda];
		LToolsSetMudim[mudim];
		(*LToolsSetDelta[delta];*)



		repRule = MapThread[Rule[#1,#2]&,{fcleOutput[[3]],resultLT}];

		res = fclsOutput[[1]] + fcleOutput[[1]] + (fcleOutput[[2]]/. Dispatch[repRule]);

		FCPrint[3,"LToolsEvaluate: full result: ", res , FCDoControl->lteVerbose];

		If[	OptionValue[Collecting],
			time=AbsoluteTime[];
			FCPrint[1, "LToolsEvaluate: Applying Collect2", FCDoControl->lteVerbose];
			res = Collect2[res, {Epsilon}, Factoring->OptionValue[Factoring],TimeConstrained->OptionValue[TimeConstrained]];
			FCPrint[1, "LToolsEvaluate: Done applying Collect2, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->lteVerbose]
		];

		If[	optChop,
			res = Chop[res,optChop]
		];

		res

	];

End[]

