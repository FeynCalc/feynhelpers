(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: KiraRunReduction													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2022-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Runs Kira 													*)

(* ------------------------------------------------------------------------ *)


KiraRunReduction::usage=
"KiraRunReduction[path] runs Kira on the job  file specified by path.  To that
aim the Kira binary is started in the background via RunProcess. The function
returns True if the evaluation succeeds and False otherwise.

If path represents a full path to a file, then this file is used as the
.config file. If it is just a path to a directory, then path/topoName/job.yaml
is assumed to be the full path.

The default path to the Kira binary is just kira. It can be modified via the
option KiraBinaryPath.

Notice that in order to use this routine you must also specify the path to the
FERMAT binary that Kira uses internally. This is done via the option
KiraFermatPath. The default value is Automatic meaning that suitable binaries
are expected to be located in FileNameJoin[{$FeynHelpersDirectory,
\"ExternalTools\", \"Fermat\"}]";


KiraBinaryPath::usage=
"KiraBinaryPath is an option for KiraRunReduction and other Kira-related
functions.

It specifies the path to the Kira binary. The default value is just \"kira\".";

KiraFermatPath::usage=
"KiraFermatPath is an option for KiraRunReduction and other Kira-related
functions.

It specifies the full path to the Fermat binary used by Kira to run the
reduction. This is done via the option KiraFermatPath. The default value is
Automatic meaning that suitable binaries are expected to be located in
FileNameJoin[{$FeynHelpersDirectory, \"ExternalTools\", \"Fermat\"}]";

KiraShowOutput::usage=
"KiraShowOutput is an option for KiraRunReduction and other Kira-related
functions.

When set to True, the output of the current process run will be shown via
Print. When set to False the output is suppressed.";


KiraRunReduction::failmsg =
"Error! KiraRunReduction has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`KiraRunReduction`Private`"]

krrVerbose::usage="";


Options[KiraRunReduction] = {
	FCVerbose			-> False,
	KiraShowOutput		-> False,
	KiraBinaryPath		-> "kira",
	KiraJobFileName		-> "job.yaml",
	KiraFermatPath		-> Automatic
};

KiraRunReduction[input_List, opts:OptionsPattern[]]:=
	KiraRunReduction[#,opts]&/@input;

KiraRunReduction[pathRaw_String, topos:{__FCTopology}, opts:OptionsPattern[]] :=
	KiraRunReduction[FileNameJoin[{pathRaw,ToString[#[[1]]]}], opts]&/@topos;

KiraRunReduction[pathRaw_String, OptionsPattern[]] :=
	Block[{	path, dir, optKiraBinaryPath, out, exitCode,
			res, output, optKiraShowOutput, optKiraJobFileName, optKiraFermatPath,
			pathToFermat},

		If[	OptionValue[FCVerbose]===False,
			krrVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				krrVerbose=OptionValue[FCVerbose]
			];
		];

		optKiraBinaryPath	= OptionValue[KiraBinaryPath];
		optKiraShowOutput	= OptionValue[KiraShowOutput];
		optKiraJobFileName	= OptionValue[KiraJobFileName];
		optKiraFermatPath	= OptionValue[KiraFermatPath];

		Which[
			FileExistsQ[pathRaw] && !DirectoryQ[pathRaw],
				path = pathRaw,
			FileExistsQ[pathRaw] && DirectoryQ[pathRaw],
				path = FileNameJoin[{pathRaw,optKiraJobFileName}];
				If[	!FileExistsQ[path],
					Message[KiraRunReduction::failmsg, "The file " <> path <> " does not exist."];
					Abort[]
				],
			True,
			Message[KiraRunReduction::failmsg, "The path " <> pathRaw <> " does not exist."];
			Abort[]
		];




		If[	optKiraFermatPath=!=Automatic,
			pathToFermat = optKiraFermatPath,
			Switch[$OperatingSystem,
				"Unix",
					pathToFermat = FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "Fermat", "ferl6", "fer64"}],
				"MacOSX",
					pathToFermat = FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "Fermat", "ferm6", "fer64"}],
				_,
					Message[KiraRunReduction::failmsg,"Recent versions of Fermat are available only for Linux and macOS."];
					Abort[]
			];
		];

		FCPrint[2,"KiraRunReduction: Path to the Fermat binary: ", pathToFermat, FCDoControl->krrVerbose];

		SetEnvironment["FERMATPATH" -> pathToFermat];

		(*
		If[	!FileExistsQ[optKiraBinaryPath],
			Message[KiraRunReduction::failmsg, "Kira binary  " <> optKiraBinaryPath <> " does not exist."];
			Abort[]
		];*)

		dir = DirectoryName[path];


		FCPrint[2,"KiraRunReduction: Path to the Kira binary: ", optKiraBinaryPath, FCDoControl->krrVerbose];
		FCPrint[2,"KiraRunReduction: Working directory: ", dir, FCDoControl->krrVerbose];
		FCPrint[2,"KiraRunReduction: Job file: ", optKiraJobFileName, FCDoControl->krrVerbose];

		If[	$VersionNumber >= 10.,
			out = RunProcess[{optKiraBinaryPath, optKiraJobFileName}, ProcessDirectory -> dir];
			If[	out===$Failed,
				Message[KiraRunReduction::failmsg,"Failed to execute the Kira binary."];
				Abort[]
			];

			output = out["StandardOutput"];
			exitCode = out["ExitCode"],

			Message[KiraRunReduction::failmsg, "Mathematica versions older than 10. are not supported."];
			Abort[]
		];

		If[	optKiraShowOutput=!=False,
			Print["Kira output:"];
			Print[StringTrim[output]]
		];

		If[	TrueQ[exitCode===0],
			res = True,
			res = False
		];

		res
	];



End[]
