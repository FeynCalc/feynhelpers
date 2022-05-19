(* ::Package:: *)

 


(* ::Section:: *)
(*FIREBurn*)


(* ::Text:: *)
(*`FIREBurn[expr, {q1, q2, ...}, {p1, p2, ...}]` reduces loop integrals with loop momenta `q1, q2, ...` and external momenta `p1, p2, ...` with integration-by-parts (IBP) relations.*)


(* ::Text:: *)
(*`FIREBurn` expects that the input does not contain any loop integrals with linearly dependent propagators. Therefore, prior to starting the reduction, use `ApartFF`.*)


(* ::Text:: *)
(*The evaluation is done on a parallel kernel using A.V. Smirnov's and V.A. Smirnov's FIRE.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md).*)


(* ::Subsection:: *)
(*Examples*)


int=SFAD[{p, m^2, 2}, {{0, 2 p.k}, m^2, 3}]


FIREBurn[int, {p}, {k},Timing->False]
