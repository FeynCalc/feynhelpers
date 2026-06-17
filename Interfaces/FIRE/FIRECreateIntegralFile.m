(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRECreateIntegralFile											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2026 Vladyslav Shtabovenko
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

Options[FIRECreateIntegralFile] = {
	Check				-> True,
	FCI					-> False,
	FCVerbose			-> False,
	FIREIntegrals		-> "LoopIntegrals.m",
	ProgressIndicator	-> True,
	OverwriteTarget		-> True
};

FIRECreateIntegralFile[expr_, {(*mappings*)_List, topos: {__FCTopology}}, rest__] :=
	FIRECreateIntegralFile[expr, topos,rest];

FIRECreateIntegralFile[expr_, topos: {__FCTopology}, dir_String, opts:OptionsPattern[]] :=
	FIRECreateIntegralFile[expr, topos,ConstantArray[4242,Length[topos]],ConstantArray[dir,Length[topos]],opts];

FIRECreateIntegralFile[expr_, topos: {__FCTopology}, idRaw_List, dir__String, opts:OptionsPattern[]] :=
	FIRECreateIntegralFile[expr, topos,idRaw,ConstantArray[dir,Length[topos]],opts];

FIRECreateIntegralFile[expr_, topos: {__FCTopology}, dirs: {__String}, opts:OptionsPattern[]] :=
	FIRECreateIntegralFile[expr, topos,ConstantArray[4242,Length[topos]],dirs,opts];

FIRECreateIntegralFile[expr_, topoRaw_FCTopology, dirRaw_String, opts:OptionsPattern[]] :=
	FIRECreateIntegralFile[expr, topoRaw, 4242, dirRaw, opts];


FIRECreateIntegralFile[expr_, topos: {__FCTopology}, idRaw_List, dirs: {__String}, opts:OptionsPattern[]] :=
	Block[{res,optVerbose},

		If[	OptionValue[FCVerbose]===False,
			optVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				optVerbose=OptionValue[FCVerbose]
			];
		];

		res = MapThread[(
			FIRECreateIntegralFile[expr,#1,#2,#3,opts]
			)&,{topos,idRaw,dirs}];

		If[	OptionValue[ProgressIndicator],
			FCPrint[0, "\n" ,UseWriteString -> True]
		];


		FCPrint[0, "FIRECreateIntegralFile: ", FeynCalc`Package`FCStyle["Created ", {Darker[Green,0.55], Bold}], Length[res],
			FeynCalc`Package`FCStyle[" integral files.", {Darker[Green,0.55], Bold}], FCDoControl->optVerbose];

		res


	];

FIRECreateIntegralFile[expr_, topoRaw_FCTopology, idRaw_, dirRaw_String, OptionsPattern[]] :=
	Block[{	ex, topo, gliList, optNames, newNames, res, vars, id, topoName, optVerbose,
			file, filePath, optOverwriteTarget, status, dir, null1, null2},

		If[	OptionValue[FCVerbose]===False,
			optVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				optVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget = OptionValue[OverwriteTarget];

		FCPrint[1,"FIRECreateIntegralFile: Entering.", FCDoControl->optVerbose];
		FCPrint[3,"FIRECreateIntegralFile: Entering with:", topoRaw, FCDoControl->optVerbose];

		If[	OptionValue[FCI],
			{ex, topo} = {expr, topoRaw},
			{ex, topo} = FCI[{expr, topoRaw}]
		];

		If[	OptionValue[Check],
			If[	!FCLoopValidTopologyQ[topo],
				Message[FIRECreateIntegralFile::failmsg, "The supplied topology is incorrect."];
				Abort[]
			];
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

		FCPrint[2,"FIRECreateIntegralFile: Problem number: ", id, FCDoControl->optVerbose];
		FCPrint[2,"FIRECreateIntegralFile: TopoID: ", topoName, FCDoControl->optVerbose];

		If[	!MatchQ[id,_Integer?Positive],
			Message[FIRECreateIntegralFile::failmsg, "Invalid FIRE problem number."];
			Abort[]
		];

		gliList = Cases[ex+null1+null2,x:GLI[topo[[1]],_]:>x,Infinity]//Union;

		If[	OptionValue[ProgressIndicator],
			If[	TrueQ[Length[gliList]>0],
				FCPrint[0,ToString[topoName] <> ", number of loop integrals: " <> ToString[Length[gliList]]<>"\n",UseWriteString -> True, FCDoControl->optVerbose],
				FCPrint[0,"FIRECreateIntegralFile: ", Style["You list of integrals is empty, so no reduction is needed.", {Darker[Red,0.55], Bold}], FCDoControl->optVerbose];
			];
		];

		FCPrint[3,"FIRECreateIntegralFile: List of GLIs: ", gliList, FCDoControl->optVerbose];

		If[	!DirectoryQ[dir],
			status = CreateDirectory[dir];
			If[	status===$Failed,
				Message[FIRECreateIntegralFile::failmsg, "Failed to create directory ", dir];
				Abort[]
			];
		];

		gliList = Map[{id,#[[2]]}&,gliList];

		FCPrint[3,"FIRECreateIntegralFile: Converted GLIs: ", gliList, FCDoControl->optVerbose];

		filePath = FileNameJoin[{dir, OptionValue[FIREIntegrals]}];

		FCPrint[3,"FIRECreateIntegralFile: Integral file path: ", filePath, FCDoControl->optVerbose];

		If[	FileExistsQ[filePath] && !optOverwriteTarget,
			Message[FIRECreateIntegralFile::failmsg, "The file ", filePath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		file = Put[gliList,filePath];
		If[	file===$Failed,
			Message[FIRECreateIntegralFile::failmsg, "Failed to save the integrals to ", filePath];
			Abort[]
		];

		(*Check for tables!!!*)
		If[OptionValue[Check],
			If[	!FileExistsQ[filePath],
				Message[FIRECreateIntegralFile::failmsg, "Failed to create .config file."];
				Return[False]
			];
		];

		filePath
	];



End[]
