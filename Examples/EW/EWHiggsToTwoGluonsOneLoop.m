(* ::Package:: *)

(* :Title: EWHiggsToTwoGluonsOneLoop										*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2019 Rolf Mertig
	Copyright (C) 1997-2019 Frederik Orellana
	Copyright (C) 2014-2019 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the total decay rate for the decay of a 
				Higgs into 2 gluons via a top-loop.						*)

(* ------------------------------------------------------------------------ *)



(* ::Section:: *)
(*Load FeynCalc and FeynArts*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the total decay rate for the decay of a Higgs into 2 gluons via a top-loop."];
];
If[$Notebooks === False, $FeynCalcStartupMessages = False];
$LoadAddOns={"FeynHelpers"};
$LoadFeynArts= True;
<<FeynCalc`
$FAVerbose = 0;


(* ::Section:: *)
(*Decay of Higgs into two gluon via a top quark loop*)


(* ::Subsection:: *)
(*Generate Feynman diagrams*)


(* ::Text:: *)
(*Here we consider only the dominant contribution from the top quark mass. However, it is trivial to include also loops from other quark flavors.*)


diagsHiggsToGG = InsertFields[CreateTopologies[1,1 -> 2],{S[1]} -> {V[5],V[5]},
InsertionLevel -> {Particles},Model->"SMQCD"];
Paint[DiagramExtract[diagsHiggsToGG,{3,6}],ColumnsXRows->{2,1},
Numbering -> None,SheetHeader->None,ImageSize->{512,256}];


(* ::Subsection:: *)
(*Kinematics*)


FCClearScalarProducts[];
ScalarProduct[k1,k1]=0;
ScalarProduct[k2,k2]=0;
ScalarProduct[pH,pH]=SMP["m_H"]^2;
ScalarProduct[k1,k2]=(SMP["m_H"]^2)/2;


(* ::Subsection:: *)
(*Evaluation of the amplitudes*)


(* ::Text:: *)
(*This is the sum of both amplitudes*)


ampHiggsToTwoGluons=FCFAConvert[CreateFeynAmp[DiagramExtract[diagsHiggsToGG,
{3,6}],PreFactor->-1],IncomingMomenta->{pH},OutgoingMomenta->{k1,k2},
LoopMomenta->{q},List->False,TransversePolarizationVectors->{k1,k2},
ChangeDimension->D,DropSumOver->True,SMP->True,
UndoChiralSplittings->True]//Contract//FCTraceFactor//SUNSimplify


(* ::Text:: *)
(*Tensor reduction is straight-forward, after which we end up with coefficient functions*)


ampHiggsToTwoGluons2=TID[ampHiggsToTwoGluons,q,ToPaVe->True]//Collect2[#,B0,C0]&


(* ::Text:: *)
(*The coefficient functions are evaluated with Package-X*)


ampHiggsToTwoGluons3=PaXEvaluate[ampHiggsToTwoGluons2,
PaXImplicitPrefactor->1/(2Pi)^D]//Simplify


(* ::Text:: *)
(*As the result is finite, it is safe to switch from D to 4 dimensions.*)


ampHiggsToTwoGluons4=ChangeDimension[ampHiggsToTwoGluons3,4];


(* ::Text:: *)
(*We square the amplitude and sum over the polarizations of the gluons*)


ampSq=ampHiggsToTwoGluons4 ComplexConjugate[ampHiggsToTwoGluons4]//
DoPolarizationSums[#,k1,k2]&//DoPolarizationSums[#,k2,k1]&//Simplify//
SUNSimplify[#,SUNNToCACF->False]&


(* ::Text:: *)
(*Multiplying the result by the phase space factor we obtain the total decay rate*)


$Assumptions={SMP["m_H"]>0,SMP["m_t"]>0};
decayRateTotal=(1/2*1/(16 Pi SMP["m_H"])*(ampSq/.SUNN->3))//
ReplaceAll[#,{SMP["e"]^2->4 Pi SMP["alpha_fs"],SMP["g_s"]^4->
16 Pi^2 SMP["alpha_s"]^2}]&//Simplify


(* ::Text:: *)
(*For convenience, we can eliminate the fine-structure constant and sine of the Weinberg angle in favor of Fermi's constant*)


decayRateTotal2=Simplify[decayRateTotal/.{ SMP["m_t"]-> SMP["m_H"]/(2 Sqrt[\[Tau]]),
SMP["alpha_fs"]->Sqrt[2]/Pi SMP["m_W"]^2 SMP["sin_W"]^2 SMP["G_F"]}]


(* ::Text:: *)
(*To compare to the literature (arXiv:hep-ph/9504378) we extract the function A^2 (tau)*)


aSq=decayRateTotal2/(SMP["alpha_s"]^2 SMP["G_F"]SMP["m_H"]^3/(36 Sqrt[2]Pi^3) 9/16)


(* ::Text:: *)
(*The plots show that our results coincide with those of Spira et al.*)


aSqLit[x_]:=Piecewise[{{(2(x+(x-1)ArcSin[Sqrt[x]]^2)/x^2)^2,0<x<=1},
{(2(x+(x-1)(-1/4(Log[(1+\[Sqrt](1-1/x))/(1-\[Sqrt](1-1/x))]- I Pi)^2))/x^2)^2,x>1}}]


aSqLitBT=(2(\[Tau]+(\[Tau]-1)ArcSin[Sqrt[\[Tau]]]^2)/\[Tau]^2)^2;
aSqLitAT=(2(\[Tau]+(\[Tau]-1)(-1/4(Log[(1+\[Sqrt](1-1/\[Tau]))/(1-\[Sqrt](1-1/\[Tau]))]- I Pi)^2))/\[Tau]^2)^2;


plot1=Plot[{Re[aSq],Re[aSqLit[\[Tau]]]},{\[Tau],0,2},PlotStyle->{{Dashed,Red},{DotDashed,Blue}},
PlotLegends->{Re[Subscript[A, FeynCalc]^2],Re[Subscript[A, Literature]^2]},AxesLabel->{\[Tau],Re[A^2]}]
plot2=Plot[{Im[aSq],Im[aSqLit[\[Tau]]]},{\[Tau],0,2},PlotStyle->{{Dashed,Cyan},{DotDashed,
Black}},PlotLegends->{Im[Subscript[A, FeynCalc]^2],Im[Subscript[A, Literature]^2]},AxesLabel->{\[Tau],Im[A^2]}]


(* ::Subsection:: *)
(*Check with the literature*)


aSqres=(-4*\[Tau] + (-1 + \[Tau])*Log[1 + 2*(-1 + Sqrt[(-1 + \[Tau])/\[Tau]])*\[Tau]]^2)^2/(4*\[Tau]^4);
Print["Check with the literature: ",
			If[Simplify[(aSqres-aSq)]===0, 
			"CORRECT.", "!!! WRONG !!!"]];
