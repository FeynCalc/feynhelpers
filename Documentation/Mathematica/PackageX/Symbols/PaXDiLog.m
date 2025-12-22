(* ::Package:: *)

 


(* ::Section:: *)
(*PaXDiLog*)


(* ::Text:: *)
(*`PaXDiLog` corresponds to `DiLog` in Package-X.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md).*)


(* ::Subsection:: *)
(*Examples*)


(*Just to load Package-X*)
PaXEvaluate[A0[1]];


(* ::Text:: *)
(*`PaXDiLog` uses ``X`DiLog`` for numerical evaluations*)


PaXDiLog[1,2]


X`DiLog[1,2]


(* ::Text:: *)
(*The same goes for derivatives and series expansions*)


D[PaXDiLog[x,\[Alpha]],x]


Series[PaXDiLog[x,\[Alpha]],{x,0,5}]
