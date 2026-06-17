(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: FIREReduceLoopIntegrals											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2026 Vladyslav Shtabovenko
*)

(* :Summary: 	Reduces GLIs using FIRE										*)

(* ------------------------------------------------------------------------ *)

FIREReduceLoopIntegrals::usage=
"FIREReduceLoopIntegrals[glis, topos, path] performs IBP reduction of loop
integral listed in glis from the families given in topos using C++ FIRE. It
returns reduction tables obtained from FIRE.

Since all processes are started from the current Mathematica notebook, it can
be reliably used only for simple integrals and topologies.";

FIREReduceLoopIntegrals::failmsg =
"Error! FIREReduceLoopIntegrals has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`FIREReduceLoopIntegrals`Private`"]

Options[FIREReduceLoopIntegrals] = {
	Check						-> True,
	CreateArchive				-> False,
	DateString					-> False,
	FCReplaceD					-> {d -> D},
	FCVerbose					-> False,
	FIREAutoDetectRestrictions	-> True,
	FIREBinaryPath 				:> FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE7", "bin", "FIRE7"}],
	FIREBucket 					-> 29,
	FIRECalc 					-> "flint",
	FIRECompressor 				-> "zstd",
	FIREDatabase 				-> Default,
	FIREFthreads 				:> 2*$ProcessorCount,
	FIREIntegrals 				-> "LoopIntegrals.m",
	FIRELI 						-> True,
	FIRELthreads 				-> 4,
	FIREMathematicaKernelPath	-> Automatic,
	FIREOutput					-> Default,
	FIREParallel				:> Ceiling[$ProcessorCount/2],
	FIREPath					:> FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE7", "FIRE7.m"}],
	FIREPosPref					-> Default,
	FIREProblemId				-> 4242,
	FIREShowOutput				-> False,
	FIRESthreads				:> $ProcessorCount,
	FIREThreads					:> $ProcessorCount,
	FIREUseLiteRed				-> True,
	FeynCalcInternal			-> False,
	FinalSubstitutions			-> {},
	Flatten						-> True,
	Head						-> Identity,
	OverwriteTarget				-> True,
	ProgressIndicator			-> True,
	SetDimensions				-> {3, 4, D, -1 + D},
	StringReplace				-> {},
	ToExpression				-> True,
	Variables					-> Automatic
};

FIREReduceLoopIntegrals[glis_List, {(*mappings*)_List, topos: {__FCTopology}}, dir_String, opts:OptionsPattern[]] :=
	FIREReduceLoopIntegrals[glis, topos, dir, opts];

FIREReduceLoopIntegrals[glis_List, topos:{__FCTopology}, dir_String, opts:OptionsPattern[]] :=
	Block[{	res, optVerbose},

		If[	OptionValue[FCVerbose]===False,
			optVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				optVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1,"FIREReduceLoopIntegrals: Entering.", FCDoControl->optVerbose];


		FCPrint[1,"FIREReduceLoopIntegrals: Calling FIREPrepareStartFile", FCDoControl->optVerbose];
		FIREPrepareStartFile[topos,dir,opts];
		FCPrint[1,"FIREReduceLoopIntegrals: FIREPrepareStartFile done.", FCDoControl->optVerbose];

		FCPrint[1,"FIREReduceLoopIntegrals: Calling FIRECreateConfigFile.", FCDoControl->optVerbose];
		FIRECreateConfigFile[topos,dir,opts];
		FCPrint[1,"FIREReduceLoopIntegrals: FIRECreateConfigFile done.", FCDoControl->optVerbose];

		FCPrint[1,"FIREReduceLoopIntegrals: Calling FIRECreateIntegralFile.", FCDoControl->optVerbose];
		FIRECreateIntegralFile[glis,topos,dir,opts];
		FCPrint[1,"FIREReduceLoopIntegrals: FIRECreateIntegralFile done.", FCDoControl->optVerbose];



		If[	OptionValue[FIREUseLiteRed],
			FCPrint[1,"FIREReduceLoopIntegrals: Calling FIRECreateLiteRedFiles.", FCDoControl->optVerbose];
			FIRECreateLiteRedFiles[dir,topos,opts];
			FCPrint[1,"FIREReduceLoopIntegrals: FIRECreateLiteRedFiles done.", FCDoControl->optVerbose];
		];

		FCPrint[1,"FIREReduceLoopIntegrals: Calling FIRECreateStartFiles.", FCDoControl->optVerbose];
		FIRECreateStartFile[dir,topos,opts];
		FCPrint[1,"FIREReduceLoopIntegrals: FIRECreateStartFiles done.", FCDoControl->optVerbose];


		FCPrint[1,"FIREReduceLoopIntegrals: Calling FIRERunReduction.", FCDoControl->optVerbose];
		FIRERunReduction[dir,topos,opts];
		FCPrint[1,"FIREReduceLoopIntegrals: FIRERunReduction done.", FCDoControl->optVerbose];

		FCPrint[1,"FIREReduceLoopIntegrals: Calling FIREImportResults.", FCDoControl->optVerbose];
		res = FIREImportResults[topos,dir,opts];
		FCPrint[1,"FIREReduceLoopIntegrals: FIREImportResults done.", FCDoControl->optVerbose];

		If[	OptionValue[Flatten],
			res = Flatten[res]
		];

		res


	];

End[]
