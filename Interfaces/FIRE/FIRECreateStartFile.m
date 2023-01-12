(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRECreateStartFile												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Creates FIRE start files									*)

(* ------------------------------------------------------------------------ *)

FIRECreateStartFile::usage=
"FIRECreateStartFile[path] creates a FIRE .start file using the script
CreateStartFile.m in path. To that aim a Mathematica kernel is started in the
background via RunProcess. The function returns True if the evaluation
succeeds and False otherwise.

Alternatively, one can use FIRECreateStartFile[path, topo] where topo is an
FCTopology symbol and the full path is implied to be
path/topoName/CreateStartFile.m.

If you need to process a list of topologies, following syntaxes are possible
FIRECreateStartFile[{path1,path2, ...}], FIRECreateStartFile[path, {topo1,
topo2, ...}]

The path to the Mathematica Kernel can be specified via
FIREMathematicaKernelPath. The default value is Automatic.";

FIREMathematicaKernelPath::usage=
"FIREMathematicaKernelPath is an option for FIRECreateStartFile and other
functions of the FIRE interface.

It specifies the full path to the Mathematica Kernel that will be used to run
FIRE. The default value is Automatic.";

FIREShowOutput::usage=
"QGShowOutput is an option for FIRECreateStartFile and other FIRE-related functions.
When set to True, the output of the current process run will be shown via Print.
When set to False the output is suppressed.";

FIRECreateStartFile::failmsg =
"Error! FIRECreateStartFile has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIRECreateStartFile`Private`"]

fcsfVerbose::usage="";

Options[FIRECreateStartFile] = {
	FCVerbose					-> False,
	FIREMathematicaKernelPath	-> Automatic,
	FIREShowOutput				-> False,
	OverwriteTarget				-> True
};

FIRECreateStartFile[pathsRaw:{__String}, opts:OptionsPattern[]] :=
	FIRECreateStartFile[#, opts]&/@pathsRaw;

FIRECreateStartFile[pathRaw_String, topos:{__FCTopology}, opts:OptionsPattern[]] :=
	FIRECreateStartFile[FileNameJoin[{pathRaw,ToString[#[[1]]]}], opts]&/@topos;

FIRECreateStartFile[pathRaw_String, topo_FCTopology, opts:OptionsPattern[]] :=
	FIRECreateStartFile[FileNameJoin[{pathRaw,ToString[topo[[1]]]}], opts];

FIRECreateStartFile[pathRaw_String, OptionsPattern[]] :=
	Block[{ path, optFIREMathematicaKernelPath, scriptFile, out, dir,
			exitCode, res, optFIREShowOutput, output},

		If[	OptionValue[FCVerbose]===False,
			fcsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fcsfVerbose=OptionValue[FCVerbose]
			];
		];

		optFIREMathematicaKernelPath = OptionValue[FIREMathematicaKernelPath];
		optFIREShowOutput			 = OptionValue[FIREShowOutput];

		If[	optFIREMathematicaKernelPath===Automatic,
			Switch[$OperatingSystem,
				"Unix",
					optFIREMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "Executables", "math"}],
				"MacOSX",
					optFIREMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "MacOS", "math"}],
				"Windows",
					optFIREMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "math.exe"}],
				_,
					Message[FIRECreateStartFile::failmsg,"Unsupported operating system!."];
					Abort[]
			];

		];

		If[	!FileExistsQ[optFIREMathematicaKernelPath],
			Message[FIRECreateStartFile::failmsg, "Mathematica kernel not found. Please check the path ", optFIREMathematicaKernelPath];
			Abort[]
		];

		Which[
			FileExistsQ[pathRaw] && !DirectoryQ[pathRaw],
				path = pathRaw,
			FileExistsQ[pathRaw] && DirectoryQ[pathRaw],
				path = FileNameJoin[{pathRaw,"CreateStartFile.m"}];
				If[	!FileExistsQ[path],
					Message[FIRECreateStartFile::failmsg, "Invalid path ", path];
					Abort[]
				],
			True,
			Message[FIRECreateStartFile::failmsg, "Invalid path ", pathRaw, " does not exist."];
			Abort[]
		];

		dir = DirectoryName[path];
		scriptFile = FileNameTake[path];

		If[	FileExistsQ[FileNameJoin[{dir,Last[FileNameSplit[dir]]<>".start"}]] && !OptionValue[OverwriteTarget],
			FCPrint[0,"FIRECreateStartFile: Start file already exists and the option OverwriteTarget is set to False, so skipping.", FCDoControl->fcsfVerbose];
			Return[True]
		];


		FCPrint[2,"FIRECreateStartFile: Full path to the Math Kernel binary: ", optFIREMathematicaKernelPath, FCDoControl->fcsfVerbose];
		FCPrint[2,"FIRECreateStartFile: Working directory: ", dir, FCDoControl->fcsfVerbose];
		FCPrint[2,"FIRECreateStartFile: Script file: ", scriptFile, FCDoControl->fcsfVerbose];

		If[	$VersionNumber >= 10.,
			out = RunProcess[{optFIREMathematicaKernelPath, "-noprompt", "-script", scriptFile}, ProcessDirectory -> dir];
			FCPrint[3,"FIRECreateStartFile: Running: ", StringRiffle[{optFIREMathematicaKernelPath, "-noprompt", "-script", scriptFile}, " "],
				FCDoControl->fcsfVerbose];
			If[	out===$Failed,
				Message[FIRECreateStartFile::failmsg,"Failed to generate the start file."];
				Abort[]
			];

			output = out["StandardOutput"];
			exitCode = out["ExitCode"],

			Message[FIRECreateStartFile::failmsg, "Mathematica versions older than 10. are not supported."];
			Abort[]
		];

		If[	optFIREShowOutput=!=False,
			Print["Mathematica output:"];
			Print[StringTrim[output]]
		];

		If[	TrueQ[exitCode===0],
			res = True,

			Message[FIRECreateStartFile::failmsg, "Mathematica process returned exit code: " <> ToString[exitCode] <>
			" .Please run the script manually to better understand the issue."
			];
			res = False
		];

		res

	];



End[]
