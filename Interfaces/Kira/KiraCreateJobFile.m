(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: KiraCreateJobFile											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2022-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates job files for KIRA out of FCTopology objects		*)

(* ------------------------------------------------------------------------ *)

KiraCreateJobFile::usage=
"KiraCreateJobFile[topo, sectors, {r,s}, path] can be used to generate Kira job
files from an FCTopology or a list thereof. Here sectors is a list of sectors
need to be reduced, e.g. {{1,0,0,0}, {1,1,0,0}, {1,1,1,0}} etc. The values of
r and s correspond to the maximal positive and negative powers that may appear
in the loop integrals to be reduced.

The functions creates the corresponding yaml files and saves them  in
path/topoName. Using KiraCreateJobFile[{topo1, topo2, ...}, {sectors1,
sectors2, ...}, {{r1,s1}, {r2,s2}, ...},  path] will save the scripts to
path/topoName1, path/topoName2 etc. The syntax using KiraCreateJobFile[{topo1,
topo2, ...}, {sectors1, sectors2, ...}, {{r1,s1}, {r2,s2}, ...},  {path1,
path2, ...}] is also possible.

It is also possible to supply a list of GLIs instead of sectors. In that case
FCLoopFindSectors and KiraGetRS will be used to determine the top sector for
each topology.

The syntax  KiraCreateJobFile[{topo1, topo2, ...}, {sectors1, sectors2, ...},
{{r1,s1}, {r2,s2}, ...}, path] or KiraCreateJobFile[{topo1, topo2, ...},
{glis1, glis2, ...},  path] is also allowed. This implies that all config
files will go into the corresponding subdirectories of path, e.g.
path/topoName1/config, path/topoName2/config etc.

The default name for job files is job.yaml and can be changed via the option
KiraJobFileName.";



KiraIntegrals::usage=
"KiraIntegrals is an option for KiraCreateJobFile and other functions of the
Kira interface.

It specifies the file containing integrals to be reduced by Kira. The default
value is {\"KiraLoopIntegrals.txt\"}.";

KiraJobFileName::usage=
"KiraJobFileName is an option for KiraCreateJobFile and other functions of the
Kira interface.

It specifies the file name for the created job file. The default value is
\"job.yaml\".";

KiraIntegralOrdering::usage=
"KiraIntegralOrdering is an option for KiraCreateJobFile and other functions of
the Kira interface.

It specifies the value of the integral_ordering parameter in the job file. The
default value is 2. This means that KIRA will integrals with dots rather those
with numerators when choosing the master integrals.";

KiraCreateJobFile::failmsg =
"Error! KiraCreateJobFile has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`KiraCreateJobFile`Private`"]

fpsfVerbose::usage="";
optDimension::usage="";
optComplex::usage="";

kiraQuadraticProp::usage="";
kiraLinearProp::usage="";

Options[KiraCreateJobFile] = {
	DateString			-> False,
	FCI					-> False,
	FCVerbose			-> False,
	KiraIntegrals		-> {"KiraLoopIntegrals"},
	KiraJobFileName		-> "job.yaml",
	KiraIntegralOrdering -> 2,
	OverwriteTarget		-> True,
	Top					-> True
};

(*
KiraCreateJobFile[topos: {__FCTopology}, topSectors: {{{__Integer}..}..}, rs: {{_Integer, _Integer}..}, dir_String, opts:OptionsPattern[]] :=
	MapThread[KiraCreateJobFile[#1,#2,#3,dir,opts]&,{topos,topSectors,rs}];

KiraCreateJobFile[topos: {__FCTopology}, topSectors: {{{__Integer}..}..}, rs: {{_Integer, _Integer}..}, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[KiraCreateJobFile[#1,#2,#3,#4,opts]&,{topos,topSectors,rs,dirs}];
*)
KiraCreateJobFile[topoRaw_FCTopology, glis:{__GLI}, dirRaw_String, opts:OptionsPattern[]] :=
	KiraCreateJobFile[topoRaw, Sequence@@Transpose@Map[{#[[1]],KiraGetRS[#[[2]]]}&,FCLoopFindSectors[glis][[1]]], dirRaw, opts];

	(*KiraCreateJobFile[topoRaw, {FCLoopFindSectors[SelectNotFree[glis, topoRaw[[1]]], Last -> True, GatherBy -> False]},
		{KiraGetRS[SelectNotFree[glis, topoRaw[[1]]]]}, dirRaw, opts];*)




KiraCreateJobFile[topos: {__FCTopology}, glis:{__GLI}, dirRaw_String, opts:OptionsPattern[]] :=
	KiraCreateJobFile[#, glis, dirRaw, opts]&/@topos;

KiraCreateJobFile[topoRaw_FCTopology, topSectorsRaw: {{__Integer}..}, rs: {{_Integer, _Integer}..}, dirRaw_String, OptionsPattern[]] :=
	Block[{	topo, topSectors, reduce, res,  dir, file, optOverwriteTarget, integralsString,
			topoName, jobPath, optKiraIntegrals, selectMandatoryList, reduceStrings},

		If[	OptionValue[FCVerbose]===False,
			fpsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fpsfVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget = OptionValue[OverwriteTarget];
		optKiraIntegrals = OptionValue[KiraIntegrals];


		FCPrint[1,"KiraCreateJobFile: Entering.", FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateJobFile: Entering with:", topoRaw, FCDoControl->fpsfVerbose];

		If[	!MatchQ[optKiraIntegrals, {___String}],
			Message[KiraCreateJobFile::failmsg, "Incorrect value of the KiraIntegrals option."];
			Abort[];
		];

		If[	OptionValue[FCI],
			topo = topoRaw,
			topo = FCI[topoRaw]
		];

		If[	!FCLoopValidTopologyQ[topo],
			Message[KiraCreateJobFile::failmsg, "The given topology is incorrect."];
			Abort[]
		];

		topoName = topo[[1]];


		topSectors = Map["sectors: [b" <> StringReplace[ToString[#,   InputForm] <> "]", {"," | " " | "}" | "{" -> ""}] &, topSectorsRaw];

		reduceStrings = MapThread["        - {topologies: ["<>StringReplace[ToString[topoName,InputForm], "\"" -> ""]<>"], "<> #1<>", r: "<>ToString[#2[[1]]]<>", s: " <> ToString[#2[[2]]]<>" }"&,{topSectors,rs}];

		reduceStrings = StringRiffle[reduceStrings,"\n"] <> "\n";

		integralsString = Map["       - [" <> ToString[topoName] <>", " <> ToString[#,InputForm] <>  "]\n"&, optKiraIntegrals];

		integralsString = StringRiffle[integralsString,"\n"] <> "\n";

		If[	Length[optKiraIntegrals]=!={},
			selectMandatoryList = "- "<>StringReplace[ToString[""@@ToString[optKiraIntegrals,InputForm]], {"}" | "{" -> ""}],
			selectMandatoryList = ""
		];

		(*TODO: More freedom here*)
		dir = FileNameJoin[{dirRaw,ToString[topo[[1]]]}];


		If[	!DirectoryQ[dir],
			If[	CreateDirectory[dir]===$Failed,
				Message[KiraCreateJobFile::failmsg, "Failed to create directory ", dir];
				Abort[]
			];
		];

		jobPath = FileNameJoin[{dir,OptionValue[KiraJobFileName]}];


		FCPrint[3,"KiraCreateJobFile: Path to the job file: ", jobPath, FCDoControl->fpsfVerbose];

		If[	FileExistsQ[jobPath] && !optOverwriteTarget,
			Message[KiraCreateJobFile::failmsg, "The file ", jobPath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		file = OpenWrite[jobPath];
		If[	file===$Failed,
			Message[KiraCreateJobFile::failmsg, "Failed to open ", jobPath, " for writing."];
			Abort[]
		];
		If[	OptionValue[DateString],
			WriteString[file, "# Generated on "<> DateString[] <>" \n\n"];
		];
		WriteString[file, "jobs:\n"];
		WriteString[file, "  - reduce_sectors:\n"];
		WriteString[file, "      reduce:\n"];
		WriteString[file, reduceStrings];
		WriteString[file, "      select_integrals:\n"];
		If[	selectMandatoryList=!={},
			WriteString[file, "        select_mandatory_list:\n"];
			WriteString[file, "          "<>selectMandatoryList<>"\n"];
		];

		WriteString[file, "      run_initiate: true\n"];
		WriteString[file, "      run_triangular: true\n"];
		WriteString[file, "      run_back_substitution: true\n"];
		WriteString[file, "      integral_ordering: "<>ToString[OptionValue[KiraIntegralOrdering]]<>"\n"];
		WriteString[file, "  - kira2math:\n"];
		WriteString[file, "      target:\n"];
		WriteString[file, integralsString];

		(*- [topology5635, "KiraLoopIntegrals.txt"]*)
		Close[file];
		jobPath
	];


End[]
