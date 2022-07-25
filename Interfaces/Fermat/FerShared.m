(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FerShared														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and Fermat						*)

(* ------------------------------------------------------------------------ *)


FerInputFile::usage =
"FerInputFile is an option for multiple functions of the Fermat interface. It
specifies the location of the file containing the input for a Fermat
calculation. If set to Automatic (default), a temporary file will be
automatically created and removed after a successful evaluation.";

FerOutputFile::usage =
"FerOutputFile is an option for various functions of the Fermat interface. It
specifies the location of the file containing the output of Fermat
calculation. If set to Automatic (default), a temporary file will be
automatically created and removed after a successful evaluation.";

FerScriptFile::usage =
"FerScriptFile is an option for various functions of the Fermat interface. It
specifies the location of the file containing instructions for Fermat. If set
to Automatic (default), a temporary file will be automatically created and
removed after a successful evaluation.";

FerPath::usage=
"FerPath is an option for FerRunScript and other functions of the Fermat
interface and multiple other Fer* functions. It specifies the full path to the
Fermat binary.

If set to Automatic, Fermat binaries are expected to be located in
FileNameJoin[{$FeynHelpersDirectory, \"ExternalTools\", \"Fermat\", \"ferl6\",
\"fer64\"}] and FileNameJoin[{$FeynHelpersDirectory, \"ExternalTools\",
\"Fermat\",\"ferm6\", \"fer64\"}] for Linux and macOS respectively.";

FerShared::failmsg =
"Error! Fermat interface has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

Begin["`Package`"]

End[]

Begin["`FerShared`Private`"]

FeynCalc`Package`ferWriteFiles[inFile_String, scriptFile_String, input_String, script_String] :=
	Block[{file},

		FCPrint[1,"ferWriteFiles: Entering."];

		FCPrint[3,"ferWriteFiles: inFile: ", inFile];
		FCPrint[3,"ferWriteFiles: scriptFile: ", scriptFile];

		FCPrint[3,"ferWriteFiles: input: ", input];
		FCPrint[3,"ferWriteFiles: script: ", script];


		file = OpenWrite[inFile];
		If[file===$Failed,
			Message[FerShared::failmsg, "Failed to write the Fermat input file."];
			Abort[]
		];
		WriteString[inFile, input];
		Close[file];

		file = OpenWrite[scriptFile];
		If[file===$Failed,
			Message[FerShared::failmsg, "Failed to write the Fermat script file."];
			Abort[]
		];
		WriteString[scriptFile, script];
		Close[file];

		FCPrint[1,"ferWriteFiles: Leaving."];
];



End[]

