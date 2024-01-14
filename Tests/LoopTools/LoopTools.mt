(* :Title: General.mt														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2024 Vladyslav Shtabovenko
*)

(* :Summary:  Unit tests for LoopTools										*)

(* ------------------------------------------------------------------------ *)


If [!StringQ[FeynCalc`$FeynHelpersDirectory],
	BeginPackage["FeynCalc`"];
	FCDeclareHeader@FileNameJoin[{$FeynCalcDirectory, "AddOns", "FeynHelpers", "FeynHelpers.m"}];
	Get@FileNameJoin[{$FeynCalcDirectory, "AddOns", "FeynHelpers", "FeynHelpers.m"}];
	EndPackage[]
]
LToolsLoadLibrary[];
$FCAdvice=False;
ClearAll[tests];
tests = FileNames["*.test",FileNameJoin[{$FeynHelpersDirectory, "Tests", "LoopTools"}]]
Get/@tests;

Map[Test[Chop@Normal@Simplify[ToExpression[(#[[2]])]-ToExpression[(#[[3]])]],0,TestID->#[[1]]]&,
	Join@@(ToExpression/@Names["Tests`LoopTools`*"])];
