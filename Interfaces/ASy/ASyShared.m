(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: ASyShared														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and asy							*)

(* ------------------------------------------------------------------------ *)

ASyLoadPackage::usage=
"ASyLoadPackage[] loads asy on the current Mathematica kernel";

ASyPackagePath::usage=
"ASyPackagePath is an option for AsyLoadPackage. It specifies the location of
the asy package.";

ASyQHullPath::usage=
"ASyPackagePath is an option for AsyLoadPackage. It specifies the location of
the QHull binary.";

ASyShared::failmsg =
"The asy interface has encountered an error and must abort the evaluation. The \
error description reads: `1`";

Begin["`Package`"]

asyLoaded;

End[]

Begin["`ASyShared`Private`"]

FeynCalc`Package`asyLoaded = False;


Options[ASyLoadPackage] = {
	ASyPackagePath	-> FileNameJoin[{$UserBaseDirectory, "Applications", "asy21.m"}],
	ASyQHullPath	-> "/usr/bin/qhull"
};


ASyLoadPackage[OptionsPattern[]]:=
	Block[{},
		If[TrueQ[Get[OptionValue[ASyPackagePath]]=!=$Failed],
			SetOptions[Global`QHull, Global`Executable -> OptionValue[ASyQHullPath]];
			FeynCalc`Package`asyLoaded=True
		];
		FeynCalc`Package`asyLoaded
	];

End[]

