(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: QGRAFShared														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and QGRAF						*)

(* ------------------------------------------------------------------------ *)

$QGModelsDirectory::usage=
"$QGModelsDirectory is the string that represents the full path to the default
models directory.";

$QGStylesDirectory::usage=
"$QGStylesDirectory is the string that represents the full path to the default
styles directory.";

$QGTeXDirectory::usage=
"$QGTeXDirectory is the string that represents the full path to the directory
that contains LaTeX templates files useful for visualizing Feynman diagrams.";

$QGInsertionsDirectory::usage=
"$QGInsertionsDirectory is the string that represents the full path to the
directory that contains Feynman rules for vertices, propagators and external
states to be inserted into amplitudes generated with QGRAF.";

$QGLogOutputAmplitudes::usage=
"$QGLogOutputAmplitudes contains the full standard output of the QGRAF binary
after generating the amplitudes.";

$QGLogOutputDiagrams::usage=
"$QGLogOutputDiagrams contains the full standard output of the QGRAF binary
after generating the diagrams.";

QGPolarization::usage=
"QGPolarization[psi[index, momentum], mass] is a placeholder for the external \
state of the field psi (e.g. a polarization vector or a spinor). It is
introduced in the QGARF style file \"feyncalc.sty\"";

QGTruncatedPolarization::usage=
"QGTruncatedPolarization[psi[index, momentum], mass] is a placeholder for the
truncated external state of the field psi. It is introduced in the QGARF style
file \"feyncalc.sty\".";

QGPropagator::usage=
"QGPropagator[psi[index1, momentum], psibar[index2, momentum], mass] is a
placeholder for the propagator  of the field psi. It is introduced in the
QGARF style file \"feyncalc.sty\".";

QGVertex::usage=
"QGVertex[psi1[index1, momentum1], psi2[index2, momentum2], ...] is a
placeholder for the interaction vertex of the fields psi1, psi2, .... It is
introduced in the QGARF style file \"feyncalc.sty\".";

QGInsertionRule::usage=
"QGInsertionRule[\"names\"] is a set of replacement rules for inserting
explicit vertices, propagators and polarization vectors into the amplitudes
generated by QGRAF. These rules are loaded via QGLoadInsertions. Running
QGInsertionRule[] returns a list of the already loaded sets of rules.";

QGShared::failmsg =
"The QGRAF interface has encountered an error and must abort the evaluation. The \
error description reads: `1`";

Begin["`Package`"]

End[]

Begin["`QGRAFShared`Private`"]


$QGModelsDirectory 		= FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "QGRAF", "Models"}];
$QGStylesDirectory 		= FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "QGRAF", "Styles"}];
$QGTeXDirectory 		= FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "QGRAF", "LaTeX"}];
$QGInsertionsDirectory 	= FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "QGRAF", "Insertions"}];


QGInsertionRule[]:=
	Block[{tmp, qgrule},
		tmp = SelectFree[ DownValues[QGInsertionRule] /. QGInsertionRule -> qgrule /.HoldPattern -> Identity, qgrule[]];
		(First/@tmp) /. qgrule -> Identity
	];


(*
	This is a small helper function that determines the full path to the file. If the path
	has already been given, there is nothing to do. If only the file name was give, it will
	check whether the file can be found in
	1) the current working directory
	2) the specified directory
*)
FeynCalc`Package`qdLoadFileFrom[fileString_String, dirToCheck_String]:=
	Block[{finalPath=""},
		If[	!FileExistsQ[dirToCheck],
			Message[QGShared::failmsg,"The directory "<> dirToCheck <> " does not exist."];
			Abort[]
		];

		If[	TrueQ[FileNameTake[fileString] === fileString],
			(* only the filename was given *)
			Which[

				FileExistsQ[FileNameJoin[{Directory[],fileString}]],
				finalPath = FileNameJoin[{Directory[],fileString}],

				FileExistsQ[FileNameJoin[{dirToCheck,fileString}]],
				finalPath = FileNameJoin[{dirToCheck,fileString}],

				True,
				Message[QGShared::failmsg,"The file " <> fileString <> " does not exist."];
				Abort[]
			],
			(* the full path was given *)
			If[TrueQ[FileExistsQ[fileString]],
				finalPath = fileString,

				Message[QGShared::failmsg,"The file " <> fileString <> " does not exist."];
				Abort[]
			]
		];

		If[	finalPath==="" || !FileExistsQ[finalPath],
			Message[QGShared::failmsg,"Something went wrong when determining the full path to " <> fileString <> " ."];
			Abort[]

		];

		finalPath

	];


End[]

