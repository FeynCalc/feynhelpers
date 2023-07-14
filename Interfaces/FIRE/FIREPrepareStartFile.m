(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIREPrepareStartFile											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2023 Vladyslav Shtabovenko
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
	DateString			-> False,
	FCI					-> False,
	FCVerbose			-> False,
	FIREPath 			-> FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE6", "FIRE6.m"}],
	OverwriteTarget		-> True,
	SetDimensions		-> {3, 4, D, D-1}
};

FIREPrepareStartFile[topos: {__FCTopology}, dir_String, opts:OptionsPattern[]] :=
	Map[FIREPrepareStartFile[#,dir,opts]&,topos];

FIREPrepareStartFile[topos: {__FCTopology}, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[FIREPrepareStartFile[#1,#2,opts]&,{topos,dirs}];

FIREPrepareStartFile[topoRaw_FCTopology, dirRaw_String, OptionsPattern[]] :=
	Block[{	topo, optNames, newNames, res, dims, internal, external, propagators, dir,
			replacements, file, filePath, optOverwriteTarget, status, optFIREPath, topoName,
			check},

		If[	OptionValue[FCVerbose]===False,
			fpsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fpsfVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget = OptionValue[OverwriteTarget];
		optFIREPath	= OptionValue[FIREPath];

		FCPrint[1,"FIREPrepareStartFile: Entering.", FCDoControl->fpsfVerbose];
		FCPrint[3,"FIREPrepareStartFile: Entering with:", topoRaw, FCDoControl->fpsfVerbose];

		If[	OptionValue[FCI],
			topo = FRH[topoRaw],
			topo = FCI[FRH[topoRaw]]
		];

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

		propagators = FCLoopPropagatorsToTopology[topo,FCI->True,ExpandScalarProduct->True];

		FCPrint[3,"FIREPrepareStartFile: Output of FCLoopPropagatorsToTopology: ", propagators, FCDoControl->fpsfVerbose];

		{propagators, replacements} =  {propagators, topo[[5]]} /. {
			Pair[Momentum[a_,___],Momentum[b_,___]] -> a b,
			CartesianPair[CartesianMomentum[a_,___],CartesianMomentum[b_,___]] -> a b,
			Hold[Pair][Momentum[a_,___],Momentum[b_,___]] -> a b,
			Hold[CartesianPair][CartesianMomentum[a_,___],CartesianMomentum[b_,___]] -> a b
		};

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
		If[	OptionValue[DateString],
			WriteString[file, "(* Generated on "<> DateString[] <>" *)\n\n"];
		];
		WriteString[file, "Get["<> ToString[optFIREPath,InputForm]  <>"];\n"];
		WriteString[file, "\n\n"];
		WriteString[file, "If[$FrontEnd===Null,\n"];
		WriteString[file, "  projectDirectory=DirectoryName[$InputFileName],\n"];
		WriteString[file, "  projectDirectory=NotebookDirectory[]\n"];
		WriteString[file, "];\n"];
		WriteString[file, "SetDirectory[projectDirectory];\n"];
		WriteString[file, "Print[\"Working directory: \", projectDirectory];\n"];
		WriteString[file, "\n\n"];
		WriteString[file, "Internal=" <> ToString[internal,InputForm] <> ";\n"];
		WriteString[file, "External=" <> ToString[external,InputForm] <> ";\n"];
		WriteString[file, "Propagators=" <> ToString[propagators,InputForm] <> ";\n"];
		WriteString[file, "Replacements=" <> ToString[replacements,InputForm] <> ";\n"];
		WriteString[file, "PrepareIBP[];\n"];
		WriteString[file, "Prepare[AutoDetectRestrictions -> True];\n"];
		WriteString[file, "SaveStart["<> ToString[topoName,InputForm]  <>"];\n"];
		Close[file];

		filePath
	];



End[]
