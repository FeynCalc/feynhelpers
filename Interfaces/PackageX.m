(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PackageX															*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2016 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and Package-X					*)

(* ------------------------------------------------------------------------ *)

PaXEvaluate::usage="PaXEvaluate[expr,q,D] evaluates \
scalar 1-loop integrals (up to 3-point functions) in expr that depend\
on the loop momentum q in D dimensions. The evaluation is done on
a parellel kernel using H. Patel's Package-X.";

PaXSubstituteEpsilon::usage=
"PaXSubstituteEpsilon is an option for PaXEvaluate. For brevity, \
Package-X normally abbreviates 1/Epsilon - EulerGamma + Log[4Pi] \
by 1/Epsilon (see DimRegEpsilon in the Documentation of Package-X). \
When SubstituteEpsilon is set to True, PaXEvaluate will undo this
abbreviation to obtain the complete result.";

PaXExpandInEpsilon::usage=
"PaXExpandInEpsilon is an option for PaXEvaluate. If ImplicitPrefactor is \
not unity and SubstituteEpsilon is set to True, then the value of ExpandInEpsilon \
determines wheter the final result should be again expanded in Epsilon. Only the
1/Epsilon pole is kept. The default value is True.";

PaXSimplifyEpsilon::usage=
"PaXSimplifyEpsilon is an option for PaXEvaluate. When set to True, PaXEvaluate will
attempt to simplify the final result by applying simplifications to the Epsilon-free parts
of the expression. The default value is True.";

PaXImplicitPrefactor::usage=
"PaXImplicitPrefactor is an option for PaXEvaluate. It specifies a prefactor \
that doesn't show up explicitly in the input expression, but is understood \
to appear in fron of every 1-loop integral. For technical reasons, PaXImplicitPrefactor \
shouldn't depend on the number of dimensions D. Instead you should explicitly specify \
what D is (e.g. 4-2 Epsilon). The default value is 1. \
If the standard prefactor 1/(2Pi)^D is implicit in your calculations then you set
ImplicitPrefactor to 1/(2 Pi)^(4 - 2 Epsilon).";

$LaunchPackageX::usage=
"$LaunchPackageX determines what package name Mathematica calls to load Package-X. \
The default is \"X`\"";

PaXpvA::usage=
"PaXpvA corresponds to the pvA function in Package-X";

PaXpvB::usage=
"PaXpvB corresponds to the pvB function in Package-X";

PaXpvC::usage=
"PaXpvC corresponds to the pvC function in Package-X";

PaXEpsilonBar::usage =
"PaXEpsilonBar corresponds to DimRegEpsilon in Package-X, i.e. \
1/PaXEpsilonBar means 1/Epsilon - EulerGamma + Log[4Pi].";

PaXDiscB::usage =
"PaXDiscB corresponds to DiscB in Package-X.";

PaXKallenLambda::usage =
"PaXDiscB corresponds to Kallen\[Lambda] in Package-X.";

PaXDiLog::usage =
"PaXDiLog corresponds to DiLog in Package-X.";

PaXDiscExpand::usage =
"PaXDiscExpand is an Option for PaXEvaluate. If set to True, \
Package-X function DiscExpand will be applied to the output \
of Package-X thus replacing DiscB by its explicit form.";

PaXKallenExpand::usage =
"PaXKallenExpand is an Option for PaXEvaluate. If set to True, \
Package-X function KallenExpand will be applied to the output \
of Package-X thus replacing KallenLambda by its explicit form.";

PaXEvaluate::convFail=
"Warning! Not all scalar loop integrals in the expression could be \
prepared to be processed with Package X. Following integrals will not \
be handled by Package X: `1`";

PaXEvaluate::tens=
"Warning! Your input contains tensor loop integrals. Those integrals \
will be ignored, because PaxEvaluate operates only on 1-loop scalar \
integrals with up to 3 propagators.";

PaXEvaluate::gen=
"PaXEvaluate has encountered an error and must abort the evaluation. The
error description reads: `1`";


Begin["`Package`"]
End[]

Begin["`PackageX`Private`"]

paxVerbose::usage="";

$LaunchPackageX = "X`OneLoop`";

Options[PaXEvaluate] = {
	Collect -> True,
	Dimension -> D,
	FCVerbose -> False,
	PaXDiscExpand -> True,
	PaXExpandInEpsilon -> True,
	PaXImplicitPrefactor -> 1,
	PaXKallenExpand -> True,
	PaXSimplifyEpsilon -> True,
	PaXSubstituteEpsilon -> True
};

(* Typesetting *)

PaXEpsilonBar /:
	MakeBoxes[PaXEpsilonBar, TraditionalForm] :=
		OverscriptBox["\[Epsilon]", "-"];

PaXKallenLambda /:
	MakeBoxes[PaXKallenLambda[a_,b_,c_], TraditionalForm]:=
		TBox["\[Lambda]","(",a,",",b,",",c,")"];

PaXDiscB /:
	MakeBoxes[PaXDiscB[a_,b_,c_], TraditionalForm]:=
		TBox["\[CapitalLambda]","(",a,",",b,",",c,")"];

PaXDiLog /:
	MakeBoxes[PaXDiLog[a_, b_], TraditionalForm] :=
		RowBox[{SubscriptBox["Li", "2"], "(", TBox[a], "+", TBox[I b], "\[Epsilon]", ")"}]

(* FeynCalc->Package-X conversion of scalar products *)
momConv[x_] :=
	ExpandScalarProduct[MomentumCombine[FCI[x]]] /. {Pair[Momentum[a_, _ : 4], Momentum[b_, _ : 4]] :> LDot[a,b]}

toPackageX[pref_, q_]:=
	pref /; FreeQ2[pref,Join[{q},FeynCalc`Package`PaVeHeadsList]];

(* FeynCalc->Package-X conversion for A0, B0, B1, B00, B11 and C0.
	Notice that additional (2Pi)^(D-4) prefactor that comes from different
	normalizations between PaVe functions in FeynCalc and Package-X:

	FeynCalc: A0(m) =  1/(I Pi^2) \int d^4 q 1/(q^2-m^2)
	Package-X: A0(m) =  16Pi^2/(I) 1/(2Pi)^D \int d^4 q 1/(q^2-m^2)
 *)
toPackageX[pref_. A0[m_, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvA[0, PowerExpand[Sqrt[m]]]/;FreeQ[pref,q] && FreeQ[m, Complex];

toPackageX[pref_. B0[mom1_, m1_, m2_, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvB[0, 0, momConv[mom1], PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex];

toPackageX[pref_. B1[mom1_, m1_, m2_, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvB[0, 1, momConv[mom1], PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex];

toPackageX[pref_. B00[mom1_, m1_, m2_, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvB[1, 0, momConv[mom1], PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex];

toPackageX[pref_. B11[mom1_, m1_, m2_, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvB[0, 2, momConv[mom1], PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex];

toPackageX[pref_. C0[mom1_, mom1min2_, mom2_, m1_, m2_, m3_, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvC[0, 0, 0, momConv[mom1], momConv[mom2], momConv[mom1min2], PowerExpand[Sqrt[m3]],
	PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m1]]]/;FreeQ[pref,q] && FreeQ[{m1,m2,m3}, Complex];

(* FeynCalc->Package-X conversion for PaVe's
	PaVe's are normalized the same way as A0, B0 etc.
*)

toPackageX[pref_. PaVe[inds__, {}, {m_}, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvA[Count[{inds},0]/2, PowerExpand[Sqrt[m]]]/;
	FreeQ[pref,q] && FreeQ[m, Complex] && EvenQ[Count[{inds},0]];

toPackageX[pref_. PaVe[inds__, {mom1_}, {m1_, m2_}, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvB[Count[{inds},0]/2, Count[{inds},1], momConv[mom1], PowerExpand[Sqrt[m1]],
	PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex] &&
	(EvenQ[Count[{inds}, 0]] || Count[{inds}, 0] === 0);

toPackageX[pref_. PaVe[inds__,  {mom1_, mom1min2_, mom2_}, {m1_, m2_, m3_}, OptionsPattern[]], q_]:=
	(2 Pi)^(FCGV["D"]-4) pref PaXpvC[Count[{inds},0]/2, Count[{inds},1], Count[{inds},2], momConv[mom1], momConv[mom2], momConv[mom1min2],
	PowerExpand[Sqrt[m3]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m1]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3}, Complex] && (EvenQ[Count[{inds}, 0]] || Count[{inds}, 0] === 0);

(*	FeynCalc FAD ->FeynCalc PaVe conversion.
	I Pi^2 prefactor comes from the way how FAD's and PaVe's are
	normalized in FeynCalc.
*)

toPackageX[pref_. FeynAmpDenominator[PD[Momentum[q_,_],m_]],q_]:=
	I Pi^2 pref toPackageX[A0[m^2],q]/; FreeQ[pref,q];

toPackageX[pref_. FeynAmpDenominator[PD[Momentum[q_,dim_],m1_],PD[Momentum[q_,dim_]+p_:0,m2_]],q_]:=
	I Pi^2 pref toPackageX[PaVeOrder[B0[FCI[ScalarProduct[p]],m1^2,m2^2]],q]/; FreeQ[pref,q];

toPackageX[pref_. FeynAmpDenominator[PD[Momentum[q_,dim_],m1_],PD[Momentum[q_,dim_]+p1_:0,m2_],
	PD[Momentum[q_,dim_]+p2_:0,m3_]],q_]:=
	I Pi^2 pref toPackageX[PaVeOrder[C0[FCI[ScalarProduct[p1]],FCI[ScalarProduct[p1-p2]],FCI[ScalarProduct[p2]],m1^2,m2^2,m3^2]],q]/; FreeQ[pref,q];



PaXEvaluate[expr_,q_:Except[_?OptionQ], OptionsPattern[]]:=
	Block[{kernel,temp,resultX,finalResult,xList,ints,fclsOutput,fclcOutput,dim,
			epsFree,epsNotFree, holddim},
		dim = OptionValue[Dimension];

		If [OptionValue[FCVerbose]===False,
			paxVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer?Positive | 0],
				paxVerbose=OptionValue[FCVerbose]
			];
		];

		If [ !FreeQ[OptionValue[PaXImplicitPrefactor],PaXEpsilonBar],
			Message[PaXEvaluate::gen, "ImplicitPrefactor is not allowed to depend on EpsilonBar."];
			Abort[]
		];

		(*	Since we care only for the scalar integrals, we need
			only the second element from the list returned by FCLoopSplit *)
		fclsOutput  = FCLoopSplit[expr,{q}];
		If [fclsOutput[[3]]=!=0 || fclsOutput[[4]]=!=0,
			Message[PaXEvaluate::tens]
		];
		(*	FCLoopCanonicalize is of course an overkill for purely scalar integrals,
			but it is better to use it than to implement own functions every time...	*)
		ints=FCLoopIsolate[fclsOutput[[2]], {q}, FCI->True, Head->loopIntegral];

		(*	The 4th element in fclcOutput is our list of unique scalar integrals that
			need to be computed. But first we need to convert them to the Pacakge X input *)
		fclcOutput = FCLoopCanonicalize[ints, q, loopIntegral,FCI->True];
		xList = Map[toPackageX[(#/.loopIntegral->Identity),q]&, fclcOutput[[4]]];

		(*  If the conversion is not complete, we need to warn the user *)
		If [!FreeQ[xList,toPackageX],
			Message[PaXEvaluate::convFail, Cases[xList,toPackageX[x_,_]:>x,Infinity]];
			xList = xList/.{toPackageX[x_,_]:>x}
		];

		FCPrint[1,"PaXEvaluate: After toPackageX: ", xList, FCDoControl->paxVerbose];

		If[	Head[xList]=!=List,
			Message[PaXEvaluate::gen, "xList is not a List."];
			Abort[]
		];

		If[	xList=!={},
			(* If the integral list is not empty, go on. *)


			(* Start a new kernel	*)
			kernel = LaunchKernels[1];

			(* Dirty trick to prevent the package from flushing the front-end with its Print output  *)
			(*ParallelEvaluate[Unprotect[System`Print]; System`Print=System`PrintTemporary&, kernel];*)

			(* Start Package X *)
			With[{startX=$LaunchPackageX},ParallelEvaluate[Get[startX], kernel]];
			resultX = With[{
					input=xList/. {
							dim->4-2*Hold[ToExpression["X`OneLoop`\[Epsilon]"]],
							FCGV["D"]:>4-2*Hold[ToExpression["X`OneLoop`\[Epsilon]"]],
							PaXpvA->Hold[ToExpression["X`OneLoop`pvA"]],
							PaXpvB->Hold[ToExpression["X`OneLoop`pvB"]],
							PaXpvC->Hold[ToExpression["X`OneLoop`pvC"]],
							LDot->Hold[ToExpression["X`IndexAlg`LDot"]],
							Epsilon->Hold[ToExpression["X`OneLoop`\[Epsilon]"]] },
						xEps=Hold[ToExpression["X`OneLoop`\[Epsilon]"]],
						xMu = Hold[ToExpression["X`OneLoop`\[Mu]R"]],
						xLDot = Hold[ToExpression["X`IndexAlg`LDot"]],
						xDiscExpOpt = OptionValue[PaXDiscExpand],
						xKallenExpOpt = OptionValue[PaXKallenExpand],
						xDiscB = Hold[ToExpression["X`OneLoop`DiscB"]],
						xKallenL = Hold[ToExpression["X`OneLoop`Kallen\[Lambda]"]],
						xDiLog = Hold[ToExpression["X`OneLoop`DiLog"]]
					},
					ParallelEvaluate[((ToExpression["X`OneLoop`LoopRefine"][ReleaseHold[input],
						ToExpression["X`OneLoop`ExplicitC0->All"]])/.{
						ReleaseHold[xEps]->FeynHelpers`Private`eps,
						ReleaseHold[xMu]->FeynHelpers`Private`mu,
						ReleaseHold[xLDot]->FeynHelpers`Private`dot})//
						If[xDiscExpOpt,ToExpression["X`OneLoop`DiscExpand"][#],#]&//
						If[xKallenExpOpt,ToExpression["X`OneLoop`KallenExpand"][#],#]&//
						ReplaceAll[#,{ReleaseHold[xDiscB]->FeynHelpers`Private`discB,
							ReleaseHold[xKallenL]->FeynHelpers`Private`kallenL,
							ReleaseHold[xDiLog]->FeynHelpers`Private`diLog

							}]&
					,kernel]];
			CloseKernels[kernel];

			(* Sanity check: The output must be either {int1,int2,...} or {{int1,int2,...}}  *)
			If[	Head[resultX]=!=List,
				Message[PaXEvaluate::gen, "resultX is not a List."];
				Abort[]
			];

			(*	In Mathematica 10 and above, With[{...},ParallelEvalluate[...]] returns a list,
				while older version give back only the evaluated expression  *)
			If [$VersionNumber>=10,
				resultX = Total[resultX];
			];

			FCPrint[2,"PaXEvaluate: resultX (raw): ", resultX, FCDoControl->paxVerbose];

			(* We need to convert Package X output into FeynCalc input *)
			resultX = resultX/.{
								FeynHelpers`Private`mu->ScaleMu,
								FeynHelpers`Private`eps -> PaXEpsilonBar,
								FeynHelpers`Private`dot[a_,b_]:>Pair[Momentum[a,dim],Momentum[b,dim]]} /.

								{
								FeynHelpers`Private`discB -> PaXDiscB,
								FeynHelpers`Private`kallenL -> PaXKallenLambda,
								FeynHelpers`Private`diLog -> PaXDiLog

								};

			(* Do we need to replace 1/Eps by 1/Eps - g_E + Log(4Pi) ? *)
			If [OptionValue[PaXSubstituteEpsilon],
				(*Need a check that the expansion was done correctly!!!*)
				resultX =  Expand2[resultX, PaXEpsilonBar]/.{1/PaXEpsilonBar^2 -> 1/Epsilon^2  +
					(1/Epsilon)(-EulerGamma+Log[4 Pi]) + (EulerGamma^2)/2 - (Pi^2)/12 -
					EulerGamma Log[4 Pi] + (1/2) Log[4 Pi]^2}/.{1/PaXEpsilonBar->1/Epsilon - EulerGamma + Log[4Pi]};
				If[	!FreeQ[resultX,PaXEpsilonBar],
					Message[PaXEvaluate::gen, "Failed to eliminate EpsilonBar."];
					Abort[]
				]
			],
			resultX={}
		];

		FCPrint[2,"PaXEvaluate: resultX (converted): ", resultX, FCDoControl->paxVerbose];

		(* Now we create the final substitution list *)
		finalResult = fclsOutput[[1]] + fclsOutput[[3]] + fclsOutput[[4]] + ints/.FCLoopSolutionList[fclcOutput,resultX];
		FCPrint[2,"PaXEvaluate: finalResult(w/o implicit prefactor): ", finalResult, FCDoControl->paxVerbose];


		(* Protect the dimensions of vectors and Dirac matrices before the expansion *)

		finalResult = finalResult /.
			LorentzIndex[a_,dim] :> LorentzIndex[holddim[a,ToString[dim,InputForm]]] /.
			Momentum[a_,dim] :> Momentum[holddim[a,ToString[dim,InputForm]]] /.
			DiracGamma[a_,dim] :> DiracGamma[holddim[a,ToString[dim,InputForm]]] /.
				{ConditionalExpression[a_,b__]:> holdcond[ToString[{a,b},InputForm]]} /. dim->4-2*Epsilon;

		FCPrint[3,"PaXEvaluate: finalResult(w/o implicit prefactor) with protected dimensions: ",
			finalResult, FCDoControl->paxVerbose];

		If[OptionValue[PaXImplicitPrefactor]=!=1,
			(* 	If implicit prefactor depends on D or Epsilon, then we need to expand around Epsilon=0 again here.
				However, this is safe only if the final expression is free of loop integrals and EpsilonBar. *)

			If[	!FreeQ2[OptionValue[PaXImplicitPrefactor],{dim,Epsilon}] &&
				FreeQ2[finalResult,{FeynAmpDenominator,q,PaXEpsilonBar}] &&
				OptionValue[PaXExpandInEpsilon],
				finalResult = Series[(OptionValue[PaXImplicitPrefactor] ChangeDimension[finalResult,4])/.dim->4-2Epsilon,{Epsilon,0,0}]//Normal,
				finalResult = (OptionValue[PaXImplicitPrefactor] finalResult)
			]
		];

		FCPrint[2,"PaXEvaluate: finalResult (with implicit prefactor): ", finalResult, FCDoControl->paxVerbose];


		(* Before returning the final result it is useful to try to simplify the Epsilon-free pieces separately *)
		If [ OptionValue[PaXSimplifyEpsilon],
			{epsFree,epsNotFree} = FCSplit[finalResult,{Epsilon}];
			finalResult = Simplify[epsNotFree] + (Simplify[epsFree]/. {Log[x_Integer] :>
				PowerExpand[Log[x]]}/. Log[4 Pi x_] :> Log[4 Pi] + Log[x]);
		];

		finalResult = finalResult /.
		holdcond[str_String] :> holdcond[Sequence@@ToExpression[str]] /. holdcond->
		ConditionalExpression /.
		DiracGamma[holddim[a_,str_String]]:> DiracGamma[a,ToExpression[str]] /.
		Momentum[holddim[a_,str_String]] :> Momentum[a,ToExpression[str]] /.
		LorentzIndex[holddim[a_,str_String]] :> LorentzIndex[a,ToExpression[str]];

		If[	OptionValue[Collect],
			finalResult = Collect2[finalResult, {Epsilon, Pair}]
		];

		FCPrint[2,"PaXEvaluate: Last finalResult (simplified): ", finalResult, FCDoControl->paxVerbose];
		finalResult
	]

End[]
