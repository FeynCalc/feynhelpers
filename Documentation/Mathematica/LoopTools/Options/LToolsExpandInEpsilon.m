(* ::Package:: *)

 


(* ::Section:: *)
(*LToolsExpandInEpsilon*)


(* ::Text:: *)
(*`LToolsExpandInEpsilon` is an option for `LToolsEvaluate`. When set to `True` (default), the result returned by LoopTools and multiplied with proper conversion factors will be expanded around $\varepsilon = 0$ to $\mathcal{O}(\varepsilon^0)$.*)


(* ::Text:: *)
(*The $\varepsilon$-dependent conversion factors arise from the differences in the normalization between Passarino-Veltman functions in FeynCalc and LoopTools. In addition to that, the prefactor specified via `LToolsImplicitPrefactor` may also depend on $\varepsilon$.*)


(* ::Text:: *)
(*Setting this option to `False` will leave the prefactors unexpanded, which  might sometimes be useful when examining the obtained results.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [LToolsEvaluate](LToolsEvaluate.md), [LToolsImplicitPrefactor](LToolsImplicitPrefactor.md).*)


(* ::Subsection:: *)
(*Examples*)


LToolsLoadLibrary[]


(* ::Text:: *)
(*The default behavior of `LToolsEvaluate` is to do the $\varepsilon$-expansion automatically*)


LToolsEvaluate[FAD[q,q-p],q,InitialSubstitutions->{SPD[p]->1}]


(* ::Text:: *)
(*This can be disabled by setting `LToolsExpandInEpsilon` to `False`*)


LToolsEvaluate[FAD[q,q-p],q,InitialSubstitutions->{SPD[p]->1},LToolsExpandInEpsilon->False]
