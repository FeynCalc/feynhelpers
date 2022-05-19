(* ::Package:: *)

 


(* ::Section:: *)
(*PaXContinuedDiLog*)


(* ::Text:: *)
(*`PaXContinuedDiLog` corresponds to `ContinuedDiLog` in Package-X.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md).*)


(* ::Subsection:: *)
(*Examples*)


(*Just to load Package-X*)
PaXEvaluate[A0[1]];


(* ::Text:: *)
(*`PaXContinuedDiLog` uses ``X`ContinuedDiLog`` for numerical evaluations*)


PaXContinuedDiLog[{3.2,1.0},{1.1,1.0}]


X`ContinuedDiLog[{3.2,1.0},{1.1,1.0}]


(* ::Text:: *)
(*The same goes for derivatives and series expansions*)


D[PaXContinuedDiLog[{x,xInf},{y,yInf}],x]


Series[PaXContinuedDiLog[{x,xInf},{y,yInf}],{x,1,2}]
