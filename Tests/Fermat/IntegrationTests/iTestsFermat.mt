(* :Title: iTestsFermat.mt													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2014-2023 Vladyslav Shtabovenko
*)

(* :Summary:  Unit tests for Fermat											*)

(* ------------------------------------------------------------------------ *)

If [!StringQ[FeynCalc`$FeynHelpersDirectory],
	BeginPackage["FeynCalc`"];
	FCDeclareHeader@FileNameJoin[{$FeynCalcDirectory, "AddOns", "FeynHelpers", "FeynHelpers.m"}];
	Get@FileNameJoin[{$FeynCalcDirectory, "AddOns", "FeynHelpers", "FeynHelpers.m"}];
	EndPackage[]
]

ClearAll[itestsFermat];
itestsFermat = FileNames["*.test",FileNameJoin[{$FeynHelpersDirectory, "Tests", "Fermat", "IntegrationTests"}]]
Get/@itestsFermat;

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
	Join@@(ToExpression/@Names["Tests`Fermat`*"])];
