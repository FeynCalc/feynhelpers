(* ::Package:: *)

 


(* ::Section:: *)
(*PaXEvaluateUVIRSplit*)


(* ::Text:: *)
(*`PaXEvaluateUVIRSplit[expr,q]` is like `PaXEvaluate`, but with the difference that it explicitly distinguishes between UV- and IR-divergences.*)


(* ::Text:: *)
(*The evaluation is using H. Patel's Package-X.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PaXEvaluateIR](PaXEvaluateIR.md), [PaXEvaluateUV](PaXEvaluateUV.md), [PaXEvaluate](PaXEvaluate.md).*)


(* ::Subsection:: *)
(*Examples*)


PaXEvaluateUVIRSplit[B0[SPD[p],0,m^2],PaXSeries -> {{SPD[p],m^2,1}},PaXAnalytic->True]
