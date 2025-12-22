(* ::Package:: *)

 


(* ::Section:: *)
(*FIREToFCTopology*)


(* ::Text:: *)
(*`FIREToFCTopology[props, lmoms, emoms]` converts the list of FIRE propagators `props` that depend on the loop momenta `lmoms` and external momenta `emoms` into a proper `FCTopology` object.*)


(* ::Text:: *)
(*Use the option `Names` to specify the `id` of the resulting topology.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIREPrepareStartFile](FIREPrepareStartFile.md).*)


(* ::Subsection:: *)
(*Examples*)


props1={p1^2,p2^2,p3^2,(Q-p1-p2-p3)^2,(Q-p1-p2)^2,(Q-p1)^2,(Q-p2)^2,(p1+p3)^2,(p2+p3)^2}


FIREToFCTopology[props1,{p1,p2,p3},{Q}]


(* ::Text:: *)
(*By default the function assumes the standard $i \eta$-prescription as in $1/(p^2 -m^2 + i \eta)$. However, if you are using "reversed" propagators that are often preferred in FIRE and FIESTA, then what you have is $1/(- p^2 + m^2 - i \eta)$, although the propagator is still Minkowskian. In this case you should use the option `EtaSign` and set it to `-1`*)


props2={-p1^2+m^2,-p2^2+m^2,-p3^2+m^2,-(-Q+p1+p2+p3)^2,-(p1+p2-Q)^2,-(p1-Q)^2,-(p2-Q)^2,-(p1+p3)^2,-(p2+p3)^2}


FIREToFCTopology[props2,{p1,p2,p3},{Q},EtaSign->-1,Names->myTopo]


(* ::Text:: *)
(*Notice that the polynomials in the FIRE propagators should not be expanded. Otherwise, there is a high chance that the conversion will fail.*)


FIREToFCTopology[ExpandAll[props1],{p1,p2,p3},{Q}]
