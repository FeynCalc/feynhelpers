(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PackageX															*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2016 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and Package-X					*)

(* ------------------------------------------------------------------------ *)

PaXEvaluate::usage="PaXEvaluate[expr,q] evaluates \
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

PaXpvA::usage=
"PaXpvA corresponds to the PVA function in Package-X";

PaXpvB::usage=
"PaXpvB corresponds to the PVB function in Package-X";

PaXpvC::usage=
"PaXpvC corresponds to the PVC function in Package-X";

PaXpvD::usage=
"PaXpvD corresponds to the PVD function in Package-X";

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

PaxLoopRefineOptions::usage =
"PaxLoopRefineOptions is an Option for PaXEvaluate. It allows \
you to directly specify the options supplied to LoopRefine, the \
Package-X function which returns analytic expressions for loop \
integrals. The options should be given using X` context, i.e. \
PaxLoopRefineOptions -> {X`ExplicitC0 -> All};
";

PaXPath::usage=
"PaXPath is an Option for PaXEvaluate. It specifies the
directory, in which Package-X is installed";

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

paxLoaded::usage="";

End[]

Begin["`PackageX`Private`"]

paxVerbose::usage="";
dummyLoopMom::usage="";

Options[PaXEvaluate] = {
	Collect -> True,
	Dimension -> D,
	ChangeDimension -> False,
	FCVerbose -> False,
	FinalSubstitutions -> {},
	PaXDiscExpand -> True,
	PaXExpandInEpsilon -> True,
	PaXImplicitPrefactor -> 1,
	PaXKallenExpand -> True,
	PaXPath -> FileNameJoin[{$UserBaseDirectory, "Applications", "X"}],
	PaXSimplifyEpsilon -> True,
	PaXSubstituteEpsilon -> True,
	PaxLoopRefineOptions -> {X`ExplicitC0 -> All}
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
	FCE[ExpandScalarProduct[MomentumCombine[FCI[x]]]];

toPackageX2[pref_, q_]:=
	pref /; FreeQ2[pref,Join[{q},FeynCalc`Package`PaVeHeadsList]];

(* FeynCalc->Package-X conversion for A0, B0, B1, B00, B11 and C0.
	Notice that additional (2Pi)^(D-4) prefactor that comes from different
	normalizations between PaVe functions in FeynCalc and Package-X:

	FeynCalc: A0(m) =  1/(I Pi^2) \int d^4 q 1/(q^2-m^2)
	Package-X: A0(m) =  16Pi^2/(I) 1/(2Pi)^D \int d^4 q 1/(q^2-m^2)
 *)

(* FeynCalc->Package-X conversion for PaVe's
	PaVe's are normalized the same way as A0, B0 etc.
*)

(* 1-point functions *)
toPackageX2[pref_. PaVe[0, {}, {m_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`\[Epsilon])) pref X`PVA[0, PowerExpand[Sqrt[m]]]/;
	FreeQ[pref,q] && FreeQ[m, Complex];

toPackageX2[pref_. PaVe[inds__, {}, {m_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`\[Epsilon])) pref X`PVA[Count[{inds},0]/2, PowerExpand[Sqrt[m]]]/;
	FreeQ[pref,q] && FreeQ[m, Complex] && EvenQ[Count[{inds},0]] && {inds}=!={0};

(* 2-point functions *)
toPackageX2[pref_. PaVe[0, {mom1_}, {m1_, m2_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`\[Epsilon])) pref X`PVB[0, 0, momConv[mom1], PowerExpand[Sqrt[m1]],
	PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex];

toPackageX2[pref_. PaVe[inds__, {mom1_}, {m1_, m2_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`\[Epsilon])) pref X`PVB[Count[{inds},0]/2, Count[{inds},1], momConv[mom1], PowerExpand[Sqrt[m1]],
	PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex] &&
	(EvenQ[Count[{inds}, 0]] || Count[{inds}, 0] === 0) && {inds}=!={0};

(* 3-point functions *)
toPackageX2[pref_. PaVe[0,  {mom1_, mom1min2_, mom2_}, {m1_, m2_, m3_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`\[Epsilon])) pref X`PVC[0, 0, 0, momConv[mom1], momConv[mom1min2], momConv[mom2],
	PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m3]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3}, Complex];

toPackageX2[pref_. PaVe[inds__,  {mom1_, mom1min2_, mom2_}, {m1_, m2_, m3_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`\[Epsilon])) pref X`PVC[Count[{inds},0]/2, Count[{inds},1], Count[{inds},2], momConv[mom1], momConv[mom1min2], momConv[mom2],
	PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m3]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3}, Complex] && (EvenQ[Count[{inds}, 0]] || Count[{inds}, 0] === 0);

(* 4-point functions *)
toPackageX2[pref_. PaVe[0,  {mom1_, mom1min2_, mom2min3_, mom3_, mom2_, mom1min3_}, {m1_, m2_, m3_, m4_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`\[Epsilon])) pref X`PVD[0, 0, 0, 0,
		momConv[mom1], momConv[mom1min2], momConv[mom2min3], momConv[mom3], momConv[mom2], momConv[mom1min3],
	PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m3]], PowerExpand[Sqrt[m4]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3,m4}, Complex];

toPackageX2[pref_. PaVe[inds__,  {mom1_, mom1min2_, mom2min3_, mom3_, mom2_, mom1min3_}, {m1_, m2_, m3_, m4_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`\[Epsilon])) pref X`PVD[Count[{inds},0]/2, Count[{inds},1], Count[{inds},2], Count[{inds},3],
		momConv[mom1], momConv[mom1min2], momConv[mom2min3], momConv[mom3], momConv[mom2], momConv[mom1min3],
	PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m3]], PowerExpand[Sqrt[m4]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3,m4}, Complex] && (EvenQ[Count[{inds}, 0]] || Count[{inds}, 0] === 0);

PaXEvaluate[expr_, opts:OptionsPattern[]]:=
	PaXEvaluate[expr, dummyLoopMom, opts];

PaXEvaluate[expr_,q:Except[_?OptionQ], OptionsPattern[]]:=
	Block[{	ex,kernel,temp,resultX,finalResult,xList,ints,fclsOutput,fclcOutput,
			dim,epsFree,epsNotFree, holddim,paxVer},

		dim = OptionValue[Dimension];

		If [OptionValue[FCVerbose]===False,
			paxVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer?Positive | 0],
				paxVerbose=OptionValue[FCVerbose]
			];
		];

		(* Check if package X has already been loaded*)
		If [ paxLoaded=!=True,

			FCPrint[1,"PaXEvaluate: Checking the version of Package-X.", FCDoControl->paxVerbose];
			paxVer = Last[Get[FileNameJoin[{OptionValue[PaXPath], "PacletInfo.m"}]][[2]]];
			paxVer = (ToExpression/@(Identity@@StringReplace[paxVer, n1__ ~~ "." ~~ n2__ ~~ "." ~~ n3__ :>
				{n1, n2, n3}]));

			If[paxVer[[1]] < 2. ,
				Message[PaXEvaluate::gen, "Package-X versions earlier than 2.0 are not supported."];
				Abort[]
			];

			FCPrint[1,"PaXEvaluate: Loading Package-X.", FCDoControl->paxVerbose];
			Begin["Global`"];
			(* 	The following code for loading the OneLoop part of Package-X was kindly
				provided by Hiren Patel, the developer of Package-X *)
			Block[{$ContextPath},
				BeginPackage["X`"];
				(*Loads all definitions in Package-X OneLoop.m.	*)
				Get[FileNameJoin[{OptionValue[PaXPath], "OneLoop.m"}]];
				EndPackage[];
			];
			End[];
			FCPrint[1,"PaXEvaluate: Package-X loaded", FCDoControl->paxVerbose];
			paxLoaded=True;
		];



		FCPrint[3,"PaXEvaluate: Entering with: ", expr, FCDoControl->paxVerbose];

		If [ !FreeQ[OptionValue[PaXImplicitPrefactor],PaXEpsilonBar],
			Message[PaXEvaluate::gen, "ImplicitPrefactor is not allowed to depend on EpsilonBar."];
			Abort[]
		];

		(*	First of all, let us convert all the scalar integrals to PaVe functions:	*)
		ex = expr//ToPaVe[#,q,PaVeAutoReduce->False]&//ToPaVe2;

		(*	Since we care only for the scalar integrals, we need
			only the second element from the list returned by FCLoopSplit *)

		FCPrint[1,"PaXEvaluate: Applying FCLoopSplit.", FCDoControl->paxVerbose];
		fclsOutput  = FCLoopSplit[ex,{q}];
		If [fclsOutput[[3]]=!=0 || fclsOutput[[4]]=!=0,
			Message[PaXEvaluate::tens]
		];

		(*	FCLoopCanonicalize is of course an overkill for purely scalar integrals,
			but it is better to use it than to implement own functions every time...	*)

		FCPrint[1,"PaXEvaluate: Applying FCLoopIsolate.", FCDoControl->paxVerbose];
		ints=FCLoopIsolate[fclsOutput[[2]], {q}, FCI->True, Head->loopIntegral];

		(*	The 4th element in fclcOutput is our list of unique scalar integrals that
			need to be computed. But first we need to convert them to the Pacakge X input *)
		fclcOutput = FCLoopCanonicalize[ints, q, loopIntegral,FCI->True];

		FCPrint[1,"PaXEvaluate: Checking the version of Package-X.", FCDoControl->paxVerbose];

		paxVer = Last[Get[FileNameJoin[{OptionValue[PaXPath], "PacletInfo.m"}]][[2]]];
		paxVer = (ToExpression/@(Identity@@StringReplace[paxVer, n1__ ~~ "." ~~ n2__ ~~ "." ~~ n3__ :>
			{n1, n2, n3}]));

		FCPrint[1,"PaXEvaluate: Converting to the Package-X notation.", FCDoControl->paxVerbose];
		xList = Map[toPackageX2[(#/.loopIntegral->Identity),q]&, fclcOutput[[4]]];

		(*  If the conversion is not complete, we need to warn the user *)
		If [!FreeQ[xList,toPackageX2],
			Message[PaXEvaluate::convFail, Cases[xList,toPackageX2[x_,_]:>x,Infinity]];
			xList = xList/.{toPackageX2[x_,_]:>x}
		];

		FCPrint[1,"PaXEvaluate: After toPackageX: ", xList, FCDoControl->paxVerbose];

		If[	Head[xList]=!=List,
			Message[PaXEvaluate::gen, "xList is not a List."];
			Abort[]
		];

		If[	xList=!={},
			(* If the integral list is not empty, go on. *)
			FCPrint[1,"PaXEvaluate: Preparing the evaluation.", FCDoControl->paxVerbose];

			xList = xList/. { dim->4-2*(X`\[Epsilon]), Epsilon->(X`\[Epsilon]) };

			resultX = X`LoopRefine[xList, Sequence@@OptionValue[PaxLoopRefineOptions]];

			If[	OptionValue[PaXDiscExpand],
				resultX = X`DiscExpand[resultX];
			];

			If[	OptionValue[PaXKallenExpand],
				resultX = X`KallenExpand[resultX];
			];

			(* We need to convert Package X output into FeynCalc input *)
			resultX = resultX /. {
				X`\[Epsilon] -> PaXEpsilonBar,
				X`\[Micro] -> ScaleMu,
				X`DiscB -> PaXDiscB,
				X`Kallen\[Lambda] -> PaXKallenLambda,
				X`DiLog -> PaXDiLog,
				X`ScalarD0 -> D0
			};

			FCPrint[2,"PaXEvaluate: resultX (raw): ", resultX, FCDoControl->paxVerbose];

			(* Sanity check: The output must be {int1,int2,...} *)
			If[	Head[resultX]=!=List,
				Message[PaXEvaluate::gen, "resultX is not a List."];
				Abort[]
			];

			(* Do we need to replace 1/Eps by 1/Eps - g_E + Log(4Pi) ? *)
			If [OptionValue[PaXSubstituteEpsilon],
				(*Need a check that the expansion was done correctly!!!*)
				resultX =  Expand2[resultX, PaXEpsilonBar]/.{1/PaXEpsilonBar^2 -> 1/Epsilon^2  +
					(1/Epsilon)(-EulerGamma+Log[4 Pi]) + (EulerGamma^2)/2 - (Pi^2)/12 -
					EulerGamma Log[4 Pi] + (1/2) Log[4 Pi]^2}/.{1/PaXEpsilonBar->1/Epsilon - EulerGamma + Log[4Pi]};
				If[	!FreeQ[resultX,PaXEpsilonBar],
					Message[PaXEvaluate::gen, "Failed to eliminate EpsilonBar."];
					Abort[]
				],
				resultX = resultX//.PaXEpsilonBar->Epsilon
			],
			resultX={}
		];

		FCPrint[2,"PaXEvaluate: resultX (converted): ", resultX, FCDoControl->paxVerbose];

		(* Now we create the final substitution list *)
		finalResult = fclsOutput[[1]] + fclsOutput[[3]] + fclsOutput[[4]] + ints/.FCLoopSolutionList[fclcOutput,resultX];
		FCPrint[2,"PaXEvaluate: finalResult(w/o implicit prefactor): ", finalResult, FCDoControl->paxVerbose];


		(* Protect the dimensions of vectors and Dirac matrices before the expansion. Same for conditionals. *)
		finalResult = finalResult/. {ConditionalExpression[a_,b__]:> holdcond[ToString[{a,b},InputForm]]};
		finalResult = FCReplaceD[finalResult,dim->4-2*Epsilon];

		FCPrint[3,"PaXEvaluate: finalResult(w/o implicit prefactor) with protected dimensions: ",
			finalResult, FCDoControl->paxVerbose];

		(* 	Since the implicit prefactor or other coefficients in the expression may depends fon D or Epsilon,
			we need to expand around Epsilon=0 again here.
			However, this is safe only if the final expression is free of loop integrals and EpsilonBar. *)

		If[	FreeQ2[finalResult,{FeynAmpDenominator,q,PaXEpsilonBar}] &&
			OptionValue[PaXExpandInEpsilon]  && FreeQ[finalResult,ConditionalExpression],
			finalResult = Series[(OptionValue[PaXImplicitPrefactor]/.dim->4-2Epsilon) finalResult,{Epsilon,0,0}]//Normal;
			If[	OptionValue[ChangeDimension],
				finalResult = ChangeDimension[finalResult,4]
			],
			finalResult = (OptionValue[PaXImplicitPrefactor] finalResult)
		];

		FCPrint[2,"PaXEvaluate: finalResult (with implicit prefactor): ", finalResult, FCDoControl->paxVerbose];

		(* Before returning the final result it is useful to try to simplify the Epsilon-free pieces separately *)
		If [ OptionValue[PaXSimplifyEpsilon] && FreeQ[finalResult,ConditionalExpression],
			{epsFree,epsNotFree} = FCSplit[finalResult,{Epsilon}];
			finalResult = Simplify[epsNotFree] + (Simplify[epsFree]/. {Log[x_Integer] :>
				PowerExpand[Log[x]]}/. Log[4 Pi x_] :> Log[4 Pi] + Log[x]);
		];

		finalResult = finalResult /.
		holdcond[str_String] :> holdcond[Sequence@@ToExpression[str]] /. holdcond->
		ConditionalExpression;

		If[	OptionValue[Collect] && FreeQ[finalResult,ConditionalExpression],
			finalResult = Collect2[finalResult, {Epsilon, Pair}]
		];

		If[	OptionValue[FinalSubstitutions]=!={},
			finalResult = finalResult /. OptionValue[FinalSubstitutions]
		];

		FCPrint[2,"PaXEvaluate: Last finalResult (simplified): ", finalResult, FCDoControl->paxVerbose];
		finalResult
	]

End[]
