(* ::Package:: *)

 


(* ::Section:: *)
(*QGTZFCreateFieldStyles*)


(* ::Text:: *)
(*`QGTZFCreateTeXFiles[model_, output_]` generates TikZ-Feynman stylings for the fields present in the QGRAF model file `model`. The resulting file containing the stylings set via `tikzset` and `tikzfeynmanset`is saved to `output`.*)


(* ::Text:: *)
(*It is also possible to invoke the function via `QGTZFCreateTeXFiles[model, qgOutput]` where `qgOutput` is the output `QGCreateAmp`.*)


(* ::Text:: *)
(*The stylings can be generated in a semi-automatic fashion but for higher quality results it is recommended to provide the necessary information for each field via the option `QGFieldStyles`. It is a list of lists, where each sublist contains the field name (e.g. `El`), its type (e.g. `photon`, `boson`, `fermion`, `anti fermion` etc.) and its T EX label.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [QGConvertToFC](QGConvertToFC.md), [QGCreateAmp](QGCreateAmp.md), [QGTZFCreateTeXFiles](QGTZFCreateTeXFiles.md).*)


(* ::Subsection:: *)
(*Examples*)


qgModel=FileNameJoin[{$FeynHelpersDirectory,"Documentation",
"Examples","Phi4","Phi4"}];


tikzStyles=QGTZFCreateFieldStyles[qgModel,$TemporaryDirectory,
QGFieldStyles->{{"Phi","scalar","\\phi"}}];


FilePrint[tikzStyles]
