(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FSARunIntegration												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Runs FIESTA 												*)

(* ------------------------------------------------------------------------ *)

FSARunIntegration::usage=
"FSARunIntegration[path] evaluates a FIESTA script FiestaScript.m in path. To
that aim a Mathematica kernel is started in the background via RunProcess. The
function returns True if the evaluation succeeds and False otherwise.

Alternatively, one can use FSARunIntegration[path, topo] where topo is an
FCTopology symbol and the full path is implied to be
path/topoName/FiestaScript.m.

If you need to process a list of topologies, following syntaxes are possible
FiestaScript.m[{path1,path2, ...}], FiestaScript.m[path, {topo1, topo2, ...}]

The path to the Mathematica Kernel can be specified via
FSAMathematicaKernelPath. The default value is Automatic.";

FSARunIntegration::failmsg =
"Error! FSARunIntegration has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FSARunIntegration`Private`"]

fcriVerbose::usage="";

Options[FSARunIntegration] = {
	FCVerbose					-> False,
	FSAMathematicaKernelPath	-> Automatic,
	FSAShowOutput				-> False
};


FSARunIntegration[pathsRaw:{__String}, opts:OptionsPattern[]] :=
	FSARunIntegration[#, opts]&/@pathsRaw;

FSARunIntegration[pathRaw_String, glis:{__GLI}, opts:OptionsPattern[]] :=
	FSARunIntegration[FileNameJoin[{pathRaw,ToString[#[[1]]]}], opts]&/@glis;

FSARunIntegration[pathRaw_String, gli_GLI, opts:OptionsPattern[]] :=
	FSARunIntegration[FileNameJoin[{pathRaw,ToString[FCLoopGLIToSymbol[gli]]}], opts];


FSARunIntegration[pathRaw_String, OptionsPattern[]] :=
	Block[{ path, optFSAMathematicaKernelPath, out, dir, fiestaShellScriptPath,
			scriptFile, exitCode, res, optFSAShowOutput, output},

		If[	OptionValue[FCVerbose]===False,
			fcriVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fcriVerbose=OptionValue[FCVerbose]
			];
		];

		optFSAMathematicaKernelPath = OptionValue[FSAMathematicaKernelPath];
		optFSAShowOutput			 = OptionValue[FSAShowOutput];

		fiestaShellScriptPath = FileNameJoin[{$FeynHelpersDirectory, "Interfaces", "FIESTA", "fiestaRunIntegration.sh"}];

		If[	optFSAMathematicaKernelPath===Automatic,
			Switch[$OperatingSystem,
				"Unix",
					optFSAMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "Executables", "math"}],
				"MacOSX",
					optFSAMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "MacOS", "math"}],
				"Windows",
					optFSAMathematicaKernelPath = FileNameJoin[{$InstallationDirectory, "math.exe"}],
				_,
					Message[FSARunIntegration::failmsg,"Unsupported operating system!."];
					Abort[]
			];

		];

		If[	!FileExistsQ[optFSAMathematicaKernelPath],
			Message[FSARunIntegration::failmsg, "Mathematica kernel not found. Please check the path ", optFSAMathematicaKernelPath];
			Abort[]
		];

		Which[
			FileExistsQ[pathRaw] && !DirectoryQ[pathRaw],
				path = pathRaw,
			FileExistsQ[pathRaw] && DirectoryQ[pathRaw],
				path = FileNameJoin[{pathRaw,"FiestaScript.m"}];
				If[	!FileExistsQ[path],
					Message[FSARunIntegration::failmsg, "Invalid path ", path];
					Abort[]
				],
			True,
			Message[FSARunIntegration::failmsg, "Invalid path ", pathRaw, " does not exist."];
			Abort[]
		];

		dir = DirectoryName[path];
		scriptFile	= FileNameTake[path];

		If[	!FileExistsQ[fiestaShellScriptPath],
			Message[FSARunIntegration::failmsg, "Shell script for running the integration does not exist."];
			Abort[]
		];


		FCPrint[2,"FSARunIntegration: Full path to the Math Kernel binary: ", optFSAMathematicaKernelPath, FCDoControl->fcriVerbose];
		FCPrint[2,"FSARunIntegration: Full path to the script file: ", path, FCDoControl->fcriVerbose];
		FCPrint[2,"FSARunIntegration: Working directory: ", dir, FCDoControl->fcriVerbose];
		FCPrint[2,"FSARunIntegration: Script file: ", scriptFile, FCDoControl->fcriVerbose];

		If[	!FileExistsQ[path],
			Message[FSARunIntegration::failmsg, "The script file " <> path <> " does not exist."];
			Abort[]
		];


		out = RunProcess[{fiestaShellScriptPath,optFSAMathematicaKernelPath, dir, scriptFile}];

		If[	out===$Failed,
			Message[FSARunIntegration::failmsg,"Failed to generate the start file."];
			Abort[]
		];

		output = out["StandardOutput"];
		exitCode = out["ExitCode"];

		If[	optFSAShowOutput=!=False,
			Print["Mathematica output:"];
			Print[StringTrim[output]]
		];

		If[	TrueQ[exitCode===0],
			res = True,

			Message[FSARunIntegration::failmsg, "Mathematica process returned exit code: " <> ToString[exitCode] <>
			" .Please run the script manually to better understand the issue."
			];
			res = False
		];

		res

	];



End[]
