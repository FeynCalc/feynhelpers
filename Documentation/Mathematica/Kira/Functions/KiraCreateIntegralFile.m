(* ::Package:: *)

 


(* ::Section:: *)
(*KiraCreateIntegralFile*)


(* ::Text:: *)
(*`KiraCreateIntegralFile[ex, topo, path]` extracts `GLI` symbols from `ex` that belong to the topology `topo`. The resulting list of integrals is saved to `path/topoName/KiraLoopIntegrals.txt` and can be referred to in the corresponding Kira job file.*)


(* ::Text:: *)
(*If the directory specified in `path/topoName` does not exist, it will be created automatically. If it already exists, its content will be automatically overwritten, unless the option `OverwriteTarget` is set to `False`.*)


(* ::Text:: *)
(*Notice that `ex` may also contain integrals from different topologies, as long as all those topologies are provided as a list in the `topo` argument.*)


(* ::Text:: *)
(*It is also possible to invoke  the routine as `KiraCreateIntegralFile[ex, {topo1, topo2, ...}, {path1, path2, ...}]` or `KiraCreateIntegralFile[ex, {topo1, topo2, ...}, {path1, path2, ...}]` if one needs to process a list of topologies.*)


(* ::Text:: *)
(*The syntax  `KiraCreateIntegralFile[ex, {topo1, topo2, ...}, path]` or `KiraCreateIntegralFile[ex, {topo1, topo2, ...}, path]` is also*)
(*allowed. This implies that all config files will go into the corresponding subdirectories of path, e.g. `path/topoName1`, `path/topoName2` etc.*)


(* ::Text:: *)
(**)
(*The default name of the file containing loop integrals for the reduction is `"KiraLoopIntegrals.txt"`. It can be changed via the option `KiraIntegrals`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [KiraCreateConfigFile](KiraCreateConfigFile.md), [KiraIntegrals](KiraIntegrals.md).*)


(* ::Subsection:: *)
(*Examples*)


ints=la^8*GLI["asyR3prop2Ltopo01310X11111N1", {-7, 1, 1, 9, 1}] + 
la^8*GLI["asyR3prop2Ltopo01310X11111N1", {-6, 0, 2, 8, 1}] - 
la^7*GLI["asyR3prop2Ltopo01310X11111N1", {-6, 1, 1, 8, 1}] - 
la^8*mg^2*GLI["asyR3prop2Ltopo01310X11111N1", {-6, 1, 2, 8, 1}] + 
 la^8*GLI["asyR3prop2Ltopo01310X11111N1", {-5, -1, 3, 7, 1}] - 
 la^7*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 0, 2, 7, 1}] - 
 2*la^8*mg^2*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 0, 3, 7, 1}] + 
 la^6*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 1, 1, 7, 1}] + 
 la^7*mg^2*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 1, 2, 7, 1}] + 
 la^8*mg^4*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 1, 3, 7, 1}];


topo=FCTopology["asyR3prop2Ltopo01310X11111N1", {SFAD[{{I*p1, 0}, {0, -1}, 1}], 
SFAD[{{I*p3, 0}, {-mg^2, -1}, 1}], SFAD[{{0, -2*p3 . q}, {0, -1}, 1}], 
SFAD[{{0, -2*p1 . q}, {0, -1}, 1}], SFAD[{{I*(p1 - p3), 0}, {0, -1}, 1}]}, 
{p1, p3}, {q}, {Hold[SPD][q, q] -> mb^2}, {}]


fileName=KiraCreateIntegralFile[ints,topo,FileNameJoin[{$FeynCalcDirectory,"Database"}]];
fileName//FilePrint


fileName=FIRECreateIntegralFile[ints,topo,1500,FileNameJoin[{$FeynCalcDirectory,"Database"}]];
fileName//FilePrint


FIRECreateIntegralFile[ints,topo,1500,FileNameJoin[{$FeynCalcDirectory,"Database"}],FCVerbose->-1];


ex2 = c1 GLI[prop1l,{1,1}] + c2 GLI[prop1l,{2,0}] + c3 GLI[tad2l,{1,1,0}] + c4 GLI[tad2l,{1,1,1}]l


topos={
FCTopology[prop1l, {FAD[{p1, m1}], FAD[{p1 + q, m2}]}, {p1}, {q}, {}, {}],

FCTopology[tad2l, {FAD[{p1, m1}], FAD[{p2, m2}], FAD[{p1 - p2, m3}]}, {p1, p2}, {}, {}, {}]
}


fileNames=KiraCreateIntegralFile[ex2,topos,FileNameJoin[{$FeynCalcDirectory,"Database"}]];


fileNames[[1]]//FilePrint


fileNames[[2]]//FilePrint


KiraCreateIntegralFile[ex2,topos,FileNameJoin[{$FeynCalcDirectory,"Database"}],FCVerbose->-1,
KiraIntegrals->"LIs.m"]
