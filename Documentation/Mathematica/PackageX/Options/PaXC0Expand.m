(* ::Package:: *)

 


(* ::Section:: *)
(*PaXC0Expand*)


(* ::Text:: *)
(*`PaXC0Expand` is an option for `PaXEvaluate`. If set to `True`, Package-X function `C0Expand` will be applied to the output of Package-X.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PaXEvaluate](PaXEvaluate.md).*)


(* ::Subsection:: *)
(*Examples*)


PaVe[0,0,1,{SP[p,p],SP[p,p],m^2},{m^2,m^2,m^2}]
PaXEvaluate[%]


(* ::Text:: *)
(*The full result is a `ConditionalExpression`*)


PaVe[0,0,1,{SP[p,p],SP[p,p],m^2},{m^2,m^2,m^2}]
res=PaXEvaluate[%,PaXC0Expand->True];


res//Short
res//Last


(* ::Text:: *)
(*Use `Normal` to get the actual expression*)


(res//Normal)
