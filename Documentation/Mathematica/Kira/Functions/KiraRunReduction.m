(* ::Package:: *)

 


(* ::Section:: *)
(*KiraRunReduction*)


(* ::Text:: *)
(*`KiraRunReduction[path]` runs Kira on the job  file specified by path.  To that aim the Kira binary is started in the background via `RunProcess`. The function returns `True` if the evaluation succeeds and `False` otherwise.*)


(* ::Text:: *)
(*If `path` represents a full path to a file, then this file is used as the .config file. If it is just a path to a directory, then `path/topoName/job.yaml` is assumed to be the full path.*)


(* ::Text:: *)
(*The default path to the Kira binary is just `kira`. It can be modified via the option `KiraBinaryPath`.*)


(* ::Text:: *)
(*Notice that in order to use this routine you must also specify the path to the FERMAT binary that Kira uses internally. This is done via the option `KiraFermatPath`. The default value is `Automatic` meaning that suitable binaries are expected to be located in `FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "Fermat"}]`*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIRECreateStartFile](FIRECreateStartFile.md).*)


(* ::Subsection:: *)
(*Examples*)


KiraRunReduction[FileNameJoin[{$FeynHelpersDirectory,"Documentation","Examples","asyR1prop2Ltopo01310X11111N1"}],FCVerbose->3]
