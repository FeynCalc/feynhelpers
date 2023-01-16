(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: KiraLabelSector														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2022-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Introduces KIRA labelling of sectors						*)

(* ------------------------------------------------------------------------ *)

KiraLabelSector::usage =
"KiraLabelSector[sec] returns the standard Kira labelling $S$ for the given
sector sec (e.g. {1,1,0,1,1}).";

KiraLabelSector::failmsg =
"Error! KiraLabelSector has encountered a fatal problem and must abort the computation. \n
The problem reads: `1`";

Begin["`Package`"]
End[]

Begin["`KiraLabelSector`Private`"];

klsVerbose::usage="";

KiraLabelSector[{}]:=
	{};

KiraLabelSector[ex:{{__Integer}..}] :=
	KiraLabelSector/@ex;

KiraLabelSector[{pows__Integer}] :=
	Total[MapIndexed[2^(First[#2] - 1) #1 &, {pows}]]/; MatchQ[{pows}, {(0 | 1) ..}];

End[]
