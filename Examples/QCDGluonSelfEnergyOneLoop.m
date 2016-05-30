(* ::Package:: *)

(* :Title: QCDGluonSelfEnergyOneLoop                                        *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2016 Rolf Mertig
	Copyright (C) 1997-2016 Frederik Orellana
	Copyright (C) 2014-2016 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the gluon self-energy in QCD at 1-loop         *)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*The gluon self-energy in QCD at  1-loop *)


(* ::Subsection:: *)
(*Load FeynCalc, FeynArts and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the gluon self-energy in QCD at 1-loop"];
];
$LoadAddOns={"FeynHelpers"};
$LoadFeynArts = True;
<<FeynCalc`
$FAVerbose=0;


(* ::Subsection:: *)
(*Generate Feynman diagrams*)


diags = InsertFields[CreateTopologies[1, 1 -> 1 ,ExcludeTopologies->{Tadpoles}],
		{V[5]} -> {V[5]},InsertionLevel -> {Classes},  Model->"SMQCD",
		ExcludeParticles->{S[_],V[2|3],U[1|2|3|4],F[4]}];
Paint[diags , ColumnsXRows -> {4, 1},SheetHeader -> False,   Numbering -> None,ImageSize->{512,128}];


amps =FCFAConvert[CreateFeynAmp[diags, Truncated -> True,PreFactor->-1],
IncomingMomenta->{p},OutgoingMomenta->{p},LoopMomenta->{q},DropSumOver->True,ChangeDimension->D,UndoChiralSplittings->True,
LorentzIndexNames->{\[Mu],\[Nu]}]/.{MQU[Index[Generation, 3]]->m}


amps2=TID[#,q]&/@SUNSimplify/@Contract/@amps


res=Total[amps2]//ToPaVe[#,q]&//Simplify


(* ::Text:: *)
(*Evaluate the Passarino-Veltman functions using Package-X*)


res2=PaXEvaluate[res,PaXImplicitPrefactor->1/(2Pi)^(4-2Epsilon)]


(* ::Text:: *)
(*We need only the terms proportional to 1/Epsilon*)


res3=res2//Expand2[#,Epsilon]&//SelectNotFree[#,Epsilon]&//Simplify//ChangeDimension[#,4]&


(* ::Text:: *)
(*We can compare this result to Eq. 2.5.131 and Eq. 2.5.132 in Foundations of QCD by T. Muta.*)


gaugePrefactor=(Pair[LorentzIndex[\[Mu]], Momentum[p]]*Pair[LorentzIndex[\[Nu]], Momentum[p]] - Pair[LorentzIndex[\[Mu]], LorentzIndex[\[Nu]]]*
		Pair[Momentum[p], Momentum[p]]);
gluonSelfEnergyMuta=-I*(Gstrong^2/(4Pi)^2)*(4/3*(1/2)*Nf-(1/2)CA(13/3-GaugeXi))*1/Epsilon*
gaugePrefactor*SUNDelta[SUNIndex[Glu1], SUNIndex[Glu2]];
Print["Check with Muta, Eq 2.5.131 and Eq. 2.5.132: ",
			If[Simplify[res3-FCI[gluonSelfEnergyMuta/.GaugeXi->1/.Nf->1]]===0, "CORRECT.", "!!! WRONG !!!"]];
