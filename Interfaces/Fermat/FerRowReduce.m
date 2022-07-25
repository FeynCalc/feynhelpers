(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FerRowReduce														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Fermat version of RowReduce									*)

(* ------------------------------------------------------------------------ *)


FerRowReduce::usage =
"FerRowReduce[mat]uses Fermat to obtain the row-reduced echelon form of matrix
mat.  An important difference to Mathematica's RowReduce is that Fermat does
not assume all symbolic variables to be nonzero by default.

The location of script, input and output files is controlled by the options
FerScriptFile, FerInputFile, FerOutputFile. When set to Automatic (default),
these files will be automatically created via CreateTemporary[]. If the option
Delete is set to True (default), the files will be deleted after a successful
Fermat run.";

FerRowReduce::failmsg =
"Error! FerRowReduce has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";


Begin["`Package`"]

End[]

Begin["`FerRowReduce`Private`"]

frrVerbose::usage="";

Options[FerRowReduce] = {
	DeleteFile		-> True,
	FCVerbose 		-> False,
	FerInputFile	-> Automatic,
	FerOutputFile	-> Automatic,
	FerPath			-> Automatic,
	FerScriptFile	-> Automatic,
	Timing			-> True
};


FerRowReduce[matRaw_?MatrixQ, OptionsPattern[]]:=
	Block[{	mat, vars, rule, optFerInputFile, optFerOutputFile, optFerScriptFile,
			cmds, script, res, time},

		If [OptionValue[FCVerbose]===False,
			frrVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				frrVerbose=OptionValue[FCVerbose]
			]
		];

		optFerInputFile 	= OptionValue[FerInputFile];
		optFerOutputFile 	= OptionValue[FerOutputFile];
		optFerScriptFile	= OptionValue[FerScriptFile];

		If[	optFerInputFile === Automatic,
			optFerInputFile = CreateTemporary[];
		];

		If[	optFerOutputFile === Automatic,
			optFerOutputFile = CreateTemporary[];
		];

		If[	optFerScriptFile === Automatic,
			optFerScriptFile = CreateTemporary[];
		];

		{mat,vars,rule} = FerMatrixToFermatArray[matRaw,"fMat"];

		cmds = {
			Sequence@@(
			FerCommand["AdjoinPolynomialVariable", #]&/@vars),
			FerCommand["ReadFromAnInputFile", optFerInputFile],
			FerCommand["ReducedRowEchelonForm", "[fMat]"],
			FerCommand["EnableUglyDisplay"],
			FerCommand["SaveToAnOutputFile", optFerOutputFile],
			FerCommand["SaveSpecifiedVariablesToAnOutputFile", {"[fMat]"}],
			FerCommand["Quit"],
			FerCommand["StopReadingFromTheInputFile"]
		};

		If[	!MatchQ[cmds,{__String}],
			Message[FerRowReduce::failmsg, "Failed to generate a proper Fermat script."];
			Abort[]
		];

		script = StringRiffle[cmds, "\n"];
		script = StringJoin[script];

		FeynCalc`Package`ferWriteFiles[optFerInputFile, optFerScriptFile, mat, script];

		FerRunScript[optFerScriptFile, FerPath -> OptionValue[FerPath], FCVerbose->frrVerbose];

		res = FerImportArrayAsSparseMatrix[optFerOutputFile, "fMat", Dimensions[matRaw], FinalSubstitutions->rule];

		If[	OptionValue[DeleteFile],

			FCPrint[1, "FerRowReduce: Removing temporary files.", FCDoControl->frrVerbose];
			If[	FileExistsQ[optFerInputFile],
				DeleteFile[optFerInputFile]
			];

			If[	FileExistsQ[optFerOutputFile],
				DeleteFile[optFerOutputFile]
			];

			If[	FileExistsQ[optFerScriptFile],
				DeleteFile[optFerScriptFile]
			];

			FCPrint[1, "FerRowReduce: Done removing temporary files timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->frrVerbose]
		];

		res
	];



End[]

