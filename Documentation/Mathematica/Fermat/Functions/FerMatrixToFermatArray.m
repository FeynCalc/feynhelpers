(* ::Package:: *)

 


(* ::Section:: *)
(*FerMatrixToFermatArray*)


(* ::Text:: *)
(*`FerMatrixToFermatArray[mat,varName]` is an auxiliary function that converts the matrix `mat` to a Fermat array named `varName`, where the latter must be a string.*)


(* ::Text:: *)
(*The function returns a string that represents the matrix, a list of auxiliary variables (introduced to be compatible with the restrictions of Fermat) and a replacement rule for converting auxiliary variables back into the original variables.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md).*)


(* ::Subsection:: *)
(*Examples*)


FerMatrixToFermatArray[{{a,b},{c,d}},"mat"]
