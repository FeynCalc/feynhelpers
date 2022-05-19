(* ::Package:: *)

 


(* ::Section:: *)
(*PaXLn*)


(* ::Text:: *)
(*`PaXLn` corresponds to `Ln` in Package-X.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md).*)


(* ::Subsection:: *)
(*Examples*)


(*Just to load Package-X*)
PaXEvaluate[A0[1]];


(* ::Text:: *)
(*`PaXLn` uses ``X`Ln`` for numerical evaluations*)


PaXLn[-4.5,1]


X`Ln[-4.5,1]


(* ::Text:: *)
(*The same goes for derivatives and series expansions*)


D[PaXLn[x,\[Alpha]],x]


Series[PaXLn[x,\[Alpha]],{x,1,2}]
