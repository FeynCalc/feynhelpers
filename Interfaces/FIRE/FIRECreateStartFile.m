(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRECreateStartFile												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Creates FIRE start files									*)

(* ------------------------------------------------------------------------ *)

FIREMathematicaKernelPath::usage="FIREMathematicaKernelPath is an option for the interface to FIRE. \
It specifies the full path to the Mathematica Kernel that will be started to run FIRE.
The default value is Automatic.";

FIRECreateStartFile::usage=
"FIRECreateStartFile[path] runs FIRE to create a start FILE using the
script CreateStartFile.m in path.";

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
	OverwriteTarget				-> True
};

FIRECreateStartFile[pathsRaw:{__String}, opts:OptionsPattern[]] :=
	FIRECreateStartFile[#, opts]&/@pathsRaw;

FIRECreateStartFile[pathRaw_String, topos:{__FCTopology}, opts:OptionsPattern[]] :=
	FIRECreateStartFile[FileNameJoin[{pathRaw,ToString[#[[1]]]}], opts]&/@topos;

FIRECreateStartFile[pathRaw_String, OptionsPattern[]] :=
	Block[{ path, optFIREMathematicaKernelPath, scriptFile, out, dir, exitCode, res},

		If[	OptionValue[FCVerbose]===False,
			fcsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fcsfVerbose=OptionValue[FCVerbose]
			];
		];

		optFIREMathematicaKernelPath = OptionValue[FIREMathematicaKernelPath];

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
			Message[FIRECreateStartFile::failmsg, "Mathematica kernel not found. Please check the path  ", optFIREMathematicaKernelPath];
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
			If[	out===$Failed,
				Message[FIRECreateStartFile::failmsg,"Failed to generate the start file."];
				Abort[]
			];

			exitCode = out["ExitCode"],

			Message[FIRECreateStartFile::failmsg, "Mathematica versions older than 10. are not supported."];
			Abort[]
		];

		If[	TrueQ[exitCode===0],
			res = True,
			res = False
		];

		res

	];



End[]
