(* ::Package:: *)

 


(* ::Section:: *)
(*LToolsFullResult*)


(* ::Text:: *)
(*`LToolsFullResult` is an option for `LToolsEvaluate`. When set to `True` (default),  `LToolsEvaluate` will return the full result including singularities and accompanying terms. Otherwise, only the finite part (standard output of LoopTools) will be provided.*)


(* ::Text:: *)
(*The full result is assembled from pieces returned by LoopTools for the $\lambda^2$-parameter set to $-2$, $-1$ and $0$ respectively. The correct prefactor that accounts for the normalization differences between Passarino-Veltman function in FeynCalc and LoopTools is added as well.*)


(* ::Text:: *)
(*As long as `LToolsFullResult` is set to `True`, the value of the `LToolsSetLambda` option is ignored.*)


(* ::Text:: *)
(*Disabling `LToolsFullResult` will most likely lead to incorrect normalization of the results (especially if you are only interested in the finite part). The reason for this are missing contributions to the finite part generated from poles being multiplied by terms proportional to $\varepsilon$ or $\varepsilon^2$.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [LToolsEvaluate](LToolsEvaluate.md).*)


(* ::Subsection:: *)
(*Examples*)


LToolsLoadLibrary[];


LToolsEvaluate[A0[m^2],InitialSubstitutions->{m^2->1}]


(* ::Text:: *)
(*Setting `LToolsFullResult` to `False` will make `LToolsEvaluate` return only the  finite part since the default value for*)
(*`LToolsSetLambda` is `0`. However, the normalization does not agree with the FeynCalc convention*)


LToolsEvaluate[A0[m^2],InitialSubstitutions->{m^2->1},LToolsFullResult->False]


(* ::Text:: *)
(*Even though `LToolsEvaluate` includes the correct prefactor to convert to the FeynCalc normalization, the finite contribution*)
(*generated by the $1/\varepsilon$-pole is missing here.*)


finRes=LToolsEvaluate[A0[m^2],InitialSubstitutions->{m^2->1},LToolsFullResult->False,LToolsExpandInEpsilon->False]


(* ::Text:: *)
(*By setting `LToolsSetLambda->-1` we can get the coefficient of the pole. Here it is obvious that the function is IR-finite so that*)
(*we do not need to check for the $1/\varepsilon^2$-pole*)


poleRes=LToolsEvaluate[A0[m^2],InitialSubstitutions->{m^2->1},LToolsFullResult->False,LToolsExpandInEpsilon->False,LToolsSetLambda->-1]


(* ::Text:: *)
(*Combining both pieces and expanding in $\varepsilon$ up to zeroth order we recover the same result as when using the option*)
(*`LToolsFullResult`*)


Series[1/Epsilon poleRes+finRes,{Epsilon,0,0}]//Normal
