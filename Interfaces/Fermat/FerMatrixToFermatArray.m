(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FerMatrixToFermatArray											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Converts matrices to Fermat arrays							*)

(* ------------------------------------------------------------------------ *)

FerMatrixToFermatArray::usage =
"FerMatrixToFermatArray[mat,varName] is an auxiliary function that converts the
matrix mat to a Fermat array named varName, where the latter must be a string.

The function returns a string that represents the matrix, a list of auxiliary
variables (introduced to be compatible with the restrictions of Fermat) and a
replacement rule for converting auxiliary variables back into the original
variables.";

Begin["`Package`"]

End[]

Begin["`FerMatrixToFermatArray`Private`"]


Options[FerMatrixToFermatArray] = {
	Names-> Function[i, ToExpression["fv" <> ToString[i]]]
};


FerMatrixToFermatArray[matRaw_?MatrixQ, varName_String, OptionsPattern[]] :=
	Block[{	sizeX, sizeY, str, strLen, dims, matVars, repRule,
			optNames, newVars, mat},

		optNames = OptionValue[Names];

		{sizeX, sizeY}	= ToString/@Dimensions[matRaw];
		matVars 		= Variables[matRaw];

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


End[]

