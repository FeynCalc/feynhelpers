(* ::Package:: *)

(* :Title: QCDQuarkSelfEnergyOneLoop                                        *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2024 Rolf Mertig
	Copyright (C) 1997-2024 Frederik Orellana
	Copyright (C) 2014-2024 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the quark self-energy in QCD at 1-loop         *)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*The quark self-energy in QCD at  1-loop *)


(* ::Subsection:: *)
(*Load FeynCalc, FeynArts and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the quark self-energy in QCD at 1-loop"];
];
$LoadAddOns={"FeynArts","FeynHelpers"};
<<FeynCalc`
$FAVerbose=0;


(* ::Subsection:: *)
(*Generate Feynman diagrams*)


Paint[diags = InsertFields[CreateTopologies[1, 1 -> 1,
		ExcludeTopologies -> {Tadpoles}], {F[3,{1}]} -> {F[3,{1}]},
		InsertionLevel -> {Classes}, GenericModel -> "Lorentz",
		Model -> "SMQCD",ExcludeParticles->{S[1],S[2],S[3],V[1],V[2],V[3]}], ColumnsXRows -> {1, 1},
		SheetHeader -> False,SheetHeader->None,Numbering -> None,ImageSize->{256,256}];


amps=FCFAConvert[CreateFeynAmp[diags, Truncated -> True,GaugeRules->{},PreFactor->1],IncomingMomenta->{p},
OutgoingMomenta->{p},LoopMomenta->{q},DropSumOver->True,UndoChiralSplittings->True,ChangeDimension->D,List->False,
FinalSubstitutions->{FCGV["MU"]->M,GaugeXi[g]->GaugeXi}]//SUNSimplify//Contract


ampsEval=TID[amps,q,ToPaVe->True]//DiracSimplify


res1=PaXEvaluate[ampsEval,q,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*This is I*Sigma (divergent part only)*)


quarkSelfEnergy=SelectNotFree2[res1,Epsilon]//Expand//Simplify


(* ::Text:: *)
(*We can compare this result to Eq. 2.5.138 in Foundations of QCD by T. Muta.*)


quarSelfEnergyMuta=I*(-SMP["g_s"]^2/(4Pi)^2 CF*(3+GaugeXi)(1/Epsilon)*M+GSD[p]*SMP["g_s"]^2/(4Pi)^2*
		CF*GaugeXi*(1/Epsilon))SDF[Col1,Col2]//FCI;
Print["Check with Muta, Eq 2.5.138: ",
			If[Simplify[quarkSelfEnergy-FCI[quarSelfEnergyMuta]]===0, "CORRECT.", "!!! WRONG !!!"]];


(* ::Text:: *)
(*Another cross-check is to compare to Eq. 16.76 in Peskin and Schroeder, where the authors compute the self-energy diagram for massless quarks in Feynman gauge. All we need to do is just set the quarks mass M to zero and the gauge parameter GaugeXi to 1.*)


quarkSelfEnergyMassless=quarkSelfEnergy/.{M->0,GaugeXi->1}


ampsSingMasslessPeskin=I*SMP["g_s"]^2/(4Pi)^2*GSD[p]*CF*(1/Epsilon)SDF[Col1,Col2]//FCI;
Print["Check with Peskin and Schroeder, Eq 16.76: ",
			If[Simplify[quarkSelfEnergyMassless-FCI[ampsSingMasslessPeskin]]===0, "CORRECT.", "!!! WRONG !!!"]];
