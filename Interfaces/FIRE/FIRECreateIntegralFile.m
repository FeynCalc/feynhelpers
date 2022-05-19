(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRECreateIntegralFile											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates FIRE integral files out of GLIs					*)

(* ------------------------------------------------------------------------ *)

FIRECreateIntegralFile::usage=
"FIRECreateIntegralFile[ex, topo, id, path] extracts GLI symbols from ex belonging
to the topology topo and saves them as a list of integrals for FIRE.
";

FIRECreateIntegralFile::failmsg =
"Error! FIRECreateIntegralFile has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIRECreateIntegralFile`Private`"]

fpsfVerbose::usage="";

Options[FIRECreateIntegralFile] = {
	FCI					-> False,
	FCVerbose			-> False,
	FIREIntegrals		-> "LoopIntegrals.m",
	OverwriteTarget		-> True
};

FIRECreateIntegralFile[expr_, topos: {__FCTopology}, dir_String, opts:OptionsPattern[]] :=
	Map[FIRECreateIntegralFile[expr, #,4242,dir,opts]&,topos];

FIRECreateIntegralFile[expr_, topos: {__FCTopology}, idRaw_List, dir__String, opts:OptionsPattern[]] :=
	MapThread[FIRECreateIntegralFile[expr, #1,#2,dir,opts]&,{topos,idRaw}];

FIRECreateIntegralFile[expr_, topos: {__FCTopology}, idRaw_List, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[FIRECreateIntegralFile[expr, #1,#2,#3,opts]&,{topos,idRaw,dirs}];

FIRECreateIntegralFile[expr_, topos: {__FCTopology}, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[FIRECreateIntegralFile[expr, #1,4242,#3,opts]&,{topos,dirs}];

FIRECreateIntegralFile[expr_, topos: {__FCTopology}, idRaw_List, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[FIRECreateIntegralFile[expr, #1,#2,#3,opts]&,{topos,idRaw,dirs}];

FIRECreateIntegralFile[expr_, topoRaw_FCTopology, dirRaw_String, opts:OptionsPattern[]] :=
	FIRECreateIntegralFile[expr, topoRaw, 4242, dirRaw, opts];

FIRECreateIntegralFile[expr_, topoRaw_FCTopology, idRaw_, dirRaw_String, OptionsPattern[]] :=
	Block[{	ex, topo, gliList, optNames, newNames, res, vars, id, topoName,
			file, filePath, optOverwriteTarget, status, dir, null1, null2},

		If[	OptionValue[FCVerbose]===False,
			fpsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fpsfVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget = OptionValue[OverwriteTarget];

		FCPrint[1,"FIRECreateIntegralFile: Entering.", FCDoControl->fpsfVerbose];
		FCPrint[3,"FIRECreateIntegralFile: Entering with:", topoRaw, FCDoControl->fpsfVerbose];

		If[	OptionValue[FCI],
			{ex, topo} = {expr, topoRaw},
			{ex, topo} = FCI[{expr, topoRaw}]
		];

		If[	!FCLoopValidTopologyQ[topo],
			Message[FIRECreateIntegralFile::failmsg, "The supplied topology is incorrect."];
			Abort[]
		];

		Which[
			MatchQ[idRaw,_Integer?Positive],
				id = idRaw,
			MatchQ[idRaw,{__Rule}],
				id = topo[[1]]/.idRaw,
			True,
				Message[FIRECreateIntegralFile::failmsg, "The id argument must be a positive integer or a list of rules."];
				Abort[]
		];


		topoName = topo[[1]];
		(*TODO: More freedom here*)
		dir = FileNameJoin[{dirRaw,ToString[topoName]}];

		FCPrint[2,"FIRECreateIntegralFile: Problem number: ", id, FCDoControl->fpsfVerbose];
		FCPrint[2,"FIRECreateIntegralFile: TopoID: ", topoName, FCDoControl->fpsfVerbose];

		If[	!MatchQ[id,_Integer?Positive],
			Message[FIRECreateIntegralFile::failmsg, "Invalid FIRE problem number."];
			Abort[]
		];

		gliList = Cases[ex+null1+null2,x:GLI[topo[[1]],_]:>x,Infinity]//Union;

		FCPrint[0,"FIRECreateIntegralFile: Number of loop integrals: ", Length[gliList], FCDoControl->fpsfVerbose];

		FCPrint[3,"FIRECreateIntegralFile: List of GLIs: ", gliList, FCDoControl->fpsfVerbose];

		If[	!DirectoryQ[dir],
			status = CreateDirectory[dir];
			If[	status===$Failed,
				Message[FIRECreateIntegralFile::failmsg, "Failed to create directory ", dir];
				Abort[]
			];
		];

		gliList = Map[{id,#[[2]]}&,gliList];

		FCPrint[3,"FIRECreateIntegralFile: Converted GLIs: ", gliList, FCDoControl->fpsfVerbose];



		filePath = FileNameJoin[{dir, OptionValue[FIREIntegrals]}];

		FCPrint[3,"FIRECreateIntegralFile: Integral file path: ", filePath, FCDoControl->fpsfVerbose];

		If[	FileExistsQ[filePath] && !optOverwriteTarget,
			Message[FIRECreateIntegralFile::failmsg, "The file ", filePath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		file = Put[gliList,filePath];
		If[	file===$Failed,
			Message[FIRECreateIntegralFile::failmsg, "Failed to save the integrals to ", filePath];
			Abort[]
		];

		filePath
	];



End[]
