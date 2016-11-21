(* ::Package:: *)

(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FeynHelpers														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2016 Vladyslav Shtabovenko
*)

(* :Summary: 	Interfaces between FeynCalc and other useful HEP package	*)

(* ------------------------------------------------------------------------ *)

$FeynHelpersVersion::usage=
"$FeynHelpersVersion is the string that represents the version of $FeynHelpersVersion";

$FeynHelpersDirectory::usage=
"$FeynHelpersDirectory is the string that represents the full path to the FeynHelpersDirectory \
directory";

Begin["`Package`"]



End[]

Begin["`FeynHelpers`Private`"];

$FeynHelpersVersion="1.0.0";

$FeynHelpersDirectory =
ToFileName[{$FeynCalcDirectory, "AddOns", "FeynHelpers"}];

(* Load the intefaces *)
BeginPackage["FeynCalc`"];
FCDeclareHeader/@FileNames[{"*.m"},ToFileName[{$FeynHelpersDirectory,"Interfaces"}]];
Get/@FileNames[{"*.m"},ToFileName[{$FeynHelpersDirectory,"Interfaces"}]];
EndPackage[]


(* Print startup message *)
If[ Global`$FeynCalcStartupMessages =!= False,
	Print[Style["FeynHelpers ", "Text", Bold], Style[$FeynHelpersVersion <> " loaded.", "Text"]];
	Print[ Style["Have a look at the supplied ","Text"],

	Style[DisplayForm@ButtonBox["examples.", BaseStyle -> "Hyperlink",	ButtonFunction :>
							SystemOpen[FileNameJoin[{$FeynHelpersDirectory, "Examples"}]],
							Evaluator -> Automatic, Method -> "Preemptive"], "Text"],
	Style[" If you use FeynHelpers in your research, please cite","Text"]];
	Print [Style[" \[Bullet] V. Shtabovenko, \"FeynHelpers: Connecting FeynCalc to FIRE and Package-X\", TUM-EFT 75/15, in preparation","Text"]];
	Print[Style["Furthermore, remember to cite the authors of the tools that you are calling from FeynHelpers, which are","Text"]];
	Print [Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["FIRE",ButtonData :> {URL["http://science.sander.su/FIRE.htm"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "http://science.sander.su/FIRE.htm"],"Text"], Style[" by A. Smirnov, if you are using the function FIREBurn.","Text"]];
	Print [Style[" \[Bullet] "], Style[DisplayForm@ButtonBox["Package-X",ButtonData :> {URL["https://packagex.hepforge.org"], None},BaseStyle -> "Hyperlink",
				ButtonNote -> "https://packagex.hepforge.org"],"Text"], Style[" by H. Patel, if you are using the function PaXEvaluate.","Text"]];
];

If[ !ValueQ[FeynHelpers`Package`paxLoaded],
	FeynHelpers`Package`paxLoaded = False
];

If[ !ValueQ[FeynHelpers`Package`paxLoaded],
	FeynHelpers`Package`paxLoaded = False
];

End[]


