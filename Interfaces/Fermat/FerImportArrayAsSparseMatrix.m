(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FerImportArrayAsSparseMatrix										*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Converts Fermat array into a sparse matrix					*)

(* ------------------------------------------------------------------------ *)

FerImportArrayAsSparseMatrix::usage =
"FerImportArrayAsSparseMatrix[outFile, var, {dimX, dimY}] is an auxiliary
function that converts the Fermat array called var from file outFile to a
SparseArray matrix with dimensions dimX and dimY.";

FerImportArrayAsSparseMatrix::failmsg =
"Error! FerImportArrayAsSparseMatrix has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";


Begin["`Package`"]

End[]

Begin["`FerImportArrayAsSparseMatrix`Private`"]

fiaVerbose::usage="";

Options[FerImportArrayAsSparseMatrix] = {
	FCVerbose 			-> False,
	FinalSubstitutions -> {}
};


FerImportArrayAsSparseMatrix[outFile_String, var_String, {dimX_Integer?Positive, dimY_Integer?Positive}, OptionsPattern[]] :=
	Block[{in, res, expr, optFinalSubstitutions},


		If [OptionValue[FCVerbose]===False,
			fiaVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				fiaVerbose=OptionValue[FCVerbose]
			]
		];

		optFinalSubstitutions	= OptionValue[FinalSubstitutions];

		FCPrint[1,"FerImportArrayAsSparseMatrix: Entering.", FCDoControl->fiaVerbose];

		If[!FileExistsQ[outFile],
			Message[FerImportArrayAsSparseMatrix::failmsg,"File not found."];
			Abort[]
		];

		FCPrint[1,"FerImportArrayAsSparseMatrix: Importing ", outFile, FCDoControl->fiaVerbose];

		in = Import[outFile, {"Text"}];

		If[(in===$Failed) || !StringQ[in],
			Message[FerImportArrayAsSparseMatrix::failmsg,"Failed to open " <> outFile];
			Abort[]
		];

		If[	StringLength[in]===0,
			Message[FerImportArrayAsSparseMatrix::failmsg, outFile <> "only contains an empty string."];
			Abort[]
		];


		FCPrint[3,"FerImportArrayAsSparseMatrix: Imported file:", in, FCDoControl->fiaVerbose];

		FCPrint[1,"FerImportArrayAsSparseMatrix: Applying StringSplit to the imported file.", FCDoControl->fiaVerbose];

		in = StringSplit[in, ";"];
		If[	Last[in] === " ",
			in = Most[in]
		];

		If[	Length[in]=!=dimX*dimY,
			Message[FerImportArrayAsSparseMatrix::failmsg,"Incorrect array dimensions."];
			Abort[]
		];

		FCPrint[1,"FerImportArrayAsSparseMatrix: Performing string replacements.", FCDoControl->fiaVerbose];

		in = Map[StringReplace[#, {var <> "[" -> "{", ";" -> "", "] :=" -> "}->"}]&, in];

		FCPrint[1,"FerImportArrayAsSparseMatrix: Applying ToExpression.", FCDoControl->fiaVerbose];

		expr = ToExpression[in];

		If[	!MatchQ[expr,{__Rule}],
			Message[FerImportArrayAsSparseMatrix::failmsg,"Failed to convert the Fermat array into a SparseArray."];
			Abort[]
		];


		If[	optFinalSubstitutions=!={},
			FCPrint[1,"FerImportArrayAsSparseMatrix: Applying final substitutions.", FCDoControl->fiaVerbose];
			expr = expr /. Dispatch[optFinalSubstitutions]
		];

		FCPrint[1,"FerImportArrayAsSparseMatrix: Creating SparseArray.", FCDoControl->fiaVerbose];

		res = SparseArray[expr, {dimX,dimY}];

		FCPrint[1,"FerImportArrayAsSparseMatrix: Leaving.", FCDoControl->fiaVerbose];

		res
	];

End[]

