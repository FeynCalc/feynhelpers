(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIREImportResults												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2022 Vladyslav Shtabovenko
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
	FCI			-> False,
	FCVerbose	-> False,
	Head		-> Identity
};

FIREImportResults[topos:{__FCTopology}, filePathRaw_String, opts:OptionsPattern[]] :=
	FIREImportResults[#[[1]],filePathRaw,opts]&/@topos;

FIREImportResults[topoName_/;!MatchQ[topoName,{__FCTopology}], pathRaw_String, OptionsPattern[]] :=
	Block[{	topo, res, tmp, id, optHead, tableData,holdGLI, repRule, pn, path},

		If[	OptionValue[FCVerbose]===False,
			firVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				firVerbose=OptionValue[FCVerbose]
			];
		];

		optHead = OptionValue[Head];

		FCPrint[1,"FIREImportResults: Entering.", FCDoControl->firVerbose];

		Which[
			FileExistsQ[pathRaw] && !DirectoryQ[pathRaw],
				path = pathRaw,
			FileExistsQ[pathRaw] && DirectoryQ[pathRaw],
				path = FileNameJoin[{pathRaw,ToString[topoName],ToString[topoName]<>".tables"}];
				If[	!FileExistsQ[path],
					Message[FIREImportResults::failmsg, "File not found: ", path];
					Abort[]
				],
			True,
			Message[FIREImportResults::failmsg, "File not found: ", pathRaw];
			Abort[]
		];

		tableData = Get[path];

		FCPrint[1,"FIREImportResults: Reduction table loaded.", FCDoControl->firVerbose];

		If[	MatchQ[topoName,{__Rule}],
			pn = First[tableData[[2]]][[2]][[1]];
			id = pn/.topoName,
			id = topoName
		];

		FCPrint[1,"FIREImportResults: id to be used: ", id, FCDoControl->firVerbose];


		tmp = {holdGLI[##[[1]]], {holdGLI[##[[1]]], ##[[2]]} & /@ ##[[2]]} & /@ tableData[[1]];

		FCPrint[3,"FIREImportResults: Preliminary tmp: ", tmp, FCDoControl->firVerbose];

		(*Remove integrals that count as masters and are mapped to themselves*)
		tmp = Replace[tmp, {holdGLI[x_], {{holdGLI[x_], "1"}}} :> Unevaluated[Sequence[]], 1];

		repRule = Rule[holdGLI[#[[1]]], GLI[id, #[[2]][[2]]]] & /@ tableData[[2]];

		tmp = tmp /. Dispatch[repRule];

		res = Map[Function[x,Rule[x[[1]],Total@Map[optHead[ToExpression[#[[2]]]] #[[1]] &, x[[2]]]]],tmp];

		res

	];




End[]
