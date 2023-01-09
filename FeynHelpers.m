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

Begin["`Package`"]



End[]

Begin["`FeynHelpers`Private`"];

If[ !ValueQ[FeynCalc`$FeynHelpersLoadInterfaces],
	FeynCalc`$FeynHelpersLoadInterfaces = {"PackageX", "FIRE", "Kira", "Fermat", "QGRAF", "LoopTools", "pySecDec"}
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

Remove["FeynCalc`load"];
EndPackage[]


fcVersion = StringSplit[$FeynCalcVersion, "."];
tooOldString = "Your FeynCalc version is too old. FeynHelpers "<> $FeynHelpersVersion <> " requires at least FeynCalc 9.3.0";

If[ (fcVersion[[1]]<9),
	Print[tooOldString];
	Abort[],
	If[ fcVersion[[2]]<3,
		Print[tooOldString];
		Abort[]
	];
];

FeynCalc`Package`FeynHelpersLoaded = True;

(* Print the startup message *)
If[ $FeynCalcStartupMessages =!= False,
	Print[Style["FeynHelpers ", "Text", Bold], Style[$FeynHelpersVersion <> ", for more information see the accompanying ", "Text"],
			Style[DisplayForm@ButtonBox["publication.", BaseStyle -> "Hyperlink",	ButtonFunction :>
				SystemOpen[FileNameJoin[{$FeynHelpersDirectory,"Documentation","1611.06793.pdf"}]],
				Evaluator -> Automatic, Method -> "Preemptive"], "Text"]];
	Print[ Style["Have a look at the supplied ","Text"],

	Style[DisplayForm@ButtonBox["examples.", BaseStyle -> "Hyperlink",	ButtonFunction :>
							SystemOpen[FileNameJoin[{$FeynHelpersDirectory, "Examples"}]],
							Evaluator -> Automatic, Method -> "Preemptive"], "Text"],
	Style[" If you use FeynHelpers in your research, please evaluate FeynHelpersHowToCite[] to learn how to correctly cite this work.","Text"]];


];

FeynCalc`FeynHelpersHowToCite[]:=
	(
	Print[Style[" \[Bullet] V. Shtabovenko, \"FeynHelpers: Connecting FeynCalc to FIRE and Package-X\", Comput. Phys. Commun., 218, 48-65, 2017, arXiv:1611.06793","Text"]];
	Print[Style["Furthermore, remember to cite the authors of the tools that you are calling from FeynHelpers, which are","Text"]];


	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["FIRE",ButtonData :> {URL["https://bitbucket.org/feynmanIntegrals/fire/"], None},BaseStyle -> "Hyperlink",
		ButtonNote -> "https://bitbucket.org/feynmanIntegrals/fire/"],"Text"], Style[" by A. Smirnov, if you are using functions that begin with FIRE.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Kira",ButtonData :> {URL["https://kira.hepforge.org/"], None},BaseStyle -> "Hyperlink",
		ButtonNote -> "https://gitlab.com/kira-pyred/kira"],"Text"], Style[" by the Kira collaboration, if you are using functions that begin with Kira.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Package-X",ButtonData :> {URL["https://packagex.hepforge.org"], None},BaseStyle -> "Hyperlink",
		ButtonNote -> "https://packagex.hepforge.org"],"Text"], Style[" by H. Patel, if you are using functions that begin with PaX.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Fermat",ButtonData :> {URL["https://home.bway.net/lewis"], None},BaseStyle -> "Hyperlink",
		ButtonNote -> "https://home.bway.net/lewis"],"Text"], Style[" by R. Lewis, if you are using functions that beging with Fer.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["QGRAF",ButtonData :> {URL["http://cfif.ist.utl.pt/~paulo/qgraf.html"], None},BaseStyle -> "Hyperlink",
		ButtonNote -> "http://cfif.ist.utl.pt/~paulo/qgraf.html"],"Text"], Style[" by P. Nogueira, if you are using functions that begin with QG.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["LoopTools",ButtonData :> {URL["http://www.feynarts.de/looptools/"], None},BaseStyle -> "Hyperlink",
		ButtonNote -> "http://www.feynarts.de/looptools"],"Text"], Style[" by T. Hahn, if you are using functions that begin with LT.","Text"]];

	Print[Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["pySecDec",ButtonData :> {URL["https://secdec.readthedocs.io/en/stable/"], None},BaseStyle -> "Hyperlink",
		ButtonNote -> "https://secdec.readthedocs.io/en/stable/"],"Text"], Style[" by the SecDec collaboration, if you are using functions that begin with PSD.","Text"]]

	);


If[ !ValueQ[FeynHelpers`Package`paxLoaded],
	FeynHelpers`Package`paxLoaded = False
];

If[ !ValueQ[FeynHelpers`Package`paxLoaded],
	FeynHelpers`Package`paxLoaded = False
];

End[]


