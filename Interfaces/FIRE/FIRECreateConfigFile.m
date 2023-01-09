(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIRECreateConfigFile											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates FIRE config files out of FCTopology objects		*)

(* ------------------------------------------------------------------------ *)

FIRECreateConfigFile::usage=
"FIRECreateConfigFile[topo, fireID, path] automatically generates a FIRE
.config file  for the given topology topo with the FIRE-identifier fireID and
saves it to path/topoName as topoName.config where topoName is the
FCTopology-identifier. The function returns the full path to the generated
.config file.

If the directory specified in path/topoName does not exist, it will be created
automatically. If it already exists, its content will be automatically
overwritten, unless the option OverwriteTarget is set to False.

If no fireID is given, i.e. the function is called as
FIRECreateConfigFile[topo,  path], then the default value 4242 is used.

It is also possible to invoke  the routine as FIRECreateConfigFile[{topo1,
topo2, ...}, {id1, id2, ...}, {path1, path2, ...}] or
FIRECreateConfigFile[{topo1, topo2, ...}, {path1, path2, ...}]if one needs to
process a list of topologies.

The syntax  FIRECreateConfigFile[{topo1, topo2, ...}, {id1, id2, ...}, path]
or FIRECreateConfigFile[{topo1, topo2, ...}, path] is also allowed. This
implies that all config files will go into the corresponding subdirectories of
path, e.g. path/topoName1, path/topoName2 etc.

The default name of the file containing loop integrals for the reduction is
\"LoopIntegrals.m\". It can be changed via the option FIREIntegrals.

To customize the content of the .config file one can use following  options:

- FIREBucket (corresponds to #bucket, default value 29)
- FIRECompressor (corresponds to #compressor, default value \"zstd\")
- FIREFThreads (corresponds to #fthreads, default value $2 \\times N_{CPU}$)
- FIRELThreads (corresponds to #lthreads, default value 2)
- FIREPosPref (corresponds to #pospref, unset by default)
- FIRESThreads (corresponds to #sthreads, default value $N_{CPU}$)
- FIREThreads (corresponds to #threads, default value $N_{CPU}$)";

FIRECompressor::usage=
"FIRECompressor is an option for FIRECreateConfigFile and other functions of
the FIRE interface.

It specifies the #compressor parameter to be set in a FIRE .config-file. The
default value is \"zstd\".";

FIREThreads::usage=
"FIREThreads is an option for FIRECreateConfigFile and other functions of the
FIRE interface.

It specifies the #threads parameter to be set in a FIRE .config-file. The
default value is the number of physical cores ($ProcessorCount) on your
machine.";

FIREFthreads::usage=
"FIREFthreads is an option for FIRECreateConfigFile and other functions of the
FIRE interface.

It specifies the #fthreads parameter to be set in a FIRE .config-file. The
default value is twice times the number of physical cores ($ProcessorCount) on
your machine with the separate [FERMAT](home.bway.net/lewis/) mode being
active.";

FIRESthreads::usage=
"FIRESthreads is an option for FIRECreateConfigFile and other functions of the
FIRE interface.

It specifies the #lthreads parameter to be set in a FIRE .config-file. The
default value is the number of physical cores ($ProcessorCount) on your
machine.";

FIRELthreads::usage=
"FIRELthreads is an option for FIRECreateConfigFile and other functions of the
FIRE interface.

It specifies the #lthreads parameter to be set in a FIRE .config-file. The
default value is 4.";

FIREPosPref::usage=
"FIREPosPref is an option for FIRECreateConfigFile and other functions of the
FIRE interface.

It specifies the #pospref parameter to be set in a FIRE .config-file. The
default value is Default meaning that this parameters is not set.";

FIREBucket::usage=
"FIREBucket is an option for FIRECreateConfigFile and other functions of the
FIRE interface.

It specifies the #bucket parameter to be set in a FIRE .config-file. The
default value is 29.";

FIREIntegrals::usage=
"FIREIntegrals is an option for FIRECreateConfigFile and other functions of the
FIRE interface.

It specifies the #integrals parameter to be set in a FIRE .config file. The
default value is \"LoopIntegrals.m\".";

FIRECreateConfigFile::failmsg =
"Error! FIRECreateConfigFile has encountered a fatal problem and must abort the computation. \
The problem reads: `1`";

Begin["`Package`"]
End[]

Begin["`FIRECreateConfigFile`Private`"]

fpsfVerbose::usage="";
optDimension::usage="";
optComplex::usage="";



Options[FIRECreateConfigFile] = {
	FCI					-> False,
	FCVerbose			-> False,
	FIREBucket			-> 29,
	FIRECompressor		-> "zstd",
	FIREFthreads		:> 2*$ProcessorCount,
	FIRELthreads		-> 4,
	FIREIntegrals		-> "LoopIntegrals.m",
	FIREPosPref			-> Default,
	FIRESthreads		:> $ProcessorCount,
	FIREThreads			:> $ProcessorCount,
	OverwriteTarget		-> True
};


FIRECreateConfigFile[topos: {__FCTopology}, dir_String, opts:OptionsPattern[]] :=
	Map[FIRECreateConfigFile[#,4242,dir,opts]&,topos];

FIRECreateConfigFile[topos: {__FCTopology}, idRaw_List, dir__String, opts:OptionsPattern[]] :=
	MapThread[FIRECreateConfigFile[#1,#2,dir,opts]&,{topos,idRaw}];

FIRECreateConfigFile[topos: {__FCTopology}, idRaw_List, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[FIRECreateConfigFile[#1,#2,#3,opts]&,{topos,idRaw,dirs}];

FIRECreateConfigFile[topos: {__FCTopology}, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[FIRECreateConfigFile[#1,4242,#3,opts]&,{topos,dirs}];

FIRECreateConfigFile[topos: {__FCTopology}, idRaw_List, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[FIRECreateConfigFile[#1,#2,#3,opts]&,{topos,idRaw,dirs}];

FIRECreateConfigFile[topoRaw_FCTopology, dirRaw_String, opts:OptionsPattern[]] :=
	FIRECreateConfigFile[topoRaw, 4242, dirRaw, opts];

FIRECreateConfigFile[topoRaw_FCTopology, idRaw_, dirRaw_String, OptionsPattern[]] :=
	Block[{	topo, optNames, newNames, res, vars, id, topoName, dir,
			file, filePath, optOverwriteTarget, status, x, optFIREBucket,
			optFIRECompressor, optFIREFthreads, optFIRELthreads,
			optFIREPosPref, optFIRESthreads, optFIREThreads,
			configString, optFIREIntegrals },

		If[	OptionValue[FCVerbose]===False,
			fpsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fpsfVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget 	= OptionValue[OverwriteTarget];

		optFIREBucket		= OptionValue[FIREBucket];
		optFIRECompressor	= OptionValue[FIRECompressor];
		optFIREFthreads		= OptionValue[FIREFthreads];
		optFIRELthreads		= OptionValue[FIRELthreads];
		optFIREPosPref		= OptionValue[FIREPosPref];
		optFIRESthreads		= OptionValue[FIRESthreads];
		optFIREThreads		= OptionValue[FIREThreads];
		optFIREIntegrals	= OptionValue[FIREIntegrals];

		FCPrint[1,"FIRECreateConfigFile: Entering.", FCDoControl->fpsfVerbose];
		FCPrint[3,"FIRECreateConfigFile: Entering with:", topoRaw, FCDoControl->fpsfVerbose];

		If[	OptionValue[FCI],
			topo = topoRaw,
			topo = FCI[topoRaw]
		];

		If[ !StringQ[optFIREIntegrals],
			Message[FIRECreateConfigFile::failmsg, "Incorrect value of the FIREIntegrals option."];
			Abort[];
		];

		If[ !MatchQ[optFIREBucket,_Integer?Positive] || optFIREBucket==Default,
			Message[FIRECreateConfigFile::failmsg, "Incorrect value of the FIREBucket option."];
			Abort[];
		];

		If[ !MatchQ[optFIREThreads,_Integer?Positive] || optFIREThreads==Default,
			Message[FIRECreateConfigFile::failmsg, "Incorrect value of the FIREThreads option."];
			Abort[];
		];

		If[ !MatchQ[optFIREFthreads,_Integer?Positive] || optFIREFthreads==Default,
			Message[FIRECreateConfigFile::failmsg, "Incorrect value of the FIREFthreads option."];
			Abort[];
		];

		If[ !MatchQ[optFIRELthreads,_Integer?Positive] || optFIRELthreads==Default,
			Message[FIRECreateConfigFile::failmsg, "Incorrect value of the FIRELthreads option."];
			Abort[];
		];

		If[ !MatchQ[optFIRESthreads,_Integer?Positive] || optFIRESthreads==Default,
			Message[FIRECreateConfigFile::failmsg, "Incorrect value of the FIRESthreads option."];
			Abort[];
		];

		If[ !(MemberQ[{"lz4", "lz4fast", "lz4hc", "zlib", "snappy", "zstd", "none"}, optFIRECompressor] || optFIRECompressor==Default),
			Message[FIRECreateConfigFile::failmsg, "Incorrect value of the FIRECompressor option."];
			Abort[];
		];

		If[ !(MemberQ[{-3, -2, -1, 1, 2, 3}, optFIREPosPref] || optFIREPosPref==Default),
			Message[FIRECreateConfigFile::failmsg, "Incorrect value of the FIREPosPref option."];
			Abort[];
		];


		If[	!FCLoopValidTopologyQ[topo],
			Message[FIRECreateConfigFile::failmsg, "The supplied topology is incorrect."];
			Abort[]
		];

		If[	FCLoopBasisIncompleteQ[topo, FCI->True],
			Message[FIRECreateConfigFile::failmsg, "Incomplete propagator basis."];
			Abort[]
		];

		If[	FCLoopBasisOverdeterminedQ[topo, FCI->True],
			Message[FIRECreateConfigFile::failmsg, "Overdetermined propagator basis."];
			Abort[]
		];

		vars = Join[{"d"},SelectFree[Variables2[FCFeynmanPrepare[topo, Names -> x, FCI->True][[2]]], x]];

		FCPrint[2,"FIRECreateConfigFile: Variables: ", vars, FCDoControl->fpsfVerbose];

		topoName = ToString[topo[[1]]];
		(*TODO: More freedom here*)
		dir = FileNameJoin[{dirRaw,topoName}];

		Which[
			MatchQ[idRaw,_Integer?Positive],
				id = idRaw,
			MatchQ[idRaw,{__Rule}],
				id = topo[[1]]/.idRaw,
			True,
				Message[FIRECreateConfigFile::failmsg, "The id argument must be a positive integer or a list of rules."];
				Abort[]
		];

		FCPrint[2,"FIRECreateConfigFile: Problem number: ", id, FCDoControl->fpsfVerbose];

		If[	!MatchQ[id,_Integer?Positive],
			Message[FIRECreateConfigFile::failmsg, "Invalid FIRE problem number."];
			Abort[]
		];

		If[	!DirectoryQ[dir],
			status = CreateDirectory[dir];
			If[	status===$Failed,
				Message[FIRECreateConfigFile::failmsg, "Failed to create directory ", dir];
				Abort[]
			];
		];

		filePath = FileNameJoin[{dir,topoName<>".config"}];

		FCPrint[3,"FIRECreateConfigFile: Config path: ", filePath, FCDoControl->fpsfVerbose];


		configString = {
			If[	optFIRECompressor=!=Default,
				"#compressor " <> optFIRECompressor,
				""
			],
			If[	optFIREThreads=!=Default,
				"#threads " <> ToString[optFIREThreads],
				""
			],
			If[	optFIREFthreads=!=Default,
				"#fthreads s" <> ToString[optFIREFthreads],
				""
			],
			If[	optFIRELthreads=!=Default,
				"#lthreads " <> ToString[optFIRELthreads],
				""
			],
			If[	optFIRESthreads=!=Default,
				"#sthreads " <> ToString[optFIRESthreads],
				""
			],
			"#variables " <> StringRiffle[ToString/@vars, ", "],
			If[	optFIREBucket=!=Default,
				"#bucket " <> ToString[optFIREBucket],
				""
			],
			"#start",
			"#folder ./",
			"#problem " <> ToString[id] <> " " <> ToString[topoName] <> ".start",
			If[	optFIREPosPref=!=Default,
				"#pos_pref " <> ToString[optFIREPosPref],
				""
			],
			"#integrals " <> optFIREIntegrals,
			"#output "<>topoName<>".tables"
		};

		configString = StringRiffle[configString /. "" -> Unevaluated[Sequence[]],"\n"];


		FCPrint[3,"FIRECreateConfigFile: configString: ", configString, FCDoControl->fpsfVerbose];

		If[	FileExistsQ[filePath] && !optOverwriteTarget,
			Message[FIRECreateConfigFile::failmsg, "The file ", filePath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		file = OpenWrite[filePath];
		If[	file===$Failed,
			Message[FIRECreateConfigFile::failmsg, "Failed to open ", file, " for writing."];
			Abort[]
		];

		WriteString[file, configString];
		Close[file];


		filePath
	];



End[]
