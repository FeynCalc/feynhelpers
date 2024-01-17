(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PackageX															*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and Package-X					*)

(* ------------------------------------------------------------------------ *)

PaXEvaluate::usage=
"PaXEvaluate[expr, q] evaluates scalar 1-loop integrals (up to 4-point
functions) in expr that depend on the loop momentum q in D dimensions.

The evaluation is using H. Patel's Package-X.";

PaXEvaluateIR::usage=
"PaXEvaluateIR[expr,q] is like PaXEvaluate but with the difference that it
returns only the IR-divergent part of the result.";

PaXEvaluateUV::usage=
"PaXEvaluateUV[expr,q] is like PaXEvaluate but with the difference that it
returns only the UV-divergent part of the result.

The evaluation is using H. Patel's Package-X.";

PaXEvaluateUVIRSplit::usage=
"PaXEvaluateUVIRSplit[expr,q] is like PaXEvaluate, but with the difference that
it explicitly distinguishes between UV- and IR-divergences.

The evaluation is using H. Patel's Package-X.";

PaXSubstituteEpsilon::usage=
"PaXSubstituteEpsilon is an option for PaXEvaluate. For brevity, Package-X
normally abbreviates 1/Epsilon - EulerGamma + Log[4Pi] with 1/Epsilon (see
DimRegEpsilon in the Documentation of Package-X).

When SubstituteEpsilon is set to True, PaXEvaluate will undo this abbreviation
to obtain the full result.";

PaXExpandInEpsilon::usage=
"PaXExpandInEpsilon is an option for PaXEvaluate. If ImplicitPrefactor is not 1
and SubstituteEpsilon is set to True, then the value of PaXExpandInEpsilon
determines whether the final result should be again expanded in Epsilon.

The expansion is done only up to $\\mathcal{O}(\\varepsilon^0)$. The default
value is True.";

PaXSimplifyEpsilon::usage=
"PaXSimplifyEpsilon is an option for PaXEvaluate. When set to True, PaXEvaluate
will attempt to simplify the final result by applying simplifications to the
Epsilon-free parts of the expression. The default value is True.";

PaXImplicitPrefactor::usage=
"PaXImplicitPrefactor is an option for PaXEvaluate. It specifies the prefactor
that does not show up explicitly in the input expression, but is understood to
appear in front of every 1-loop integral. For technical reasons,
PaXImplicitPrefactor should not depend on the number of dimensions D. Instead
you should explicitly specify what D is (e.g. 4-2 Epsilon). The default value
is 1.

If the standard prefactor $1/(2 \\pi)^D$ is implicit in your calculations, use
ImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon) .";

PaXpvA::usage=
"PaXpvA corresponds to the PVA function in Package-X.";

PaXpvB::usage=
"PaXpvB corresponds to the PVB function in Package-X.";

PaXpvC::usage=
"PaXpvC corresponds to the PVC function in Package-X";

PaXpvD::usage=
"PaXpvD corresponds to the PVD function in Package-X.";

PaXEpsilonBar::usage =
"PaXEpsilonBar corresponds to DimRegEpsilon in Package-X, i.e. 1/PaXEpsilonBar
means 1/Epsilon - EulerGamma + Log[4Pi].";

PaXDiscB::usage =
"PaXDiscB corresponds to DiscB in Package-X.";

PaXKallenLambda::usage =
"PaXKallenLambda corresponds to Kallen\[Lambda] in Package-X.";

PaXDiLog::usage =
"PaXDiLog corresponds to DiLog in Package-X.";

PaXContinuedDiLog::usage =
"PaXContinuedDiLog corresponds to ContinuedDiLog in Package-X.";

PaXKibblePhi::usage =
"PaXKibblePhi corresponds to Kibble\[Phi] in Package-X.";

PaXLn::usage =
"PaXLn corresponds to Ln in Package-X.";

PaXDiscExpand::usage =
"PaXDiscExpand is an option for PaXEvaluate. If set to True, Package-X function
DiscExpand will be applied to the output
of Package-X thus replacing DiscB by its explicit form.";

PaXKallenExpand::usage =
"PaXKallenExpand is an option for PaXEvaluate. If set to True, Package-X
function KallenExpand will be applied to the output of Package-X thus
replacing Kallen\[Lambda] by its explicit form.";

PaXKibbleExpand::usage =
"PaXKibbleExpand is an option for PaXEvaluate. If set to True, Package-X
function KibbleExpand will be applied to the output of Package-X thus
replacing Kibble\[Phi] by its explicit form.";

PaXC0Expand::usage =
"PaXC0Expand is an option for PaXEvaluate. If set to True, Package-X function
C0Expand will be applied to the output of Package-X.";

PaXD0Expand::usage =
"PaXD0Expand is an option for PaXEvaluate. If set to True, Package-X function
D0Expand will be applied to the output of Package-X.";

PaXLoopRefineOptions::usage =
"PaXLoopRefineOptions is an option for PaXEvaluate. It allows you to directly
specify the options supplied to LoopRefine, the Package-X function which
returns analytic expressions for loop integrals.

The options should be given using X  context, i.e. PaXLoopRefineOptions ->
{XExplicitC0 -> All}.";

PaXSeries::usage =
"PaXSeries is an option for PaXEvaluate. It allows to expand Passarino-Veltman
functions around given variables.

The expansion is done by LoopRefineSeries and the syntax is the same as with
the ordinary Series, e.g. PaXSeries -> {{m0,0,2}} or PaXSeries ->
{{SPD[p1,p1],pp1,0},{SPD[p2,p2],pp2,0}}.";

PaXAnalytic::usage =
"PaXAnalytic is an option for PaXEvaluate. If set to True, LoopRefine and
LoopRefineSeries will be called with Analytic->True.";

PaXEvaluate::convFail=
"Warning! Not all scalar loop integrals in the expression could be \
prepared to be processed with Package X. Following integrals will not \
be handled by Package X: `1`";

PaXEvaluate::tens=
"Warning! Your input contains tensor loop integrals. Those integrals \
will be ignored, because PaxEvaluate operates only on 1-loop scalar \
integrals with up to 4 propagators.";

PaXEvaluate::gen=
"PaXEvaluate has encountered an error and must abort the evaluation. The \
error description reads: `1`";

PaXEvaluate::C0D0=
"The explicit result for the occurring `1` function(s) is expected to be very \
complicated. Please rerun PaXEvaluate with the option `2` \
to show the result nevertheless. Please set $FCAdvice=False if you do not want \
to see this message in future.";

Begin["`Package`"]

paxLoaded::usage="";

End[]

Begin["`PackageX`Private`"]

paxVerbose::usage="";
dummyLoopMom::usage="";

paxLoaded = False;

Options[PaXEvaluate] = {
	Collecting 				-> True,
	Dimension 				-> D,
	FCE 					-> False,
	FCVerbose 				-> False,
	Factoring 				-> {Factor, 5000},
	FinalSubstitutions		-> {},
	PaVeAutoOrder			-> True,
	PaVeAutoReduce			-> True,
	PaXAnalytic				-> False,
	PaXC0Expand				-> False,
	PaXD0Expand				-> False,
	PaXDiscExpand			-> True,
	PaXExpandInEpsilon		-> True,
	PaXImplicitPrefactor	-> 1,
	PaXKallenExpand 		-> True,
	PaXKibbleExpand 		-> True,
	PaXLoopRefineOptions 	-> {},
	PaXSeries				-> False,
	PaXSimplifyEpsilon		-> {Automatic, 5000},
	PaXSubstituteEpsilon	-> True,
	TimeConstrained 		-> 3,
	ToPaVe					-> True
};

Options[PaXEvaluateUVIRSplit] = Options[PaXEvaluate];
Options[PaXEvaluateUV] = Options[PaXEvaluate];
Options[PaXEvaluateIR] = Options[PaXEvaluate];

(* Typesetting *)

PaXEpsilonBar /:
	MakeBoxes[PaXEpsilonBar, TraditionalForm] :=
		OverscriptBox["\[Epsilon]", "-"];

PaXKallenLambda /:
	MakeBoxes[PaXKallenLambda[a_,b_,c_], TraditionalForm]:=
		TBox["\[Lambda]","(",a,",",b,",",c,")"];

PaXKibblePhi /:
	MakeBoxes[PaXKibblePhi[a_,b_,c_,d_,e_,f_], TraditionalForm]:=
		TBox["\[Lambda]","(",a,",",b,",",c,",",d,";",e,",",f,")"];

PaXDiscB /:
	MakeBoxes[PaXDiscB[a_,b_,c_], TraditionalForm]:=
		TBox["\[CapitalLambda]","(",a,",",b,",",c,")"];

PaXDiLog /:
	MakeBoxes[PaXDiLog[a_, b_], TraditionalForm] :=
		RowBox[{SubscriptBox["Li", "2"], "(", TBox[a], Sequence@@If[Internal`SyntacticNegativeQ[b],{TBox[I b]},{"+",TBox[I b]}], "\[Epsilon]", ")"}];

PaXLn /:
	MakeBoxes[PaXLn[a_, b_], TraditionalForm] :=
		RowBox[{"log", "(", TBox[a], Sequence@@If[Internal`SyntacticNegativeQ[b],{TBox[I b]},{"+",TBox[I b]}], "\[Epsilon]", ")"}];

PaXContinuedDiLog /:
	MakeBoxes[PaXContinuedDiLog[{x1_, a1_}, {x2_, a2_}], TraditionalForm] :=
		RowBox[{SubscriptBox["\[ScriptCapitalL]", "2"], "(", TBox[x1], Sequence@@If[Internal`SyntacticNegativeQ[a2],{TBox[I a1]},{"+",TBox[I a1]}],
			"\[Epsilon]",",", TBox[x2], Sequence@@If[Internal`SyntacticNegativeQ[a2],{TBox[I a2]},{"+",TBox[I a2]}], "\[Epsilon]", ")"}];


PaXLn[a_, b_?NumericQ] :=
	X`Ln[a, b]/; paxLoaded;

(* Numerical evaluation *)

PaXDiLog[a_?NumericQ, b_] :=
	X`DiLog[a, b]/; paxLoaded;

PaXDiscB[a_?NumericQ, b_?NumericQ, c_?NumericQ]:=
	X`DiscB[a,b,c]/; paxLoaded;

PaXKallenLambda[a_?NumericQ, b_?NumericQ, c_?NumericQ]:=
	X`Kallen\[Lambda][a,b,c]/; paxLoaded;

PaXKibblePhi[a_?NumericQ, b_?NumericQ, c_?NumericQ, d_?NumericQ, e_?NumericQ, f_?NumericQ]:=
	X`Kibble\[Phi][a,b,c,d,e,f]/; paxLoaded;

PaXContinuedDiLog[{x1_?NumericQ, a1_?NumericQ}, {x2_?NumericQ, a2_?NumericQ}]:=
	X`ContinuedDiLog[{x1,a1},{x2,a2}]/; paxLoaded;

(* Series expansions *)

Derivative[args1__][PaXLn][args2__]:=
	(Derivative[args1][X`Ln][args2] /. {X`Ln->PaXLn,X`DiLog->PaXDiLog,X`ContinuedDiLog->PaXContinuedDiLog})/; paxLoaded;

Derivative[args1__][PaXDiLog][args2__]:=
	(Derivative[args1][X`DiLog][args2]/.{X`Ln->PaXLn,X`DiLog->PaXDiLog,X`ContinuedDiLog->PaXContinuedDiLog})/; paxLoaded;

Derivative[args1__][PaXContinuedDiLog][args2__]:=
	(Derivative[args1][X`ContinuedDiLog][args2]/.{X`Ln->PaXLn,X`DiLog->PaXDiLog,X`ContinuedDiLog->PaXContinuedDiLog})/; paxLoaded;

(* FeynCalc->Package-X conversion of scalar products *)
momConv[x_] :=
	FCE[ExpandScalarProduct[MomentumCombine[x]]];

toPackageX[pref_, q_]:=
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
toPackageX[pref_. PaVe[0, {}, {m_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`Eps)) pref X`PVA[0, PowerExpand[Sqrt[m]]]/;
	FreeQ[pref,q] && FreeQ[m, Complex];

toPackageX[pref_. PaVe[inds__, {}, {m_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`Eps)) pref X`PVA[Count[{inds},0]/2, PowerExpand[Sqrt[m]]]/;
	FreeQ[pref,q] && FreeQ[m, Complex] && EvenQ[Count[{inds},0]] && {inds}=!={0};

(* 2-point functions *)
toPackageX[pref_. PaVe[0, {mom1_}, {m1_, m2_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`Eps)) pref X`PVB[0, 0, momConv[mom1], PowerExpand[Sqrt[m1]],
	PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex];

toPackageX[pref_. PaVe[inds__, {mom1_}, {m1_, m2_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`Eps)) pref X`PVB[Count[{inds},0]/2, Count[{inds},1], momConv[mom1], PowerExpand[Sqrt[m1]],
	PowerExpand[Sqrt[m2]]]/;FreeQ[pref,q] && FreeQ[{m1,m2}, Complex] &&
	(EvenQ[Count[{inds}, 0]] || Count[{inds}, 0] === 0) && {inds}=!={0};

(* 3-point functions *)
toPackageX[pref_. PaVe[0,  {mom1_, mom1min2_, mom2_}, {m1_, m2_, m3_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`Eps)) pref X`PVC[0, 0, 0, momConv[mom1], momConv[mom1min2], momConv[mom2],
	PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m3]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3}, Complex];

toPackageX[pref_. PaVe[inds__,  {mom1_, mom1min2_, mom2_}, {m1_, m2_, m3_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`Eps)) pref X`PVC[Count[{inds},0]/2, Count[{inds},1], Count[{inds},2], momConv[mom1], momConv[mom1min2], momConv[mom2],
	PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m3]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3}, Complex] && (EvenQ[Count[{inds}, 0]] || Count[{inds}, 0] === 0);

(* 4-point functions *)
toPackageX[pref_. PaVe[0,  {mom1_, mom1min2_, mom2min3_, mom3_, mom2_, mom1min3_}, {m1_, m2_, m3_, m4_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`Eps)) pref X`PVD[0, 0, 0, 0,
		momConv[mom1], momConv[mom1min2], momConv[mom2min3], momConv[mom3], momConv[mom2], momConv[mom1min3],
	PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m3]], PowerExpand[Sqrt[m4]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3,m4}, Complex];

toPackageX[pref_. PaVe[inds__,  {mom1_, mom1min2_, mom2min3_, mom3_, mom2_, mom1min3_}, {m1_, m2_, m3_, m4_}, OptionsPattern[]], q_]:=
	(2 Pi)^(-2*(X`Eps)) pref X`PVD[Count[{inds},0]/2, Count[{inds},1], Count[{inds},2], Count[{inds},3],
		momConv[mom1], momConv[mom1min2], momConv[mom2min3], momConv[mom3], momConv[mom2], momConv[mom1min3],
	PowerExpand[Sqrt[m1]], PowerExpand[Sqrt[m2]], PowerExpand[Sqrt[m3]], PowerExpand[Sqrt[m4]]]/;
	FreeQ[pref,q] && FreeQ[{m1,m2,m3,m4}, Complex] && (EvenQ[Count[{inds}, 0]] || Count[{inds}, 0] === 0);


PaXEvaluateUVIRSplit[expr_, opts:OptionsPattern[]]:=
	PaXEvaluateUVIRSplit[expr, dummyLoopMom, opts];

PaXEvaluateUVIRSplit[expr_, q:Except[_?OptionQ], opts:OptionsPattern[]]:=
	Block[{resFull,resUV,resIRAndFinite,resFinal},
		resUV = PaXEvaluateUV[expr, q, opts]/. EpsilonUV->Epsilon;
		resFull = PaXEvaluate[expr, q, opts];
		(*TODO Checks!!!*)
		If[	FreeQ[resUV,ConditionalExpression] && FreeQ[resFull,ConditionalExpression],
			resIRAndFinite = Collect2[resFull-resUV,{Epsilon}, Factoring->OptionValue[Factoring],TimeConstrained->OptionValue[TimeConstrained]]/. Epsilon->EpsilonIR,
			resIRAndFinite = (resFull-resUV) /. Epsilon->EpsilonIR
		];
		resUV = resUV/. Epsilon -> EpsilonUV;
		resFinal = resUV + resIRAndFinite;
		If[ Factor[(Normal[resFinal]/.(EpsilonUV|EpsilonIR)->Epsilon)-Normal[resFull]]=!=0,
			Message[PaXEvaluate::gen, "Splitting into UV and IR pieces failed."];
			Abort[]
		];
		resFinal
	];

PaXEvaluateIR[expr_, opts:OptionsPattern[]]:=
	PaXEvaluateIR[expr, dummyLoopMom, opts];

PaXEvaluateIR[expr_, q:Except[_?OptionQ], opts:OptionsPattern[]]:=
	Block[{loopRefineOpts, newOpts, res},
		loopRefineOpts = OptionValue[PaXEvaluate,{opts},PaXLoopRefineOptions];
		loopRefineOpts = Join[{Part->X`IRDivergent},loopRefineOpts];
		newOpts = Flatten[Join[{PaXLoopRefineOptions->loopRefineOpts},
			FilterRules[{opts}, Except[PaXLoopRefineOptions]]]];
		res = PaXEvaluate[expr, q, newOpts];
		(* If we care only for the pole, the finite part is not needed *)
		res = FCSplit[res,{Epsilon}][[2]] /. Epsilon -> EpsilonIR;
		res
	];

PaXEvaluateUV[expr_, opts:OptionsPattern[]]:=
	PaXEvaluateUV[expr, dummyLoopMom, opts];

PaXEvaluateUV[expr_, q:Except[_?OptionQ], opts:OptionsPattern[]]:=
	Block[{loopRefineOpts, newOpts, res},
		loopRefineOpts = OptionValue[PaXEvaluate,{opts},PaXLoopRefineOptions];
		loopRefineOpts = Join[{Part->X`UVDivergent},loopRefineOpts];
		newOpts = Flatten[Join[{PaXLoopRefineOptions->loopRefineOpts},
			FilterRules[{opts}, Except[PaXLoopRefineOptions]]]];
		res = PaXEvaluate[expr, q, newOpts];
		(* If we care only for the pole, the finite part is not needed *)

		res = FCSplit[res,{Epsilon}][[2]] /. Epsilon -> EpsilonUV;

		res
	];


PaXEvaluate[expr_, opts:OptionsPattern[]]:=
	PaXEvaluate[expr, dummyLoopMom, opts];

PaXEvaluate[expr_,q:Except[_?OptionQ], OptionsPattern[]]:=
	Block[{	ex, resultX, finalResult, xList, ints, fclsOutput, fclcOutput,
			dim, epsFree, epsNotFree, paxVer, paxOptions={}, paxSeries, paxSeriesVars={}, time, tmp, check,
			rootsum, optPaXSimplifyEpsilon, seriesProtectList, seriesProtectRule, seriesVarProtectRule, varHold},

		dim = OptionValue[Dimension];
		paxSeries = OptionValue[PaXSeries];
		paxOptions = Join[OptionValue[PaXLoopRefineOptions],paxOptions] ;

		optPaXSimplifyEpsilon = Switch[
			OptionValue[PaXSimplifyEpsilon],
				{Automatic, _Integer},
					{True, OptionValue[PaXSimplifyEpsilon][[2]]},
				True,
					{True, Infinity},
				False,
					{False, 0},
				_,
				Message[PaXEvaluate::gen, "Unknown value for the option PaXSimplifyEpsilon."];
				Abort[]
		];


		If[ OptionValue[PaXAnalytic],
			paxOptions = Join[paxOptions, {Analytic->True}]
		];

		(* Variables, in which PaVe functions will be expanded *)
		If[ MatchQ[paxSeries, {{_, _, _Integer} ..}],
			paxSeriesVars = Cases[paxSeries, {x_, _, _Integer} :> x]
		];

		If [OptionValue[FCVerbose]===False,
			paxVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				paxVerbose=OptionValue[FCVerbose]
			];
		];

		(* Check if package X has already been loaded*)
		If [ paxLoaded=!=True,

			FCPrint[1,"PaXEvaluate: Loading Package-X.", FCDoControl->paxVerbose];
			Begin["Global`"];
			(* 	The following code for loading the OneLoop part of Package-X was kindly
				provided by Hiren Patel, the developer of Package-X *)
			Block[{$ContextPath},
				BeginPackage["X`"];
				(*Loads all definitions in Package-X OneLoop.m.	*)
				Get[FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "OneLoopFromPackageX", "OneLoop.m"}]];
				EndPackage[];
			];
			End[];
			FCPrint[1,"PaXEvaluate: Package-X loaded", FCDoControl->paxVerbose];
			paxLoaded=True;
		];


		FCPrint[1,"PaXEvaluate: Entering.", FCDoControl->paxVerbose];
		FCPrint[3,"PaXEvaluate: Entering with: ", expr, FCDoControl->paxVerbose];

		If [ !FreeQ[OptionValue[PaXImplicitPrefactor],PaXEpsilonBar],
			Message[PaXEvaluate::gen, "ImplicitPrefactor is not allowed to depend on EpsilonBar."];
			Abort[]
		];

		(*	First of all, let us convert all the scalar integrals to PaVe functions:	*)
		FCPrint[1,"PaXEvaluate: Applying ToPaVe/ToPaVe2.", FCDoControl->paxVerbose];
		If[OptionValue[ToPaVe] && !FreeQ[expr,q],
			ex = expr//ToPaVe[#,q,PaVeAutoReduce->False,
						PaVeAutoOrder -> OptionValue[PaVeAutoOrder]]&//ToPaVe2,
			ex = ToPaVe2[expr,PaVeAutoOrder -> OptionValue[PaVeAutoOrder]]
		];


		(*	Since we care only for the scalar integrals, we need
			only the second element from the list returned by FCLoopSplit.
			Notice that we also single out variables in which PaVe functions
			should be expanded. This is necessary, since otherwise things
			like 1/p.p B0[p.p,m^2,m^2] will be expanded in a wrong way *)

		FCPrint[1,"PaXEvaluate: Applying FCLoopSplit.", FCDoControl->paxVerbose];
		fclsOutput  = FCLoopSplit[ex,Join[{q}],PaVeIntegralHeads->Join[FeynCalc`Package`PaVeHeadsList, {X`PVA, X`PVB, X`PVC, X`PVD}]];
		If [fclsOutput[[3]]=!=0 || fclsOutput[[4]]=!=0,
			Message[PaXEvaluate::tens]
		];
		FCPrint[3,"PaXEvaluate: After FCLoopSplit: ",fclsOutput, FCDoControl->paxVerbose];


		(*	FCLoopCanonicalize is of course an overkill for purely scalar integrals,
			but it is better to use it than to implement own functions every time...	*)

		tmp = fclsOutput[[2]];

		If[	paxSeriesVars=!={} && !FreeQ2[tmp,{Spinor,Polarization}],

			seriesProtectList = Cases2[tmp,Spinor,Polarization];

			seriesVarProtectRule =
				Thread[Rule[paxSeriesVars,Table[varHold[Unique["sVar"]], {i, 1, Length[paxSeriesVars]}]]];

			seriesProtectRule = Thread[Rule[seriesProtectList,(seriesProtectList//.seriesVarProtectRule)]];

			FCPrint[1,"PaXEvaluate: Rule for protecting expansion variables in nonexpandable objects: ",
					seriesVarProtectRule, FCDoControl->paxVerbose];

			tmp = tmp /. Dispatch[seriesProtectRule],

			seriesVarProtectRule = {}
		];


		FCPrint[1,"PaXEvaluate: Applying FCLoopIsolate.", FCDoControl->paxVerbose];

		check=FCLoopIsolate[FCReplaceD[tmp, dim->4-2*Epsilon], {q}, FCI->True, Head->loopIntegral,
			PaVeIntegralHeads->Join[FeynCalc`Package`PaVeHeadsList, {X`PVA, X`PVB, X`PVC, X`PVD, Epsilon},paxSeriesVars]];
		FCPrint[3,"PaXEvaluate: After FCLoopIsolate: ",check, FCDoControl->paxVerbose];


		Quiet[check = Cases2[check, loopIntegral] /. Epsilon -> 0, Power::infy];
		If[!FreeQ[check,ComplexInfinity],
			Message[PaXEvaluate::gen, "PaXEvaluate cannot handle PaVe functions multiplied by 1/Epsilon poles."];
			Abort[]
		];


		FCPrint[1,"PaXEvaluate: Applying FCLoopIsolate.", FCDoControl->paxVerbose];
		ints=FCLoopIsolate[tmp, {q}, FCI->True, Head->loopIntegral,
			PaVeIntegralHeads->Join[FeynCalc`Package`PaVeHeadsList, {X`PVA, X`PVB, X`PVC, X`PVD},paxSeriesVars]];
		FCPrint[3,"PaXEvaluate: After FCLoopIsolate: ",ints, FCDoControl->paxVerbose];

		(*	The 4th element in fclcOutput is our list of unique scalar integrals that
			need to be computed. But first we need to convert them to the Pacakge X input *)
		fclcOutput = FCLoopCanonicalize[ints, q, loopIntegral,FCI->True,
			PaVeIntegralHeads->Join[FeynCalc`Package`PaVeHeadsList, {X`PVA, X`PVB, X`PVC, X`PVD}]];

		If[	!FreeQ2[fclcOutput,{Spinor,Polarization}],
			Message[PaXEvaluate::gen, "PaXEvaluate may not pass spinors or polarization vectors to Package-X."];
			Abort[]
		];

		FCPrint[1,"PaXEvaluate: Converting to the Package-X notation.", FCDoControl->paxVerbose];
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
			FCPrint[1,"PaXEvaluate: Evaluating the Passarino-Veltman function via Package-X.", FCDoControl->paxVerbose];
			time=AbsoluteTime[];

			xList = FCE[xList]/. { dim->4-2*(X`Eps), Epsilon->(X`Eps) };

			If[ Head[paxSeries]===List,
				FCPrint[1,"PaXEvaluate: Applying LoopRefineSeries.", FCDoControl->paxVerbose];
				xList = Normal[X`LoopRefineSeries[xList, Sequence@@paxSeries, Sequence@@paxOptions]];
				FCPrint[3,"PaXEvaluate: xList (after LoopRefineSeries): ", xList, FCDoControl->paxVerbose]
			];

			resultX = X`LoopRefine[xList, Sequence@@paxOptions]//FCI;

			FCPrint[1, "PaXEvaluate: Evaluation finished, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];


			FCPrint[2,"PaXEvaluate: resultX (preliminary): ", resultX, FCDoControl->paxVerbose];

			If[	OptionValue[PaXC0Expand],
				time=AbsoluteTime[];
				FCPrint[1, "PaXEvaluate: Applying C0Expand.", FCDoControl->paxVerbose];
				resultX = X`C0Expand[resultX];
				FCPrint[1, "PaXEvaluate: Done applying C0Expand, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
				FCPrint[3,"PaXEvaluate: resultX after C0Expand: ", resultX, FCDoControl->paxVerbose]
			];

			If[	OptionValue[PaXD0Expand],
				time=AbsoluteTime[];
				FCPrint[1, "PaXEvaluate: Applying D0Expand.", FCDoControl->paxVerbose];
				resultX = X`D0Expand[resultX];
				FCPrint[1, "PaXEvaluate: Done applying D0Expand, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
				FCPrint[3,"PaXEvaluate: resultX after D0Expand: ", resultX, FCDoControl->paxVerbose]
			];

			If[	OptionValue[PaXDiscExpand],
				time=AbsoluteTime[];
				FCPrint[1, "PaXEvaluate: Applying DiscExpand.", FCDoControl->paxVerbose];
				resultX = X`DiscExpand[resultX];
				FCPrint[1, "PaXEvaluate: Done applying DiscExpand, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
				FCPrint[3,"PaXEvaluate: resultX after DiscExpand: ", resultX, FCDoControl->paxVerbose]
			];

			If[	OptionValue[PaXKallenExpand],
				time=AbsoluteTime[];
				FCPrint[1, "PaXEvaluate: Applying KallenExpand.", FCDoControl->paxVerbose];
				resultX = X`KallenExpand[resultX];
				FCPrint[1, "PaXEvaluate: Done applying KallenExpand, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
				FCPrint[3,"PaXEvaluate: resultX after KallenExpand: ", resultX, FCDoControl->paxVerbose]
			];

			If[	OptionValue[PaXKibbleExpand],
				time=AbsoluteTime[];
				FCPrint[1, "PaXEvaluate: Applying KibbleExpand.", FCDoControl->paxVerbose];
				resultX = X`KibbleExpand[resultX];
				FCPrint[1, "PaXEvaluate: Done applying KibbleExpand, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
				FCPrint[3,"PaXEvaluate: resultX after KibbleExpand: ", resultX, FCDoControl->paxVerbose]
			];

			(* We need to convert Package X output into FeynCalc input *)

			If[	!FreeQ2[resultX,{X`ScalarC0,X`ScalarC0IR6}] && $FCAdvice,
				Message[PaXEvaluate::C0D0,"C0","PaXC0Expand->True"]
			];

			If[	!FreeQ2[resultX,{X`ScalarD0,X`ScalarD0IR12,X`ScalarD0IR13,X`ScalarD0IR16}] && $FCAdvice,
				Message[PaXEvaluate::C0D0,"D0","PaXD0Expand->True"]
			];

			resultX = resultX /. {
				X`Eps -> PaXEpsilonBar,
				X`Mu -> ScaleMu,
				X`DiscB -> PaXDiscB,
				X`Kallen\[Lambda] -> PaXKallenLambda,
				X`Kibble\[Phi] -> PaXKibblePhi,
				X`ContinuedDiLog -> PaXContinuedDiLog,
				X`DiLog -> PaXDiLog,
				X`Ln -> PaXLn,
				(* Notice the differnence between mass conventions
					in FeynCalc and Package-X	*)
				X`ScalarC0[s1_,s12_,s2_,m0_,m1_,m2_] :>
					PaVe[0,{s1,s12,s2},{m0^2,m1^2,m2^2},
					PaVeAutoReduce -> OptionValue[PaVeAutoReduce],
					PaVeAutoOrder -> OptionValue[PaVeAutoOrder]],
				X`ScalarD0[s1_,s2_,s3_,s4_,s12_,s23_,m0_,m1_,m2_,m3_] :>
					PaVe[0,{s1,s2,s3,s4,s12,s23},{m0^2,m1^2,m2^2,m3^2},
					PaVeAutoReduce -> OptionValue[PaVeAutoReduce],
					PaVeAutoOrder -> OptionValue[PaVeAutoOrder]]
			};

			FCPrint[2,"PaXEvaluate: resultX (raw): ", resultX, FCDoControl->paxVerbose];

			(* Sanity check: The output must be {int1,int2,...} *)
			If[	Head[resultX]=!=List,
				Message[PaXEvaluate::gen, "resultX is not a List."];
				Abort[]
			];

			(* Do we need to replace 1/Eps by 1/Eps - g_E + Log(4Pi) ? *)
			If [OptionValue[PaXSubstituteEpsilon],

				time=AbsoluteTime[];
				FCPrint[1, "PaXEvaluate: Substituting 1/Eps - EulerGamma + Log[4Pi].", FCDoControl->paxVerbose];
				(*Need a check that the expansion was done correctly!!!*)

				If[!FreeQ[resultX,RootSum],
					resultX  = resultX /. RootSum->rootsum
				];

				resultX =  Expand2[resultX, PaXEpsilonBar]/.{1/PaXEpsilonBar^2 -> 1/Epsilon^2  +
					(1/Epsilon)(-EulerGamma+Log[4 Pi]) + (EulerGamma^2)/2 -
					EulerGamma Log[4 Pi] + (1/2) Log[4 Pi]^2}/.{1/PaXEpsilonBar->1/Epsilon - EulerGamma + Log[4Pi]};

				If[!FreeQ[resultX,rootsum],
					resultX  = resultX /. rootsum->RootSum
				];

				If[	!FreeQ[resultX,PaXEpsilonBar],
					Message[PaXEvaluate::gen, "Failed to eliminate EpsilonBar."];
					Abort[]
				];
				FCPrint[1, "PaXEvaluate: Done substituting Substituting 1/Eps - EulerGamma + Log[4Pi], timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose]

			],
			resultX={}
		];

		FCPrint[2,"PaXEvaluate: resultX (converted): ", resultX, FCDoControl->paxVerbose];

		(* Series expansion for the piece free of loop integrals*)
		If[ Head[paxSeries]===List,
			time=AbsoluteTime[];
			FCPrint[1, "PaXEvaluate: Performing series expansion w.r.t ",paxSeries, FCDoControl->paxVerbose];
			fclsOutput[[1]]= Series[fclsOutput[[1]],Sequence@@paxSeries]//Normal;
			FCPrint[1, "PaXEvaluate: Done performing series expansion, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
			FCPrint[2,"PaXEvaluate:  After series expansion of the loop-free part: ", fclsOutput[[1]], FCDoControl->paxVerbose]
		];


		(* Now we create the final substitution list *)
		time=AbsoluteTime[];
		FCPrint[1, "PaXEvaluate: Creating the final substition list", FCDoControl->paxVerbose];
		finalResult = fclsOutput[[1]] + fclsOutput[[3]] + fclsOutput[[4]] + ints/.FCLoopSolutionList[fclcOutput,resultX];
		FCPrint[1, "PaXEvaluate: Done creating the final substitution list, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
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

			time=AbsoluteTime[];
			FCPrint[1, "PaXEvaluate: Expanding around Epsilon=0", FCDoControl->paxVerbose];
			finalResult = Series[(OptionValue[PaXImplicitPrefactor]/.dim->4-2Epsilon) finalResult,{Epsilon,0,0}]//Normal,
			finalResult = (OptionValue[PaXImplicitPrefactor] finalResult);
			FCPrint[1, "PaXEvaluate: Done expanding around Epsilon=0, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
		];

		finalResult = finalResult//ReplaceAll[#,Reverse/@seriesVarProtectRule]&;
		If[	!FreeQ[finalResult,varHold],
			Message[PaXEvaluate::gen, "Failed to perform a backsubstitution for variables in spinors and polarization vectors."];
			Abort[]
		];

		FCPrint[2,"PaXEvaluate: finalResult (with implicit prefactor): ", finalResult, FCDoControl->paxVerbose];

		(* Before returning the final result it is useful to try to simplify the Epsilon-free pieces separately *)
		If [ optPaXSimplifyEpsilon[[1]] && LeafCount[finalResult]<optPaXSimplifyEpsilon[[2]] && FreeQ[finalResult,ConditionalExpression],

			time=AbsoluteTime[];
			FCPrint[1, "PaXEvaluate: Simplifying the result", FCDoControl->paxVerbose];
			{epsFree,epsNotFree} = FCSplit[finalResult,{Epsilon}];
			finalResult = Simplify[epsNotFree] + (Simplify[epsFree] /. Log[4 Pi x_] :> Log[4 Pi] + Log[x]);
			FCPrint[1, "PaXEvaluate: Done simplifying the result, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose];
		];


		finalResult = finalResult /.
		holdcond[str_String] :> holdcond[Sequence@@ToExpression[str]] /. holdcond->
		ConditionalExpression;

		If[	OptionValue[Collecting] && FreeQ[finalResult,ConditionalExpression],
			time=AbsoluteTime[];
			FCPrint[1, "PaXEvaluate: Applying Collect2", FCDoControl->paxVerbose];
			finalResult = Collect2[finalResult, {Epsilon, Pair}, Factoring->OptionValue[Factoring],TimeConstrained->OptionValue[TimeConstrained]];
			FCPrint[1, "PaXEvaluate: Done applying Collect2, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->paxVerbose]
		];

		If[	OptionValue[FinalSubstitutions]=!={},
			finalResult = finalResult /. OptionValue[FinalSubstitutions]
		];

		If[	OptionValue[FCE],
			finalResult = FCE[finalResult]
		];

		FCPrint[2,"PaXEvaluate: Last finalResult (simplified): ", finalResult, FCDoControl->paxVerbose];
		finalResult
	]

End[]
