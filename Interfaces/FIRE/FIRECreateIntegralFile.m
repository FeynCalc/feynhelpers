(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRECreateIntegralFile											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates FIRE integral files out of GLIs					*)

(* ------------------------------------------------------------------------ *)

FIRECreateIntegralFile::usage=
"FIRECreateIntegralFile[ex, topo, fireID, path] extracts GLI symbols from ex
that belong to the topology topo. The resulting list of integrals is saved to
path/topoName/LoopIntegrals.m and can be referred to in the corresponding FIRE
.config file.

If the directory specified in path/topoName does not exist, it will be created
automatically. If it already exists, its content will be automatically
overwritten, unless the option OverwriteTarget is set to False.

If no fireID is given, i.e. the function is called as
FIRECreateIntegralFile[topo,  path], then the default value 4242 is used.

Notice that ex may also contain integrals from different topologies, as long
as all those topologies are provided as a list in the topo argument.

It is also possible to invoke  the routine as FIRECreateIntegralFile[ex,
{topo1, topo2, ...}, {id1, id2, ...}, {path1, path2, ...}] or
FIRECreateIntegralFile[ex, {topo1, topo2, ...}, {path1, path2, ...}]if one
needs to process a list of topologies.

The syntax  FIRECreateIntegralFile[ex, {topo1, topo2, ...}, {id1, id2, ...},
path] or FIRECreateIntegralFile[ex, {topo1, topo2, ...}, path] is also
allowed. This implies that all config files will go into the corresponding
subdirectories of path, e.g. path/topoName1, path/topoName2 etc.

The default name of the file containing loop integrals for the reduction is
\"LoopIntegrals.m\". It can be changed via the option FIREIntegrals.";

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
	MapThread[FIRECreateIntegralFile[expr, #1,4242,#2,opts]&,{topos,dirs}];

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
