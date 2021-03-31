(* ::Package:: *)

(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FeynHelpers														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Interfaces between FeynCalc and other useful HEP package	*)

(* ------------------------------------------------------------------------ *)

$FeynHelpersVersion::usage=
"$FeynHelpersVersion is the string that represents the version of FeynHelpers";

$FeynHelpersDirectory::usage=
"$FeynHelpersDirectory is the string that represents the full path to the FeynHelpers \
directory";

Begin["`Package`"]



End[]

Begin["`FeynHelpers`Private`"];

If[ !ValueQ[FeynCalc`$FeynHelpersLoadInterfaces],
	FeynCalc`$FeynHelpersLoadInterfaces = {"PackageX", "FIRE", "Fermat", "QGRAF", "LoopTools"}
];

$FeynHelpersVersion="1.4.0";

$FeynHelpersDirectory = FileNameJoin[{$FeynCalcDirectory, "AddOns", "FeynHelpers"}];

(* Load the intefaces *)
BeginPackage["FeynCalc`"];

load = "";

If[	!FreeQ[$FeynHelpersLoadInterfaces,"PackageX"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","PackageX.m"}];
	FCDeclareHeader[load];
	Get[load]
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"FIRE"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","FIRE.m"}];
	FCDeclareHeader[load];
	Get[load]
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"Fermat"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","Fermat.m"}];
	FCDeclareHeader[load];
	Get[load]
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"LoopTools"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","LoopTools.m"}];
	FCDeclareHeader[load];
	Get[load]
];

If[	!FreeQ[$FeynHelpersLoadInterfaces,"QGRAF"],
	load = FileNameJoin[{$FeynHelpersDirectory,"Interfaces","QGRAF","QGRAFShared.m"}];
	FCDeclareHeader[load];
	Get[load];
	load = FileNames[{"*.m"},ToFileName[{$FeynHelpersDirectory,"Interfaces","QGRAF"}]];
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
	Style[" If you use FeynHelpers in your research, please cite","Text"]];
	Print [Style[" \[Bullet] V. Shtabovenko, \"FeynHelpers: Connecting FeynCalc to FIRE and Package-X\", Comput. Phys. Commun., 218, 48-65, 2017, arXiv:1611.06793","Text"]];
	Print[Style["Furthermore, remember to cite the authors of the tools that you are calling from FeynHelpers, which are","Text"]];

	If[	!FreeQ[$FeynHelpersLoadInterfaces,"FIRE"],
		Print [Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["FIRE",ButtonData :> {URL["https://bitbucket.org/feynmanIntegrals/fire/"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "https://bitbucket.org/feynmanIntegrals/fire/"],"Text"], Style[" by A. Smirnov, if you are using the function FIREBurn.","Text"]];
	];

	If[	!FreeQ[$FeynHelpersLoadInterfaces,"PackageX"],
		Print [Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Package-X",ButtonData :> {URL["https://packagex.hepforge.org"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "https://packagex.hepforge.org"],"Text"], Style[" by H. Patel, if you are using the function PaXEvaluate.","Text"]];
	];

	If[	!FreeQ[$FeynHelpersLoadInterfaces,"Fermat"],
		Print [Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Fermat",ButtonData :> {URL["https://home.bway.net/lewis"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "https://home.bway.net/lewis"],"Text"], Style[" by R. Lewis, if you are using the function FerSolve.","Text"]];
	];

	If[	!FreeQ[$FeynHelpersLoadInterfaces,"QGRAF"],
		Print [Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["QGRAF",ButtonData :> {URL["http://cfif.ist.utl.pt/~paulo/qgraf.html"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "http://cfif.ist.utl.pt/~paulo/qgraf.html"],"Text"], Style[" by P. Nogueira, if you are using functions that begin with QG.","Text"]];
	];

	If[	!FreeQ[$FeynHelpersLoadInterfaces,"LoopTools"],
		Print [Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["LoopTools",ButtonData :> {URL["http://www.feynarts.de/looptools/"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "http://www.feynarts.de/looptools"],"Text"], Style[" by T. Hahn, if you are using functions that begin with LT.","Text"]];
	];

];

If[ !ValueQ[FeynHelpers`Package`paxLoaded],
	FeynHelpers`Package`paxLoaded = False
];

If[ !ValueQ[FeynHelpers`Package`paxLoaded],
	FeynHelpers`Package`paxLoaded = False
];

End[]


