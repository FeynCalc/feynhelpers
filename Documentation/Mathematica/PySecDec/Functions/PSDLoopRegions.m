(* ::Package:: *)

 


(* ::Section:: *)
(*PSDLoopRegions*)


(* ::Text:: *)
(*`PSDLoopRegions[name, loopIntegral, order, smallnessParameter]` is an auxiliary function that creates input for pySecDec's `loop_regions` routine. The results is returned as a string.*)


(* ::Text:: *)
(*`PSDLoopPackage` is used by `PSDCreatePythonScripts` when assembling the generation script for an asymptotic expansion.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md), [PSDIntegrate](PSDIntegrate.md), [PSDLoopIntegralFromPropagators](PSDLoopIntegralFromPropagators.md), [PSDLoopPackage](PSDLoopPackage.md).*)


(* ::Subsection:: *)
(*Examples*)


PSDLoopRegions["loopint","li",2,z]
