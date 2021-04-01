(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: QGCreateAmp														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Runs QGRAF and generates the diagrams						*)

(* ------------------------------------------------------------------------ *)

QGCreateAmp::usage=
"QGCreateAmp[nLoops, {\"InParticle1[p1]\", \"InParticle1[p2]\", ...} -> \
{\"OutParticle1[k1]\", \"OutParticle1[k2]\", ...}] \
calls QGRAF to generate Feynman amplitudes and (optionally) the corresponding diagrams, \
using the specified  model and style files. The function returns a list with the \
paths to two files, where the first file contains the amplitudes and the second file the \
diagrams (a graphical representation of the amplitudes).";

QGOutputAmplitudes::usage=
"QGOutputAmplitudes is an option for QGCreateAmp. It specifies the filename to which \
the QGRAF output containing the generated amplitudes will be saved. The default name is \
\"amplitudes.m\" in the current working directory.";

QGOutputDiagrams::usage=
"QGOutputAmplitudes is an option for QGCreateAmp. It specifies, the filename to which \
the QGRAF output containing the generated diagrams will be saved. The default name is \
\"diagrams.tex\" in the current working directory.";

QGOutputDirectory::usage=
"QGOutputDirectory is an option for QGCreateAmp. It specifies the directory in \
which the QGRAF output containing the generated amplitudes and diagrams will be saved. \
The default location is the current working directory (Directory[])";

QGModel::usage=
"QGMode is an option for QGCreateAmp, which specifies the QGRAF model file. \
If you provide only the file name, they model will be loaded from the standard \
directory containing model files ($QGModelsDirectory). \
If you specify the full path, the model file will be loaded from there. The default \
value is a model for one flavour QCD, \"QCDOneFlavor\"";

QGAmplitudeStyle::usage=
"QGAmplitudeStyle is an option for QGCreateAmp, which specifies the QGRAF style file \
for generating the amplitudes. If you provide only the file name, they style will be \
loaded from the standard directory containing style files ($QGStylesDirectory). \
If you specify the full path, the style file will be loaded from there. The default \
value is a custom style file for FeynCalc \"feyncalc.sty\".";

QGDiagramStyle::usage=
"QGDiagramStyle is an option for QGCreateAmp, which specifies the QGRAF style file \
for generating the diagrams. If you provide only the file name, they style will be \
loaded from the standard directory containing model and style files ($QGStylesDirectory). \
If you specify the full path, the style file will be loaded from there. The default \
value is a custom style file for FeynMP \"latex.sty\". \n

If the options value is set to an empty string, no diagram file will be generated.";

QGSaveInputFile::usage =
"QGSaveInputFile is an option for QGCreateAmp, which specifies where to save the QGRAF input file \
\"qgraf.dat\". This file is automatically created from the input parameters of QGCreateAmp \
but it must be located in the same directory as the QGRAF binary when QGRAF is invoked. The default
value is False, which means that \"qgraf.dat\" will be deleted after the succesful QGRAF run. \
When set to True, \"qgraf.dat\" will be copied to the current directory. Specifying an explicit path \
will make QGCreateAmp put \"qgraf.dat\" there. Notice that only the file for generating the amplitudes
is saved. The file for generating the diagrams (if exists) is identical except for the difference in the
style line.";

QGBinaryFile::usage=
"QGBinaryFile is an option for QGCreateAmp, which specifies full path to the QGRAF binary. When set \
to Automatic, the default binary is qgraf on Linux and macOS or qgraf.exe on Windows, which resides in \
FileNameJoin[{$FeynHelpersDirectory, \"ExternalTools\", \"QGRAF\", \"Binary\"}]. If you provide a different \
location, you must ensure that the containing directory is user-writable, since QGCreateAmp will need to \
save an automatically genearated \"qgraf.dat\" in that directory and delete it afterwards.";

QGLoopMomentum::usage =
"QGLoopMomentum is an option for QGCreateAmp, which specifies the names of the loop momenta. The default values \
is LoopMom, which means that the loop momenta will be named LoopMom1, LoopMom2, etc.";

QGOptions::usage =
"QGOptions is an option for QGCreateAmp, which specifies the options to be passed to QGRAF. It is a list of \
strings, where each string is a valid QGRAF option.";

QGOptionalStatements::usage =
"QGOptionalStatements is an option for QGCreateAmp, which specifies optional statements to be passed to QGRAF. It is a list of \
strings, where each string is a valid QGRAF optional statement.";

QGOverwriteExistingAmplitudes::usage =
"QGOverwriteExistingAmplitudes is an option for QGCreateAmp, which determines the behavior of the function when the \
file for the generated amplitudes already exists. The default value is True, which means that the file will be silently \
overwritten. Setting it to False, will prevent the overwriting by aborting the evaluation.";

QGOverwriteExistingDiagrams::usage =
"QGOverwriteExistingDiagrams is an option for QGCreateAmp, which determines the behavior of the function when the \
file for the generated diagrams already exists. The default value is True, which means that the file will be silently \
overwritten. Setting it to False, will prevent the overwriting by aborting the evaluation.";

QGCleanUpOutputDirectory::usage =
"QGCleanUpOutputDirectory is an option for QGCreateAmp, which determines whether all temporary files created in the \
directory that contains the QGRAF binary should be deleted after a succesfull QGRAF run. Tge default value is True.";

QGShowOutput::usage=
"QGShowOutput is an option for QGCreateAmp. When set to True, the output of the current QGRAF run will be shown via \
Print. When set to False the ouput is suppressed.";

QGCreateAmp::fail=
"QGCreateAmp has encountered an error and must abort the evaluation. The error description reads: `1`";

Begin["`Package`"]

End[]

Begin["`QGCreateAmp`Private`"]

qgBinaryDirectory::usage="";
qgcaVerbose::usage="";

Options[QGCreateAmp] = {
	FCVerbose 						-> False,
	QGAmplitudeStyle				-> "feyncalc.sty",
	QGBinaryFile 					-> Automatic,
	QGCleanUpOutputDirectory		-> True,
	QGDiagramStyle					-> "tikz-feynman.sty",
	QGLoopMomentum 					-> "LoopMom",
	QGModel							-> "QCDOneFlavor",
	QGOptionalStatements			-> {},
	QGOptions 						-> {"notadpole"},
	QGOutputAmplitudes 				-> "amplitudes.m",
	QGOutputDiagrams 				-> "diagrams.m",
	QGOutputDirectory 				:> Directory[],
	QGOverwriteExistingAmplitudes	-> True,
	QGOverwriteExistingDiagrams 	-> True,
	QGSaveInputFile 				-> False,
	QGShowOutput 					-> True
};



QGCreateAmp[nLoops_Integer?NonNegative, Rule[inFields_List, outFields_List], OptionsPattern[]]:=
	Block[{	currentFile,inputFileAsList,finalInputAsString,out,
			optQGOutputAmplitudes, optQGOutputDiagrams, optQGOutputDirectory,
			optQGAmplitudeStyle, optQGDiagramStyle, optQGModel, optQGBinaryFile,
			optQGOverwriteExistingAmplitudes, optQGOverwriteExistingDiagrams,
			optQGShowOutput, pathQGAmplitudeStyle, pathQGDiagramStyle, pathQGModel,
			pathQGOutputAmplitudes, pathQGOutputDiagrams, pathQGInputFile, optQGSaveInputFile,
			pathQGOutputAmplitudesTemporary, pathQGModelTemporary,
			pathQGAmplitudeStyleTemporary, pathQGDiagramStyleTemporary, pathQGOutputDiagramsTemporary},

		optQGAmplitudeStyle 				= OptionValue[QGAmplitudeStyle];
		optQGDiagramStyle 					= OptionValue[QGDiagramStyle];
		optQGModel 							= OptionValue[QGModel];
		optQGBinaryFile						= OptionValue[QGBinaryFile];
		optQGOutputAmplitudes 				= OptionValue[QGOutputAmplitudes];
		optQGOutputDiagrams 				= OptionValue[QGOutputDiagrams];
		optQGOutputDirectory 				= OptionValue[QGOutputDirectory];
		optQGSaveInputFile 					= OptionValue[QGSaveInputFile];
		optQGOverwriteExistingAmplitudes 	= OptionValue[QGOverwriteExistingAmplitudes];
		optQGOverwriteExistingDiagrams 		= OptionValue[QGOverwriteExistingDiagrams];
		optQGShowOutput 					= OptionValue[QGShowOutput];

		If [OptionValue[FCVerbose]===False,
			qgcaVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				qgcaVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1, "QGCreateAmp: Entering.", FCDoControl->qgcaVerbose];

		FCPrint[1, "QGCreateAmp: Checking the QGRAF binary.", FCDoControl->qgcaVerbose];
		(* Check that we have a proper QGRAF binary *)
		If[	optQGBinaryFile===Automatic,
			Switch[$OperatingSystem,
				"Unix"|"MacOSX",
					optQGBinaryFile = FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "QGRAF", "Binary", "qgraf"}],
				"Windows",
					optQGBinaryFile = FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "QGRAF", "Binary", "qgraf.exe"}],
				_,
					Message[FerRunScript::failmsg,"Unsupported operating system!."];
					Abort[]
			];
		];

		If[ !FileExistsQ[optQGBinaryFile],
			Message[QGCreateAmp::fail,"The QGRAF binary " <> optQGBinaryFile <> " does not exist."];
			Abort[]
		];
		qgBinaryDirectory = DirectoryName[optQGBinaryFile];

		(* Check that the provided file and directory paths are correct *)
		FCPrint[1, "QGCreateAmp: Checking the options.", FCDoControl->qgcaVerbose];
		stringOptCheck["QGAmplitudeStyle",	optQGAmplitudeStyle,	QGCreateAmp::fail];
		stringOptCheck["QGDiagramStyle",	optQGDiagramStyle,		QGCreateAmp::fail];
		stringOptCheck["QGModel",			optQGModel,				QGCreateAmp::fail];
		stringOptCheck["QGOutputAmplitudes",optQGOutputAmplitudes,	QGCreateAmp::fail];
		stringOptCheck["QGOutputDiagrams",	optQGOutputDiagrams,	QGCreateAmp::fail];
		stringOptCheck["QGOutputDirectory",	optQGOutputDirectory,	QGCreateAmp::fail];
		If[	(optQGSaveInputFile=!=True) && (optQGSaveInputFile=!=False),
			stringOptCheck["QGSaveInputFile",	optQGSaveInputFile,	QGCreateAmp::fail];
		];


		pathQGOutputAmplitudes 	= FileNameJoin[{optQGOutputDirectory, optQGOutputAmplitudes}];
		If[ pathQGDiagramStyle=!="",
			pathQGOutputDiagrams 	= FileNameJoin[{optQGOutputDirectory, optQGOutputDiagrams}],
			(* No diagrams will be generated *)
			pathQGOutputDiagrams=""
		];

		(* Check that the speciified model and style files exist *)
		FCPrint[1, "QGCreateAmp: Checking model and style files.", FCDoControl->qgcaVerbose];

		pathQGAmplitudeStyle=FeynCalc`Package`qdLoadFileFrom[optQGAmplitudeStyle,$QGStylesDirectory];

		If[ optQGDiagramStyle=!="",
			pathQGDiagramStyle=FeynCalc`Package`qdLoadFileFrom[optQGDiagramStyle,$QGStylesDirectory],
			pathQGDiagramStyle=""
		];

		pathQGModel=FeynCalc`Package`qdLoadFileFrom[optQGModel,$QGModelsDirectory];


		(*
			These files will be located in the same directory as the QGRAF binary.
			Existing files must be deleted since otherweise QGRAF will refuse to overwrite them
		*)
		pathQGOutputAmplitudesTemporary = FileNameJoin[{qgBinaryDirectory,optQGOutputAmplitudes}];
		pathQGOutputDiagramsTemporary = FileNameJoin[{qgBinaryDirectory,optQGOutputDiagrams}];

		FCPrint[1, "QGCreateAmp: Removing possible leftover output files.", FCDoControl->qgcaVerbose];
		deleteIfExists[pathQGOutputAmplitudesTemporary];
		deleteIfExists[pathQGOutputDiagramsTemporary];

		(* Model and style files should be also be located in the same directory as the QGRAF binary *)
		pathQGModelTemporary 			= FileNameJoin[{qgBinaryDirectory,FileNameTake[pathQGModel]}];
		pathQGAmplitudeStyleTemporary 	= FileNameJoin[{qgBinaryDirectory,FileNameTake[pathQGAmplitudeStyle]}];
		pathQGDiagramStyleTemporary 	= FileNameJoin[{qgBinaryDirectory,FileNameTake[pathQGDiagramStyle]}];


		FCPrint[1, "QGCreateAmp: Copying model and style files to the QGRAF directory.", FCDoControl->qgcaVerbose];
		(* existing file are automatically overwritten	*)
		copyFile[pathQGAmplitudeStyle,pathQGAmplitudeStyleTemporary, OverwriteTarget->True];
		copyFile[pathQGModel,pathQGModelTemporary, OverwriteTarget->True];
		If[	pathQGDiagramStyle=!="",
			copyFile[pathQGDiagramStyle,pathQGDiagramStyleTemporary, OverwriteTarget->True];
		];

		(* Create qgraf.dat for the amplitudes *)
		inputFileAsList = {
			"output= '"			<> optQGOutputAmplitudes <> "';",
			"style= '" 			<> FileNameTake[pathQGAmplitudeStyle] <> "';",
			"model= '"			<> FileNameTake[pathQGModel] <> "';",
			"in= "				<> StringJoin[Riffle[inFields, ", "]] <> ";",
			"out= "				<> StringJoin[Riffle[outFields, ", "]] <> ";",
			"loops= "			<> ToString[nLoops] <> ";\n\n",
			"loop_momentum= "	<> ToString[OptionValue[QGLoopMomentum]] <>";",
			"options= "			<> StringJoin[Riffle[OptionValue[QGOptions], ", "]] <> ";\n\n",
			StringJoin[Riffle[OptionValue[QGOptionalStatements], "\n"]]
		};

		finalInputAsString 	= StringJoin[Riffle[inputFileAsList, "\n\n"]];
		pathQGInputFile 	= FileNameJoin[{DirectoryName[optQGBinaryFile],"qgraf.dat"}];


		FCPrint[1, "QGCreateAmp: Running QGRAF to generate the amplitudes.", FCDoControl->qgcaVerbose];
		runQgraf[optQGBinaryFile, pathQGInputFile, finalInputAsString, optQGShowOutput];

		FCPrint[1, "QGCreateAmp: Copying the amplitudes to the correct location.", FCDoControl->qgcaVerbose];
		If[	copyFile[pathQGOutputAmplitudesTemporary,pathQGOutputAmplitudes, OverwriteTarget->optQGOverwriteExistingAmplitudes]===$Failed,
			Message[QGCreateAmp::fail,"The file " <> pathQGOutputAmplitudes <> " already exists and can or should not be removed."];
			Abort[]
		];

		(*
			Possibly need to save the input file before it will overwritten during
			the 2nd run or deleted at the very end.
		*)
		If[	optQGSaveInputFile=!=False,
			FCPrint[1, "QGCreateAmp: Saving qgraf.dat", FCDoControl->qgcaVerbose];
			Which[
				optQGSaveInputFile===True,
					copyFile[pathQGInputFile, FileNameJoin[{Directory[], FileNameTake[pathQGInputFile]}], OverwriteTarget->True],
				StringQ[optQGSaveInputFile],
					copyFile[pathQGInputFile, optQGSaveInputFile, OverwriteTarget->True],
				True,
				Message[QGCreateAmp::fail,"Unknown value of the QGSaveInputFile option."];
				Abort[]
			]
		];

		If[	pathQGOutputDiagrams=!="" && pathQGDiagramStyle=!="" && pathQGDiagramStyle=!=optQGAmplitudeStyle,
			FCPrint[1, "QGCreateAmp: Preparing to generate the diagrams.", FCDoControl->qgcaVerbose];
			(*	The generation of the diagrams is not mandatory!	*)

			(* Copy the diagram style file to the QGRAF directory	*)
			FCPrint[1, "QGCreateAmp: Copying model and style files to the QGRAF directory.", FCDoControl->qgcaVerbose];
			copyFile[pathQGDiagramStyle, pathQGDiagramStyleTemporary, OverwriteTarget->True];
			copyFile[pathQGModel,FileNameJoin[{qgBinaryDirectory,FileNameTake[pathQGModel]}], OverwriteTarget->True];

			(* Edit the original qgraf.dat *)
			finalInputAsString 	= StringJoin[Riffle[ReplacePart[inputFileAsList,{
				1 -> "output= '" <> optQGOutputDiagrams <> "';",
				2 -> "style= '" <> FileNameTake[pathQGDiagramStyle] <> "';"
			}], "\n\n"]];

			(* Run QGRAF to generate the diagrams *)
			runQgraf[optQGBinaryFile, pathQGInputFile, finalInputAsString, optQGShowOutput];

			(*Copy the diagrams to the correct location *)
			If[	copyFile[pathQGOutputDiagramsTemporary,pathQGOutputDiagrams, OverwriteTarget->optQGOverwriteExistingDiagrams]===$Failed,
				Message[QGCreateAmp::fail,"The file " <> pathQGOutputDiagrams <> " already exists and can or should not be removed."];
				Abort[]
			];
		];

		(*	Clean up the directory containing the QGRAF binary	*)
		If[	OptionValue[QGCleanUpOutputDirectory],
			deleteIfExists[pathQGInputFile];
			deleteIfExists[pathQGModelTemporary];
			deleteIfExists[pathQGAmplitudeStyleTemporary];
			deleteIfExists[pathQGDiagramStyleTemporary];
			deleteIfExists[pathQGOutputAmplitudesTemporary];
			deleteIfExists[pathQGOutputDiagramsTemporary];
		];


		{pathQGOutputAmplitudes, pathQGOutputDiagrams}
	];



runQgraf[optQGBinaryFile_, pathQGInputFile_, finalInputAsString_, optQGShowOutput_]:=
	Block[{stream, out, currentFile,saveDirectory},

		If[	!StringQ[pathQGInputFile],
			Message[QGCreateAmp::fail,"Failed to generate the full path to qgraf.dat."];
			Abort[]
		];

		currentFile = OpenWrite[pathQGInputFile];
		WriteString[currentFile, finalInputAsString];
		Close[currentFile];

		If[	$VersionNumber >= 10.,
			out=RunProcess[optQGBinaryFile, ProcessDirectory->qgBinaryDirectory];
			If[	out===$Failed,
				Message[QGCreateAmp::fail,"Failed to execute the QGRAF binary."];
				Abort[]
			];
			out = out["StandardOutput"],

			(*In Mma  8 and 9 there is no RunProcess*)
			saveDirectory=Directory[];
			SetDirectory[qgBinaryDirectory];
			stream = OpenRead["!"<>optQGBinaryFile];
			If[	Head[stream]=!=InputStream,
				Message[QGCreateAmp::fail,"OpenRead failed to create an InputStream object."];
				Abort[]
			];
			out = ReadList[stream, String];
			Close[stream];
			SetDirectory[saveDirectory];
			If[	MatchQ[out, {__String}],
				out = StringJoin[Riffle[out, "\n"]],
				Print[out];
				Message[QGCreateAmp::fail,"Failed to execute the QGRAF binary."];
				Abort[]
			]
		];

		$QGLogOutputAmplitudes = StringTrim[out];

		If[	optQGShowOutput=!=False,
			Print[$QGLogOutputAmplitudes]
		];

		If[ !StringFreeQ[out, "error"],
			Message[QGCreateAmp::fail,"QGRAF reported an error while genearting the diagrams."];
			Print[out];
			Abort[]
		];

	];

Options[copyFile] = {
	OverwriteTarget -> False
};


deleteIfExists[file_String]:=
	If[ FileExistsQ[file],
			DeleteFile[file];
			If[ FileExistsQ[file],
				Message[QGCreateAmp::fail,"Failed to delete the file " <> file];
				Abort[]
			]
	];

copyFile[a_,b_, OptionsPattern[]]:=
	Block[{res},
	res = CopyFile[a,b,OverwriteTarget -> OptionValue[OverwriteTarget]];
	If[!FileExistsQ[b],
			Message[QGCreateAmp::fail,"Failed to copy the file " <> a <> " to " <> b];
			Abort[]
	];
	res
	]/; $VersionNumber>=11.0;


copyFile[a_,b_,OptionsPattern[]]:=
	Block[{res},
		If[!FileExistsQ[b],
			res = CopyFile[a,b],
			If[	OptionValue[OverwriteTarget]===True,
				DeleteFile[b];
				res = CopyFile[a,b],
				res = $Failed
			]
		];
		If[!FileExistsQ[b],
			Message[QGCreateAmp::fail,"Failed to copy the file " <> a <> " to " <> b];
			Abort[]
		];

		res
	]/; $VersionNumber<11.0;


stringOptCheck[optname_String, val_, failmsg_]:=
	If[	!StringQ[val] || val==="",
		Message[failmsg, optname<>" must be a nonempty string."];
		Abort[]
	];



End[]

