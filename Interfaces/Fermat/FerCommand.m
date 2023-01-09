(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FerCommand														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Templates for Fermat commands								*)

(* ------------------------------------------------------------------------ *)

FerCommand::usage =
"FerCommand[str, args] is an auxiliary function that returns a Fermat command
corresponding to str (possibly using arguments args) as a list of strings.

At the moment only a very limited set of Fermat instructions is implemented.";

Begin["`Package`"]

End[]

Begin["`FerCommand`Private`"]

FerCommand["Quit"]:=
	"&q;";

FerCommand["StopReadingFromTheInputFile"]:=
	"&x;";

FerCommand["EnableUglyDisplay"]:=
	"&(U=1);";

FerCommand["ReadFromAnInputFile", inputFile_String]:=
	"&(R='" <> inputFile <> "');";

FerCommand["SaveToAnOutputFile", outputFile_String]:=
	"&(S='"<> outputFile <>"');";

FerCommand["SaveSpecifiedVariablesToAnOutputFile", {vars__?AtomQ}]:=
	"!(&o, "<>StringReplace[ToString[{vars}], {"}" | "{" -> ""}]<>");";

FerCommand["ReducedRowEchelonForm", augMat_String]:=
	"Redrowech("<>augMat<>");";

FerCommand["AdjoinPolynomialVariable", var_?AtomQ]:=
	"&(J="<>ToString[var]<>");";


End[]

