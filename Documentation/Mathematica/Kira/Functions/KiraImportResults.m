(* ::Package:: *)

 


(* ::Section:: *)
(*KiraImportResults*)


(* ::Text:: *)
(*`KiraImportResults[topoName, path]`  imports the content of a Kira reduction table and converts the results to replacement rules for `GLI`s with the id `topoName`.*)


(* ::Text:: *)
(*Notice that `topoName` can be also a list of replacement rules that link FIRE ids to `FCTopology` ids. For the sake of convenience one can also use full `FCTopology` objects instead of their ids as in  `KiraImportResults[topo, path]` or `KiraImportResults[{topo1, topo2, ...}, path]`.*)


(* ::Text:: *)
(*If `path` represents a full path to a file, then this file is loaded. If it is just a path to a directory, then `path/topoName/topoName` is assumed to be the full path.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [KiraCreateConfigFiles](KiraCreateConfigFiles.md), [KiraCreateJobFile](KiraCreateJobFile.md), [KiraRunReduction](KiraRunReduction.md)*)


(* ::Subsection:: *)
(*Examples*)


ibpTables=FileNameJoin[{$FeynHelpersDirectory,"Documentation","Examples","kira_asyR1prop2Ltopo01310X11111N1.m"}];


ibpRules=KiraImportResults["prop3L1topo010000100",ibpTables];


ibpRules//Length


ibpRules[[-5;;]]
