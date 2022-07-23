(* ::Package:: *)

 


(* ::Section:: *)
(*FerCommand*)


(* ::Text:: *)
(*`FerCommand[str, args]` is an auxiliary function that returns a Fermat command corresponding to `str` (possibly using arguments `args`) as a list of strings.*)


(* ::Text:: *)
(*At the moment only a very limited set of Fermat instructions is implemented.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md).*)


(* ::Subsection:: *)
(*Examples*)


FerCommand["Quit"]


FerCommand["StopReadingFromTheInputFile"]


FerCommand["EnableUglyDisplay"]


FerCommand["ReadFromAnInputFile", "myFile.txt"]


FerCommand["SaveToAnOutputFile", "myFile.txt"]


FerCommand["SaveSpecifiedVariablesToAnOutputFile", {x,y,z}]


FerCommand["ReducedRowEchelonForm", "mat"]


FerCommand["AdjoinPolynomialVariable", x]
