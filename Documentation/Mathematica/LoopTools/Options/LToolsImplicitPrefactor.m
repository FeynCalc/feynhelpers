(* ::Package:: *)

 


(* ::Section:: *)
(*LToolsImplicitPrefactor*)


(* ::Text:: *)
(*`LToolsImplicitPrefactor` is an option for `LToolsEvaluate`. It specifies a prefactor that does not show up explicitly in the input expression, but is understood to appear in front of every Passarino-Veltman function. The default value is `1`.*)


(* ::Text:: *)
(*You may want to use `LToolsImplicitPrefactor->1/(2Pi)^D` when working with 1-loop amplitudes, if no explicit prefactor has been introduced from the very beginning.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [LToolsEvaluate](LToolsEvaluate.md).*)


(* ::Subsection:: *)
(*Examples*)


LToolsLoadLibrary[]


(* ::Text:: *)
(*Here the prefactor $i \pi^2$ arises from the conversion of $\int d^D q\, 1/(q^2-m^2)$ to $A_0(m^2)$*)


LToolsEvaluate[FAD[{q,m}],q,InitialSubstitutions->{m->5}]


LToolsEvaluate[FAD[{q,m}],q,InitialSubstitutions->{m->5},Head->keep]


(* ::Text:: *)
(*This recovers the textbook prefactor*)


LToolsEvaluate[FAD[{q,m}],q,InitialSubstitutions->{m->5},LToolsImplicitPrefactor->1/(2Pi)^(4-2Epsilon)]


(PaXEvaluate[FAD[{q,m}],q,PaXImplicitPrefactor->1/(2Pi)^(4-2Epsilon)]/.{m->5,ScaleMu^2->1})//N


(* ::Text:: *)
(*If the input expression contains both loop and non-loop terms, only the terms containing a `PaVe`-function will be multiplied*)
(*by the implicit prefactor*)


LToolsEvaluate[extra+FAD[{q,m}],q,InitialSubstitutions->{m->2},LToolsExpandInEpsilon->False]
