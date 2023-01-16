(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: KiraImportResults												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2022-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Imports Kira tables											*)

(* ------------------------------------------------------------------------ *)

KiraImportResults::usage=
"KiraImportResults[topoName, path]  imports the content of a Kira reduction
table and converts the results to replacement rules for GLIs with the id
topoName.

Notice that topoName can be also a list of replacement rules that link FIRE
ids to FCTopology ids. For the sake of convenience one can also use full
FCTopology objects instead of their ids as in  KiraImportResults[topo, path]
or KiraImportResults[{topo1, topo2, ...}, path].

If path represents a full path to a file, then this file is loaded. If it is
just a path to a directory, then path/topoName/topoName is assumed to be the
full path.";

KiraImportResults::failmsg =
"Error! KiraImportResults has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`KiraImportResults`Private`"]

kirVerbose::usage="";

Options[KiraImportResults] = {
	FCI				-> False,
	FCReplaceD		-> {ToExpression["Global`d"]->D},
	FCVerbose		-> False
};

KiraImportResults[topos:{__String}, filePathRaw_String, opts:OptionsPattern[]] :=
	KiraImportResults[#,filePathRaw,opts]&/@topos;

KiraImportResults[topos:{__FCTopology}, filePathRaw_String, opts:OptionsPattern[]] :=
	KiraImportResults[#[[1]],filePathRaw,opts]&/@topos;

KiraImportResults[topoName_/;!MatchQ[topoName,{__FCTopology}], pathRaw_String, OptionsPattern[]] :=
	Block[{	res, tmp, tableData, repRule, path, time, optFCReplaceD, gliInts, gli},

		If[	OptionValue[FCVerbose]===False,
			kirVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				kirVerbose=OptionValue[FCVerbose]
			];
		];

		optFCReplaceD = OptionValue[FCReplaceD];

		FCPrint[1,"KiraImportResults: Entering.", FCDoControl->kirVerbose];

		Which[
			FileExistsQ[pathRaw] && !DirectoryQ[pathRaw],
				path = pathRaw,
			FileExistsQ[pathRaw] && DirectoryQ[pathRaw],
				path = FileNameJoin[{pathRaw,ToString[topoName],"results",ToString[topoName],"kira_" <> ToString[topoName] <> ".m"}];
				If[	!FileExistsQ[path],
					Message[KiraImportResults::failmsg, "File not found: " <> path];
					Abort[]
				],
			True,
			Message[KiraImportResults::failmsg, "File not found: " <> pathRaw];
			Abort[]
		];

		FCPrint[1,"KiraImportResults: Loading the reduction table.", FCDoControl->kirVerbose];
		time=AbsoluteTime[];
		tableData = Get[path];
		FCPrint[1,"KiraImportResults: Reduction table loaded, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->kirVerbose];

		kiraInts = SelectFree[Cases[tableData, _[__Integer], Infinity], Rational];

		FCPrint[1,"KiraImportResults: Processing the input.", FCDoControl->kirVerbose];

		time=AbsoluteTime[];

		If[	TrueQ[Head[topoName]===String],
			gliInts = Map[GLI[ToString[Head[#]],Apply[List,#]]&, kiraInts],
			gliInts = Map[GLI[Head[#],Apply[List,#]]&, kiraInts]
		];

		FCPrint[3,"KiraImportResults: Preliminary tmp: ", tmp, FCDoControl->kirVerbose];

		repRule= Thread[Rule[kiraInts,gliInts]];
		FCPrint[1,"KiraImportResults: Processing done, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->kirVerbose];

		FCPrint[1,"KiraImportResults: Applying the replacement rule.", FCDoControl->kirVerbose];
		time=AbsoluteTime[];
		res = tableData /. Dispatch[repRule];
		FCPrint[1,"KiraImportResults: Done applying the replacement rule, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->kirVerbose];

		FCPrint[1,"KiraImportResults: Number of entries to process:", Length[res], FCDoControl->kirVerbose];
		FCPrint[1,"KiraImportResults: LeafCount: ", LeafCount[res], FCDoControl->kirVerbose];
		FCPrint[1,"KiraImportResults: ByteCount: ", ByteCount[res], FCDoControl->kirVerbose];

		If[	optFCReplaceD=!={},
			FCPrint[1,"KiraImportResults: Applying FCReplaceD.", FCDoControl->kirVerbose];
			time=AbsoluteTime[];
			res = FCReplaceD[res,optFCReplaceD];
			FCPrint[1,"KiraImportResults: FCReplaceD done, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->kirVerbose];
		];

		res

	];

End[]
