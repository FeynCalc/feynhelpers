(* ::Package:: *)

(* :Title: MasslessQEDSelfEnergiesTwoLoops                                       *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2018 Rolf Mertig
	Copyright (C) 1997-2018 Frederik Orellana
	Copyright (C) 2014-2018 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the 2-loop self-energies in massless QED  *)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*2-loop self-energies in massless QED*)


(* ::Subsection:: *)
(*Load FeynCalc, FeynArts and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the 2-loop self-energies in massless QED"];
];
$LoadAddOns={"FeynHelpers"};
$LoadFeynArts= True;
<< FeynCalc`
$FAVerbose = 0;


(* ::Subsection:: *)
(*Vacuum polarization*)


topsPol=CreateTopologies[2, 1 -> 1,ExcludeTopologies -> {Tadpoles}];
diagsVacuumPol=InsertFields[topsPol, {V[1]} -> {V[1]},
InsertionLevel -> {Particles},ExcludeParticles->{V[2|3],S[_],U[_],F[1|3|4]}];
Paint[DiagramExtract[diagsVacuumPol,{1,4,7}],ColumnsXRows->{3,1},
SheetHeader -> False,   Numbering -> None,ImageSize->{768,256}];


(* ::Text:: *)
(*First of all we need to generate the amplitudes and convert them into FeynCalc notation. We choose l1 and l2 to be the loop momenta and p the external momentum*)


ampsVacuumPol=FCFAConvert[CreateFeynAmp[DiagramExtract[diagsVacuumPol,{1,4,7}], 
Truncated -> True,PreFactor->-1,GaugeRules->{}],
IncomingMomenta->{p},OutgoingMomenta->{p},LoopMomenta->{l1,l2},DropSumOver->True,
ChangeDimension->D,UndoChiralSplittings->True,List->False,SMP->True,
LorentzIndexNames->{\[Mu],\[Nu]}]//ReplaceAll[#,SMP["m_e"]->0]&//Contract//FCTraceFactor


(* ::Text:: *)
(*Calculation of the Dirac trace and tensor reduction*)


AbsoluteTiming[ampsVacuumPol1=(ampsVacuumPol/.DiracTrace->Tr)//FCMultiLoopTID[#,{l1,l2}]&]


(* ::Text:: *)
(*Simplification of the loop integrals using shifts in the loop momenta*)


ampsVacuumPol2=ampsVacuumPol1//FDS[#,l1,l2]&


(* ::Text:: *)
(*IBP-Reduction using FIRE*)


ampsVacuumPol3=FIREBurn[ampsVacuumPol2,{l1,l2},{p}]//FDS[#,l1,l2]&


(* ::Text:: *)
(*Nicer form. Notice that the gauge dependence dropped out in the final result, as it should.*)


ampsVacuumPol4=ampsVacuumPol3//Collect2[#,{FeynAmpDenominator},Factoring->Factor2]&


(* ::Text:: *)
(*This is Pi_2 (p^2) up to the 1/(2Pi)^2D prefactor*)


resVacuumPol=Cancel[ampsVacuumPol4/(-I FCI[(FVD[p,\[Mu]]FVD[p,\[Nu]]-SPD[p,p]MTD[\[Mu],\[Nu]])])]//FullSimplify


(* ::Subsection:: *)
(*Electron self-energy*)


topsSE=CreateTopologies[2, 1 -> 1,ExcludeTopologies -> {Tadpoles}];
diagsSE=InsertFields[topsSE, {F[2,{1}]} -> {F[2,{1}]},InsertionLevel -> {Particles},
ExcludeParticles->{V[2|3],S[_],U[_],F[1|3|4]}];
Paint[DiagramExtract[diagsSE,{1,2,5}],ColumnsXRows->{3,1},SheetHeader -> False,   
Numbering -> None,ImageSize->{768,256}];


(* ::Text:: *)
(*First of all we need to generate the amplitudes and convert them into FeynCalc notation. We choose l1 and l2 to be the loop momenta and p the external momentum*)


ampsSE=FCFAConvert[CreateFeynAmp[DiagramExtract[diagsSE,{1,2,5}], Truncated -> True,
PreFactor->-1,GaugeRules->{}],IncomingMomenta->{p},OutgoingMomenta->{p},
LoopMomenta->{l1,l2},DropSumOver->True,ChangeDimension->D,UndoChiralSplittings->True,
List->False,SMP->True,LorentzIndexNames->{\[Mu]}]//ReplaceAll[#,SMP["m_e"]->0]&//
Contract//FCTraceFactor


(* ::Text:: *)
(*Calculation of the Dirac trace, tensor reduction and simplification of the Dirac algebra*)


AbsoluteTiming[ampsSE1=(ampsSE/.DiracTrace->Tr)//FCMultiLoopTID[#,{l1,l2}]&//DiracSimplify]


(* ::Text:: *)
(*Simplification of the loop integrals using shifts in the loop momenta*)


ampsSE2=ampsSE1//FDS[#,l1,l2]&


(* ::Text:: *)
(*IBP-Reduction using FIRE*)


ampsSE3=FIREBurn[ampsSE2,{l1,l2},{p}]//FDS[#,l1,l2]&


(* ::Text:: *)
(*Nicer form*)


ampsSE4=ampsSE3//Collect2[#,{FeynAmpDenominator},Factoring->FullSimplify]&


(* ::Text:: *)
(*This is Sigma_2V(p^2) up to the 1/(2Pi)^2D prefactor*)


resSE=Cancel[ampsSE4/(-I FCI[(GSD[p])])]//FullSimplify


(* ::Subsection:: *)
(*Check with the literature*)


(* ::Text:: *)
(*Check with Eq. 5.18 from Grozin's Lectures on QED and QCD (hep-ph/0508242)*)


resGrozinVacuumPol=FCI[SMP["e"]^4 2(D-2)/((D-1)(D-4))(-(D^2-7D+16)FAD[l1,l2,l1-p,l2-p]+
4(D-3)(D^2-4D+8)/(D-4)(1/SPD[p,p])FAD[l1,l1-l2,l2-p])]//Cancel//FullSimplify


(* ::Text:: *)
(*Check with Eq. 5.51 from Grozin's Lectures on QED and QCD (hep-ph/0508242)*)


resGrozinSE=FCI[SMP["e"]^4(D-2)( 2(D-2)/(D-6)(1/SPD[p,p])FAD[l1,l1-l2,l2-p]-
1/4((D-2)(GaugeXi[A])^2+D-6)FAD[l1,l2,l1-p,l2-p]
+(1/2)(D-3)/(D-4)((3D-8)(GaugeXi[A])^2-D-4)(1/SPD[p,p])FAD[l1,
l1-l2,l2-p])]//Cancel//FullSimplify


Print["Check with the Grozin (hep-ph/0508242): ", If[{Simplify[resGrozinSE-resSE],
Simplify[resGrozinVacuumPol-resVacuumPol]}==={0,0},
		"CORRECT.", "!!! WRONG !!!"]];
