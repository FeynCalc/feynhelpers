(* ::Package:: *)

 


(* ::Section:: *)
(*FIRECreateLiteRedFiles*)


(* ::Text:: *)
(*`FIRECreateLiteRedFiles[path]` creates lbases  files (generated with LiteRed) using the script `CreateLiteRedFiles.m` in `path`. To that aim a Mathematica kernel is started in the background via `RunProcess`. The function returns `True` if the evaluation succeeds and `False` otherwise.*)


(* ::Text:: *)
(*Notice that lbases files must be created before generating sbases using FIRECreateStartFiles (or running the*)
(*respective scripts directly) .*)


(* ::Text:: *)
(*Alternatively, one can use `FIRECreateLiteRedFiles[path, topo]` where `topo` is an `FCTopology` symbol and the full path is implied to be `path/topoName/CreateStartFile.m`.*)


(* ::Text:: *)
(*If you need to process a list of topologies, following syntaxes are possible `FIRECreateLiteRedFiles[{path1,path2, ...}]`, `FIRECreateLiteRedFiles[path, {topo1, topo2, ...}]`*)


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


FIRECreateLiteRedFiles[fileName,FCVerbose->3]
