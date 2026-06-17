(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIREImportResults												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2026 Vladyslav Shtabovenko
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

Options[FIREImportResults] = {
	FCI					-> False,
	FCReplaceD			-> {ToExpression["Global`d"]->D},
	FCVerbose			-> False,
	Head				-> Identity,
	ProgressIndicator	-> True,
	ToExpression		-> True
};

FIREImportResults[topos_List/;FreeQ[topos,FCTopology], filePathRaw_String, opts:OptionsPattern[]] :=
	Block[{	res, counter, out, optVerbose},

		If[	OptionValue[FCVerbose]===False,
			optVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				optVerbose=OptionValue[FCVerbose]
			];
		];

		If[	OptionValue[ProgressIndicator],

			counter=0;
			res = Map[(
				counter++;
				FCPrint[0, "Importing reduction tables ("<>ToString[counter]<>"/"<>ToString[Length[topos]]<> ") for ", FileBaseName[#], "... " ,UseWriteString -> True];
				out = FIREImportResults[#, filePathRaw, opts];
				FCPrint[0, "done.\n" ,UseWriteString -> True];
				out
				)&,topos];
				FCPrint[0, "\n" ,UseWriteString -> True],

			res = Map[FIREImportResults[#, filePathRaw, opts]&, topos];
		];

		FCPrint[0, "FIREImportResults: ", FeynCalc`Package`FCStyle["Imported ", {Darker[Green,0.55], Bold}], Length[res],
			FeynCalc`Package`FCStyle[" reduction tables.", {Darker[Green,0.55], Bold}], FCDoControl->optVerbose];

		res

	];

FIREImportResults[{(*mappings*)_List, topos: {__FCTopology}}, rest__] :=
	FIREImportResults[topos,rest];

FIREImportResults[topos:{__FCTopology}, filePathRaw_String, opts:OptionsPattern[]] :=
	FIREImportResults[#[[1]]&/@topos,filePathRaw,opts];

FIREImportResults[topoName_/;Head[topoName]=!=List, pathRaw_String, OptionsPattern[]] :=
	Block[{	topo, res, tmp, id, optHead, tableData, optVerbose,
			holdGLI, repRule, pn, path, time, optFCReplaceD},

		If[	OptionValue[FCVerbose]===False,
			optVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				optVerbose=OptionValue[FCVerbose]
			];
		];

		optHead = OptionValue[Head];
		optFCReplaceD = OptionValue[FCReplaceD];

		FCPrint[1,"FIREImportResults: Entering.", FCDoControl->optVerbose];

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

		FCPrint[1,"FIREImportResults: Loading the reduction table.", FCDoControl->optVerbose];
		time=AbsoluteTime[];
		tableData = Get[path];
		FCPrint[1,"FIREImportResults: Reduction table loaded, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->optVerbose];

		If[	MatchQ[topoName,{__Rule}],
			pn = First[tableData[[2]]][[2]][[1]];
			id = pn/.topoName,
			id = topoName
		];

		FCPrint[1,"FIREImportResults: id to be used: ", id, FCDoControl->optVerbose];


		FCPrint[1,"FIREImportResults: Processing the input.", FCDoControl->optVerbose];

		time=AbsoluteTime[];
		tmp = {holdGLI[##[[1]]], {holdGLI[##[[1]]], ##[[2]]} & /@ ##[[2]]} & /@ tableData[[1]];

		FCPrint[3,"FIREImportResults: Preliminary tmp: ", tmp, FCDoControl->optVerbose];

		(*Remove integrals that count as masters and are mapped to themselves*)
		tmp = Replace[tmp, {holdGLI[x_], {{holdGLI[x_], "1"}}} :> Unevaluated[Sequence[]], 1];

		repRule = Rule[holdGLI[#[[1]]], GLI[id, #[[2]][[2]]]] & /@ tableData[[2]];
		FCPrint[1,"FIREImportResults: Processing done, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->optVerbose];

		FCPrint[1,"FIREImportResults: Applying the replacement rule.", FCDoControl->optVerbose];
		time=AbsoluteTime[];
		tmp = tmp /. Dispatch[repRule];
		FCPrint[1,"FIREImportResults: Done applying the replacement rule, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->optVerbose];

		FCPrint[1,"FIREImportResults: Number of entries to process:", Length[tmp], FCDoControl->optVerbose];
		FCPrint[1,"FIREImportResults: LeafCount: ", LeafCount[tmp], FCDoControl->optVerbose];
		FCPrint[1,"FIREImportResults: ByteCount: ", ByteCount[tmp], FCDoControl->optVerbose];

		If[	OptionValue[ToExpression],
			FCPrint[1,"FIREImportResults: Applying ToExpression.", FCDoControl->optVerbose];
			time=AbsoluteTime[];

			res = Map[Function[x,Rule[x[[1]],Total@Map[optHead[ToExpression[#[[2]]]] #[[1]] &, x[[2]]]]],tmp];
			FCPrint[1,"FIREImportResults: Done applying ToExpression, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->optVerbose],

			FCPrint[1,"FIREImportResults: Generating results with string coefficients.", FCDoControl->optVerbose];
			time=AbsoluteTime[];

			res = Map[Function[x,Rule[x[[1]],Total@Map[optHead[#[[2]]] #[[1]] &, x[[2]]]]],tmp];
			FCPrint[1,"FIREImportResults: Done generating results, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->optVerbose];
		];

		If[	optFCReplaceD=!={},
			FCPrint[1,"FIREImportResults: Applying FCReplaceD.", FCDoControl->optVerbose];
			time=AbsoluteTime[];
			res = FCReplaceD[res,optFCReplaceD];
			FCPrint[1,"FIREImportResults: FCReplaceD done, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->optVerbose];
		];

		res

	];




End[]
