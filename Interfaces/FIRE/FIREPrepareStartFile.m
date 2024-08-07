(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIREPrepareStartFile											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates FIRE start files out of FCTopology objects		*)

(* ------------------------------------------------------------------------ *)

FIREPrepareStartFile::usage=
"FIREPrepareStartFile[topo, path] can be used to convert an FCTopology object
topo into a FIRE. start-file.

The functions creates the corresponding Mathematica script CreateStartFile.m
and saves it in path/topoName. Notice that the script still needs to be
evaluated in Mathematica to generate the actual FIRE .start-file. This can be
conveniently done using FIRECreateStartFile.

Using FIREPrepareStartFile[{topo1, topo2, ...},  path] will save the scripts
to path/topoName1, path/topoName2 etc. The syntax FIREPrepareStartFile[{topo1,
topo2, ...},  {path1, path2, ...}] is also possible.

The default path to the FIRE package is FileNameJoin[{$UserBaseDirectory,
\"Applications\", \"FIRE6\", \"FIRE6.m\"}]. It can be adjusted using the
option FIREPath.";

FIREAutoDetectRestrictions::usage =
"FIREParallel is an option for FIREPrepareStartFile and other functions of the
FIRE interface.

It specifies whether the preparation of start or sbases files should be
parallelized. The default value is 2 meaning that 2 parallel kernels will be
used for this task.";

FIREParallel::usage =
"FIREParallel is an option for FIREPrepareStartFile and other functions of the
FIRE interface.

It specifies whether the preparation of start or sbases files should be
parallelized. The default value is 2 meaning that 2 parallel kernels will be
used for this task.";

FIRELI::usage =
"FIREProblemId is an option for FIREPrepareStartFile and other functions of the
FIRE interface.

It specifies the problem ID for the reduction. The default value is 4242.";

FIREUseLiteRed::usage =
"FIREUseLiteRed is an option for FIREPrepareStartFile and other functions of
the FIRE interface.

It specifies whether the reduction should be prepared using LiteRed. The
default value is True.";

FIREProblemId::usage =
"FIREProblemId is an option for FIREPrepareStartFile and other functions of the
FIRE interface.

It specifies the problem ID for the reduction. The default value is 4242.";

FIREPrepareStartFile::failmsg =
"Error! FIREPrepareStartFile has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIREPrepareStartFile`Private`"]

fpsfVerbose::usage="";
optDimension::usage="";
optComplex::usage="";



Options[FIREPrepareStartFile] = {
	Check						-> True,
	DateString					-> False,
	FCI							-> False,
	FCVerbose					-> False,
	FinalSubstitutions			-> {},
	FIREAutoDetectRestrictions	-> True,
	FIRELI 						-> True,
	FIREProblemId				-> 4242,
	FIREParallel				-> 2,
	FIREPath 					-> FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE6", "FIRE6.m"}],
	FIREUseLiteRed				-> True,
	OverwriteTarget				-> True,
	SetDimensions				-> {3, 4, D, D-1},
	StringReplace				-> {}
};

FIREPrepareStartFile[topos: {__FCTopology}, dir_String, opts:OptionsPattern[]] :=
	Map[FIREPrepareStartFile[#,dir,opts]&,topos];

FIREPrepareStartFile[topos: {__FCTopology}, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[FIREPrepareStartFile[#1,#2,opts]&,{topos,dirs}];

FIREPrepareStartFile[topoRaw_FCTopology, dirRaw_String, OptionsPattern[]] :=
	Block[{	topo, optNames, newNames, res, dims, internal, external, propagators, dir,
			replacements, file, filePath, optOverwriteTarget, status, optFIREPath, topoName,
			check, time, optStringReplace, startFileString, optFIREAutoDetectRestrictions,
			optFIREParallel, optFIRELI, prepareOptionsString, optFIREUseLiteRed, filePathLR,
			lrFileString, fileLR, optFIREProblemId, fileNameJoin, directoryName
			},

		If[	OptionValue[FCVerbose]===False,
			fpsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fpsfVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget				= OptionValue[OverwriteTarget];
		optFIREPath						= OptionValue[FIREPath];
		optStringReplace				= OptionValue[StringReplace];
		optFIREAutoDetectRestrictions	= OptionValue[FIREAutoDetectRestrictions];
		optFIREParallel					= OptionValue[FIREParallel];
		optFIRELI						= OptionValue[FIRELI];
		optFIREUseLiteRed				= OptionValue[FIREUseLiteRed];
		optFIREProblemId				= OptionValue[FIREProblemId];

		FCPrint[1,"FIREPrepareStartFile: Entering.", FCDoControl->fpsfVerbose];
		FCPrint[3,"FIREPrepareStartFile: Entering with:", topoRaw, FCDoControl->fpsfVerbose];

		If[	OptionValue[FCI],
			topo = topoRaw,
			topo = FCI[topoRaw]
		];

		(*
		(* This is necessary to account for scalar products defined via downvalues *)
		topo[[5]] = Map[Head[#][#[[1]],FRH[#[[2]]]]&, topo[[5]] ];
		*)
		If[ OptionValue[Check],
			FCPrint[1, "FIREPrepareStartFile: Checking the correctness of topologies.", FCDoControl->fpsfVerbose];
			time=AbsoluteTime[];

			If[	!FCLoopValidTopologyQ[topo],
				Message[FIREPrepareStartFile::failmsg, "The given topology is incorrect."];
				Abort[]
			];

			If[	FCLoopBasisIncompleteQ[topo, FCI->True],
				Message[FIREPrepareStartFile::failmsg, "Incomplete propagator basis."];
				Abort[]
			];

			If[	FCLoopBasisOverdeterminedQ[topo, FCI->True],
				Message[FIREPrepareStartFile::failmsg, "Overdetermined propagator basis."];
				Abort[]
			];

			If[	FCLoopScalelessQ[topo, FCI->True],
				Message[FIREPrepareStartFile::failmsg, "The given topology is scaleless so that all integrals from this family vanish."];
				Abort[]
			];

			FCPrint[1, "FIREPrepareStartFile: Checks done, timing:", N[AbsoluteTime[] - time, 4],  FCDoControl->fpsfVerbose];
		];

		If[ TrueQ[FeynCalc`FCLoopBasis`Private`cartesianIntegralQ[topo[[2]]]],
			(*Cartesian integral *)
			dims = Cases[OptionValue[SetDimensions], 3 | _Symbol - 1],
			(*Lorentzian integral *)
			dims = Cases[OptionValue[SetDimensions], 4 | _Symbol ]
		];

		FCPrint[1,"FIREPrepareStartFile: Dimensions: ", dims, FCDoControl->fpsfVerbose];

		If[	!FreeQ2[topo,{TemporalPair,TemporalMomentum}],
			Message[FIREPrepareStartFile::failmsg, "Explicit temporal components are not supported."];
			Abort[]
		];

		FCPrint[1, "FIREPrepareStartFile: Applying FCLoopPropagatorsToTopology.", FCDoControl->fpsfVerbose];
		time=AbsoluteTime[];

		propagators = FCLoopPropagatorsToTopology[topo,FCI->True,ExpandScalarProduct->True];

		FCPrint[1, "FIREPrepareStartFile: FCLoopPropagatorsToTopology done, timing:", N[AbsoluteTime[] - time, 4],  FCDoControl->fpsfVerbose];

		FCPrint[3, "FIREPrepareStartFile: Output of FCLoopPropagatorsToTopology: ", propagators, FCDoControl->fpsfVerbose];

		{propagators, replacements} =  {propagators, topo[[5]]} /. {
			Hold[SPD][a_] -> a^2,
			Hold[CSPD][a_] -> a^2,
			Hold[SPD][a_, b_] -> a b,
			Hold[CSPD][a_, b_] -> a b,
			Pair[Momentum[a_,___],Momentum[b_,___]] -> a b,
			CartesianPair[CartesianMomentum[a_,___],CartesianMomentum[b_,___]] -> a b,
			Hold[Pair][Momentum[a_,___],Momentum[b_,___]] -> a b,
			Hold[CartesianPair][CartesianMomentum[a_,___],CartesianMomentum[b_,___]] -> a b
		};

		replacements = Join[replacements,OptionValue[FinalSubstitutions]];

		replacements = SelectFree[replacements,{TemporalMomentum,Polarization}];

		check = ToString /@ (Variables2[Last /@ replacements]);

		If[!MatchQ[LowerCaseQ /@ StringReplace[check,"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"0"->""], {True...}],
			Message[FIREPrepareStartFile::failmsg, "Replacement rules contain variables that are not entirely lowercase:" <> ToString[check,InputForm]];
			Abort[]

		];

		(* Important to avoid issues like in
		FCTopology[testTopo, {FeynAmpDenominator[
StandardPropagatorDenominator[I Momentum[p3, D], 0, 0, {1, 1}]],
FeynAmpDenominator[
StandardPropagatorDenominator[I Momentum[p1, D], 0, 0, {1, 1}]],
FeynAmpDenominator[
StandardPropagatorDenominator[
	0, -2 Pair[Momentum[p1, D], Momentum[q, D]], 0, {1, 1}]],
FeynAmpDenominator[
StandardPropagatorDenominator[Momentum[I p3 + I q, D], 0,
	mb^2, {1, 1}]],
FeynAmpDenominator[
StandardPropagatorDenominator[0,
	Pair[Momentum[p1, D], Momentum[p3, D]], 0, {1, 1}]]}, {p1,
p3}, {q}, {Pair[Momentum[q, D], Momentum[q, D]] -> mb^2}, {}]
		*)

		propagators = ExpandAll[propagators]/.replacements;

		If[	!FreeQ2[propagators,{Pair,CartesianPair,Momentum,CartesianMomentum}],
			Message[FIREPrepareStartFile::failmsg, "Failed to convert the given propagators into FIRE notation."];
			Abort[]
		];

		topoName = ToString[topo[[1]]];
		internal = topo[[3]];
		external = topo[[4]];
		(*TODO: More freedom here*)
		dir = FileNameJoin[{dirRaw,topoName}];


		FCPrint[3,"FIREPrepareStartFile: prepareFIRE: FIRE's Internal: ", StandardForm[internal], FCDoControl->fpsfVerbose];
		FCPrint[3,"FIREPrepareStartFile: prepareFIRE: FIRE's External: ", StandardForm[external], FCDoControl->fpsfVerbose];
		FCPrint[3,"FIREPrepareStartFile: prepareFIRE: FIRE's Propagators: ", StandardForm[propagators], FCDoControl->fpsfVerbose];
		FCPrint[3,"FIREPrepareStartFile: prepareFIRE: FIRE's Replacements: ", StandardForm[replacements], FCDoControl->fpsfVerbose];

		If[	!DirectoryQ[dir],
			status = CreateDirectory[dir];
			If[	status===$Failed,
				Message[FIREPrepareStartFile::failmsg, "Failed to create directory ", dir];
				Abort[]
			];
		];

		filePath = FileNameJoin[{dir,"CreateStartFile.m"}];


		FCPrint[3,"FIREPrepareStartFile: Script path: ", filePath, FCDoControl->fpsfVerbose];

		If[	FileExistsQ[filePath] && !optOverwriteTarget,
			Message[FIREPrepareStartFile::failmsg, "The file ", filePath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		file = OpenWrite[filePath];
		If[	file===$Failed,
			Message[FIREPrepareStartFile::failmsg, "Failed to open ", filePath, " for writing."];
			Abort[]
		];


		prepareOptionsString = {
			If[	optFIREAutoDetectRestrictions=!=Default,
					"AutoDetectRestrictions -> " <> ToString[optFIREAutoDetectRestrictions],
					Unevaluated[Sequence[]]
			],

			If[	optFIREParallel=!=False,
					"Parallel -> True",
					Unevaluated[Sequence[]]
			],

			If[	optFIRELI=!=Default,
					"LI -> " <> ToString[optFIRELI],
					Unevaluated[Sequence[]]
			]

		};

		prepareOptionsString = StringRiffle[prepareOptionsString,","];

		startFileString = {
			If[	OptionValue[DateString],
				WriteString[file, "(* Generated on "<> DateString[] <>" *)\n\n"],
				""
			],
			"Get["<> ToString[optFIREPath,InputForm]  <>"];\n",
			"\n\n",
			"If[$FrontEnd===Null,\n",
			"  projectDirectory=DirectoryName[$InputFileName],\n",
			"  projectDirectory=NotebookDirectory[]\n",
			"];\n",
			"SetDirectory[projectDirectory];\n",
			"Print[\"Working directory: \", projectDirectory];\n",
			If[	optFIREParallel=!=False,
					"LaunchKernels[" <> ToString[optFIREParallel] <> "];",
					Unevaluated[Sequence[]]
			],
			"\n\n\n",
			"Internal=" <> ToString[internal,InputForm] <> ";\n",
			"External=" <> ToString[external,InputForm] <> ";\n",
			"Propagators=" <> ToString[propagators,InputForm] <> ";\n",
			"Replacements=" <> ToString[replacements,InputForm] <> ";\n",
			"PrepareIBP[];\n",

			"Quiet[Prepare["<> StringJoin[prepareOptionsString]  <>"], LaunchKernels::nodef];\n",

			If[optFIREUseLiteRed,
				Unevaluated[Sequence[
					"TransformRules[FileNameJoin[{Directory[],\"LR\"}],\""<>ToString[topoName]<>".lbases\","<>ToString[optFIREProblemId]<>"];\n",
					"SaveSBases[\""<>ToString[topoName]<>"\"];\n"
				]],

				"SaveStart["<> ToString[topoName,InputForm]  <>"];\n"
			]


		};

		If[	optStringReplace=!={},
			startFileString = StringReplace[startFileString,optStringReplace]
		];

		startFileString = StringJoin[startFileString];

		WriteString[file, startFileString];

		Close[file];

		If[	optFIREUseLiteRed,
				filePathLR = FileNameJoin[{dir,"CreateLiteRedFiles.m"}];

				FCPrint[3,"FIREPrepareStartFile: LiteRed script path: ", filePathLR, FCDoControl->fpsfVerbose];

				If[	FileExistsQ[filePathLR] && !optOverwriteTarget,
					Message[FIREPrepareStartFile::failmsg, "The file ", filePathLR, " already exists and the option OverwriteTarget is set to False."];
					Abort[]
				];

				fileLR = OpenWrite[filePathLR];
				If[	fileLR===$Failed,
					Message[FIREPrepareStartFile::failmsg, "Failed to open ", filePathLR, " for writing."];
					Abort[]
				];


				lrFileString = {
					If[	OptionValue[DateString],
						WriteString[fileLR, "(* Generated on "<> DateString[] <>" *)\n\n"],
						""
					],
					"SetDirectory[FileNameJoin[{DirectoryName["<> ToString[optFIREPath,InputForm] <> "],\"extra\",\"LiteRed\",\"Setup\"}]];\n",
					"Get[\"LiteRed.m\"];\n",
					"\n\n",
					"Get["<> ToString[optFIREPath,InputForm]  <>"];\n",
					"\n\n",
					"If[$FrontEnd===Null,\n",
					"  projectDirectory=DirectoryName[$InputFileName],\n",
					"  projectDirectory=NotebookDirectory[]\n",
					"];\n",
					"SetDirectory[projectDirectory];\n",
					"Print[\"Working directory: \", projectDirectory];\n",
					"\n\n",
					"Internal=" <> ToString[internal,InputForm] <> ";\n",
					"External=" <> ToString[external,InputForm] <> ";\n",
					"Propagators=" <> ToString[propagators,InputForm] <> ";\n",
					"Replacements=" <> ToString[replacements,InputForm] <> ";\n",
					"Quiet[CreateNewBasis[topology, Directory->FileNameJoin[{Directory[],\"LR\"}]], {DiskSave::overwrite,DiskSave::dir}];\n",
					"Quiet[GenerateIBP[topology], FrontEndObject::notavail];\n",
					"Quiet[AnalyzeSectors[topology], FrontEndObject::notavail];\n",
					"Quiet[FindSymmetries[topology, EMs->True], FrontEndObject::notavail];\n",
					"Quiet[DiskSave[topology], {DiskSave::overwrite,DiskSave::dir}];\n"
				};


				If[	optStringReplace=!={},
					lrFileString = StringReplace[lrFileString,optStringReplace];
				];

				lrFileString = StringJoin[lrFileString];

				WriteString[fileLR, lrFileString];

				Close[fileLR];
		];

		If[	TrueQ[optFIREUseLiteRed],
			{filePath,filePathLR},
			filePath
		]

	];

End[]
