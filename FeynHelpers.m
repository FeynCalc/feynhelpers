(* ::Package:: *)

(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FeynHelpers														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Interfaces between FeynCalc and other useful HEP package	*)

(* ------------------------------------------------------------------------ *)

$FeynHelpersVersion::usage=
"$FeynHelpersVersion is a string that represents the version of FeynHelpers.";

$FeynHelpersDirectory::usage=
"$FeynHelpersDirectory specifies the location of FeynHelpers.";

FeynHelpersHowToCite::usage=
"FeynHelpersHowToCite[] lists publications that should be cited when mentioning
FeynHelpers in scientific works.";

$FeynHelpersLoadInterfaces::usage=
"$FeynHelpersLoadIntefaces is a debugging switch that can be used to disable
the loading of particular interfaces contained in FeynHelpers.";

$FeynHelpersLastCommitDateHash::usage=
"The setting of $FeynHelpersLastCommitDateHash provides the date and the hash
of the last commit in the branch from which the current FeynHelpers version
originates.";

Begin["`Package`"]



End[]

Begin["`FeynHelpers`Private`"];

If[ !ValueQ[FeynCalc`$FeynHelpersLoadInterfaces],
	FeynCalc`$FeynHelpersLoadInterfaces = {"PackageX", "FIRE", "Kira", "Fermat", "QGRAF", "LoopTools", "pySecDec", "FIESTA", "Asy"}
];

$FeynHelpersVersion="2.0.0";

$FeynHelpersDirectory = FileNameJoin[{$FeynCalcDirectory, "AddOns", "FeynHelpers"}];

If[ ($VersionNumber < 10.0) && StringFreeQ[$Version, "Mathics"],
	Print[Style["You need at least Mathematica 10.0 to run FeynHelpers. Evaluation aborted.",Red, Bold]];
	Abort[]
];

(* Load the intefaces *)
BeginPackage["FeynCalc`"];

load = "";

If[	!FreeQ[$FeynHelpersLoadInterfaces,"PackageX"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","PackageX.m"}];
	FCDeclareHeader[load];
	Get[load]
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"FIRE"],
	load = FileNames[{"*.m"},FileNameJoin[{$FeynHelpersDirectory,"Interfaces","FIRE"}]];
	FCDeclareHeader/@load;
	Get/@load
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"Kira"],
	load = FileNames[{"*.m"},FileNameJoin[{$FeynHelpersDirectory,"Interfaces","Kira"}]];
	FCDeclareHeader/@load;
	Get/@load
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"Fermat"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","Fermat","FerShared.m"}];
	FCDeclareHeader[load];
	Get[load];
	load = FileNames[{"*.m"},ToFileName[{$FeynHelpersDirectory,"Interfaces","Fermat"}]];
	FCDeclareHeader/@load;
	Get/@load
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"LoopTools"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","LoopTools","LoopToolsShared.m"}];
	FCDeclareHeader[load];
	Get[load];
	load = FileNames[{"*.m"},FileNameJoin[{$FeynHelpersDirectory,"Interfaces","LoopTools"}]];
	FCDeclareHeader/@load;
	Get/@load
];


If[	!FreeQ[$FeynHelpersLoadInterfaces,"QGRAF"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","QGRAF","QGRAFShared.m"}];
	FCDeclareHeader[load];
	Get[load];
	load = FileNames[{"*.m"},ToFileName[{$FeynHelpersDirectory,"Interfaces","QGRAF"}]];
	FCDeclareHeader/@load;
	Get/@load
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"pySecDec"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","pySecDec","PSDShared.m"}];
	FCDeclareHeader[load];
	Get[load];
	load = FileNames[{"*.m"},FileNameJoin[{$FeynHelpersDirectory,"Interfaces","pySecDec"}]];
	FCDeclareHeader/@load;
	Get/@load
];


If[	!FreeQ[$FeynHelpersLoadInterfaces,"FIESTA"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","FIESTA","FSAShared.m"}];
	FCDeclareHeader[load];
	Get[load];
	load = FileNames[{"*.m"},FileNameJoin[{$FeynHelpersDirectory,"Interfaces","FIESTA"}]];
	FCDeclareHeader/@load;
	Get/@load
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"Asy"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","ASy","ASyShared.m"}];
	FCDeclareHeader[load];
	Get[load];
	load = FileNames[{"*.m"},FileNameJoin[{$FeynHelpersDirectory,"Interfaces","ASy"}]];
	FCDeclareHeader/@load;
	Get/@load
];

Remove["FeynCalc`load"];
EndPackage[]


fcVersion = StringSplit[$FeynCalcVersion, "."];
tooOldString = "Your FeynCalc version is too old. FeynHelpers "<> $FeynHelpersVersion <> " requires at least FeynCalc 10.0";

If[ (fcVersion[[1]]<10),
	Print[tooOldString];
	Abort[],
	If[ fcVersion[[2]]<0,
		Print[tooOldString];
		Abort[]
	];
];

FeynCalc`Package`FeynHelpersLoaded = True;


If[	TrueQ[FileExistsQ[FileNameJoin[{$FeynHelpersDirectory, ".version"}]]],
	FeynCalc`$FeynHelpersLastCommitDateHash = Import[FileNameJoin[{$FeynHelpersDirectory, ".version"}],"Text"];
	If[	TrueQ[StringFreeQ[FeynCalc`$FeynHelpersLastCommitDateHash,"$"]],
		FeynCalc`$FeynHelpersLastCommitDateHash = StringRiffle[ToExpression[FeynCalc`$FeynHelpersLastCommitDateHash], ", "],
		FeynCalc`$FeynHelpersLastCommitDateHash = ""
	],
	FeynCalc`$FeynHelpersLastCommitDateHash = ""
];

FeynCalc`file = FileNameJoin[{AbsoluteFileName[$FeynHelpersDirectory], ".git", "HEAD"}];


If[	TrueQ[FileExistsQ[FeynCalc`file] && FeynCalc`$FeynHelpersLastCommitDateHash === ""],

	FeynCalc`file = FileNameJoin[{AbsoluteFileName[$FeynHelpersDirectory], ".git", Last[StringSplit[Import[FeynCalc`file, "Text"], ": "]]}];

	If[	TrueQ[FileExistsQ[FeynCalc`file]],
		FeynCalc`$FeynHelpersLastCommitDateHash = StringJoin[{DateString[FileDate[FeynCalc`file], {"Year", "-", "Month", "-", "Day", " ", "Time",
		" ", "ISOTimeZone"}], ", ", StringTake[Import[FeynCalc`file, "Text"], 8]}],
		FeynCalc`$FeynHelpersLastCommitDateHash = ""
	],
	FeynCalc`$FeynHelpersLastCommitDateHash = ""
];

(* Print the startup message *)
If[ $FeynCalcStartupMessages =!= False,
	Print[Style["FeynHelpers ", "Text", Bold], Style[$FeynHelpersVersion <> " (" <> FeynCalc`$FeynHelpersLastCommitDateHash <>")" <> ". For help, use the ", "Text"],
	Style[DisplayForm@ButtonBox["online documentation,", ButtonData :> {URL["https://feyncalc.github.io/referenceFeynHelpersDev"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "https://feyncalc.github.io/referenceFeynHelpersDev"], "Text"],
			Style[" visit the ", "Text"],
			Style[DisplayForm@ButtonBox["forum", ButtonData :> {URL["https://github.com/FeynCalc/feyncalc/discussions"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "https://github.com/FeynCalc/feyncalc/discussions/"],"Text"], Style[" and have a look at the supplied ","Text"],
				Style[DisplayForm@ButtonBox["examples.", BaseStyle -> "Hyperlink",	ButtonFunction :>
							SystemOpen[FileNameJoin[{$FeynHelpersDirectory, "Examples"}]],
							Evaluator -> Automatic, Method -> "Preemptive"], "Text"],
			Style["The PDF-version of the manual can be downloaded ", "Text"],
			Style[DisplayForm@ButtonBox["here.", ButtonData :> {URL["https://github.com/FeynCalc/feynhelpers-manual/releases/download/dev-manual/FeynHelpersManual.pdf"],
				None},BaseStyle -> "Hyperlink",	ButtonNote -> "https://github.com/FeynCalc/feynhelpers-manual/releases/download/dev-manual/FeynHelpersManual.pdf"], "Text"]
			];
	Print[Style[" If you use FeynHelpers in your research, please evaluate FeynHelpersHowToCite[] to learn how to cite this work.","Text"]];
];

FeynCalc`FeynHelpersHowToCite[]:=
	(
	Print[Style[" \[Bullet] V. Shtabovenko, \"FeynHelpers: Connecting FeynCalc to FIRE and Package-X\", Comput. Phys. Commun., 218, 48-65, 2017, arXiv:1611.06793","Text"]];
	Print[Style["Furthermore, remember to cite the authors of the tools that you are calling from FeynHelpers, which are","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Asy",ButtonData :> {URL["https://www.ttp.kit.edu/~asmirnov/Tools-Regions.htm"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that beging with ASy.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Fermat",ButtonData :> {URL["https://home.bway.net/lewis"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that beging with Fer.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["FIRE",ButtonData :> {URL["https://gitlab.com/feynmanintegrals/fire"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that begin with FIRE.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["FIESTA",ButtonData :> {URL["https://gitlab.com/feynmanintegrals/fiesta/"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that begin with FSA.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Kira",ButtonData :> {URL["https://gitlab.com/kira-pyred/kira"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that begin with Kira.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["LoopTools",ButtonData :> {URL["http://www.feynarts.de/looptools/"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that begin with LT.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Package-X",ButtonData :>
		{URL["https://inspirehep.net/literature?sort=mostrecent&size=25&page=1&q=find+a+patel%2C+h+and+t+package"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that begin with PaX.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["QGRAF",ButtonData :> {URL["http://cfif.ist.utl.pt/~paulo/qgraf.html"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that begin with QG.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["pySecDec",ButtonData :> {URL["https://secdec.readthedocs.io/en/stable/"], None},
		BaseStyle -> "Hyperlink"],"Text"], Style[" if you are using functions that begin with PSD.","Text"]];



	);


If[ !ValueQ[FeynHelpers`Package`paxLoaded],
	FeynHelpers`Package`paxLoaded = False
];

If[ !ValueQ[FeynHelpers`Package`paxLoaded],
	FeynHelpers`Package`paxLoaded = False
];

FeynCalc`Private`AddToTheWhiteListedContextAdditions={"AlphaRepExpand", "AsySigns","Executable","GenericPowers","PreResolve","QHull"};


End[]


