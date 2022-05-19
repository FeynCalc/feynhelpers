(* ::Package:: *)

 


(* ::Section:: *)
(*PaXDiscExpand*)


(* ::Text:: *)
(*`PaXDiscExpand` is an option for `PaXEvaluate`. If set to `True`, Package-X function `DiscExpand` will be applied to the output*)
(*of Package-X thus replacing `DiscB` by its explicit form.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PaXEvaluate](PaXEvaluate.md).*)


(* ::Subsection:: *)
(*Examples*)


PaVe[0,0,1,{SP[p,p],0,m^2},{m^2,m^2,m^2}]
PaXEvaluate[%]


PaVe[0,0,1,{SP[p,p],0,m^2},{m^2,m^2,m^2}]
PaXEvaluate[%,PaXDiscExpand->False]
