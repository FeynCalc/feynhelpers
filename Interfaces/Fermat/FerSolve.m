(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FerSolve															*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Fermat version of Solve										*)

(* ------------------------------------------------------------------------ *)


FerSolve::usage =
"FerSolve[eqs, vars] solves the system of linear equations eqs for the
variables vars by calculating the row-reduced form of the corresponding
augmented matrix using Fermat by R. Lewis.

The location of script, input and output files is controlled by the options
FerScriptFile, FerInputFile, FerOutputFile. When set to Automatic (default),
these files will be automatically created via
CreateTemporary[]. If the option Delete is set to True (default), the files
will be deleted after a successful Fermat run.";

FerSolve::failmsg =
"Error! FerSolve has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

Begin["`Package`"]

End[]

Begin["`FerSolve`Private`"]

fsVerbose::usage="";



Options[FerSolve] = {
	Check				-> True,
	DeleteFile			-> True,
	FCVerbose 			-> False,
	FerInputFile		-> Automatic,
	FerOutputFile		-> Automatic,
	FerPath				-> Automatic,
	FerScriptFile		-> Automatic,
	"SetPivotStrategy"	-> 0,
	SparseArray			-> False,
	Timing				-> True
};

FerSolve[eqs_List, vars_List, OptionsPattern[]]:=
	Block[{	aPiece, bPiece, augMatrix, res, size, inFile, outFile,
			scriptFile, sol, time, checkVars, checkRule, checkPrimes,
			checkRes, checkSol},


		If [OptionValue[FCVerbose]===False,
			fsVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				fsVerbose=OptionValue[FCVerbose]
			]
		];

		inFile 		= OptionValue[FerInputFile];
		outFile 	= OptionValue[FerOutputFile];
		scriptFile	= OptionValue[FerScriptFile];

		If[	inFile === Automatic,
			inFile = CreateTemporary[];
		];

		If[	outFile === Automatic,
			outFile = CreateTemporary[];
		];

		If[	scriptFile === Automatic,
			scriptFile = CreateTemporary[];
		];

		If[!MatchQ[eqs, {__Equal}],
			Message[FerSolve::failmsg,"The input does not contain a valid system of equations."];
			Abort[]
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

		FCPrint[1,"FerSolve: Done constructing the augmented matrix, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->fsVerbose];
		FCPrint[3,"FerSolve: Augmented matrix: ", augMatrix, FCDoControl->fsVerbose];

		If[!MatrixQ[augMatrix],
			Message[FerSolve::failmsg,"Failed to obtain the augmented matrix."];
			Abort[]
		];

		FCPrint[1,"FerSolve: Calling RowReduce.", FCDoControl->fsVerbose];
		time=AbsoluteTime[];

		res = FerRowReduce[augMatrix, FerInputFile->inFile, FerOutputFile->outFile, FerScriptFile->scriptFile, FCVerbose-> fsVerbose,
			DeleteFile -> OptionValue[DeleteFile], SparseArray -> OptionValue[SparseArray], "SetPivotStrategy"	-> OptionValue["SetPivotStrategy"]];

		FCPrint[1, "FerSolve: RowReduce done, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->fsVerbose];

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
		FCPrint[3,"FerSolve: Final solution: ", res, FCDoControl->fsVerbose];

		If[	OptionValue[Check],

			time=AbsoluteTime[];
			FCPrint[0, "FerSolve: Verifying the result.","\n", UseWriteString -> True, FCDoControl->fsVerbose];

			checkVars 	= Variables[augMatrix];
			checkPrimes = Table[RandomPrime[{10^6, 10^7}],{i,1,Length[checkVars]}];
			checkRule 	= Thread[Rule[checkVars,checkPrimes]];
			checkSol 	= sol /. Dispatch[checkRule];
			checkRes 	= eqs /. Dispatch[checkRule];
			checkRes 	= checkRes /. Dispatch[checkSol];
			checkRes 	= Together/@checkRes;

			If[	!MatchQ[checkRes,{True..}],
				Message[FerSolve::failmsg,"The obtained solution is incorrect."];
				Abort[]
			];

			FCPrint[0, "FerSolve: Done verifying the result, timing: ", N[AbsoluteTime[] - time, 4], "\n", UseWriteString -> True, FCDoControl->fsVerbose];

		];

		FCPrint[1,"FerSolve: Leaving.", FCDoControl->fsVerbose];

		sol
	];


End[]

