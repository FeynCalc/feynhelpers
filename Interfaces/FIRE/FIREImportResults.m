(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIREImportResults												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Imports FIRE tables											*)

(* ------------------------------------------------------------------------ *)

FIREImportResults::usage=
"FIREImportResults[topoName, path] can be used to import results after a FIRE reduction.
";

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
	FCI					-> False,
	FCVerbose			-> False,
	Head				-> Identity
};

FIREImportResults[topos:{__FCTopology}, filePathRaw_String, opts:OptionsPattern[]] :=
	FIREImportResults[#[[1]],filePathRaw,opts]&/@topos;

FIREImportResults[topoName_/;Head[topoName]=!=List, pathRaw_String, OptionsPattern[]] :=
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
		If[	MatchQ[topoName,{__Rule}],
			pn = First[tableData[[2]]][[2]][[1]];
			id = pn/.topoName,
			id = topoName
		];


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
