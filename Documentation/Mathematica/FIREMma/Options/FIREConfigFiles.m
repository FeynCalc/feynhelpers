(* ::Package:: *)

 


(* ::Section:: *)
(*FIREConfigFiles*)


(* ::Text:: *)
(*`FIREConfigFiles` is an option for `FIREBurn`. It specifies, where the three files that contain all the FIRE configuration are saved.*)


(* ::Text:: *)
(*The first file contains the lists of loop momenta, external momenta and propagators. Normally it ends with the FIRE command `SaveStart`.*)


(* ::Text:: *)
(*The second file loads the .start file that was generated previously and reduces the given loop integrals.*)


(* ::Text:: *)
(*Finally, the third file contains replacement rules for the introduced abbreviations. The default location of these files is the `Database` folder inside `$FeynCalcDirectory`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FIREBurn](FIREBurn.md).*)


(* ::Subsection:: *)
(*Examples*)
