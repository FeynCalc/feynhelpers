(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDShared														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and pySecDec						*)

(* ------------------------------------------------------------------------ *)

Begin["`Package`"]

End[]

Begin["`PSDShared`Private`"]

FeynCalc`Package`psdToString[x_]:=
	StringReplace[ToString[x,InputForm], {"\"" -> "'", "*^" -> "*10^"}];

End[]

