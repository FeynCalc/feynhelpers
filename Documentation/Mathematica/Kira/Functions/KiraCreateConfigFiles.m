(* ::Package:: *)

 


(* ::Section:: *)
(*KiraCreateConfigFiles*)


(* ::Text:: *)
(*`KiraCreateConfigFiles[topo, sectors, path]` can be used to generate Kira configuration files (`integralfamilies.yaml` and `kinematics.yaml`) from an FCTopology or list thereof. Here `sectors` is a list of sectors need to be reduced, e.g. `{{1,0,0,0}, {1,1,0,0}, {1,1,1,0}}` etc.*)


(* ::Text:: *)
(*The functions creates the corresponding yaml files and saves them  in path/topoName/config. Using `KiraCreateConfigFiles[{topo1, topo2, ...}, {sectors1, sectors2, ...},  path]` will save the scripts to `path/topoName1`, `path/topoName2` etc. The syntax `KiraCreateConfigFiles[{topo1, topo2, ...}, {sectors1, sectors2, ...},  {path1, path2, ...}]` is also possible.*)


(* ::Text:: *)
(*If the directory specified in `path/topoName` does not exist, it will be created automatically. If it already exists, its content will be automatically overwritten, unless the option `OverwriteTarget` is set to `False`.*)


(* ::Text:: *)
(*It is also possible to supply a list of `GLI`s instead of sectors. In that case `FCLoopFindSectors` will be used to determine the top sector for each topology.*)


(* ::Text:: *)
(*The syntax  `KiraCreateConfigFiles[{topo1, topo2, ...}, {sectors1, sectors2, ...}, path]` or `KiraCreateConfigFiles[{topo1, topo2, ...}, {glis1, glis2, ...},  path]` is also allowed. This implies that all config files will go into the corresponding subdirectories of path, e.g. `path/topoName1/config`, `path/topoName2/config` etc.*)


(* ::Text:: *)
(*The mass dimension of all kinematic variables should be specified via the option `KiraMassDimensions` e.g. as in `{{m1->1},{M->1},{msq->2}}`.*)


(* ::Text:: *)
(*If the amplitude originally contained any external momenta that were eliminated using momentum conservation, .e.g. by replacing $k_2$ by $P-k_1$ for $P=k_1+k_2$, those momenta must be nevertheless specified via the option `KiraImplicitIncomingMomenta`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [KiraMassDimensions](KiraMassDimensions.md), [KiraImplicitIncomingMomenta](KiraImplicitIncomingMomenta.md).*)


(* ::Subsection:: *)
(*Examples*)


topo=FCTopology["asyR1prop2Ltopo01310X11111N1", {SFAD[{p1, 0}], 
SFAD[{p3,mg^2}], SFAD[{{0,2*p3.q}}], 
SFAD[{(p1 + q), mb^2}], SFAD[{{0, p1 . p3}}]}, 
{p1, p3}, {q}, {Hold[SPD][q, q] -> mb^2}, {}]


fileName=KiraCreateConfigFiles[topo,{{1,1,1,1,1}},
FileNameJoin[{$FeynCalcDirectory,"Database"}],KiraMassDimensions->{mb->1,mg->1}];


fileName[[1]]//FilePrint


fileName[[2]]//FilePrint


topos={
FCTopology["asyR3prop2Ltopo01310X11111N1", {SFAD[{{-p1, 0}, {0, 1}, 1}], SFAD[{{-p3, 0}, {mg^2, 1}, 1}], SFAD[{{0, 2*p3 . q}, {0, 1}, 1}], 
SFAD[{{0, 2*p1 . q}, {0, 1}, 1}], SFAD[{{-p1 + p3, 0}, {0, 1}, 1}]}, {p1, p3}, {q}, {Hold[SPD][q, q] -> mb^2}, {}], 
 FCTopology["asyR1prop2Ltopo01310X11111N1", {SFAD[{{-p1, 0}, {0, 1}, 1}], SFAD[{{-p3, 0}, {mg^2, 1}, 1}], SFAD[{{0, 2*p3 . q}, {0, 1}, 1}],
  SFAD[{{-p1 - q, 0}, {mb^2, 1}, 1}], SFAD[{{0, -p1 . p3}, {0, 1}, 1}]}, {p1, p3}, {q}, {Hold[SPD][q, q] -> mb^2}, {}]
 }


{GLI["asyR3prop2Ltopo01310X11111N1",{1,1,1,1,2}],GLI["asyR1prop2Ltopo01310X11111N1",{1,1,1,1,2}]}


fileNames=KiraCreateConfigFiles[topos,{GLI["asyR3prop2Ltopo01310X11111N1",{1,1,1,1,2}],GLI["asyR1prop2Ltopo01310X11111N1",{1,1,1,1,2}]},
FileNameJoin[{$FeynCalcDirectory,"Database"}],KiraMassDimensions->{mb->1,mg->1}]


FilePrint[fileNames[[1]][[1]]]


FilePrint[fileNames[[1]][[2]]]


FilePrint[fileNames[[2]][[1]]]


FilePrint[fileNames[[2]][[2]]]
