(* ::Package:: *)

 


(* ::Section:: *)
(*FIREPrepareStartFile*)


(* ::Text:: *)
(*`FIREPrepareStartFile[topo, path]` can be used to convert an `FCTopology` object `topo` into a FIRE. start-file.*)


(* ::Text:: *)
(*The functions creates the corresponding Mathematica script `CreateStartFile.m` and saves it in `path/topoName`. Notice that the script still needs to be evaluated in Mathematica to generate the actual FIRE .start-file. This can be conveniently done using `FIRECreateStartFile`.*)


(* ::Text:: *)
(*Using `FIREPrepareStartFile[{topo1, topo2, ...},  path]` will save the scripts to `path/topoName1`, `path/topoName2` etc. The syntax `FIREPrepareStartFile[{topo1, topo2, ...},  {path1, path2, ...}]` is also possible.*)


(* ::Text:: *)
(*The default path to the FIRE package is `FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE6", "FIRE6.m"}]`. It can be adjusted using the option `FIREPath`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIRECreateStartFile](FIRECreateStartFile.md), [FIRERunReduction](FIRERunReduction.md)*)


(* ::Subsection:: *)
(*Examples*)


topo=FCTopology["prop3lX1",{SFAD[{p1,m^2}],SFAD[p2],SFAD[{p3,m^2}],SFAD[Q-p1-p2-p3],SFAD[Q-p1-p2],SFAD[Q-p1],SFAD[Q-p2],SFAD[p1+p3],SFAD[p2+p3]},{p1,p2,p3},{Q},{},{}]


fileName=FIREPrepareStartFile[topo,FileNameJoin[{$FeynCalcDirectory,"Database"}]];
fileName//FilePrint
