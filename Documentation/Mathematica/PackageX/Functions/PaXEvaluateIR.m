(* ::Package:: *)

 


(* ::Section:: *)
(*PaXEvaluateIR*)


(* ::Text:: *)
(*`PaXEvaluateIR[expr,q]` is like `PaXEvaluate` but with the difference that it returns only the IR-divergent part of the result.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PaXEvaluate](PaXEvaluate.md), [PaXEvaluateUV](PaXEvaluateUV.md), [PaXEvaluateUVIRSplit](PaXEvaluateUVIRSplit.md).*)


(* ::Subsection:: *)
(*Examples*)


PaXEvaluateIR[B0[SPD[p],0,m^2],PaXSeries -> {{SPD[p],m^2,1}},PaXAnalytic->True]
