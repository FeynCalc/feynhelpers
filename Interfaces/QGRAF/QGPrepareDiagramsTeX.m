(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: QGPrepareDiagramsTeX												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Prepare TeX files with Feynman diagrams						*)

(* ------------------------------------------------------------------------ *)

QGPrepareDiagramsTeX::usage="
QGPrepareDiagramsTeX[input_, output_] processes the LaTeX representation of \
Feynman diagrams generated by QGRAF using a supported style file. The input \
file must contain valid LaTeX code. Following styles (to be set via the Option \
Stlye) are supported: \n

\"TikZ-Feynman\" - uses tikz-feynmann packages to visualize Feynman diagrams \
created with tikz-feynman.sty \n

The beginning and the end of each .tex file will be pasted from the files specified \
by the options QGTeXProlog and QGTeXEpilog respectively. The resulting .tex file \
will be saved to output. If the option Split is set to True, each diagram will be \
saved to a separate .tex file in the directory output.";

QGPrepareDiagramsTeX::fail=
"QGPrepareDiagramsTeX has encountered an error and must abort the evaluation. The \
error description reads: `1`";

QGTeXProlog::usage="QGTeXProlog is an option for QGPrepareDiagramsTeX, which specifies \
a file containing the LaTeX code to be added to the beginning of each .tex file \
containing Feynman diagrams. \n
If you provide only the file name, they file will be \
loaded from the standard directory containing .tex files ($QGTeXDirectory). \
If you specify the full path, the file will be loaded from there.";

QGTeXEpilog::usage="QGTeXEpilog is an option for QGPrepareDiagramsTeX, which specifies \
a file containing the LaTeX code to be added to the end of each .tex file \
containing Feynman diagrams. \n
If you provide only the file name, they file will be \
loaded from the standard directory containing .tex files ($QGTeXDirectory). \
If you specify the full path, the file will be loaded from there.";

Begin["`Package`"]

End[]

Begin["`QGPrepareDiagramsTeX`Private`"]

qgptVerbose::usage="";

Options[QGPrepareDiagramsTeX] =
{
	DeleteDirectory -> True,
	DeleteFile		-> True,
	FCVerbose 		-> False,
	Names 			-> Function[{x}, "dia-" <> ToString[x] <> ".tex"],
	QGTeXEpilog 	-> "TikZ-FeynmanEpilog.tex",
	QGTeXProlog 	-> "TikZ-FeynmanProlog.tex",
	Style			-> "TikZ-Feynman",
	Split			-> False,
	StringSplit 	-> "\\diaProlog"
};


QGPrepareDiagramsTeX[input_String/;input=!="", output_String, OptionsPattern[]] :=
	Block[{	importedFile, time, diagramsRaw, prolog, diagrams, optNames,
			optDeleteFile, optDeleteDirectory, status, texPrologEpilog,
			pathQGTeXProlog, pathQGTeXEpilog, optQGTeXProlog, optQGTeXEpilog},

		If [OptionValue[FCVerbose]===False,
			qgptVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				qgptVerbose=OptionValue[FCVerbose]
			];
		];

		optNames 			= OptionValue[Names];
		optDeleteFile 		= OptionValue[DeleteFile];
		optDeleteDirectory	= OptionValue[DeleteDirectory];
		optQGTeXProlog		= OptionValue[QGTeXProlog];
		optQGTeXEpilog		= OptionValue[QGTeXEpilog];

		FCPrint[1,"QGPrepareDiagramsTeX: Entering. ", FCDoControl->qgptVerbose];

		If[	FileNameTake[optQGTeXProlog] === optQGTeXProlog,
			pathQGTeXProlog = FileNameJoin[{$QGTeXDirectory,optQGTeXProlog}],
			pathQGTeXProlog = optQGTeXProlog
		];

		If[	FileNameTake[optQGTeXEpilog] === optQGTeXEpilog,
			pathQGTeXEpilog = FileNameJoin[{$QGTeXDirectory,optQGTeXEpilog}],
			pathQGTeXEpilog = optQGTeXEpilog
		];

		If[	!FileExistsQ[input],
			Message[QGPrepareDiagramsTeX::fail,"Input file "<> input <>" not found."];
			Abort[]
		];

		If[	!FileExistsQ[pathQGTeXProlog],
			Message[QGPrepareDiagramsTeX::fail,"TeX prolog file "<> pathQGTeXProlog <>" not found."];
			Abort[]
		];

		If[	!FileExistsQ[pathQGTeXEpilog],
			Message[QGPrepareDiagramsTeX::fail,"TeX epilog file "<> pathQGTeXEpilog <>" not found."];
			Abort[]
		];


		FCPrint[1,"QGPrepareDiagramsTeX: Importig the prolog and epilog files.", FCDoControl->qgptVerbose];
		time = AbsoluteTime[];
		texPrologEpilog = {Import[pathQGTeXProlog, "String"], Import[pathQGTeXEpilog, "String"]};

		If[	!FreeQ[texPrologEpilog, $Failed],
			Message[QGPrepareDiagramsTeX::fail,"Failed to import the prolog or epilog files as a string."];
			Abort[]
		];

		FCPrint[1, "QGPrepareDiagramsTeX: Done importing tprolog and epilog files, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgptVerbose];


		FCPrint[1,"QGPrepareDiagramsTeX: Importig the input file.", FCDoControl->qgptVerbose];
		time = AbsoluteTime[];
		importedFile = Import[input, "String"];

		If[	importedFile===$Failed,
			Message[QGPrepareDiagramsTeX::fail,"Failed to import "<> input <>" as a string."];
			Abort[]
		];
		FCPrint[1, "QGPrepareDiagramsTeX: Done importing the input file, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgptVerbose];
		FCPrint[2, "QGPrepareDiagramsTeX: The input file contains ", StringLength[importedFile], " characters.", FCDoControl->qgptVerbose];

		FCPrint[1,"QGPrepareDiagramsTeX: Splitting the input file into single diagrams.", FCDoControl->qgptVerbose];
		time = AbsoluteTime[];
		diagramsRaw = StringSplit[importedFile, OptionValue[StringSplit]];

		If[	Length[diagramsRaw]<2,
			Message[QGPrepareDiagramsTeX::fail,"Something went wrong when splitting the input file."];
			Abort[]
		];
		FCPrint[1, "QGPrepareDiagramsTeX: Done splitting the input file, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgptVerbose];

		FCPrint[2, "QGPrepareDiagramsTeX: The input file contains ", Length[diagramsRaw]-1,  " diagram(s).", FCDoControl->qgptVerbose];


		FCPrint[1,"QGPrepareDiagramsTeX: Fixing collapsing self-energy loops.", FCDoControl->qgptVerbose];
		time = AbsoluteTime[];
		diagrams = fixSELoopsTikz /@ diagramsRaw;
		FCPrint[1, "QGPrepareDiagramsTeX: Done fixing collapsing self-energy loops, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgptVerbose];

		FCPrint[1,"QGPrepareDiagramsTeX: Saving the output.", FCDoControl->qgptVerbose];
		time = AbsoluteTime[];

		If[	OptionValue[Split],
			(* Save each diagram separately *)

			diagrams = Rest[diagrams];

			(*directory already exits and should be cleansed beforehand*)
			If[	DirectoryQ[output] && optDeleteDirectory,
				If[	DeleteDirectory[output,DeleteContents->True]===$Failed,
					Message[QGPrepareDiagramsTeX::fail,"Failed to create the directory "<> output <> " for saving single diagram files."];
					Abort[]
				]
			];

			(*directory doesn't exit*)
			If[	!DirectoryQ[output],
				If[	CreateDirectory[output]===$Failed,
					Message[QGPrepareDiagramsTeX::fail,"Failed to create the directory "<> output <> " for saving single diagram files."];
					Abort[]
				]
			];
			(*save the files*)
			status = Table[Export[FileNameJoin[{output,optNames[i]}], StringJoin[texPrologEpilog[[1]], "\n", OptionValue[StringSplit], "\n", diagrams[[i]], "\n",  texPrologEpilog[[2]]], "String"],{i,1,Length[diagrams]-1}],

			(*save all diagrams into a single file *)
			diagrams = Riffle[diagrams, OptionValue[StringSplit]];
			If[	FileExistsQ[output],
				If[	optDeleteFile,
					If[	DeleteFile[output]===$Failed,
						Message[QGPrepareDiagramsTeX::fail,"Failed to delete the file " <> output <> "."];
						Abort[]
					],
					Message[QGPrepareDiagramsTeX::fail,"The output file "<> output <> " already exists and should not be overwritten."];
					Abort[]
				]
			];
			status = Export[output, StringJoin[texPrologEpilog[[1]], "\n", diagrams, "\n", texPrologEpilog[[2]]], "String"]
		];

		If[	!FreeQ[status,$Failed],
				Message[QGPrepareDiagramsTeX::fail,"Something went wrong when saving single diagram files."];
				Abort[]
		];



		FCPrint[1,"QGPrepareDiagramsTeX: Leaving. ", FCDoControl->qgptVerbose];

		output

	];

fixSELoopsTikz[str_] :=
	FixedPoint[
		StringReplace[#, {
			"v" ~~ i1_ ~~ Shortest[" -- [" ~~ st1__ ~~ "] "] ~~ "v" ~~ i2_ ~~ ",\nv" ~~ i2_ ~~ Shortest[" -- [" ~~ st2__ ~~ "] "] ~~ "v" ~~ i1_ ~~ ",\n" /;
			StringFreeQ[st1, {"half left", "[", "]"}] && StringFreeQ[st2, {"half left", "half right", "[", "]"}] :>
				("v" ~~ i1 ~~ " -- [half left, "  ~~ st1 ~~ "] " ~~ "v" ~~ i2 ~~ ",\nv" ~~ i2 ~~ " -- [half left, " ~~ st2 ~~ "] " ~~ "v" ~~ i1 ~~ ",\n"),

			"v" ~~ i1_ ~~ Shortest[" -- [" ~~ st1__ ~~ "] "] ~~ "v" ~~ i2_ ~~ ",\nv" ~~ i1_ ~~ Shortest[" -- [" ~~ st2__ ~~ "] "] ~~ "v" ~~ i2_ ~~ ",\n" /;
			StringFreeQ[st1, {"half left", "[", "]"}] && StringFreeQ[st2, {"half left", "half right", "[", "]"}] :>
				("v" ~~ i1 ~~ " -- [half right, " ~~ st1 ~~ "] " ~~ "v" ~~ i2 ~~ ",\nv" ~~ i1 ~~ " -- [half left, " ~~ st2 ~~ "] " ~~ "v" ~~ i2 ~~ ",\n")
		}] &, str];




End[]

