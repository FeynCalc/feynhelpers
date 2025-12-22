(* ::Package:: *)

 


(* ::Section:: *)
(*FSARunIntegration*)


(* ::Text:: *)
(*`FSARunIntegration[path]` evaluates a FIESTA script `FiestaScript.m` in `path`. To that aim a Mathematica kernel is started in the background via `RunProcess`. The function returns `True` if the evaluation succeeds and `False` otherwise.*)


(* ::Text:: *)
(*Alternatively, one can use `FSARunIntegration[path, topo]` where `topo` is an `FCTopology` symbol and the full path is implied to be `path/topoName/FiestaScript.m`.*)


(* ::Text:: *)
(*If you need to process a list of topologies, following syntaxes are possible `FiestaScript.m[{path1,path2, ...}]`, `FiestaScript.m[path, {topo1, topo2, ...}]`*)


(* ::Text:: *)
(*The path to the Mathematica Kernel can be specified via `FSAMathematicaKernelPath`. The default value is `Automatic`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FSAShowOutput](FSAShowOutput.md), [FSAMathematicaKernelPath](FSAMathematicaKernelPath.md).*)


(* ::Subsection:: *)
(*Examples*)


topo1=FCTopology[prop1L,{-SFAD[{{I p1,0},{-m1^2,-1},1}],-SFAD[{{I (p1+q),0},{-m2^2,-1},1}]},{p1},{q},{},{}]
int1=GLI[prop1L,{1,1}]


fileNames=FSAPrepareSDEvaluate[int1,topo1,FileNameJoin[{$FeynCalcDirectory,"Database"}],
FinalSubstitutions->{SPD[q]->qq,qq->20. , m1->2. , m2->2.}];


FSARunIntegration[fileNames[[1]]]
