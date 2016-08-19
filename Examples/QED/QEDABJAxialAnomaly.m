(* ::Package:: *)

(* :Title: QEDABJAxialAnomaly                                       *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2016 Rolf Mertig
	Copyright (C) 1997-2016 Frederik Orellana
	Copyright (C) 2014-2016 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the Adler-Bell-Jackiw anomaly in QED *)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*Adler-Bell-Jackiw anomaly in QED*)


(* ::Subsection:: *)
(*Load FeynCalc and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the Adler-Bell-Jackiw anomaly in QED"];
];
$LoadAddOns={"FeynHelpers"};
<< FeynCalc`


(* ::Subsection:: *)
(*Compute the diagrams*)


(* ::Text:: *)
(*According to Peskin and Schroeder (Ch 19.2), the amplitude for the first triangle diagram reads*)


amp1=((-1)(-I SMP["e"])^2 DiracTrace[GAD[mu].GA[5].QuarkPropagator[l-k].GAD[la].QuarkPropagator[l].GAD[nu].QuarkPropagator[l+p]])//
Explicit


(* ::Text:: *)
(*And the second one follows from the first by the interchanging k with p and la with nu*)


amp2=amp1/.{k->p,p->k,la->nu,nu->la}


(* ::Text:: *)
(*Contracting both amplitudes with I*(k+p)^mu we can check the non-conservation of the axial current.*)


ampDotted=Contract[I*FVD[k+p,mu](amp1+amp2)]


(* ::Text:: *)
(*For this calculation it is crucial to use a correct scheme for gamma^5. As in the book, we use the Breitenlohner-Maison-t'Hooft-Veltman*)
(*prescription.*)


$BreitMaison=True;
ampDotted2=ampDotted/.DiracTrace->Tr


(* ::Text:: *)
(*Now comes the tensor decomposition. Notice that although in the BMHV scheme the external momenta live in 4 dimensions, we do the computation with D-dimensional external momenta. This is fine, since at the end we can send them to 4 dimensions to obtain the physical result.*)


ampDotted3=TID[ampDotted2,l]//ToPaVe[#,l]&//EpsEvaluate


(* ::Text:: *)
(*Evaluate the resulting Passarino-Veltman functions using Package-X.*)


abjRes=PaXEvaluate[ampDotted3,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*The result should be twice Eq. 19.59 in Peskin and Schroeder*)


abjPeskin = SMP["e"]^2/(4 Pi^2)LC[al,la,be,nu]FV[k,al]FV[p,be]//Contract//FCI;
Print["Check with Peskin and Schroeder, Eq 19.59: ", If[(abjRes-2*abjPeskin)===0,
		"CORRECT.", "!!! WRONG !!!"]];
