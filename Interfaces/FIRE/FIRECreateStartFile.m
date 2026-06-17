(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRECreateStartFile												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2026 Vladyslav Shtabovenko
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
"FIREShowOutput is an option for FIRECreateStartFile and other FIRE-related
functions.

When set to True, the output of the current process run will be shown via
Print. When set to False the output is suppressed.";

FIRECreateStartFile::failmsg =
"Error! FIRECreateStartFile has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIRECreateStartFile`Private`"]

Options[FIRECreateStartFile] = {
	Check						-> True,
	FCVerbose					-> False,
	FIREMathematicaKernelPath	-> Automatic,
	FIREShowOutput				-> False,
	ProgressIndicator			-> True,
	OverwriteTarget				-> True
};

FIRECreateStartFile[pathsRaw:{__String}, opts:OptionsPattern[]] :=
	Block[{res,counter,time,out,optVerbose},

		If[	OptionValue[FCVerbose]===False,
			optVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				optVerbose=OptionValue[FCVerbose]
			];
		];
		If[	OptionValue[ProgressIndicator],

			counter=0;
			res = Map[(
				time=AbsoluteTime[];
				counter++;
				FCPrint[0, "Creating FIRE files ("<>ToString[counter]<>"/"<>ToString[Length[pathsRaw]]<> ") for ", FileBaseName[#], "... " ,UseWriteString -> True];
				out = FIRECreateStartFile[#, opts];
				FCPrint[0, "done, timing: ",N[AbsoluteTime[] - time, 4],"\n" ,UseWriteString -> True];
				out
				)&,pathsRaw];
				FCPrint[0, "\n" ,UseWriteString -> True],

			res = Map[FIRECreateStartFile[#, opts]&,pathsRaw];
		];

		FCPrint[0, "FIRECreateStartFile: ", FeynCalc`Package`FCStyle["Run ", {Darker[Green,0.55], Bold}], Length[res],
			FeynCalc`Package`FCStyle[" script files.", {Darker[Green,0.55], Bold}], FCDoControl->optVerbose];

		res

	]

FIRECreateStartFile[pathRaw_String, topos:{__FCTopology}, opts:OptionsPattern[]] :=
	FIRECreateStartFile[FileNameJoin[{pathRaw,ToString[#[[1]]]}]&/@topos, opts];


FIRECreateStartFile[a_,{(*mappings*)_List, topos: {__FCTopology}}, rest___] :=
	FIRECreateStartFile[a,topos,rest];

FIRECreateStartFile[pathRaw_String, topo_FCTopology, opts:OptionsPattern[]] :=
	FIRECreateStartFile[FileNameJoin[{pathRaw,ToString[topo[[1]]]}], opts];

FIRECreateStartFile[pathRaw_String, OptionsPattern[]] :=
	Block[{ path, optFIREMathematicaKernelPath, out, dir, fireShellScriptPath,
			scriptFile, exitCode, res, optFIREShowOutput, output, aux, optVerbose},

		If[	OptionValue[FCVerbose]===False,
			optVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				optVerbose=OptionValue[FCVerbose]
			];
		];

		optFIREMathematicaKernelPath = OptionValue[FIREMathematicaKernelPath];
		optFIREShowOutput			 = OptionValue[FIREShowOutput];

		fireShellScriptPath = FileNameJoin[{$FeynHelpersDirectory, "Interfaces", "FIRE", "fireCreateStartFile.sh"}];

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
		scriptFile	= FileNameTake[path];

		If[	FileExistsQ[FileNameJoin[{dir,Last[FileNameSplit[dir]]<>".start"}]] && !OptionValue[OverwriteTarget],
			FCPrint[0,"FIRECreateStartFile: Start file already exists and the option OverwriteTarget is set to False, so skipping.", FCDoControl->optVerbose];
			Return[True]
		];

		If[	!FileExistsQ[fireShellScriptPath],
			Message[FIRECreateStartFile::failmsg, "Shell script for creating start files does not exist."];
			Abort[]
		];


		FCPrint[2,"FIRECreateStartFile: Full path to the Math Kernel binary: ", optFIREMathematicaKernelPath, FCDoControl->optVerbose];
		FCPrint[2,"FIRECreateStartFile: Full path to the script file: ", path, FCDoControl->optVerbose];
		FCPrint[2,"FIRECreateStartFile: Working directory: ", dir, FCDoControl->optVerbose];
		FCPrint[2,"FIRECreateStartFile: Script file: ", scriptFile, FCDoControl->optVerbose];

		If[	!FileExistsQ[path],
			Message[FIRECreateStartFile::failmsg, "The script file " <> path <> " does not exist."];
			Abort[]
		];


		out = RunProcess[{fireShellScriptPath,optFIREMathematicaKernelPath, dir, scriptFile}];

		If[	out===$Failed,
			Message[FIRECreateStartFile::failmsg,"Failed to generate the start file."];
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

			Message[FIRECreateStartFile::failmsg, "Mathematica process returned exit code: " <> ToString[exitCode] <>
			". Please run the script manually to better understand the issue."
			];
			res = False
		];

		If[	OptionValue[Check],
			aux=Import[#,"Text"]&/@FileNames[{"*.lbases","*.sbases","*.start"},pathRaw];
			aux=StringFreeQ[aux,{"`","Private","FIRE"}];
			If[!MatchQ[aux,{True..}],
				Message[FIRECreateStartFile::failmsg,"Incorrect files generated for " <> pathRaw];
			];
		];

		res

	];



End[]
