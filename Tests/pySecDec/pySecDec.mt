(* :Title: pySecDec.mt															*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2018 Vladyslav Shtabovenko
*)

(* :Summary:  Unit tests for the interace to pySecDec							*)

(* ------------------------------------------------------------------------ *)


If [!StringQ[FeynCalc`$FeynHelpersDirectory],
	BeginPackage["FeynCalc`"];
	FCDeclareHeader@FileNameJoin[{$FeynCalcDirectory, "AddOns", "FeynHelpers", "FeynHelpers.m"}];
	Get@FileNameJoin[{$FeynCalcDirectory, "AddOns", "FeynHelpers", "FeynHelpers.m"}];
	EndPackage[]
]

ClearAll[tests];
tests = FileNames["*.test",FileNameJoin[{$FeynHelpersDirectory, "Tests", "pySecDec"}]]
Get/@tests;

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
	Join@@(ToExpression/@Names["Tests`pySecDec`*"])];
