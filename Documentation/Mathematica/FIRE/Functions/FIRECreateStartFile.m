(* ::Package:: *)

 


(* ::Section:: *)
(*FIRECreateStartFile*)


(* ::Text:: *)
(*`FIRECreateStartFile[path]` creates a FIRE .start file using the script `CreateStartFile.m` in `path`. To that aim a Mathematica kernel is started in the background via `RunProcess`. The function returns `True` if the evaluation succeeds and `False` otherwise.*)


(* ::Text:: *)
(*Alternatively, one can use `FIRECreateStartFile[path, topo]` where `topo` is an `FCTopology` symbol and the full path is implied to be `path/topoName/CreateStartFile.m`.*)


(* ::Text:: *)
(*If you need to process a list of topologies, following syntaxes are possible `FIRECreateStartFile[{path1,path2, ...}]`, `FIRECreateStartFile[path, {topo1, topo2, ...}]`*)


(* ::Text:: *)
(*The path to the Mathematica Kernel can be specified via `FIREMathematicaKernelPath`. The default value is `Automatic`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIREPrepareStartFile](FIREPrepareStartFile.md), [FIREMathematicaKernelPath](FIREMathematicaKernelPath.md)*)


(* ::Subsection:: *)
(*Examples*)


topo=FCTopology["prop3lX1",{SFAD[{p1,m^2}],SFAD[p2],SFAD[{p3,m^2}],SFAD[Q-p1-p2-p3],SFAD[Q-p1-p2],SFAD[Q-p1],SFAD[Q-p2],SFAD[p1+p3],SFAD[p2+p3]},{p1,p2,p3},{Q},{},{}]


fileName=FIREPrepareStartFile[topo,FileNameJoin[{$FeynCalcDirectory,"Database"}]]


FIRECreateStartFile[fileName,FCVerbose->3]
