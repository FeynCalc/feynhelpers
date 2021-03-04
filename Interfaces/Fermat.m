(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: Fermat															*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2020-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc/Mathematica and Fermat			*)

(* ------------------------------------------------------------------------ *)

FerCommand::usage =
"FerCommand[str, args] is an auxiliary function that returns a Fermat command \
corresponding to str (possibly using arguments args) as a list of strings.";

FerSolve::usage =
"FerSolve[eqs, vars] solves the system of linear equations eqs for the variables \
vars by calculating the row-reduced form of the corresponding augmented matrix \
using Fermat.";

FerMatrixToFermatArray::usage =
"FerMatrixToFermatArray[mat,varName] is an auxiliary function that converts \
the matrix mat to a Fermat array named varName. The function returns a string \
that represents the matrix, a list of auxuliary variables (introduced to be \
compatible with the restrictions of Fermat) and a replacement rule for \
converting auxiliary variables back into the original variables."

FerInputFile::usage =
"FerInputFile is an option for multiple functions of the Fermat interface. It \
specifies the location of the file containing the input for a Fermat calculation. If set \
to Automatic (default), a temporary file will be automatically created and removed \
after a successful evaluation.";

FerOutputFile::usage =
"FerOutputFile is an option for multiple functions of the Fermat interface. It \
specifies the location of the file containing the output of Fermat calculation. If set \
to Automatic (default), a temporary file will be automatically created and removed \
after a successful evaluation.";

FerScriptFile::usage =
"FerScriptFile is an option for multiple functions of the Fermat interface. It \
specifies the location of the file containing instructions for Fermat. If set \
to Automatic (default), a temporary file will be automatically created and removed \
after a successful evaluation.";

FerRunScript::usage =
"FerRunScript[scriptFile] is an auxiliary function that runs the script \
scriptFile in Fermat. The script file is expected to be a valid Fermat code. \
Furthermore, the option FerPath should point to an executable Fermat binary";

FerPath::usage="FerPath is an option for FerRunScript and multiple other Fer* functions. \
It specifies the full path to the Fermat binary. If set to Automatic, Fermat binaries are
expected to be located in \
FileNameJoin[{$FeynHelpersDirectory, \"ExternalTools\", \"Fermat\", \"ferl6\", \"fer64\"}] and \
and FileNameJoin[{$FeynHelpersDirectory, \"ExternalTools\", \"Fermat\",\"ferm6\", \"fer64\"}] \
for Linux and macOS respectively.";

FerMatrixToFermatArray::failmsg =
"Error! FerMatrixToFermatArray has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

FerRowReduce::failmsg =
"Error! FerRowReduce has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

FerWriteFile::failmsg =
"Error! FerWriteFile has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

FerRunScript::failmsg =
"Error! FerRunScript has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

FerImportArrayAsSparseMatrix::failmsg =
"Error! FerImportArrayAsSparseMatrix has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

FerSolve::failmsg =
"Error! FerSolve has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";


Begin["`Package`"]

End[]

Begin["`Fer`Private`"]

fsVerbose::usage="";
frsVerbose::usage="";

FerCommand["Quit"]:=
	"&q;";

FerCommand["StopReadingFromTheInputFile"]:=
	"&x;";

FerCommand["EnableUglyDisplay"]:=
	"&(U=1);";

FerCommand["ReadFromAnInputFile", inputFile_String]:=
	"&(R='" <> inputFile <> "');";

FerCommand["SaveToAnOutputFile", outputFile_String]:=
	"&(S='"<> outputFile <>"');";

FerCommand["SaveSpecifiedVariablesToAnOutputFile", {vars__?AtomQ}]:=
	"!(&o, "<>StringReplace[ToString[{vars}], {"}" | "{" -> ""}]<>");";

FerCommand["ReducedRowEchelonForm", augMat_String]:=
	"Redrowech("<>augMat<>");";

FerCommand["AdjoinPolynomialVariable", var_?AtomQ]:=
	"&(J="<>ToString[var]<>");";


Options[FerMatrixToFermatArray] = {
	Names-> Function[i, ToExpression["fv" <> ToString[i]]]
};


Options[FerRowReduce] = {
	FerInputFile	:> CreateTemporary[],
	FerOutputFile	:> CreateTemporary[],
	FerScriptFile	:> CreateTemporary[],
	FerPath			-> Automatic,
	Timing			-> True
};

Options[FerSolve] = {
	Check			-> True,
	DeleteFile		-> True,
	FCVerbose 		-> False,
	FerInputFile	:> CreateTemporary[],
	FerOutputFile	:> CreateTemporary[],
	FerPath			-> Automatic,
	FerScriptFile	:> CreateTemporary[],
	Timing			-> True
};


Options[FerRunScript] = {
	FCVerbose 		-> False,
	FerPath			-> Automatic,
	MaxIterations	-> Infinity,
	Timing			-> True
};

Options[FerImportArrayAsSparseMatrix] = {
	FinalSubstitutions -> {}
};


FerSolve[eqs_List, vars_List, OptionsPattern[]]:=
	Block[{	aPiece,bPiece, augMatrix, res, size,
			inFile, outFile, scriptFile, optTiming, sol, time,
			checkVars, checkRule, checkPrimes, checkRes, checkSol},

		inFile 		= OptionValue[FerInputFile];
		outFile 	= OptionValue[FerOutputFile];
		scriptFile	= OptionValue[FerScriptFile];
		optTiming	= OptionValue[Timing];

		If[!MatchQ[eqs, {__Equal}],
			Message[FerSolve::failmsg,"The input does not contain a valid system of equations."];
			Abort[]
		];

		If [OptionValue[FCVerbose]===False,
			fsVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				fsVerbose=OptionValue[FCVerbose]
			]
		];

		FCPrint[1,"FerSolve: Entering.", FCDoControl->fsVerbose];
		FCPrint[1,"FerSolve: Fermat input file: ", inFile, FCDoControl->fsVerbose];
		FCPrint[1,"FerSolve: Fermat output file: ", outFile, FCDoControl->fsVerbose];
		FCPrint[1,"FerSolve: Fermat scriptFile file: ", scriptFile, FCDoControl->fsVerbose];
		FCPrint[3,"FerSolve: Entering with: ", {eqs,vars}, FCDoControl->fsVerbose];

		FCPrint[1,"FerSolve: Constructing the augmented matrix.", FCDoControl->fsVerbose];
		time=AbsoluteTime[];
		{aPiece, bPiece} = CoefficientArrays[eqs, vars];
		augMatrix = Transpose[Join[Transpose[bPiece], {aPiece}]];
		FCPrint[1, "FerSolve: Done constructing the augmented matrix, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->fsVerbose];

		FCPrint[3,"FerSolve: Augmented matrix: ", augMatrix, FCDoControl->fsVerbose];

		If[!MatrixQ[augMatrix],
			Message[FerSolve::failmsg,"Failed to obtain the augmented matrix."];
			Abort[]
		];

		FCPrint[1,"FerSolve: Calling RowReduce.", FCDoControl->fsVerbose];
		time=AbsoluteTime[];
		res = FerRowReduce[augMatrix, FerInputFile->inFile, FerOutputFile->outFile,
			FerScriptFile->scriptFile, Timing-> optTiming];
		FCPrint[1, "FerSolve: RowReduce done, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->fsVerbose];

		If[	OptionValue[DeleteFile],

			FCPrint[1,"FerSolve: Removing temporary files.", FCDoControl->fsVerbose];
			If[	FileExistsQ[inFile],
				DeleteFile[inFile]
			];
			If[	FileExistsQ[outFile],
				DeleteFile[outFile]
			];
			If[	FileExistsQ[scriptFile],
				DeleteFile[scriptFile]
			];
			FCPrint[1, "FerSolve: Done removing temporary files timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->fsVerbose];
		];

		FCPrint[3,"FerSolve: Raw solution: ", res, FCDoControl->fsVerbose];

		If[!MatrixQ[res],
			Message[FerSolve::failmsg,"Failed to obtain the row-reduced matrix."];
			Abort[]
		];

		size = First[Dimensions[res]];
		If[	IdentityMatrix[size, SparseArray] =!= res[[1 ;;, 1 ;; -2]],
			(*No solution found*)
			Return[{}];
			Abort[]
		];

		sol = Thread[Rule[vars, -1*res[[All, -1]]]];
		FCPrint[3,"FerSolve: Final solution: " res, FCDoControl->fsVerbose];

		If[OptionValue[Check],

			time=AbsoluteTime[];
			FCPrint[If[optTiming,0,1],"FerSolve: Verifying the result.","\n", UseWriteString -> True, FCDoControl->fsVerbose];

			checkVars = Variables[augMatrix];
			checkPrimes = Table[RandomPrime[{10^6, 10^7}],{i,1,Length[checkVars]}];
			checkRule = Thread[Rule[checkVars,checkPrimes]];
			checkSol = sol /. Dispatch[checkRule];
			checkRes = eqs /. Dispatch[checkRule];
			checkRes = checkRes /. Dispatch[checkSol];
			checkRes = Together/@checkRes;
			If[	!MatchQ[checkRes,{True..}],
				Message[FerSolve::failmsg,"The obtained solution is incorrect."];
				Abort[]
			];
			FCPrint[If[optTiming,0,1],"FerSolve: Done verifying the result, timing: ", N[AbsoluteTime[] - time, 4], "\n", UseWriteString -> True, FCDoControl->fsVerbose];

		];

		FCPrint[1,"FerSolve: Leaving.", FCDoControl->fsVerbose];

		sol
	];


FerRowReduce[matRaw_?MatrixQ, OptionsPattern[]]:=
	Block[{	mat,vars,rule, inFile, outFile, scriptFile, cmds,
			script, res},

		inFile 		= OptionValue[FerInputFile];
		outFile 	= OptionValue[FerOutputFile];
		scriptFile	= OptionValue[FerScriptFile];

		{mat,vars,rule} = FerMatrixToFermatArray[matRaw,"fMat"];

		cmds = {
			Sequence@@(FerCommand["AdjoinPolynomialVariable", #]&/@vars),
			FerCommand["ReadFromAnInputFile", inFile],
			FerCommand["ReducedRowEchelonForm", "[fMat]"],
			FerCommand["EnableUglyDisplay"],
			FerCommand["SaveToAnOutputFile", outFile],
			FerCommand["SaveSpecifiedVariablesToAnOutputFile", {"[fMat]"}],
			FerCommand["Quit"],FerCommand["StopReadingFromTheInputFile"]
		};

		If[	!MatchQ[cmds,{__String}],
			Message[FerRowReduce::failmsg, "Failed to generate a proper Fermat script."];
			Abort[]
		];

		script = StringRiffle[cmds, "\n"];
		script = StringJoin[script];

		FerWriteFile[inFile, scriptFile, mat, script];

		FerRunScript[scriptFile, FerPath -> OptionValue[FerPath], Timing->OptionValue[Timing]];

		res = FerImportArrayAsSparseMatrix[outFile, "fMat", Dimensions[matRaw], FinalSubstitutions->rule];

		res
	];


FerMatrixToFermatArray[matRaw_?MatrixQ, varName_String, OptionsPattern[]] :=
	Block[{	sizeX, sizeY, str, strLen, dims, matVars, repRule,
			optNames, newVars, mat},

		optNames 				= OptionValue[Names];

		{sizeX, sizeY} = ToString/@Dimensions[matRaw];
		matVars = Variables[matRaw];

		If[	!MatchQ[matVars, {___?AtomQ}],
			Message[FerMatrixToFermatArray::failmsg, "The symbolic variables in the matrix must be atomic."];
			Abort[]
		];

		newVars = Table[optNames[i],{i,1,Length[matVars]}];

		If[	!MatchQ[newVars, {___?AtomQ}],
			Message[FerMatrixToFermatArray::failmsg, "Failed to generate proper substitution variables."];
			Abort[]
		];

		repRule = Thread[Rule[matVars,newVars]];

		mat = matRaw /. Dispatch[repRule];
		If[	Sort[Variables[mat]]=!=Sort[newVars],
			Print[Sort[Variables[mat]]];
			Print[Sort[newVars]];
			Message[FerMatrixToFermatArray::failmsg, "Failed to introduce auxiliary variables in the matrix."];
			Abort[]
		];

		repRule = Reverse/@repRule;

		str = ToString[Flatten[Transpose[mat]],InputForm];
		strLen = Length[str];
		str = "[" <> varName <> "]:=[[" <> StringTake[str, {2, strLen - 2}] <> "]];";
		str = "Array " <> varName <> "[" <> sizeX <> "," <> sizeY <> "];\n" <> str;

		{str,newVars,repRule}
	];


FerImportArrayAsSparseMatrix[outFile_String, var_String, {dimX_Integer?Positive, dimY_Integer?Positive}, OptionsPattern[]] :=
	Block[{in, res, expr, optFinalSubstitutions},

		optFinalSubstitutions	= OptionValue[FinalSubstitutions];

		If[!FileExistsQ[outFile],
			Message[FerImportArrayAsSparseMatrix::failmsg,"File not found."];
			Abort[]
		];

		in = Import[outFile, {"Text"}];

		If[in===$Failed,
			Message[FerImportArrayAsSparseMatrix::failmsg,"Failed to open " <> outFile];
			Abort[]
		];

		in = StringSplit[in, ";"];
		If[	Last[in] === " ",
			in = Most[in]
		];

		If[	Length[in]=!=dimX*dimY,
			Message[FerImportArrayAsSparseMatrix::failmsg,"Incorrect array dimensions."];
			Abort[]
		];

		in = Map[StringReplace[#, {var <> "[" -> "{", ";" -> "", "] :=" -> "}->"}]&, in];
		expr = ToExpression[in];

		If[	!MatchQ[expr,{__Rule}],
			Message[FerImportArrayAsSparseMatrix::failmsg,"Failed to convert the Fermat array into a SparseArray."];
			Abort[]
		];


		If[	optFinalSubstitutions=!={},
			expr = expr /. Dispatch[optFinalSubstitutions]
		];

		res = SparseArray[expr, {dimX,dimY}];

		res
	];


FerWriteFile[inFile_String, scriptFile_String, input_String, script_String] :=
	Block[{file},

		file = OpenWrite[inFile];
		If[file===$Failed,
			Message[FerWriteFile::failmsg, "Failed to write the Fermat input file."];
			Abort[]
		];
		WriteString[inFile, input];
		Close[file];

		file = OpenWrite[scriptFile];
		If[file===$Failed,
			Message[FerWriteFile::failmsg, "Failed to write the Fermat script file."];
			Abort[]
		];
		WriteString[scriptFile, script];
		Close[file];
];



FerRunScript[scriptFile_String, OptionsPattern[]]:=
	Block[{	scriptRunner, server, input, counter,
			optMaxIterations, failed, time, optTiming, pathToFermat, optFerPath},

		If [OptionValue[FCVerbose]===False,
			frsVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				frsVerbose=OptionValue[FCVerbose]
			]
		];

		failed	= False;
		counter = 0;

		optMaxIterations	= OptionValue[MaxIterations];
		optTiming			= OptionValue[Timing];
		optFerPath			= OptionValue[FerPath];

		FCPrint[1,"FerRunScript: Entering.", FCDoControl->frsVerbose];

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

		scriptRunner = FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "Fermat","runFermatUnix.sh"}];

		time=AbsoluteTime[];
		FCPrint[If[optTiming,0,1],"FerRunScript: Running Fermat.","\n", UseWriteString -> True];

		FCPrint[1,"FerRunScript: Fermat script runner: ", scriptRunner,  FCDoControl->frsVerbose];
		FCPrint[1,"FerRunScript: Fermat binary: ", pathToFermat,  FCDoControl->frsVerbose];
		FCPrint[1,"FerRunScript: Fermat script file: ", pathToFermat,  FCDoControl->frsVerbose];

		server = StartProcess[{scriptRunner,pathToFermat,scriptFile}];

		If[	server === $Failed,
			Message[FerRunScript::failmsg,"Failed to execute StartProcess."];
			Abort[]
		];

		While[	input =!= EndOfFile,
				counter++;

				input = ReadLine[server];
				If[input === EndOfFile, Continue[]];
				FCPrint[1,"FerRunScript: ", input,"\n", UseWriteString -> True,  FCDoControl->frsVerbose];

				If[ input === " bye",
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

		FCPrint[If[optTiming,0,1],"FerRunScript: Done running Fermat, timing: ", N[AbsoluteTime[] - time, 4], "\n", UseWriteString -> True];

		FCPrint[1,"FerRunScript: ProcessStatus: ", ProcessStatus[server], FCDoControl->frsVerbose];

		FCPrint[1,"FerRunScript: Leaving.", FCDoControl->frsVerbose];
];








End[]


