(* ::Package:: *)

 


(* ::Section:: *)
(*PSDLoopIntegralFromPropagators*)


(* ::Text:: *)
(*`PSDLoopIntegralFromPropagators[int, topo]` is an auxiliary function that converts the given loop integral (in the `GLI` representation) belonging to the topology `topo` into input for pySecDec's `LoopIntegralFromPropagators` routine. The output is given as a list of two elements, containing a string and the prefactor of the integral. `PSDLoopIntegralFromPropagators`*)


(* ::Text:: *)
(*`PSDLoopIntegralFromPropagators` is used by `PSDCreatePythonScripts` when assembling the generation script.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md), [PSDIntegrate](PSDIntegrate.md), [PSDLoopPackage](PSDLoopPackage.md), [PSDLoopRegions](PSDLoopRegions.md).*)


(* ::Subsection:: *)
(*Examples*)


topo=FCTopology["prop3lX1",{SFAD[{p1,m^2}],SFAD[p2],SFAD[{p3,m^2}],SFAD[Q-p1-p2-p3],SFAD[Q-p1-p2],SFAD[Q-p1],SFAD[Q-p2],SFAD[p1+p3],SFAD[p2+p3]},{p1,p2,p3},{Q},{},{}]


PSDLoopIntegralFromPropagators[GLI["prop3lX1",{1,1,1,1,1,1,0,0,0}],topo]


PSDLoopIntegralFromPropagators[GLI["prop3lX1",{1,1,1,1,1,0,0,0,0}],topo,FinalSubstitutions->{FCI@SPD[Q]->QQ,m^2->mm}]
