(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRECreateLiteRedFiles												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Creates lbases files										*)

(* ------------------------------------------------------------------------ *)

FIRECreateLiteRedFiles::usage=
"FIRECreateLiteRedFiles[path] creates lbases  files (generated with LiteRed)
using the script CreateLiteRedFiles.m in path. To that aim a Mathematica
kernel is started in the background via RunProcess. The function returns True
if the evaluation succeeds and False otherwise.

Notice that lbases files must be created before generating sbases using
FIRECreateStartFiles (or running the
respective scripts directly) .

Alternatively, one can use FIRECreateLiteRedFiles[path, topo] where topo is an
FCTopology symbol and the full path is implied to be
path/topoName/CreateStartFile.m.

If you need to process a list of topologies, following syntaxes are possible
FIRECreateLiteRedFiles[{path1,path2, ...}], FIRECreateLiteRedFiles[path,
{topo1, topo2, ...}]

The path to the Mathematica Kernel can be specified via
FIREMathematicaKernelPath. The default value is Automatic.";

FIRECreateLiteRedFiles::failmsg =
"Error! FIRECreateLiteRedFiles has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIRECreateLiteRedFiles`Private`"]

fcsfVerbose::usage="";

Options[FIRECreateLiteRedFiles] = {
	FCVerbose					-> False,
	FIREMathematicaKernelPath	-> Automatic,
	FIREShowOutput				-> False,
	OverwriteTarget				-> True
};

FIRECreateLiteRedFiles[pathsRaw:{__String}, opts:OptionsPattern[]] :=
	FIRECreateLiteRedFiles[#, opts]&/@pathsRaw;

FIRECreateLiteRedFiles[pathRaw_String, topos:{__FCTopology}, opts:OptionsPattern[]] :=
	FIRECreateLiteRedFiles[FileNameJoin[{pathRaw,ToString[#[[1]]]}], opts]&/@topos;

FIRECreateLiteRedFiles[pathRaw_String, topo_FCTopology, opts:OptionsPattern[]] :=
	FIRECreateLiteRedFiles[FileNameJoin[{pathRaw,ToString[topo[[1]]]}], opts];

FIRECreateLiteRedFiles[pathRaw_String, OptionsPattern[]] :=
	Block[{ path, optFIREMathematicaKernelPath, out, dir, fireShellScriptPath,
			scriptFile, exitCode, res, optFIREShowOutput, output},

		If[	OptionValue[FCVerbose]===False,
			fcsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fcsfVerbose=OptionValue[FCVerbose]
			];
		];

		optFIREMathematicaKernelPath = OptionValue[FIREMathematicaKernelPath];
		optFIREShowOutput			 = OptionValue[FIREShowOutput];

		fireShellScriptPath = FileNameJoin[{$FeynHelpersDirectory, "Interfaces", "FIRE", "fireCreateLiteRedFiles.sh"}];

		If[	optFIREMathematicaKernelPath===Automatic,
			Switch[$OperatingSystem,
				"Unix",
					optFIREMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "Executables", "math"}],
				"MacOSX",
					optFIREMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "MacOS", "math"}],
				"Windows",
					optFIREMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "math.exe"}],
				_,
					Message[FIRECreateLiteRedFiles::failmsg,"Unsupported operating system!."];
					Abort[]
			];

		];

		If[	!FileExistsQ[optFIREMathematicaKernelPath],
			Message[FIRECreateLiteRedFiles::failmsg, "Mathematica kernel not found. Please check the path ", optFIREMathematicaKernelPath];
			Abort[]
		];

		Which[
			FileExistsQ[pathRaw] && !DirectoryQ[pathRaw],
				path = pathRaw,
			FileExistsQ[pathRaw] && DirectoryQ[pathRaw],
				path = FileNameJoin[{pathRaw,"CreateLiteRedFiles.m"}];
				If[	!FileExistsQ[path],
					Message[FIRECreateLiteRedFiles::failmsg, "Invalid path ", path];
					Abort[]
				],
			True,
			Message[FIRECreateLiteRedFiles::failmsg, "Invalid path ", pathRaw, " does not exist."];
			Abort[]
		];

		dir = DirectoryName[path];
		scriptFile	= FileNameTake[path];

		If[	FileExistsQ[FileNameJoin[{dir,Last[FileNameSplit[dir]]<>".lbases"}]] && !OptionValue[OverwriteTarget],
			FCPrint[0,"FIRECreateLiteRedFiles: .lbases file already exists and the option OverwriteTarget is set to False, so skipping.", FCDoControl->fcsfVerbose];
			Return[True]
		];

		If[	!FileExistsQ[fireShellScriptPath],
			Message[FIRERunReduction::failmsg, "Shell script for creating start files does not exist."];
			Abort[]
		];


		FCPrint[2,"FIRECreateLiteRedFiles: Full path to the Math Kernel binary: ", optFIREMathematicaKernelPath, FCDoControl->fcsfVerbose];
		FCPrint[2,"FIRECreateLiteRedFiles: Full path to the script file: ", path, FCDoControl->fcsfVerbose];
		FCPrint[2,"FIRECreateLiteRedFiles: Working directory: ", dir, FCDoControl->fcsfVerbose];
		FCPrint[2,"FIRECreateLiteRedFiles: Script file: ", scriptFile, FCDoControl->fcsfVerbose];

		If[	!FileExistsQ[path],
			Message[FIRECreateLiteRedFiles::failmsg, "The script file " <> path <> " does not exist."];
			Abort[]
		];


		out = RunProcess[{fireShellScriptPath,optFIREMathematicaKernelPath, dir, scriptFile}];

		If[	out===$Failed,
			Message[FIRECreateLiteRedFiles::failmsg,"Failed to generate the .lbases file."];
			Abort[]
		];

		output = out["StandardOutput"];
		exitCode = out["ExitCode"];

		If[	optFIREShowOutput=!=False,
			Print["Mathematica output:"];
			Print[StringTrim[output]]
		];

		If[	TrueQ[exitCode===0],
			res = True,

			Message[FIRECreateLiteRedFiles::failmsg, "Mathematica process returned exit code: " <> ToString[exitCode] <>
			" .Please run the script manually to better understand the issue."
			];
			res = False
		];

		res

	];



End[]
