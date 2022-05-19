(* ::Package:: *)

 


(* ::Section:: *)
(*FIREImportResults*)


(* ::Text:: *)
(*`FIREImportResults[topoName, path]`  imports the content of a FIRE .tables file and converts the results to replacement rules for `GLI`s with the id `topoName`.*)


(* ::Text:: *)
(*Notice that `topoName` can be also a list of replacement rules that link FIRE ids to `FCTopology` ids. For the sake of convenience one can also use full `FCTopology` objects instead of their ids as in  `FIREImportResults[topo, path]` or `FIREImportResults[{topo1, topo2, ...}, path]`.*)


(* ::Text:: *)
(*If `path` represents a full path to a file, then this file is loaded. If it is just a path to a directory, then `path/topoName/topoName` is assumed to be the full path.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIRECreateStartFile](FIRECreateStartFile.md), [FIRERunReduction](FIRERunReduction.md)*)


(* ::Subsection:: *)
(*Examples*)


ibpTables=FileNameJoin[{$FeynHelpersDirectory,"Documentation","Examples","prop3L1topo010000100.tables"}];


ibpRules=FIREImportResults["prop3L1topo010000100",ibpTables];


ibpRules//Length


ibpRules[[1;;2]]


ibpRulesTest=FIREImportResults[{3110->"prop3L1topo010000100"},ibpTables];


ibpRules===ibpRulesTest


ibpRulesTest[[3;;4]]


topo=FCTopology[prop3L1topo010000100, {SFAD[{{I*p1, 0}, {0, -1}, 1}], SFAD[{{I*p2, 0}, {-m1^2, -1}, 1}], SFAD[{{I*p3, 0}, {0, -1}, 1}], SFAD[{{I*(p1 - p2), 0}, {0, -1}, 1}], SFAD[{{I*(p2 - p3), 0}, {0, -1}, 1}], SFAD[{{I*(p1 + q1), 0}, {0, -1}, 1}], SFAD[{{I*(p2 + q1), 0}, {-m1^2, -1}, 1}], SFAD[{{I*(p3 + q1), 0}, {0, -1}, 1}], SFAD[{{0, -p1 . p3}, {0, -1}, 1}]}, {p1, p2, p3}, {q1}, {SPD[q1, q1] -> m1^2}, {}];
