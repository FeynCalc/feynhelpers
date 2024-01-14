(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIREImportResults												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Imports FIRE tables											*)

(* ------------------------------------------------------------------------ *)

FIREImportResults::usage=
"FIREImportResults[topoName, path]  imports the content of a FIRE .tables file
and converts the results to replacement rules for GLIs with the id topoName.

Notice that topoName can be also a list of replacement rules that link FIRE
ids to FCTopology ids. For the sake of convenience one can also use full
FCTopology objects instead of their ids as in  FIREImportResults[topo, path]
or FIREImportResults[{topo1, topo2, ...}, path].

If path represents a full path to a file, then this file is loaded. If it is
just a path to a directory, then path/topoName/topoName is assumed to be the
full path.";

FIREImportResults::failmsg =
"Error! FIREImportResults has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIREImportResults`Private`"]

firVerbose::usage="";
optDimension::usage="";
optComplex::usage="";



Options[FIREImportResults] = {
	FCI				-> False,
	FCReplaceD		-> {ToExpression["Global`d"]->D},
	FCVerbose		-> False,
	Head			-> Identity,
	ToExpression	-> True
};

FIREImportResults[topos:{__String}, filePathRaw_String, opts:OptionsPattern[]] :=
	FIREImportResults[#,filePathRaw,opts]&/@topos;

FIREImportResults[topos:{__FCTopology}, filePathRaw_String, opts:OptionsPattern[]] :=
	FIREImportResults[#[[1]],filePathRaw,opts]&/@topos;

FIREImportResults[topoName_/;!MatchQ[topoName,{__FCTopology}], pathRaw_String, OptionsPattern[]] :=
	Block[{	topo, res, tmp, id, optHead, tableData,
			holdGLI, repRule, pn, path, time, optFCReplaceD},

		If[	OptionValue[FCVerbose]===False,
			firVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				firVerbose=OptionValue[FCVerbose]
			];
		];

		optHead = OptionValue[Head];
		optFCReplaceD = OptionValue[FCReplaceD];

		FCPrint[1,"FIREImportResults: Entering.", FCDoControl->firVerbose];

		Which[
			FileExistsQ[pathRaw] && !DirectoryQ[pathRaw],
				path = pathRaw,
			FileExistsQ[pathRaw] && DirectoryQ[pathRaw],
				path = FileNameJoin[{pathRaw,ToString[topoName],ToString[topoName]<>".tables"}];
				If[	!FileExistsQ[path],
					Message[FIREImportResults::failmsg, "File not found: " <> path];
					Abort[]
				],
			True,
			Message[FIREImportResults::failmsg, "File not found: " <> pathRaw];
			Abort[]
		];

		FCPrint[1,"FIREImportResults: Loading the reduction table.", FCDoControl->firVerbose];
		time=AbsoluteTime[];
		tableData = Get[path];
		FCPrint[1,"FIREImportResults: Reduction table loaded, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->firVerbose];

		If[	MatchQ[topoName,{__Rule}],
			pn = First[tableData[[2]]][[2]][[1]];
			id = pn/.topoName,
			id = topoName
		];

		FCPrint[1,"FIREImportResults: id to be used: ", id, FCDoControl->firVerbose];


		FCPrint[1,"FIREImportResults: Processing the input.", FCDoControl->firVerbose];

		time=AbsoluteTime[];
		tmp = {holdGLI[##[[1]]], {holdGLI[##[[1]]], ##[[2]]} & /@ ##[[2]]} & /@ tableData[[1]];

		FCPrint[3,"FIREImportResults: Preliminary tmp: ", tmp, FCDoControl->firVerbose];

		(*Remove integrals that count as masters and are mapped to themselves*)
		tmp = Replace[tmp, {holdGLI[x_], {{holdGLI[x_], "1"}}} :> Unevaluated[Sequence[]], 1];

		repRule = Rule[holdGLI[#[[1]]], GLI[id, #[[2]][[2]]]] & /@ tableData[[2]];
		FCPrint[1,"FIREImportResults: Processing done, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->firVerbose];

		FCPrint[1,"FIREImportResults: Applying the replacement rule.", FCDoControl->firVerbose];
		time=AbsoluteTime[];
		tmp = tmp /. Dispatch[repRule];
		FCPrint[1,"FIREImportResults: Done applying the replacement rule, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->firVerbose];

		FCPrint[1,"FIREImportResults: Number of entries to process:", Length[tmp], FCDoControl->firVerbose];
		FCPrint[1,"FIREImportResults: LeafCount: ", LeafCount[tmp], FCDoControl->firVerbose];
		FCPrint[1,"FIREImportResults: ByteCount: ", ByteCount[tmp], FCDoControl->firVerbose];

		If[	OptionValue[ToExpression],
			FCPrint[1,"FIREImportResults: Applying ToExpression.", FCDoControl->firVerbose];
			time=AbsoluteTime[];

			res = Map[Function[x,Rule[x[[1]],Total@Map[optHead[ToExpression[#[[2]]]] #[[1]] &, x[[2]]]]],tmp];
			FCPrint[1,"FIREImportResults: Done applying ToExpression, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->firVerbose],

			FCPrint[1,"FIREImportResults: Generating results with string coefficients.", FCDoControl->firVerbose];
			time=AbsoluteTime[];

			res = Map[Function[x,Rule[x[[1]],Total@Map[optHead[#[[2]]] #[[1]] &, x[[2]]]]],tmp];
			FCPrint[1,"FIREImportResults: Done generating results, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->firVerbose];
		];

		If[	optFCReplaceD=!={},
			FCPrint[1,"FIREImportResults: Applying FCReplaceD.", FCDoControl->firVerbose];
			time=AbsoluteTime[];
			res = FCReplaceD[res,optFCReplaceD];
			FCPrint[1,"FIREImportResults: FCReplaceD done, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->firVerbose];
		];

		res

	];




End[]
