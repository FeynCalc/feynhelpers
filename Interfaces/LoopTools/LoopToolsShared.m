(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: LoopToolsShared													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and LoopTools					*)

(* ------------------------------------------------------------------------ *)

$LTools::usage =
"$LTools denotes the LinkObject of the LoopTools MathLink executable."

LToolsLoadLibrary::usage=
"LToolsLoadLibrary[] loads the LoopTools library so that it can be used with
FeynCalc. This command must be executed once before using any of the LTools*
functions.";

LToolsUnLoadLibrary::usage=
"LToolsUnLoadLibrary[] is the inverse of LToolsLoadLibrary[], i.e. it unloads
the LoopTools library.";

LToolsPath::usage=
"LToolsPath is an option for LToolsLoadLibrary. It specifies the full path, to
the LoopTools MathLink executable.

The default value is FileNameJoin[{$FeynHelpersDirectory, \"ExternalTools\",
\"LoopTools\", \"LoopTools\"}].";

Begin["`Package`"]

ltLoaded;

End[]

Begin["`LoopTools`Private`"]

$LTools = Null;
ltLoaded = False;

Options[LToolsLoadLibrary] = {
	LToolsPath 			-> FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "LoopTools", "LoopTools"}],
	TimeConstrained 	-> 5,
	Quiet 				-> True
};

LToolsLoadLibrary[OptionsPattern[]]:=
	Block[{quiet, optLToolsPath},
		If[	!ltLoaded,

			If[OptionValue[Quiet],
				quiet = Quiet
			];

			optLToolsPath = OptionValue[LToolsPath];

			If[	!FileExistsQ[optLToolsPath],
				Message[LToolsLoadLibrary::nobinary];
				Abort[]
			];


			quiet[
			Block[{$ContextPath},
				TimeConstrained[
					BeginPackage["LoopTools`"];
					(* 	If we don't get an answer after X secs, then most likely it is because the MathLink
						executable is not suitable and Install got frozen.*)
					$LTools = Install[optLToolsPath];
					EndPackage[],
					OptionValue[TimeConstrained]
				];


			],{General::shdw}];
			If[	Head[$LTools]=!=LinkObject,
				Message[LToolsLoadLibrary::nobinary];
				Abort[]
			];

			FeynCalc`Package`ltLoaded=True;
			FCPrint[0,"LoopTools library loaded."],
			FCPrint[0,"Nothing to do: LoopTools library is already loaded."]
		];
	];

LToolsUnLoadLibrary[]:=
	Block[{},
		If[FeynCalc`Package`ltLoaded,
			Uninstall[$LTools];
			FeynCalc`Package`ltLoaded=False,
			FCPrint[0,"Nothing to do: LoopTools library is currently not loaded."];
		];
	];


End[]

