(* ::Package:: *)

 


(* ::Section:: *)
(*PSDIntegrate*)


(* ::Text:: *)
(*`PSDIntegrate[]` is an auxiliary function that creates input for pySecDec's numerical integration routines. The output is returned in form of a string.*)


(* ::Text:: *)
(*`PSDIntegrate` is used by `PSDCreatePythonScripts` when assembling the integration script.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md), [PSDLoopIntegralFromPropagators](PSDLoopIntegralFromPropagators.md), [PSDLoopPackage](PSDLoopPackage.md), [PSDLoopRegions](PSDLoopRegions.md).*)


(* ::Subsection:: *)
(*Examples*)


PSDIntegrate[PSDRealParameterValues->{11.,42.}]


PSDIntegrate[PSDRealParameterValues->{2.,4.},PSDIntegrator->"Vegas",PSDMinEval->10^5]
