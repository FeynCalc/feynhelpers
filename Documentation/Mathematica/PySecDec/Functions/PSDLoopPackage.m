(* ::Package:: *)

 


(* ::Section:: *)
(*PSDLoopPackage*)


(* ::Text:: *)
(*`PSDLoopPackage[name, loopIntegral, order]` is an auxiliary function that creates input for pySecDec's `loop_package` routine. The result is returned as a string.*)


(* ::Text:: *)
(*`PSDLoopPackage` is used by `PSDCreatePythonScripts` when assembling the generation script.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md), [PSDIntegrate](PSDIntegrate.md), [PSDLoopIntegralFromPropagators](PSDLoopIntegralFromPropagators.md), [PSDLoopRegions](PSDLoopRegions.md).*)


(* ::Subsection:: *)
(*Examples*)


PSDLoopPackage["loopint","li",2]


PSDLoopPackage["loopint","li",0,PSDDecompositionMethod->"iterative",
PSDAdditionalPrefactor->"2",PSDContourDeformation->False]
