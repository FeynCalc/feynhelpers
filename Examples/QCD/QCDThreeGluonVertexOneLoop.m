(* ::Package:: *)

(* :Title: QCDThreeGluonVertexOneLoop                                        *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2023 Rolf Mertig
	Copyright (C) 1997-2023 Frederik Orellana
	Copyright (C) 2014-2023 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the singularities in the QCD 3-gluon vertex 
              at 1-loop                                                     *)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*QCD 3-gluon vertex 1-loop *)


(* ::Subsection:: *)
(*Load FeynCalc, FeynArts and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the singularities in QCD triangle diagrams"];
];
$LoadAddOns={"FeynArts","FeynHelpers"};
<<FeynCalc`
$FAVerbose=0;


(* ::Subsection:: *)
(*Useful definitions*)


(* ::Text:: *)
(*For comparing to the literature, let us define the Lorentz  structure of the 3-gluon vertex here*)


VertexLorentzStruct[{p_,q_,k_},{mu_,nu_,si_},{a_,b_,c_}]:=
-I SUNF[a,b,c](MTD[mu,nu]FVD[p-q,si]+MTD[nu,si]FVD[q-k,mu]+MTD[si,mu]FVD[k-p,nu])


(* ::Subsection::Closed:: *)
(*Ghost triangle*)


diagsGhostTriangle = InsertFields[CreateTopologies[1,1->2,
ExcludeTopologies->{WFCorrections,SelfEnergies,Tadpoles}],
{V[5]}->{V[5],V[5]},Model->"SMQCD",InsertionLevel -> {Particles},
ExcludeParticles->{F[__],S[_],V[_],U[1|2|3|4]}];
Paint[diagsGhostTriangle, ColumnsXRows -> {2, 1}, SheetHeader->None, 
Numbering -> None,ImageSize->{512,256}];


ampsGhost1=FCFAConvert[CreateFeynAmp[diagsGhostTriangle, Truncated -> True,
GaugeRules->{},PreFactor->1],IncomingMomenta->{p1}, OutgoingMomenta->{p2,p3},
LoopMomenta->{q},DropSumOver->True,UndoChiralSplittings->True,ChangeDimension->D,
List->False,SMP->True,LorentzIndexNames->{la,mu,nu}, SUNIndexNames->{a,b,c}]//
SUNSimplify//Contract


(* ::Text:: *)
(*Since we are computing a vertex function, the momenta  should be all incoming*)


ampsGhost2=ampsGhost1/.p2->-p2/.p3->-p3;


(* ::Text:: *)
(*As we keep the kinematics completely general, it is better to decompose tensor integrals into coefficient functions. Using scalar integrals*)
(*would give us huge expressions that we don't really need here.*)


ampsGhost3=TID[ampsGhost2,q,UsePaVeBasis->True]


(* ::Text:: *)
(*There are no IR singularities*)


PaXEvaluateIR[ampsGhost3,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*What we are interested in, is the UV singularity*)


ampsGhostUVPart1=PaXEvaluateUV[ampsGhost3,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*In the calculation p1 was eliminated via momentum conservation p1+p2+p3=0. Now we need to reintroduce it*)


ampsGhostUVPartFinal=ampsGhostUVPart1//FCE//Collect2[#,MTD]&//ReplaceAll[#,{FVD[p2,i_]+2FVD[p3,i_]:>FVD[p3,i]-FVD[p1,i],
FVD[p3,i_]+2FVD[p2,i_]:>FVD[p2,i]-FVD[p1,i]}]&//MomentumCombine//Simplify


(* ::Text:: *)
(*Let us compare this to the results given in Eq III .46 of Pascual and Tarrach, QCD: Renormalization for the Practitioner, Springer, 1984*)


ampsGhostUVPartPT=(I SMP["g_s"]) SMP["g_s"]^2/(4Pi)^2  CA/8 1/(3EpsilonUV) VertexLorentzStruct[{p1,p2,p3},{la,mu,nu},{a,b,c}]//Simplify;
Print["Check with Pascual and Tarrach, Eq III.46: ",
			If[Simplify[ExpandScalarProduct[ampsGhostUVPartFinal-ampsGhostUVPartPT]]===0, "CORRECT.", "!!! WRONG !!!"]];


(* ::Subsection::Closed:: *)
(*Gluonic triangle*)


diagsGluonTriangle = InsertFields[CreateTopologies[1,1->2,
ExcludeTopologies->{WFCorrections,SelfEnergies,Tadpoles}],
{V[5]}->{V[5],V[5]},Model->"SMQCD",InsertionLevel -> {Particles},
ExcludeParticles->{F[__],S[_],U[_]}];
Paint[DiagramExtract[diagsGluonTriangle,1], ColumnsXRows -> {2, 1}, SheetHeader->None, 
Numbering -> None,ImageSize->{512,256}];


(* ::Text:: *)
(*If we keep the full gauge dependence and the generic kinematics, the calculation will take a lot of  time. So we will do two calculations: one with generic kinematics but in Feynman*)
(*gauge and the other with a simple kinematics but full gauge dependence.*)


ampsGluonTriangle=FCFAConvert[CreateFeynAmp[DiagramExtract[diagsGluonTriangle,1], Truncated -> True,
GaugeRules->{},PreFactor->1],IncomingMomenta->{p1}, OutgoingMomenta->{p2,p3},
LoopMomenta->{q},DropSumOver->True,UndoChiralSplittings->True,ChangeDimension->D,
List->False,SMP->True,LorentzIndexNames->{la,mu,nu}, SUNIndexNames->{a,b,c}]//
Expand2[#,SUNF]&//SUNSimplify//Contract


(* ::Text:: *)
(*Since we are computing a vertex function, the momenta  should be all incoming*)


ampsGluonTriangle2=ampsGluonTriangle/.p2->-p2/.p3->-p3/.p1->-p2-p3;


(* ::Subsubsection:: *)
(*Feynman gauge, generic kinematics*)


ampsGluonTriangleFeynmanGauge1=ampsGluonTriangle2/.GaugeXi[g]->1;


(* ::Text:: *)
(*As we keep the kinematics completely general, it is better to decompose tensor integrals into coefficient functions. Using scalar integrals*)
(*would give us huge expressions that we don't really need here.*)


ampsGluonTriangleFeynmanGauge2=TID[ampsGluonTriangleFeynmanGauge1,q,UsePaVeBasis->True,ToPaVe->True]


(* ::Text:: *)
(*There are no IR singularities*)


PaXEvaluateIR[ampsGluonTriangleFeynmanGauge2,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*What we are interested in, is the UV singularity*)


ampsGluonTriangleFeynmanGaugeUVPart1=PaXEvaluateUV[ampsGluonTriangleFeynmanGauge2,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*In the calculation p1 was eliminated via momentum conservation p1+p2+p3=0. Now we need to reintroduce it*)


ampsGluonTriangleFeynmanGaugeUVPartFinal=ampsGluonTriangleFeynmanGaugeUVPart1//FCE//Collect2[#,MTD]&//ReplaceAll[#,{FVD[p2,i_]+
2FVD[p3,i_]:>FVD[p3,i]-FVD[p1,i],FVD[p3,i_]+2FVD[p2,i_]:>FVD[p2,i]-FVD[p1,i]}]&//MomentumCombine//Simplify


(* ::Text:: *)
(*Let us compare this to the results given in Eq III .46 of Pascual and Tarrach, QCD: Renormalization for the Practitioner, Springer, 1984*)


ampsGluonTriangleUVPartPT=(I SMP["g_s"]) SMP["g_s"]^2/(4Pi)^2  CA/8 (-4/EpsilonUV-9 GaugeXi[g]/EpsilonUV) * 
VertexLorentzStruct[{p1,p2,p3},{la,mu,nu},{a,b,c}]//Simplify;
Print["Check with Pascual and Tarrach, Eq III.46: ",
			If[Simplify[ExpandScalarProduct[ampsGluonTriangleFeynmanGaugeUVPartFinal-(ampsGluonTriangleUVPartPT/.GaugeXi[g]->1)]]===0, 
			"CORRECT.", "!!! WRONG !!!"]];


(* ::Subsubsection:: *)
(*R_xi gauge, specific kinematics (p2 = -p3 =p, p1 = 0)*)


ampsGluonTriangleRXiGauge1=ampsGluonTriangle2/.p3->-p2/.p2->p;


(* ::Text:: *)
(*Here we need to use a different strategy. The gauge part of the gluon propagators leads to loop integrals with denominators raised to integer powers. Those can be significantly simplified by using IBP relations, so it makes no sense to immediately switch to coefficient functions. Of course, this result is quite compact as we have chosen a simple kinematics. For generic*)
(*kinematics we would a huge amount of terms that are hardly manageable with Mathematica.*)


ampsGluonTriangleRXiGauge2=TID[ampsGluonTriangleRXiGauge1,q]


(* ::Text:: *)
(*After IBP reduction the amplitude becomes much simpler*)


ampsGluonTriangleRXiGauge3=FIREBurn[ampsGluonTriangleRXiGauge2,{q},{p}]


(* ::Text:: *)
(*There are no IR singularities.*)


PaXEvaluateIR[ampsGluonTriangleRXiGauge3,q,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*What we are interested in, is the UV singularity*)


ampsGluonTriangleRXiGaugeUVPartFinal=PaXEvaluateUV[ampsGluonTriangleRXiGauge3,q,PaXImplicitPrefactor->1/(2Pi)^D]//Simplify


(* ::Text:: *)
(*Let us compare this to the results given in Eq III .46 of Pascual and Tarrach, QCD: Renormalization for the Practitioner, Springer, 1984*)


ampsGluonTriangleUVPartPT=(I SMP["g_s"]) SMP["g_s"]^2/(4Pi)^2  CA/8 (-4/EpsilonUV-9 GaugeXi[g]/EpsilonUV) * 
VertexLorentzStruct[{p1,p2,p3},{la,mu,nu},{a,b,c}]//Simplify;
Print["Check with Pascual and Tarrach, Eq III.46: ",
			If[Simplify[ExpandScalarProduct[ampsGluonTriangleRXiGaugeUVPartFinal-(ampsGluonTriangleUVPartPT/.p3->-p2/.p2->p/.p1->0)]]===0, 
			"CORRECT.", "!!! WRONG !!!"]];


(* ::Subsection::Closed:: *)
(*Gluonic bubbles*)


diagsGluonBubbles = InsertFields[CreateTopologies[1,1->2,
ExcludeTopologies->{WFCorrections,SelfEnergies,Tadpoles}],
{V[5]}->{V[5],V[5]},Model->"SMQCD",InsertionLevel -> {Particles},
ExcludeParticles->{F[__],S[_],U[_]}];
Paint[DiagramExtract[diagsGluonBubbles,2,3,4], ColumnsXRows -> {3, 1}, SheetHeader->None, 
Numbering -> None,ImageSize->{768,256}];


(* ::Text:: *)
(*If we keep the full gauge dependence and the generic kinematics, the calculation will take a lot of  time. So we will do two calculations: one with generic kinematics but in Feynman*)
(*gauge and the other with a simple kinematics but full gauge dependence.*)


ampsGluonBubbles=FCFAConvert[CreateFeynAmp[DiagramExtract[diagsGluonBubbles,2,3,4], Truncated -> True,
GaugeRules->{},PreFactor->1],IncomingMomenta->{p1}, OutgoingMomenta->{p2,p3},
LoopMomenta->{q},DropSumOver->True,UndoChiralSplittings->True,ChangeDimension->D,
List->False,SMP->True,LorentzIndexNames->{la,mu,nu}, SUNIndexNames->{a,b,c}]//
Expand2[#,SUNF]&//SUNSimplify//Contract;


(* ::Text:: *)
(*Since we are computing a vertex function, the momenta  should be all incoming*)


ampsGluonBubbles2=ampsGluonBubbles/.p2->-p2/.p3->-p3/.p1->-p2-p3;


(* ::Subsubsection:: *)
(*Feynman gauge, generic kinematics*)


ampsGluonBubblesFeynmanGauge1=ampsGluonBubbles2/.GaugeXi[g]->1


(* ::Text:: *)
(*As we keep the kinematics completely general, it is better to decompose tensor integrals into coefficient functions. Using scalar integrals*)
(*would give us huge expressions that we don't really need here.*)


ampsGluonBubblesFeynmanGauge2=TID[ampsGluonBubblesFeynmanGauge1,q,UsePaVeBasis->True,ToPaVe->True]


(* ::Text:: *)
(*There are no IR singularities*)


PaXEvaluateIR[ampsGluonBubblesFeynmanGauge2,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*What we are interested in, is the UV singularity*)


ampsGluonBubblesFeynmanGaugeUVPart1=PaXEvaluateUV[ampsGluonBubblesFeynmanGauge2,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*In the calculation p1 was eliminated via momentum conservation p1+p2+p3=0. Now we need to reintroduce it*)


ampsGluonBubblesFeynmanGaugeUVPartFinal=ampsGluonBubblesFeynmanGaugeUVPart1//FCE//Collect2[#,MTD]&//ReplaceAll[#,{FVD[p2,i_]+
2FVD[p3,i_]:>FVD[p3,i]-FVD[p1,i],FVD[p3,i_]+2FVD[p2,i_]:>FVD[p2,i]-FVD[p1,i]}]&//MomentumCombine//Simplify


(* ::Text:: *)
(*Let us compare this to the results given in Eq III .46 of Pascual and Tarrach, QCD: Renormalization for the Practitioner, Springer, 1984*)


ampsGluonBubblesUVPartPT=(I SMP["g_s"]) SMP["g_s"]^2/(4Pi)^2  CA/8 (15/EpsilonUV+ 3 GaugeXi[g]/EpsilonUV) * 
VertexLorentzStruct[{p1,p2,p3},{la,mu,nu},{a,b,c}]//Simplify;
Print["Check with Pascual and Tarrach, Eq III.46: ",
			If[Simplify[ExpandScalarProduct[ampsGluonBubblesFeynmanGaugeUVPartFinal-(ampsGluonBubblesUVPartPT/.GaugeXi[g]->1)]]===0, 
			"CORRECT.", "!!! WRONG !!!"]];


(* ::Subsubsection:: *)
(*R_xi gauge, specific kinematics (p2 = -p3 =p, p1 = 0)*)


ampsGluonBubblesRXiGauge1=ampsGluonBubbles2/.p3->-p2/.p2->p;


(* ::Text:: *)
(*Here we need to use a different strategy. The gauge part of the gluon propagators leads to loop integrals with denominators raised to integer powers. Those can be significantly simplified by using IBP relations, so it makes no sense to immediately switch to coefficient functions. Of course, this result is quite compact as we have chosen a simple kinematics. For generic*)
(*kinematics we would a huge amount of terms that are hardly manageable with Mathematica.*)


ampsGluonBubblesRXiGauge2=TID[ampsGluonBubblesRXiGauge1,q]


(* ::Text:: *)
(*After IBP reduction the amplitude becomes much simpler*)


ampsGluonBubblesRXiGauge3=FIREBurn[ampsGluonBubblesRXiGauge2,{q},{p}]


(* ::Text:: *)
(*There are no IR singularities.*)


PaXEvaluateIR[ampsGluonBubblesRXiGauge3,q,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*What we are interested in, is the UV singularity*)


ampsGluonBubblesRXiGaugeUVPartFinal=PaXEvaluateUV[ampsGluonBubblesRXiGauge3,q,PaXImplicitPrefactor->1/(2Pi)^D]//Simplify


(* ::Text:: *)
(*Let us compare this to the results given in Eq III .46 of Pascual and Tarrach, QCD: Renormalization for the Practitioner, Springer, 1984*)


ampsGluonBubblesUVPartPT=(I SMP["g_s"]) SMP["g_s"]^2/(4Pi)^2  CA/8 (15/EpsilonUV+ 3 GaugeXi[g]/EpsilonUV) * 
VertexLorentzStruct[{p1,p2,p3},{la,mu,nu},{a,b,c}]//Simplify;
Print["Check with Pascual and Tarrach, Eq III.46: ",
			If[Simplify[ExpandScalarProduct[ampsGluonBubblesRXiGaugeUVPartFinal-(ampsGluonBubblesUVPartPT/.p3->-p2/.p2->p/.p1->0)]]===0, 
			"CORRECT.", "!!! WRONG !!!"]];


(* ::Subsection:: *)
(*Quark triangle*)


diagsQuarkTriangle = InsertFields[CreateTopologies[1,1->2,
ExcludeTopologies->{WFCorrections,SelfEnergies,Tadpoles}],
{V[5]}->{V[5],V[5]},Model->"SMQCD",InsertionLevel -> {Particles},
ExcludeParticles->{S[_],V[_],U[_]}];
Paint[DiagramExtract[diagsQuarkTriangle,{1,4}], ColumnsXRows -> {2, 1}, SheetHeader->None, 
Numbering -> None,ImageSize->{512,256}];


Options[SUNSimplify]


ampsQuarkTriangle1=FCFAConvert[CreateFeynAmp[DiagramExtract[diagsQuarkTriangle,{1,4}], Truncated -> True,
GaugeRules->{},PreFactor->1],IncomingMomenta->{p1}, OutgoingMomenta->{p2,p3},
LoopMomenta->{q},DropSumOver->True,UndoChiralSplittings->True,ChangeDimension->D,
List->False,SMP->True,LorentzIndexNames->{la,mu,nu}, SUNIndexNames->{a,b,c},
FinalSubstitutions->{SMP["m_u"]->SMP["m_q"]}]//FCTraceFactor//SUNSimplify[#,SUNTrace->True,Explicit->True]&//
ReplaceAll[#,SUNTrace[x__]:>SUNTrace[x,Explicit->True]]&


(* ::Text:: *)
(*Since we are computing a vertex function, the momenta  should be all incoming*)


ampsQuarkTriangle2=ampsQuarkTriangle1/.p2->-p2/.p3->-p3;


(* ::Text:: *)
(*As we keep the kinematics completely general, it is better to decompose tensor integrals into coefficient functions. Using scalar integrals*)
(*would give us huge expressions that we don't really need here.*)


ampsQuarkTriangle3=TID[ampsQuarkTriangle2,q,UsePaVeBasis->True,ToPaVe->True]


(* ::Text:: *)
(*There are no IR singularities*)


PaXEvaluateIR[ampsQuarkTriangle3,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*What we are interested in, is the UV singularity*)


ampsQuarkTriangleUVPart1=PaXEvaluateUV[ampsQuarkTriangle3,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*In the calculation p1 was eliminated via momentum conservation p1+p2+p3=0. Now we need to reintroduce it*)


ampsQuarkTriangleUVPartFinal=ampsQuarkTriangleUVPart1//FCE//Collect2[#,MTD]&//ReplaceAll[#,{FVD[p2,i_]+2FVD[p3,i_]:>FVD[p3,i]-FVD[p1,i],
FVD[p3,i_]+2FVD[p2,i_]:>FVD[p2,i]-FVD[p1,i]}]&//MomentumCombine//Simplify


(* ::Text:: *)
(*Let us compare this to the results given in Eq III .46 of Pascual and Tarrach, QCD: Renormalization for the Practitioner, Springer, 1984*)


ampsQuarkTriangleUVPartPT=(I SMP["g_s"]) CA SMP["g_s"]^2/(4Pi)^2  (-2/(3EpsilonUV)) VertexLorentzStruct[{p1,p2,p3},{la,mu,nu},{a,b,c}]//Simplify;
Print["Check with Pascual and Tarrach, Eq III.46: ",
			If[Simplify[ExpandScalarProduct[ampsQuarkTriangleUVPartFinal-ampsQuarkTriangleUVPartPT]]===0, "CORRECT.", "!!! WRONG !!!"]];
