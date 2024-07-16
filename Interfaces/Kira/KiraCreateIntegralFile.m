(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: KiraCreateIntegralFile											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2022-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates KIRA integral files out of GLIs					*)

(* ------------------------------------------------------------------------ *)

KiraCreateIntegralFile::usage=
"KiraCreateIntegralFile[ex, topo, path] extracts GLI symbols from ex that
belong to the topology topo. The resulting list of integrals is saved to
path/topoName/KiraLoopIntegrals.txt and can be referred to in the
corresponding Kira job file.

If the directory specified in path/topoName does not exist, it will be created
automatically. If it already exists, its content will be automatically
overwritten, unless the option OverwriteTarget is set to False.

Notice that ex may also contain integrals from different topologies, as long
as all those topologies are provided as a list in the topo argument.

It is also possible to invoke  the routine as KiraCreateIntegralFile[ex,
{topo1, topo2, ...}, {path1, path2, ...}] or KiraCreateIntegralFile[ex,
{topo1, topo2, ...}, {path1, path2, ...}] if one needs to process a list of
topologies.

The syntax  KiraCreateIntegralFile[ex, {topo1, topo2, ...}, path] or
KiraCreateIntegralFile[ex, {topo1, topo2, ...}, path] is also
allowed. This implies that all config files will go into the corresponding
subdirectories of path, e.g. path/topoName1, path/topoName2 etc.

The default name of the file containing loop integrals for the reduction is
\"KiraLoopIntegrals.txt\". It can be changed via the option KiraIntegrals.";

KiraCreateIntegralFile::failmsg =
"Error! KiraCreateIntegralFile has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`KiraCreateIntegralFile`Private`"]

fpsfVerbose::usage="";

Options[KiraCreateIntegralFile] = {
	Check				-> True,
	FCI					-> False,
	FCVerbose			-> False,
	KiraIntegrals		-> "KiraLoopIntegrals",
	OverwriteTarget		-> True
};

KiraCreateIntegralFile[expr_, topos: {__FCTopology}, dir_String, opts:OptionsPattern[]] :=
	Map[KiraCreateIntegralFile[expr, #,dir,opts]&,topos];

KiraCreateIntegralFile[expr_, topos: {__FCTopology}, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[KiraCreateIntegralFile[expr, #1,#2,opts]&,{topos,dirs}];

KiraCreateIntegralFile[expr_, topoRaw_FCTopology, dirRaw_String, OptionsPattern[]] :=
	Block[{	ex, topo, gliList, optNames, newNames, res, vars, id, topoName,
			file, filePath, optOverwriteTarget, status, dir, null1, null2, gliString},

		If[	OptionValue[FCVerbose]===False,
			fpsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fpsfVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget = OptionValue[OverwriteTarget];

		FCPrint[1,"KiraCreateIntegralFile: Entering.", FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateIntegralFile: Entering with:", topoRaw, FCDoControl->fpsfVerbose];

		If[	OptionValue[FCI],
			{ex, topo} = {expr, topoRaw},
			{ex, topo} = FCI[{expr, topoRaw}]
		];

		If[	OptionValue[Check],
			If[	!FCLoopValidTopologyQ[topo],
				Message[KiraCreateIntegralFile::failmsg, "The supplied topology is incorrect."];
				Abort[]
			];
		];

		topoName = topo[[1]];
		(*TODO: More freedom here*)

		dir = FileNameJoin[{dirRaw,ToString[topoName]}];

		FCPrint[2,"KiraCreateIntegralFile: TopoID: ", topoName, FCDoControl->fpsfVerbose];

		gliList = Cases[ex+null1+null2,x:GLI[topo[[1]],_]:>x,Infinity]//Union;

		FCPrint[0,"KiraCreateIntegralFile: Number of loop integrals: ", Length[gliList], FCDoControl->fpsfVerbose];

		FCPrint[3,"KiraCreateIntegralFile: List of GLIs: ", gliList, FCDoControl->fpsfVerbose];

		If[	!DirectoryQ[dir],
			status = CreateDirectory[dir];
			If[	status===$Failed,
				Message[KiraCreateIntegralFile::failmsg, "Failed to create directory ", dir];
				Abort[]
			];
		];

		gliList = Map[(ToExpression[topoName]@@#[[2]])&,gliList];

		FCPrint[3,"KiraCreateIntegralFile: Converted GLIs: ", gliList, FCDoControl->fpsfVerbose];

		gliString = StringRiffle[ToString/@gliList,"\n"];


		filePath = FileNameJoin[{dir, OptionValue[KiraIntegrals]}];

		FCPrint[3,"KiraCreateIntegralFile: Integral file path: ", filePath, FCDoControl->fpsfVerbose];

		If[	FileExistsQ[filePath] && !optOverwriteTarget,
			Message[KiraCreateIntegralFile::failmsg, "The file ", filePath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		file = OpenWrite[filePath];
		If[	file===$Failed,
			Message[KiraCreateIntegralFile::failmsg, "Failed to open ", file, " for writing."];
			Abort[]
		];

		WriteString[file, gliString];
		Close[file];

		filePath
	];



End[]
