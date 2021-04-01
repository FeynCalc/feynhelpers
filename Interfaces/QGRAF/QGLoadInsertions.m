(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: QGLoadInsertions													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Load insertion rules for amplitudes generated with QGRAF	*)

(* ------------------------------------------------------------------------ *)

QGLoadInsertions::usage="
QGLoadInsertions[\"insertion.m\"] loads insertion rules from insertion.m for amplitudes \
generated with QGRAF. Specifying only the file name means that QGLoadInsertions will \
search for the file first in $QGInsertionsDirectory and then in the current directory. \
Specifying the full path will force the function to load the file from there directly. \n
Evaluating QGLoadInsertions[] loads some common insertions from QGCommonInsertions.m that \
are shipped with this interface.";

QGLoadInsertions::fail=
"QGLoadInsertions has encountered an error and must abort the evaluation. The \
error description reads: `1`";

Begin["`Package`"]

End[]

Begin["`QGInsertions`Private`"]

qgliVerbose::usage="";

Options[QGLoadInsertions] =
{
	FCVerbose -> False
};

QGLoadInsertions[] :=
	QGLoadInsertions["QGCommonInsertions.m"];

QGLoadInsertions[ins_String/;ins=!="",OptionsPattern[]] :=
	Block[{insFile, loadedInsertion, finalInsertions, res},

		If [OptionValue[FCVerbose]===False,
			qgliVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				qgliVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1,"QGLoadInsertions: Entering. ", FCDoControl->qgliVerbose];
		insFile = FeynCalc`Package`qdLoadFileFrom[ins, $QGInsertionsDirectory];
		FCPrint[1,"QGLoadInsertions: Full path to the insertions file: ", insFile, FCDoControl->qgliVerbose];

		loadedInsertion = Get[insFile];

		If[	loadedInsertion===$Failed,
			Message[QGLoadInsertions::fail,"Failed to load the file with the insertion rules."];
			Abort[]
		];

		Quiet[FCPrint[3,"QGLoadInsertions: Content of the insertion rules file: ", loadedInsertion , FCDoControl->qgliVerbose],{Last::normal}];

		If[	Head[loadedInsertion]=!=List || !MatchQ[DeleteDuplicates[Sort[(Head /@ (loadedInsertion))]], {Rule} | {RuleDelayed} | {Rule,RuleDelayed}],
			Message[QGLoadInsertions::fail,"The loaded file does not contain a valid list of insertion rules."];
			Abort[]
		];

		With[{xx = FileBaseName[ins], yy = loadedInsertion}, QGInsertionRule[xx] = yy];

		FCPrint[1,"QGLoadInsertions: Leaving. ", FCDoControl->qgliVerbose];

		insFile

	];




End[]

