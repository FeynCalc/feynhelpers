(* ::Package:: *)

 


(* ::Section:: *)
(*PaXEvaluate*)


(* ::Text:: *)
(*`PaXEvaluate[expr, q]` evaluates scalar 1-loop integrals (up to 4-point functions) in `expr` that depend on the loop momentum `q` in `D` dimensions.*)


(* ::Text:: *)
(*The evaluation is using H. Patel's Package-X.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PaXEvaluateIR](PaXEvaluateIR.md), [PaXEvaluateUV](PaXEvaluateUV.md), [PaXEvaluateUVIRSplit](PaXEvaluateUVIRSplit.md).*)


(* ::Subsection:: *)
(*Examples*)


FAD[{q,m}]
PaXEvaluate[%,q,PaXImplicitPrefactor->1/(2 Pi)^(4-2 Epsilon)]


FAD[{l,0},{q+l,0}]
PaXEvaluate[%,l,PaXImplicitPrefactor->1/(2 Pi)^(4-2 Epsilon)]


(* ::Text:: *)
(*`PaVe` functions do not require the second argument specifying the loop momentum*)


PaVe[0, {0, Pair[Momentum[p, D], Momentum[p, D]],Pair[Momentum[p, D], Momentum[p, D]]}, {0, 0, M}]
PaXEvaluate[%]
