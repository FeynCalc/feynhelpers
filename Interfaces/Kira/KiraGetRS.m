(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: KiraGetRS														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2022-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Gets the r and s identifiers of GLIs						*)

(* ------------------------------------------------------------------------ *)

KiraGetRS::usage =
"KiraGetRS[{sec1, {gli1, ...}}] returns the number of positive and negative
propagator powers ($r$ and $s$ in the Kira/Reduze syntax) for the GLI
integrals belonging to sector sec1. The input can be also a list of such
entries.

If the option Max is set to True (default), only the largest {r,s} combination
made of the largest r and the largest s values in this sector will be
returned. Otherwise, the function will return the {r,s}-pair for each GLI.

KiraGetRS can directly handle the output of FCLoopFindSectors. Furthermore,
the function can also deal with a simple list of GLIs as in
KiraGetRS[{gli1,gli2,...}].

If the option Top is set to True, and the input is a list of the form {{sec1,
{gli11, ...}}, {sec2, {gli21, ...}}, ...} then the output will consists of a
list of top sectors and the largest possible {r,s} combination.";

KiraGetRS::failmsg = "Error! KiraGetRS has encountered a fatal problem and must abort the computation. \n
The problem reads: `1`";

Begin["`Package`"]
End[]

Begin["`KiraGetRS`Private`"];

kgrsVerbose::usage="";



Options[KiraGetRS] = {
	FCVerbose -> False,
	Max -> True,
	Top -> False
};

(*Standard output of FCLoopFindSectors*)
KiraGetRS[{ex: {{{__?IntegerQ}, {__GLI}} ..}, {{__?IntegerQ} ..}}, opts:OptionsPattern[]] :=
	KiraGetRS[ex, opts];

(*Just the first element from the standard output of FCLoopFindSectors*)
KiraGetRS[ex: {{{__?IntegerQ}, {__GLI}}..}, opts:OptionsPattern[]] :=
	Block[{res,topSectors},
		res = Map[KiraGetRS[#, opts]&,ex];

		If[OptionValue[Top],
			res = {First /@ Last[GatherBy[res, Count[First[#], 0] &]], Max /@ Transpose[Transpose[res][[2]]]}
		];
		res
	];

(*Only a single sector*)
KiraGetRS[{sec: {__?IntegerQ}, (glis : {__GLI})}, opts:OptionsPattern[]] :=
	{sec, KiraGetRS[glis, opts]};

KiraGetRS[(glis : {__GLI}), OptionsPattern[]] :=
	Block[{	rsList},

		If [OptionValue[FCVerbose]===False,
				kgrsVerbose=$VeryVerbose,
				If[MatchQ[OptionValue[FCVerbose], _Integer],
					kgrsVerbose=OptionValue[FCVerbose]
				];
		];

		FCPrint[1,"KiraGetRS: Entering.", FCDoControl->kgrsVerbose];
		FCPrint[3,"KiraGetRS: Entering with: ", glis, FCDoControl->kgrsVerbose];

		rsList = Union[Map[(# /. GLI -> getRS)&, glis]];

		If[	OptionValue[Max],
			rsList = Max/@Transpose[rsList]
		];

		FCPrint[1,"KiraGetRS: Leaving.", FCDoControl->kgrsVerbose];

		rsList
	];

(*Safe for memoization, since we only count powers here*)
getRS[id_, li_List] :=
	MemSet[getRS[id, li],
		{Total[Select[li, Positive]], -Total[Select[li, NonPositive]]}
	];

End[]
