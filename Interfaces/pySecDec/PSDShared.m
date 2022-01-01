(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDShared														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and pySecDec						*)

(* ------------------------------------------------------------------------ *)

Begin["`Package`"]

End[]

Begin["`PSDShared`Private`"]

FeynCalc`Package`psdToString[x_]:=
	StringReplace[ToString[x,InputForm], {"\"" -> "'"}];


End[]

