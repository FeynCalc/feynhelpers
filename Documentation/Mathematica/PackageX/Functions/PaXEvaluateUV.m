(* ::Package:: *)

 


(* ::Section:: *)
(*PaXEvaluateUV*)


(* ::Text:: *)
(*`PaXEvaluateUV[expr,q]` is like `PaXEvaluate` but with the difference that it returns only the UV-divergent part of the result.*)


(* ::Text:: *)
(*The evaluation is using H. Patel's Package-X.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PaXEvaluateIR](PaXEvaluateIR.md), [PaXEvaluate](PaXEvaluate.md), [PaXEvaluateUVIRSplit](PaXEvaluateUVIRSplit.md).*)


(* ::Subsection:: *)
(*Examples*)


int=-FAD[{k, m}] + 2*FAD[k, {k - p, m}]*(m^2 + SPD[p, p])


PaXEvaluateUV[%, k, PaXImplicitPrefactor -> 1/(2 Pi)^D, FCE -> True]


(* ::Text:: *)
(*Notice that with `PaVeUVPart` one can get the same result*)


res=PaVeUVPart[ToPaVe[int,k],Prefactor->1/(2 Pi)^D]


Series[FCReplaceD[res,D->4-2EpsilonUV],{EpsilonUV,0,0}]//Normal//SelectNotFree2[#,EpsilonUV]&//ExpandAll


int2 = TID[FVD[2 k - p, mu] FVD[2 k - p, nu] FAD[{k, m}, {k - p, m}] - 2 MTD[mu, nu] FAD[{k, m}], k]


PaXEvaluateUV[int2, k, PaXImplicitPrefactor -> 1/(2 Pi)^D, FCE -> True]
