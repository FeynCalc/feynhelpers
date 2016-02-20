(* :Title: MUnitTestSuite.mt												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015 Vladyslav Shtabovenko
*)

(* :Summary:  Test Suite for FeynHelpers via MUnit							*)

(* ------------------------------------------------------------------------ *)

BeginPackage["FeynCalc`"];
FCDeclareHeader@ToFileName[{$FeynCalcDirectory, "AddOns",
"FeynHelpers"}, "FeynHelpers.m"];
Get@ToFileName[{$FeynCalcDirectory, "AddOns",
"FeynHelpers"}, "FeynHelpers.m"];
EndPackage[];

RunTestSuite[
	ToFileName[{$FeynHelpersDirectory, "Tests"}],
	Map[FileNameJoin[{#[[Length[#] - 2]], #[[Length[#]-1]], #[[Length[#]]]}] &,
	FileNameSplit /@ FileNames["*.mt", FileNameJoin[{$FeynHelpersDirectory, "Tests", "*"}]]]
]
