(* ::Package:: *)

 


(* ::Section:: *)
(*FIRERunReduction*)


(* ::Text:: *)
(*`FIRERunReduction[path]` runs C++ FIRE on the FIRE .config file specified by path.  To that aim the FIRE binary is started in the background via `RunProcess`. The function returns `True` if the evaluation succeeds and `False` otherwise.*)


(* ::Text:: *)
(*If `path` represents a full path to a file, then this file is used as the .config file. If it is just a path to a directory, then `path/topoName/topoName.config` is assumed to be the full path.*)


(* ::Text:: *)
(*The default path to the FIRE binary is `FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE6", "bin", "FIRE6"}]`. It can be modified via the option `FIREBinaryPath`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIRECreateStartFile](FIRECreateStartFile.md).*)


(* ::Subsection:: *)
(*Examples*)


FIRERunReduction[FileNameJoin[{$FeynHelpersDirectory,"Documentation","Examples","asyR2prop2Ltopo13311X01201N1"}],FCVerbose->3]
