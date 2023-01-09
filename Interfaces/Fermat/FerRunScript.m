(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FermatShared														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and Fermat						*)

(* ------------------------------------------------------------------------ *)


FerRunScript::usage =
"FerRunScript[scriptFile] is an auxiliary function that runs the script
scriptFile containing Fermat instructions. The script file is expected to be a
valid Fermat code.

The option FerPath should point to an executable Fermat binary";


FerRunScript::failmsg =
"Error! FerRunScript has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

Begin["`Package`"]

End[]

Begin["`FerRunScript`Private`"]

frsVerbose::usage="";

Options[FerRunScript] = {
	FCVerbose 		-> False,
	FerPath			-> Automatic,
	MaxIterations	-> Infinity
};

FerRunScript[scriptFile_String, OptionsPattern[]]:=
	Block[{	scriptRunner, server, input, counter, optMaxIterations,
			failed, time, pathToFermat, optFerPath},

		If [OptionValue[FCVerbose]===False,
			frsVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				frsVerbose=OptionValue[FCVerbose]
			]
		];

		failed	= False;
		counter = 0;

		optMaxIterations	= OptionValue[MaxIterations];
		optFerPath			= OptionValue[FerPath];

		FCPrint[1, "FerRunScript: Entering.", FCDoControl->frsVerbose];

		Switch[$OperatingSystem,
			"Unix",
			pathToFermat = FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "Fermat", "ferl6", "fer64"}],
			"MacOSX",
			pathToFermat = FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "Fermat", "ferm6", "fer64"}],
			_,
			Message[FerRunScript::failmsg,"Recent versions of Fermat are available only for Linux and macOS."];
			Abort[]
		];

		If[	optFerPath=!=Automatic,
			pathToFermat = optFerPath
		];

		If[	!FileExistsQ[pathToFermat],
			Message[FerRunScript::failmsg,"Fermat binary not found. Did you download Fermat from the author's webpage?"];
			Abort[]'
		];

		scriptRunner = FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "Fermat", "runFermatUnix.sh"}];

		time=AbsoluteTime[];
		FCPrint[0, "FerRunScript: Running Fermat.","\n", UseWriteString -> True,  FCDoControl->frsVerbose];

		FCPrint[1, "FerRunScript: Fermat script runner: ", scriptRunner,  FCDoControl->frsVerbose];
		FCPrint[1, "FerRunScript: Fermat binary: ", pathToFermat,  FCDoControl->frsVerbose];
		FCPrint[1, "FerRunScript: Fermat script file: ", pathToFermat,  FCDoControl->frsVerbose];

		server = StartProcess[{scriptRunner,pathToFermat,scriptFile}];

		If[	server === $Failed,
			Message[FerRunScript::failmsg,"Failed to execute StartProcess."];
			Abort[]
		];

		While[	input =!= EndOfFile,

				counter++;
				input = ReadLine[server];

				If[	input === EndOfFile,
					Continue[]
				];

				FCPrint[1, "FerRunScript: ", input,"\n", UseWriteString -> True,  FCDoControl->frsVerbose];

				If[ input === " bye"  || counter>=optMaxIterations,
					KillProcess[server];
					Break[]
				];

				If[ StringMatchQ[input, ___ ~~"Inappropriate" ~~ ___] ||
					StringMatchQ[input, ___ ~~"Stopped" ~~ ___] ||
					StringMatchQ[input, ___ ~~"Error occurred" ~~ ___],

					Print[input];
					failed=True;
					KillProcess[server];
					Message[FerRunScript::failmsg,"Errors in the execution of the Fermat script " <> scriptFile];
					Abort[]
				];
		];

		FCPrint[0, "FerRunScript: Done running Fermat, timing: ", N[AbsoluteTime[] - time, 4], "\n", UseWriteString -> True, FCDoControl->frsVerbose];

		FCPrint[1, "FerRunScript: ProcessStatus: ", ProcessStatus[server], FCDoControl->frsVerbose];

		FCPrint[1, "FerRunScript: Leaving.", FCDoControl->frsVerbose];
];


End[]

