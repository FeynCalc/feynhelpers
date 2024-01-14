(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: SpinorsAtMathematica												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and S@M							*)

(* ------------------------------------------------------------------------ *)

SaMLoadPackage::usage =
"SaMLoadPackage loads S@M such, that it can be used together with FeynCalc
in the same Mathematica session. S@M objects that conflict with FeynCalc's
function are renamed according to the option SaMRename."

SaMPath::usage=
"SaMPath is an option for SaMLoadPackage. It specifies the \
directory, in which S@M is installed";

SaMRename::usage=
"SaMPath is an option for SaMLoadPackage. It specifies, how some S@M
objects show be renamed. This is necessary to avoid shadowing issues when S@M
is used together with FeynCalc."

Begin["`Package`"]

End[]

Begin["`SaM`Private`"]


samLoaded = False;

Options[SaMLoadPackage] = {

	SaMPath -> FileNameJoin[{$UserBaseDirectory, "Applications", "Spinors"}],
	SaMRename -> {
		"Schouten" -> "samSchouten",
		"Gamma0" -> "samGamma0",
		"Gamma1" -> "samGamma1",
		"Gamma2" -> "samGamma2",
		"Gamma3" -> "samGamma3",
		"Gamma5" -> "samGamma5"
	},
	Quiet -> False,
	FCVerbose -> False
}

SaMLoadPackage[OptionsPattern[]]:=
	Block[{originalCode,patchedCode,repList},
		If[	!samLoaded,

			Spinors`$SpinorsPath = OptionValue[SaMPath];
			originalCode = Import[FileNameJoin[{OptionValue[SaMPath], "spinors_impl.m"}], "Text"];

			repList = Map[{
				Rule[RegularExpression["\\b" <> First[#] <> "\\b"], Last[#]],
				Rule[RegularExpression["\\_" <> First[#] <> "\\b"], "_" <> Last[#]],
				Rule[RegularExpression[First[#] <> "\\_\\b"], Last[#] <> "_"]} &, OptionValue[SaMRename]] // Flatten;

			patchedCode = StringReplace[originalCode, repList, MetaCharacters -> Automatic];

			ToExpression[patchedCode];
			samLoaded=True;

			FCPrint[0,"FeynHelpers: S@M loaded."],
			FCPrint[0,"FeynHelpers: Nothing to do: S@M is already loaded."]
		];
	];



End[]

