(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRERunReduction													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Runs FIRE 													*)

(* ------------------------------------------------------------------------ *)

FIREBinaryPath::usage=
"FIREBinaryPath is an option for the interface to FIRE. \
It specifies the full location of the C++ FIRE binary. \
The default value is FileNameJoin[{$UserBaseDirectory, \"Applications\", \"FIRE6\", \"bin\", \"FIRE6\"}].";

FIRERunReduction::usage=
"FIRERunReduction[path] reduces the given topology using C++ FIRE.";

FIRERunReduction::failmsg =
"Error! FIRERunReduction has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIRERunReduction`Private`"]

fcsfVerbose::usage="";


Options[FIRERunReduction] = {
	FCVerbose			-> False,
	FIREBinaryPath 		-> FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE6", "bin", "FIRE6"}]
};

FIRERunReduction[input_List, opts:OptionsPattern[]]:=
	FIRERunReduction[#,opts]&/@input;

FIRERunReduction[pathRaw_String, topos:{__FCTopology}, opts:OptionsPattern[]] :=
	FIRERunReduction[FileNameJoin[{pathRaw,ToString[#[[1]]]}], opts]&/@topos;






FIRERunReduction[pathRaw_String, OptionsPattern[]] :=
	Block[{	path, dir, optFIREBinaryPath, out, configFile, exitCode, res},

		If[	OptionValue[FCVerbose]===False,
			fcsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fcsfVerbose=OptionValue[FCVerbose]
			];
		];

		optFIREBinaryPath = OptionValue[FIREBinaryPath];

		Which[
			FileExistsQ[pathRaw] && !DirectoryQ[pathRaw],
				path = pathRaw,
			FileExistsQ[pathRaw] && DirectoryQ[pathRaw],
				path = FileNameJoin[{pathRaw,FileBaseName[pathRaw]<>".config"}];
				If[	!FileExistsQ[path],
					Message[FIRERunReduction::failmsg, "The file " <> path <> " does not exist."];
					Abort[]
				],
			True,
			Message[FIRERunReduction::failmsg, "The path " <> pathRaw <> " does not exist."];
			Abort[]
		];

		If[	!FileExistsQ[optFIREBinaryPath],
			Message[FIRERunReduction::failmsg, "C++ FIRE binary  " <> optFIREBinaryPath <> " does not exist."];
			Abort[]
		];

		dir = DirectoryName[path];
		configFile = FileBaseName[path];


		FCPrint[2,"FIRERunReduction: Full path to the FIRE binary: ", optFIREBinaryPath, FCDoControl->fcsfVerbose];
		FCPrint[2,"FIRERunReduction: Working directory: ", dir, FCDoControl->fcsfVerbose];
		FCPrint[2,"FIRERunReduction: Config file: ", configFile, FCDoControl->fcsfVerbose];

		If[	$VersionNumber >= 10.,
			out = RunProcess[{optFIREBinaryPath,"-c", configFile}, ProcessDirectory -> dir];
			If[	out===$Failed,
				Message[FIRERunReduction::failmsg,"Failed to execute the C++ FIRE binary."];
				Abort[]
			];

			exitCode = out["ExitCode"],

			Message[FIRERunReduction::failmsg, "Mathematica versions older than 10. are not supported."];
			Abort[]
		];

		If[	TrueQ[exitCode===0],
			res = True,
			res = False
		];

		res
	];



End[]
