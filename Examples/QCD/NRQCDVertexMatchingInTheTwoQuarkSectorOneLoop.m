(* ::Package:: *)

(* :Title: NRQCDVertexMatchingInTheTwoQuarkSectorOneLoop                                        *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2019 Rolf Mertig
	Copyright (C) 1997-2019 Frederik Orellana
	Copyright (C) 2014-2019 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the QCD side of the QCD/NRQCD matching in the
			   two quark sector by expanding quark-gluon vertex in the relative
			   momentum                                                     *)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*QCD side of the matching to NRQCD (quark-gluon vertex only) at  1-loop *)


(* ::Text:: *)
(*This example uses a custom QCD in background field formalism model created with FeynRules. Please evaluate the file FeynCalc/Examples/FeynRules/QCDBGF/GenerateModelQCDBGF.m before running it for the first time*)


(* ::Subsection:: *)
(*Load FeynCalc, FeynArts and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the QCD side of the QCD/NRQCD matching in the 
two quark sector by expanding quark-gluon vertex in the relative momentum"];
];
$LoadAddOns={"FeynHelpers"};
$LoadFeynArts = True;
<<FeynCalc`
$FAVerbose=0;


(* ::Subsection:: *)
(*Generate Feynman diagrams*)


topVertex = CreateTopologies[1,2 -> 1,ExcludeTopologies -> {WFCorrections}];
diagsVertex = InsertFields[topVertex, {F[3, {1}],V[50]} ->
		{F[3, {1}]}, InsertionLevel -> {Classes},		
 Model -> FileNameJoin[{"QCDBGF","QCDBGF"}],GenericModel->FileNameJoin[{"QCDBGF","QCDBGF"}]];
Paint[diagsVertex, ColumnsXRows -> {2, 1},ImageSize->{512,256}, Numbering -> None,SheetHeader->False];


(* ::Subsection:: *)
(*On-shell kinematics*)


FCClearScalarProducts[];
ScalarProduct[p1,p1]=m^2;
ScalarProduct[p2,p2]=m^2;
ScalarProduct[q,q]=q2;
ScalarProduct[p1,p2]=-1/2FCI@ SPD[q,q]+m^2;


(* ::Subsection:: *)
(*Evaluation*)


(* ::Text:: *)
(*Since we are going to evaluate both diagrams one after another, it is convenient to define helper functions that will do the job.*)


(* ::Text:: *)
(*This function obtains the amplitude for further evaluation with FeynCalc*)


ampFunc0[diag_]:=FCFAConvert[FCPrepareFAAmp[CreateFeynAmp[diag, 
Truncated -> False,PreFactor->-1]],IncomingMomenta->{p1,q},
OutgoingMomenta->{p2},LoopMomenta->{l},UndoChiralSplittings->True,
DropSumOver->True,List->False,FinalSubstitutions->{SMP["m_u"]->m,
q->p2-p1,Pair[Momentum[Polarization[___],___],___]:>1},
ChangeDimension->D,SMP->True]//Contract//SUNSimplify//
ReplaceAll[#,SUNTF[{x__},__]:>SUNT[x]]&//SUNSimplify[#,Explicit->True]&//
ReplaceAll[#,SMP["g_s"]^3->4Pi SMP["alpha_s"]SMP["g_s"]]&


(* ::Text:: *)
(*Tensor reduction and simplification of the Dirac algebra*)


ampFunc1[expr_]:=expr//TID[#,l,UsePaVeBasis->True,ToPaVe->True]&//DiracSimplify//
Collect2[#,Spinor,Factoring->Simplify]&;


(* ::Text:: *)
(*Gordon decomposition*)


ampFunc2[expr_]:=(expr/.{FCI[(FVD[p1,i_]+
FVD[p2,i_])SpinorUBarD[p2,m_].SpinorUBarD[p1,m_]]:>
FCI[SpinorUBarD[p2,m].(2m GAD[i]-I DiracSigma[GAD[i],
GSD[p2-p1]]).SpinorUD[p1,m]]})//DotSimplify//Collect2[#,LorentzIndex]&;


(* ::Text:: *)
(*Expansion in q^2 up to first order*)


ampFunc3[expr_]:=PaXEvaluateUVIRSplit[expr,PaXSeries->{{q2,0,1}},PaXAnalytic->True,
PaXImplicitPrefactor->(2Pi)^(-D)]//FCHideEpsilon//Collect2[#,LorentzIndex]&;


(* ::Text:: *)
(*Extracts F_1(q^2)*)


vectorPart[expr_,fo_:1]:=((expr//SelectFree2[#,DiracSigma]&)/
FCI[I SMP["g_s"]SUNT[Glu2]SpinorUBarD[p2,m].GAD[Lor1].SpinorUD[p1,m]])//
Collect2[#,{SMP["Delta_UV"],SMP["Delta_IR"],q2},Factoring->FullSimplify,FCFactorOut->fo]&;


(* ::Text:: *)
(*Extracts F_2(q^2)*)


scalarPart[expr_,fo_:1]:=((expr//SelectNotFree2[#,DiracSigma]&)/
FCI[-I SMP["g_s"]SUNT[Glu2](I/(2m))FCI[SpinorUBarD[p2,m]. DiracSigma[GAD[Lor1],
GSD[p1-p2]].SpinorUD[p1,m]]])//Collect2[#,{SMP["Delta_UV"],SMP["Delta_IR"],q2},
Factoring->FullSimplify,FCFactorOut->fo]&;


(* ::Subsection:: *)
(*QCD abelian vertex*)


abelianVertex=ampFunc0[DiagramExtract[diagsVertex,1]]


abelianVertex1=ampFunc1[abelianVertex]


abelianVertex2=ampFunc2[abelianVertex1]


abelianVertex3=ampFunc3[abelianVertex2]


(* ::Text:: *)
(*This is  F_1^(V)*)


resF1V=vectorPart[abelianVertex3,SMP["alpha_s"](CF-CA/2)1/Pi]


(* ::Text:: *)
(*This is  F_2^(V)*)


resF2V=scalarPart[abelianVertex3,SMP["alpha_s"](CF-CA/2)1/Pi]


(* ::Subsection:: *)
(*QCD non-abelian vertex*)


nonAbelianVertex=ampFunc0[DiagramExtract[diagsVertex,2]];


nonAbelianVertex1=ampFunc1[nonAbelianVertex];


nonAbelianVertex2=ampFunc2[nonAbelianVertex1]


nonAbelianVertex3=ampFunc3[nonAbelianVertex2];


(* ::Text:: *)
(*This is  F_1^(g)*)


resF1G=vectorPart[nonAbelianVertex3,SMP["alpha_s"]CA/(8Pi)]


(* ::Text:: *)
(*This is  F_2^(g)*)


resF2G=scalarPart[nonAbelianVertex3,SMP["alpha_s"]CA/(8Pi)]


(* ::Subsection:: *)
(*Check with the literature*)


(* ::Text:: *)
(*Here we collect the results for F_1^(V) and F_2^(V) (abelian on-shell quark-gluon vertex) as well as  F_1^(g) and F_2^(g) (non-abelian on-shell quark-gluon vertex)  from Manohar (arXiv:hep-ph/9701294). The explicit values for these form-factors are given in Eqs. 29-30 and Eqs. 33-34 of the above-mentioned preprint.*)


F1V=((SMP["alpha_s"]/Pi)(CF-1/2 CA)(1/(2EpsilonUV)+1/EpsilonIR+1-3/2Log[m/ScaleMu]+
q2/m^2(-1/(3EpsilonIR)-1/8+1/3Log[m/ScaleMu])))


F2V=(SMP["alpha_s"]/Pi)(CF-1/2 CA)(1/2+q2/(12m^2))


F1G=(SMP["alpha_s"]/(8Pi))CA(2/EpsilonUV+4/EpsilonIR+4-6Log[m/ScaleMu]+
q2/m^2(-3/EpsilonIR-1+3Log[m/ScaleMu]))


F2G=(SMP["alpha_s"]/(8Pi))CA(4/EpsilonIR+6-4Log[m/ScaleMu]+
q2/m^2(4/EpsilonIR+1-4Log[m/ScaleMu]))


diff=Map[Simplify[(PowerExpand[FCShowEpsilon[#[[1]]]/.
{ScaleMu^2->ScaleMu^2 E^EulerGamma/(4Pi),1/EpsilonIR->2/EpsilonIR,
1/EpsilonUV->2/EpsilonUV}])-#[[2]],Assumptions->{ScaleMu>0,m>0}]&,{{resF1V,F1V},
{resF2V,F2V},{resF1G,F1G},{resF2G,F2G}}]


Print["Check with Manohar, arXiv:hep-ph/9701294: ",
			If[diff==={0,0,0,0}, "CORRECT.", "!!! WRONG !!!"]];
