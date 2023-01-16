(* ::Package:: *)

 


(* ::Section:: *)
(*KiraGetRS*)


(* ::Text:: *)
(*`KiraGetRS[{sec1, {gli1, ...}}]` returns the number of positive and negative propagator powers ($r$ and $s$ in the Kira/Reduze syntax) for the `GLI` integrals belonging to sector `sec1`. The input can be also a list of such entries.*)


(* ::Text:: *)
(*If the option `Max` is set to `True` (default), only the largest `{r,s}` combination made of the largest `r` and the largest `s` values in this sector will be returned. Otherwise, the function will return the `{r,s}`-pair for each `GLI`.*)


(* ::Text:: *)
(*`KiraGetRS` can directly handle the output of `FCLoopFindSectors`. Furthermore, the function can also deal with a simple list of `GLI`s as in `KiraGetRS[{gli1,gli2,...}]`.*)


(* ::Text:: *)
(*If the option `Top` is set to `True`, and the input is a list of the form `{{sec1, {gli11, ...}}, {sec2, {gli21, ...}}, ...}` then the output will consists of a list of top sectors and the largest possible `{r,s}` combination.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [KiraLabelSector](KiraLabelSector.md), [KiraCreateJobFile](KiraCreateJobFile.md).*)


KiraGetRS[{GLI[topo1,{1,1,1,1}],GLI[topo1,{2,1,2,1}],
GLI[topo2,{1,0,1,1}],GLI[topo3,{1,0,1,-1}]}]


KiraGetRS[{GLI[topo1,{1,1,1,1}],GLI[topo1,{2,1,2,1}],
GLI[topo2,{1,0,1,1}],GLI[topo3,{1,0,1,-1}]},Max->False]


out=FCLoopFindSectors[{GLI[topo1,{1,1,1,1}],GLI[topo1,{2,1,2,1}],
GLI[topo2,{1,0,1,1}],GLI[topo3,{1,0,1,-1}]}]


KiraGetRS[out]


KiraGetRS[out,Top->True]
