(* ::Package:: *)

 


(* ::Section:: *)
(*FIREReduceLoopIntegrals*)


(* ::Text:: *)
(*`FIREReduceLoopIntegrals[glis, topos, path]` performs IBP reduction of loop*)
(*integral listed in `glis` from the families given in `topos` using C++ FIRE. It returns reduction tables obtained from FIRE.*)
(**)


(* ::Text:: *)
(*Since all processes are started from the current Mathematica notebook, it can be reliably used only for simple integrals and topologies.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FIRERunReduction](FIRERunReduction.md).*)


(* ::Subsection:: *)
(*Examples*)


glis=Get[FileNameJoin[{$FeynHelpersDirectory,"Documentation","Examples","glglToHH1L","glis.m"}]];


glis//Length


glis[[1;;5]]


topos=Get[FileNameJoin[{$FeynHelpersDirectory,"Documentation","Examples","glglToHH1L","topos.m"}]];


topos[[1]]//FCE


dir=FileNameJoin[{$TemporaryDirectory,"Docu-Reduction-glglToHH-1L"}];


tables=FIREReduceLoopIntegrals[glis,topos,dir];


tables[[1;;3]]
