(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: QGTZFCreateFieldStyles												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Prepare TeX files with Feynman diagrams						*)

(* ------------------------------------------------------------------------ *)

QGTZFCreateFieldStyles::usage=
"QGTZFCreateTeXFiles[model_, output_] generates TikZ-Feynman stylings for the
fields present in the QGRAF model file model. The resulting file containing
the stylings set via tikzset and tikzfeynmansetis saved to output.

It is also possible to invoke the function via QGTZFCreateTeXFiles[model,
qgOutput] where qgOutput is the output QGCreateAmp.

The stylings can be generated in a semi-automatic fashion but for higher
quality results it is recommended to provide the necessary information for
each field via the option QGFieldStyles. It is a list of lists, where each
sublist contains the field name (e.g. El), its type (e.g. photon, boson,
fermion, anti fermion etc.) and its T EX label.";

QGFieldStyles::usage=
"QGFieldStyles is an option for QGTZFCreateFieldStyles, which specifies the
TikZ-Feynman stylings for the fields present in the given QGRAF model.";

QGExtraStyles::usage=
"QGExtraStyles is an option for QGTZFCreateFieldStyles, which adds additional
stylings to those created for Tikz-Feynman.

For example, one can use QGExtraStyles -> {\"every vertex/.style={small,
dot}\"} to add a small dot to every vertex.";

QGTZFCreateFieldStyles::fail=
"QGTZFCreateFieldStyles has encountered an error and must abort the evaluation. The \
error description reads: `1`";



Begin["`Package`"]

End[]

Begin["`QGTZFCreateFieldStyles`Private`"]

qgtzfcfsVerbose::usage="";

Options[QGTZFCreateFieldStyles] = {
	DeleteFile		-> True,
	FCVerbose 		-> False,
	Names			-> "tikz-styles.tex",
	QGFieldStyles	-> {},
	QGExtraStyles   -> {}
};

QGTZFCreateFieldStyles[modelRaw_String, {(*amps*)_String, dias_String}, opts:OptionsPattern[]] :=
	QGTZFCreateFieldStyles[modelRaw, DirectoryName[dias], opts];

QGTZFCreateFieldStyles[modelRaw_String/;modelRaw=!="", outputRaw_String, OptionsPattern[]] :=
	Block[{	time, optDeleteFile, status, modelAsString, bosonicFields, fermionicFields,
			tikzFeynmanSetString, optQGFieldStyles, tikzSetString, customFieldStyles,
			bosonicTikzFeynmanSetString, fermionicTikzFeynmanSetString, finalPrologString,
			bosonicTikzSetString, fermionicTikzSetString, model, output, optNames,
			optQGExtraStyles, extraStylesString
		},

		If [OptionValue[FCVerbose]===False,
			qgtzfcfsVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				qgtzfcfsVerbose=OptionValue[FCVerbose]
			];
		];

		optDeleteFile 		= OptionValue[DeleteFile];
		optQGFieldStyles	= OptionValue[QGFieldStyles];
		optQGExtraStyles	= OptionValue[QGExtraStyles];
		optNames			= OptionValue[Names];

		FCPrint[1,"QGTZFCreateFieldStyles: Entering. ", FCDoControl->qgtzfcfsVerbose];

		If[!MatchQ[optQGFieldStyles,{} | {{_String,_String,_String}..}],
			Message[QGTZFCreateFieldStyles::fail,"The option QGFieldStyles is not of the correct form."];
			Abort[]
		];

		If[!MatchQ[optQGExtraStyles,{} | {__String}],
			Message[QGTZFCreateFieldStyles::fail,"The option QGExtraStyles is not of the correct form."];
			Abort[]
		];

		If[	TrueQ[FileExtension[outputRaw]=!=""],
			output = outputRaw,
			output = FileNameJoin[{outputRaw,optNames}]
		];


		FCPrint[1,"QGTZFCreateFieldStyles: Importig the model file.", FCDoControl->qgtzfcfsVerbose];

		model=FeynCalc`Package`qdLoadFileFrom[modelRaw,$QGModelsDirectory];

		time = AbsoluteTime[];
		modelAsString = Import[model, "String"];

		If[	!FreeQ[modelAsString, $Failed],
			Message[QGTZFCreateFieldStyles::fail,"Failed to import the model as a string."];
			Abort[]
		];

		FCPrint[1, "QGTZFCreateFieldStyles: Done importing the model file, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgtzfcfsVerbose];

		bosonicFields 	= extractQgBosonicFields[modelAsString];
		fermionicFields = extractQgFermionicFields[modelAsString];

		FCPrint[1, "QGTZFCreateFieldStyles: Bosonic fields in the model: ", bosonicFields, FCDoControl->qgtzfcfsVerbose];
		FCPrint[1, "QGTZFCreateFieldStyles: Fermionic fields in the model: ", fermionicFields, FCDoControl->qgtzfcfsVerbose];

		If[	optQGExtraStyles=!={},
			extraStylesString = StringJoin[StringRiffle[optQGExtraStyles, ",\n"]],
			extraStylesString = ""
		];

		If[	optQGFieldStyles=!={},
			customFieldStyles = First/@optQGFieldStyles;

			bosonicFields = SelectFree[bosonicFields,customFieldStyles];
			fermionicFields = SelectFree[fermionicFields,customFieldStyles];

			tikzFeynmanSetString = StringJoin[StringRiffle[Flatten[Map[{"qg" <> #[[1]] <> "Name/.style={particle=\\(" <> #[[3]] <> "\\)}",
			"qg" <> #[[1]] <> "Style/.style={" <> #[[2]] <> "}"} &, optQGFieldStyles]], ",\n"]];

			tikzSetString =	StringJoin[StringRiffle[Flatten[Map[{"qg" <> #[[1]] <> "EdgeName/.style={edge label=\\(" <> #[[3]] <> "\\)}"} &,
			optQGFieldStyles]], ",\n"]],

			tikzFeynmanSetString = "";
			tikzSetString = ""
		];

		bosonicTikzFeynmanSetString = StringJoin[StringRiffle[Flatten[Map[{"qg" <> # <> "Name/.style={particle=" <> # <> "}",
			"qg" <> # <> "Style/.style={boson}"} &, bosonicFields]], ",\n"]];

		fermionicTikzFeynmanSetString = StringJoin[StringRiffle[Flatten[Map[{"qg" <> # <> "Name/.style={particle=" <> # <> "}",
			"qg" <> # <> "Style/.style={fermion}"} &, fermionicFields]], ",\n"]];

		bosonicTikzSetString =		StringJoin[StringRiffle[Flatten[Map[{"qg" <> # <> "EdgeName/.style={edge label=" <> # <> "}"} &,
			bosonicFields]], ",\n"]];

		fermionicTikzSetString =	StringJoin[StringRiffle[Flatten[Map[{"qg" <> # <> "EdgeName/.style={edge label=" <> # <> "}"} &,
			fermionicFields]], ",\n"]];

		finalPrologString = {
			"\n",
			"\\tikzfeynmanset{",
			If[	extraStylesString=!="",
				extraStylesString<>",",
				Unevaluated[Sequence[]]
			],
			"qgMomentumArrowStyle/.style n args={2}{{momentum={[arrow style=red, arrow shorten=0.35]{\\tiny \(#1\)}}}},",
			If[	tikzFeynmanSetString=!="",
				tikzFeynmanSetString<>",",
				Unevaluated[Sequence[]]
			],
			If[	bosonicTikzFeynmanSetString=!="",
				bosonicTikzFeynmanSetString<>",",
				Unevaluated[Sequence[]]
			],
			If[	fermionicTikzFeynmanSetString=!="",
				fermionicTikzFeynmanSetString<>",",
				Unevaluated[Sequence[]]
			],
			"}",
			"\n",
			"\\tikzset{",
			If[	tikzSetString=!="",
				tikzSetString<>",",
				Unevaluated[Sequence[]]
			],
			If[	bosonicTikzSetString=!="",
				bosonicTikzSetString<>",",
				Unevaluated[Sequence[]]
			],
			If[	fermionicTikzSetString=!="",
				fermionicTikzSetString<>",",
				Unevaluated[Sequence[]]
			],
			"}"
		};

		finalPrologString = StringRiffle[Flatten[finalPrologString] /. "" -> Unevaluated[Sequence[]],"\n"];

		FCPrint[3,"QGTZFCreateFieldStyles: Output: ", finalPrologString, FCDoControl->qgtzfcfsVerbose];

		FCPrint[1,"QGTZFCreateFieldStyles: Saving the output.", FCDoControl->qgtzfcfsVerbose];
		time = AbsoluteTime[];


		If[	FileExistsQ[output],
			If[	optDeleteFile,
				If[	DeleteFile[output]===$Failed,
					Message[QGTZFCreateFieldStyles::fail,"Failed to delete the file " <> output <> "."];
					Abort[]
				],
				Message[QGTZFCreateFieldStyles::fail,"The output file "<> output <> " already exists and should not be overwritten."];
				Abort[]
			]
		];
		status = Export[output, finalPrologString, "String"];


		If[	!FreeQ[status,$Failed],
				Message[QGTZFCreateFieldStyles::fail,"Something went wrong when saving the style file."];
				Abort[]
		];

		FCPrint[1,"QGTZFCreateFieldStyles: Leaving. ", FCDoControl->qgtzfcfsVerbose];

		output

	];

(*TODO: Safe for memoization*)
extractQgBosonicFields[model_String] :=
	StringCases[model, {Shortest["[" ~~ x__ ~~ "+;"] /; StringFreeQ[x, {"[", "]"}] :> x,
		Shortest["[" ~~ x__ ~~ "+, " ~~ __ ~~ ";"] /; StringFreeQ[x, {"[", "]"}] :> x
		}] // StringSplit[#, ","] & // Flatten // Union //
	StringTrim // ReplaceAll[#, "" -> Unevaluated[Sequence[]]] & // Union;


extractQgFermionicFields[model_String] :=
	StringCases[model, {Shortest["[" ~~ x__ ~~ "-;"] /; StringFreeQ[x, {"[", "]"}] :> x,
		Shortest["[" ~~ x__ ~~ "-, " ~~ __ ~~ ";"] /; StringFreeQ[x, {"[", "]"}] :> x
		}] // StringSplit[#, ","] & // Flatten // Union //
	StringTrim // ReplaceAll[#, "" -> Unevaluated[Sequence[]]] & // Union;

End[]

