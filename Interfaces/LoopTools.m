(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: LoopTools														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2018 Vladyslav Shtabovenko
*)

(* :Summary: 	Interface between FeynCalc and LoopTools					*)

(* ------------------------------------------------------------------------ *)

$LTools::usage =
"$LTools denotes the LinkObject of the LoopTools MathLink executable."

LToolsLoadLibrary::usage=
"LToolsLoadLibrary[] loads the LoopTools library so that it can be
used with FeynCalc. This command must be executed once before using any
of the LoopTools functions";

LToolsUnLoadLibrary::usage=
"LToolsUnLoadLibrary[] is the inverse of LToolsLoadLibrary[], i.e. it
unloads the LoopTools library.";

LToolsEvaluate::usage=
"LToolsEvaluate[expr,q] evaluates \
Passarino-Veltman functions in expr nuimerically. The evaluation is using \
T. Hahn's LoopTools.";

LToolsImplicitPrefactor::usage=
"LToolsImplicitPrefactor is an option for LToolsEvaluate. It specifies a prefactor \
that doesn't show up explicitly in the input expression, but is understood \
to appear in fron of every Passarino-Veltman function. LToolsEvaluate does not
expand the result in Epsilon..";

LToolsPath::usage=
"LToolsPath is an option for LToolsLoadLibrary. It specifies the \
full path, to the LoopTools MathLink executable.";

LToolsFullResult::usage=
"LToolsFullResult is an option for LToolsEvaluate, LToolsEvaluateUV,
LToolsEvaluateIR and LToolsEvaluateUVIRSplit. When set to True (default),
LToolsEvaluate* functions will return the full result including
singularities and accompanying terms. Otherwise, only the finite part
(standard output of LoopTools) will be provided.";

LToolsA0i::usage=
"LToolsA0i corresponds to the A0i function in LoopTools. The only \
difference is that the id should be entered as a string, e.g. \"a0\" \
instead of a0.\n
See ?LoopTools`A0i for more details about the LoopTools function.";

LToolsB0i::usage=
"LToolsB0i corresponds to the B0i function in LoopTools. The only \
difference is that the id should be entered as a string, e.g. \"b0\" \
instead of b0.\n
See ?LoopTools`B0i for more details about the LoopTools function.";

LToolsC0i::usage=
"LToolsC0i corresponds to the C0i function in LoopTools. The only \
difference is that the id should be entered as a string, e.g. \"c0\" \
instead of c0.\n
See ?LoopTools`C0i for more details about the LoopTools function.";

LToolsD0i::usage=
"LToolsD0i corresponds to the D0i function in LoopTools. The only \
difference is that the id should be entered as a string, e.g. \"d0\" \
instead of d0.\n
See ?LoopTools`D0i for more details about the LoopTools function.";

LToolsE0i::usage=
"LToolsE0i corresponds to the E0i function in LoopTools. The only \
difference is that the id should be entered as a string, e.g. \"e0\" \
instead of e0.\n
See ?LoopTools`E0i for more details about the LoopTools function.";

LToolsPaVe::usage=
"LToolsPaVe corresponds to the PaVe function in LoopTools.\n
See ?LoopTools`PaVe for more details about the LoopTools function.";

LToolsLi2::usage=
"LToolsLi2 corresponds to the Li2 function in LoopTools.\n
See ?LoopTools`Li2 for more details about the LoopTools function.";

LToolsLi2omx::usage=
"LToolsLi2omx corresponds to the Li2omx function in LoopTools.\n
See ?LoopTools`Li2omx for more details about the LoopTools function.";

LToolsSetMudim::usage=
"LToolsSetMudim corresponds to the SetMudim function in LoopTools.\n
See ?LoopTools`SetMudim for more details about the LoopTools function.";

LToolsGetMudim::usage=
"LToolsGetMudim corresponds to the GetMudim function in LoopTools.\n
See ?LoopTools`GetMudim for more details about the LoopTools function.";

LToolsSetDelta::usage=
"LToolsSetDelta corresponds to the SetDelta function in LoopTools.\n
See ?LoopTools`SetDelta for more details about the LoopTools function.";

LToolsGetDelta::usage=
"LToolsGetDelta corresponds to the GetDelta function in LoopTools.\n
See ?LoopTools`GetDelta for more details about the LoopTools function.";

LToolsSetUVDiv::usage=
"LToolsSetUVDiv corresponds to the SetUVDiv function in LoopTools.\n
See ?LoopTools`SetUVDiv for more details about the LoopTools function.";

LToolsGetUVDiv::usage=
"LToolsGetUVDiv corresponds to the GetUVDiv function in LoopTools.\n
See ?LoopTools`GetUVDiv for more details about the LoopTools function.";

LToolsSetLambda::usage=
"LToolsSetLambda corresponds to the SetLambda function in LoopTools.\n
See ?LoopTools`SetLambda for more details about the LoopTools function.";

LToolsGetLambda::usage=
"LToolsGetLambda corresponds to the GetLambda function in LoopTools.\n
See ?LoopTools`GetLambda for more details about the LoopTools function.";

LToolsSetMinMass::usage=
"LToolsSetMinMass corresponds to the SetMinMass function in LoopTools.\n
See ?LoopTools`SetMinMass for more details about the LoopTools function.";

LToolsGetMinMass::usage=
"LToolsGetMinMass corresponds to the GetMinMass function in LoopTools.\n
See ?LoopTools`GetMinMass for more details about the LoopTools function.";

LToolsClearCache::usage=
"LToolsClearCache corresponds to the ClearCache function in LoopTools.\n
See ?LoopTools`ClearCache for more details about the LoopTools function.";

LToolsMarkCache::usage=
"LToolsMarkCache corresponds to the MarkCache function in LoopTools.\n
See ?LoopTools`MarkCache for more details about the LoopTools function.";

LToolsRestoreCache::usage=
"LToolsRestoreCache corresponds to the RestoreCache function in LoopTools.\n
See ?LoopTools`RestoreCache for more details about the LoopTools function.";

LToolsSetMaxDev::usage=
"LToolsSetMaxDev corresponds to the SetMaxDev function in LoopTools.\n
See ?LoopTools`SetMaxDev for more details about the LoopTools function.";

LToolsGetMaxDev::usage=
"LToolsGetMaxDev corresponds to the GetMaxDev function in LoopTools.\n
See ?LoopTools`GetMaxDev for more details about the LoopTools function.";

LToolsSetWarnDigits::usage=
"LToolsSetWarnDigits corresponds to the SetWarnDigits function in LoopTools.\n
See ?LoopTools`SetWarnDigits for more details about the LoopTools function.";

LToolsGetWarnDigits::usage=
"LToolsGetWarnDigits corresponds to the GetWarnDigits function in LoopTools.\n
See ?LoopTools`GetWarnDigits for more details about the LoopTools function.";

LToolsSetErrDigits::usage=
"LToolsSetErrDigits corresponds to the SetErrDigits function in LoopTools.\n
See ?LoopTools`SetErrDigits for more details about the LoopTools function.";

LToolsGetErrDigits::usage=
"LToolsGetErrDigits corresponds to the GetErrDigits function in LoopTools.\n
See ?LoopTools`GetErrDigits for more details about the LoopTools function.";

LToolsSetVersionKey::usage=
"LToolsSetVersionKey corresponds to the SetVersionKey function in LoopTools.\n
See ?LoopTools`SetVersionKey for more details about the LoopTools function.";

LToolsGetVersionKey::usage=
"LToolsGetVersionKey corresponds to the SetVersionKey function in LoopTools.\n
See ?LoopTools`GetVersionKey for more details about the LoopTools function.";

LToolsSetDebugKey::usage=
"LToolsSetDebugKey corresponds to the SetVersionKey function in LoopTools.\n
See ?LoopTools`SetDebugKey for more details about the LoopTools function.";

LToolsGetDebugKey::usage=
"LToolsGetDebugKey corresponds to the SetVersionKey function in LoopTools.\n
See ?LoopTools`GetDebugKey for more details about the LoopTools function.";

LToolsSetDebugRange::usage=
"LToolsSetDebugRange corresponds to the SetVersionKey function in LoopTools.\n
See ?LoopTools`SetDebugRange for more details about the LoopTools function.";

LToolsSetCmpBits::usage=
"LToolsSetCmpBits corresponds to the SetCmpBits function in LoopTools.\n
See ?LoopTools`SetCmpBits for more details about the LoopTools function.";

LToolsGetCmpBits::usage=
"LToolsGetCmpBits corresponds to the SetCmpBits function in LoopTools.\n
See ?LoopTools`GetCmpBits for more details about the LoopTools function.";

LToolsSetDiffEps::usage=
"LToolsSetDiffEps corresponds to the SetDiffEps function in LoopTools.\n
See ?LoopTools`SetDiffEps for more details about the LoopTools function.";

LToolsGetDiffEps::usage=
"LToolsGetDiffEps corresponds to the GetDiffEps function in LoopTools.\n
See ?LoopTools`GetDiffEps for more details about the LoopTools function.";

LToolsGetZeroEps::usage=
"LToolsGetZeroEps corresponds to the GetZeroEps function in LoopTools.\n
See ?LoopTools`GetZeroEps for more details about the LoopTools function.";

LToolsDRResult::usage=
"LToolsDRResult corresponds to the DRResult function in LoopTools.\n
See ?LoopTools`DRResult for more details about the LoopTools function.";

LToolsDR1eps::usage=
"LToolsDR1eps corresponds to the DRResult function in LoopTools.\n
See ?LoopTools`DR1eps for more details about the LoopTools function.";

LToolsA0::usage=
"LToolsA0 corresponds to the A0 function in LoopTools.";

LToolsA00::usage=
"LToolsA00 corresponds to the A00 function in LoopTools.";

LToolsB0::usage=
"LToolsB0 corresponds to the B0 function in LoopTools.";

LToolsB1::usage=
"LToolsB1 corresponds to the B1 function in LoopTools.";

LToolsB00::usage=
"LToolsB00 corresponds to the B00 function in LoopTools.";

LToolsB11::usage=
"LToolsB11 corresponds to the B11 function in LoopTools.";

LToolsB001::usage=
"LToolsB001 corresponds to the B001 function in LoopTools.";

LToolsB111::usage=
"LToolsB111 corresponds to the B111 function in LoopTools.";

LToolsDB0::usage=
"LToolsDB0 corresponds to the DB0 function in LoopTools.";

LToolsDB1::usage=
"LToolsDB1 corresponds to the DB1 function in LoopTools.";

LToolsDB00::usage=
"LToolsDB00 corresponds to the DB00 function in LoopTools.";

LToolsDB11::usage=
"LToolsDB11 corresponds to the DB11 function in LoopTools.";

LToolsC0::usage=
"LToolsC0 corresponds to the C0 function in LoopTools.";

LToolsD0::usage=
"LToolsD0 corresponds to the D0 function in LoopTools.";

LToolsE0::usage=
"LToolsE0 corresponds to the E0 function in LoopTools.";

LToolsKeyA0::usage=
"LToolsKeyA0 corresponds to KeyA0 in LoopTools.";

LToolsKeyBget::usage=
"LToolsKeyBget corresponds to KeyBget in LoopTools.";

LToolsKeyC0::usage=
"LToolsKeyC0 corresponds to KeyC0 in LoopTools.";

LToolsKeyD0::usage=
"LToolsKeyD0 corresponds to KeyD0 in LoopTools.";

LToolsKeyE0::usage=
"LToolsKeyE0 corresponds to KeyE0 in LoopTools.";

LToolsKeyEget::usage=
"LToolsKeyEget corresponds to KeyEget in LoopTools.";

LToolsKeyCEget::usage=
"LToolsKeyCEget corresponds to KeyCEget in LoopTools.";

LToolsKeyAll::usage=
"LToolsKeyAll corresponds to KeyAll in LoopTools.";

LToolsDebugA::usage=
"LToolsDebugA corresponds to DebugA in LoopTools.";

LToolsDebugB::usage=
"LToolsDebugB corresponds to DebugB in LoopTools.";

LToolsDebugC::usage=
"LToolsDebugC corresponds to DebugC in LoopTools.";

LToolsDebugD::usage=
"LToolsDebugD corresponds to DebugD in LoopTools.";

LToolsDebugE::usage=
"LToolsDebugE corresponds to DebugE in LoopTools.";

LToolsDebugAll::usage=
"LToolsDebugAll corresponds to DebugAll in LoopTools.";

LTools::failmsg=
"Interface to LoopTools has encountered an error and must abort the evaluation. The \
error description reads: `1`";

LTools::pavefail=
"Warning! LoopTools failed to evaluate the following PaVe function: `1`";

LTools::tens=
"Warning! Your input contains tensor loop integrals. Those integrals \
will be ignored, because LoopTools operates only on 1-loop scalar integrals.";

Begin["`Package`"]

End[]

Begin["`LoopTools`Private`"]

$LTools = Null;
ltLoaded = False;
ltPath = "";
ltVerbose::usage="";
dummyLoopMom::usage="";
failed::usage="";

Options[LToolsLoadLibrary] = {
	TimeConstrained -> 5,
	Quiet -> True,
	LToolsPath ->
	FileNameJoin[{$UserBaseDirectory, "Applications", "LoopTools",
		Switch[$System,
			"Linux x86 (64-bit)",
				"x86_64-Linux",
			"Linux x86 (32-bit)",
				"i686-Linux",
			_,
				"UnknownSystem"], "bin", "LoopTools"}]
	}

Options[LToolsEvaluate] = {
	LToolsFullResult 		-> True,
	LToolsImplicitPrefactor -> 1,
	LToolsSetMudim 			-> 1.,
	LToolsSetLambda 		-> 0,
	LToolsSetDelta 			-> -EulerGamma- Log[Pi],
	PaVeAutoOrder 			-> True,
	FCVerbose 				-> False,
	InitialSubstitutions	-> {}
}

idList = {
	"aa0", "aa00", "bb0", "bb1", "bb00", "bb11", "bb001", "bb111",
	"dbb0", "dbb1", "dbb00", "dbb11", "dbb001", "cc0", "cc1", "cc2",
	"cc00", "cc11", "cc12", "cc22", "cc001", "cc002", "cc111", "cc112",
	"cc122", "cc222", "cc0000", "cc0011", "cc0012", "cc0022", "cc1111",
	"cc1112", "cc1122", "cc1222", "cc2222", "dd0", "dd1", "dd2", "dd3",
	"dd00", "dd11", "dd12", "dd13", "dd22", "dd23", "dd33", "dd001",
	"dd002", "dd003", "dd111", "dd112", "dd113", "dd122", "dd123",
	"dd133", "dd222", "dd223", "dd233", "dd333", "dd0000", "dd0011",
	"dd0012", "dd0013", "dd0022", "dd0023", "dd0033", "dd1111", "dd1112",
	"dd1113", "dd1122", "dd1123", "dd1133", "dd1222", "dd1223", "dd1233",
	"dd1333", "dd2222", "dd2223", "dd2233", "dd2333", "dd3333",
	"dd00001", "dd00002", "dd00003", "dd00111", "dd00112", "dd00113",
	"dd00122", "dd00123", "dd00133", "dd00222", "dd00223", "dd00233",
	"dd00333", "dd11111", "dd11112", "dd11113", "dd11122", "dd11123",
	"dd11133", "dd11222", "dd11223", "dd11233", "dd11333", "dd12222",
	"dd12223", "dd12233", "dd12333", "dd13333", "dd22222", "dd22223",
	"dd22233", "dd22333", "dd23333", "dd33333", "ee0", "ee1", "ee2",
	"ee3", "ee4", "ee00", "ee11", "ee12", "ee13", "ee14", "ee22", "ee23",
	"ee24", "ee33", "ee34", "ee44", "ee001", "ee002", "ee003", "ee004",
	"ee111", "ee112", "ee113", "ee114", "ee122", "ee123", "ee124",
	"ee133", "ee134", "ee144", "ee222", "ee223", "ee224", "ee233",
	"ee234", "ee244", "ee333", "ee334", "ee344", "ee444", "ee0000",
	"ee0011", "ee0012", "ee0013", "ee0014", "ee0022", "ee0023", "ee0024",
	"ee0033", "ee0034", "ee0044", "ee1111", "ee1112", "ee1113", "ee1114",
	"ee1122", "ee1123", "ee1124", "ee1133", "ee1134", "ee1144", "ee1222",
	"ee1223", "ee1224", "ee1233", "ee1234", "ee1244", "ee1333", "ee1334",
	"ee1344", "ee1444", "ee2222", "ee2223", "ee2224", "ee2233", "ee2234",
	"ee2244", "ee2333", "ee2334", "ee2344", "ee2444", "ee3333", "ee3334",
	"ee3344", "ee3444", "ee4444"
};

LToolsLoadLibrary[OptionsPattern[]]:=
	Block[{quiet, optLToolsPath},
		If[	!ltLoaded,

			If[OptionValue[Quiet],
				quiet = Quiet
			];

			optLToolsPath = OptionValue[LToolsPath];

			If[	!FileExistsQ[optLToolsPath],
				Message[LTools::failmsg,"Incorrect path to the LoopTools MathLink executable."];
				Abort[]
			];


			quiet[
			Block[{$ContextPath},
				TimeConstrained[
					BeginPackage["LoopTools`"];
					(* 	If we don't get an answer after X secs, then most likely it is because the MathLink
						executable is not suitable ans Install got frozen.*)
					$LTools = Install[optLToolsPath];
					EndPackage[],
					OptionValue[TimeConstrained]
				];


			],{General::shdw}];
			If[	Head[$LTools]=!=LinkObject,
				Message[LTools::failmsg,"Failed to load the LoopTools MathLink executable."];
				Abort[]
			];

			ltLoaded=True;
			FCPrint[0,"LoopTools library loaded."],
			FCPrint[0,"Nothing to do: LoopTools library is already loaded."]
		];
	];





LToolsUnLoadLibrary[]:=
	Block[{},
		If[ltLoaded,
			Uninstall[$LTools];
			ltLoaded=False,
			FCPrint[0,"Nothing to do: LoopTools library is currently not loaded."];
		];
	];


LToolsEvaluate[expr_, opts:OptionsPattern[]]:=
	LToolsEvaluate[expr, dummyLoopMom, opts];

LToolsEvaluate[expr_, q:Except[_?OptionQ], OptionsPattern[]]:=
	Block[	{ex, fclsOutput, loopIntegral, ints, fcleOutput,
			resultLT,resEps2,resEps1,resFinitePart,
			lambda, mudim, delta, repRule, res, optLToolsImplicitPrefactor,
			optInitialSubstitutions},

		If [OptionValue[FCVerbose]===False,
			ltVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer],
				ltVerbose=OptionValue[FCVerbose]
			];
		];

		optLToolsImplicitPrefactor	= OptionValue[LToolsImplicitPrefactor];
		optInitialSubstitutions 	= OptionValue[InitialSubstitutions];

		If[!ltLoaded,
			LToolsLoadLibrary[];
			ltLoaded=True
		];

		FCPrint[3,"LToolsEvaluate: Entering with: ", expr, FCDoControl->ltVerbose];

		(*	First of all, let us convert all the scalar integrals to PaVe functions:	*)
		ex = ToPaVe[expr,q,PaVeAutoReduce->False, PaVeAutoOrder -> OptionValue[PaVeAutoOrder]]//ToPaVe2;

		FCPrint[1,"LToolsEvaluate: Applying FCLoopSplit.", FCDoControl->ltVerbose];
		fclsOutput  = FCLoopSplit[ex,{q}];
		FCPrint[3,"LToolsEvaluate: After FCLoopSplit: ", fclsOutput, FCDoControl->ltVerbose];

		If [fclsOutput[[3]]=!=0 || fclsOutput[[4]]=!=0,
			Message[LTools::tens]
		];

		FCPrint[1,"LToolsEvaluate: Applying FCLoopExtract.", FCDoControl-> ltVerbose];
		fcleOutput=FCLoopExtract[fclsOutput[[2]], {q}, loopIntegral, FCI->True];
		FCPrint[3,"LToolsEvaluate: After FCLoopExtract: ", fcleOutput, FCDoControl-> ltVerbose];

		(*	The 3rd element in fcleOutput is our list of unique scalar integrals that
			need to be computed. *)
		ints = fcleOutput[[3]] /. Dispatch[optInitialSubstitutions];

		FCPrint[3,"LToolsEvaluate: Unique integrals with numerical parameters: ", ints, FCDoControl-> ltVerbose];

		If[	!MatchQ[(ints/.loopIntegral->Identity), {__PaVe}],
			Message[LTools::failmsg,"List of unique scalar integrals contains integrals that are not written as PaVe functions."];
			FCPrint[1,"LToolsEvaluate: ints: ", (ints/.loopIntegral->Identity), " ", FCDoControl-> ltVerbose];
			Abort[];
		];


		If[	!MatchQ[(ints/.loopIntegral->Identity), {PaVe[__?NumberQ, {___?NumberQ}, {__?NumberQ}, OptionsPattern[]] ..}],
			Message[LTools::failmsg,"Arguments of PaVe functions are not purely numerical."];
			FCPrint[1,"LToolsEvaluate: ints: ", (ints/.loopIntegral->Identity), " ", FCDoControl-> ltVerbose];
			Abort[];
		];


		lambda = LToolsGetLambda[];
		mudim = LToolsGetMudim[];
		delta = LToolsGetDelta[];

		LToolsSetMudim[OptionValue[LToolsSetMudim]];
		LToolsSetDelta[OptionValue[LToolsSetDelta]];
		If[	OptionValue[LToolsFullResult],
			FCPrint[1,"LToolsEvaluate: Calculating full result.", FCDoControl->ltVerbose];

			LToolsSetLambda[-2];
			resEps2 = ints /. loopIntegral->Identity /. PaVe -> LToolsPaVe;
			FCPrint[3,"LToolsEvaluate: 1/Epsilon^2 term: ", resEps2, " ", FCDoControl->ltVerbose];

			LToolsSetLambda[-1];
			resEps1 = ints /. loopIntegral->Identity /. PaVe -> LToolsPaVe;
			FCPrint[3,"LToolsEvaluate: 1/Epsilon term: ", resEps1, " ", FCDoControl->ltVerbose];

			LToolsSetLambda[OptionValue[LToolsSetLambda]];
			resFinitePart = ints /.loopIntegral->Identity /. PaVe -> LToolsPaVe;
			FCPrint[3,"LToolsEvaluate: finite part: ", resFinitePart, " ", FCDoControl->ltVerbose];

			resultLT = optLToolsImplicitPrefactor*((resEps2/. failed[_] -> 0)/Epsilon^2 + (resEps1/. failed[_] -> 0)/Epsilon + resFinitePart),


			FCPrint[1,"LToolsEvaluate: Calculating only the finite part.", FCDoControl->ltVerbose];
			LToolsSetLambda[OptionValue[LToolsSetLambda]];
			resultLT = optLToolsImplicitPrefactor * (ints /.loopIntegral->Identity /. PaVe -> LToolsPaVe);
			FCPrint[3,"LToolsEvaluate: resultLT: ", FCDoControl->ltVerbose]
		];

		LToolsSetLambda[lambda];
		LToolsSetMudim[mudim];
		LToolsSetDelta[delta];

		FCPrint[3,"LToolsEvaluate: resultLT: ", FCDoControl->ltVerbose];

		repRule = MapThread[Rule[#1,#2]&,{fcleOutput[[3]],resultLT}];

		res = fcleOutput[[1]] + (fcleOutput[[2]]/. Dispatch[repRule]);

		res

	];


LToolsA0i[id_String, m_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`A0i[idVal,m]
	]/; ltLoaded;

LToolsB0i[id_String, p_, m1_, m2_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`B0i[idVal, p, m1, m2]
	]/; ltLoaded;

LToolsC0i[id_String, p1_, p2_, p1p2_, m1_, m2_, m3_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`C0i[idVal, p1, p2, p1p2, m1, m2, m3]
	]/; ltLoaded;

LToolsD0i[id_String, p1_, p2_, p3_, p4_, p1p2_, p2p3_, m1_, m2_, m3_, m4_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`D0i[idVal, p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4]
	]/; ltLoaded;

LToolsE0i[id_String, p1_, p2_, p3_, p4_, p5_, p1p2_, p2p3_, p3p4_, p4p5_, p5p1_, m1_, m2_, m3_, m4_, m5_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`E0i[idVal, p1, p2, p3, p4, p5, p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3, m4, m5]
	]/; ltLoaded;


LToolsPaVe[i__Integer, {p___}, {m__}, OptionsPattern[]]:=
	Block[{res},
		(*  LoopTools`PaVe[i,{p},{m}]] won't work, as the id (e.g. bb0) will end up in the global context. So we
			essentially duplicate the original LoopTools function here *)
		res = (ToExpression["LoopTools`" <> #1 <> "0i"][ToExpression["LoopTools`" <> #2 <> #2 <> ToString /@ Sort[{i}]],
			p, m] &)[FromCharacterCode[Length[{m}] + 64], FromCharacterCode[Length[{m}] + 96]];
		If[	res===Indeterminate,
			Message[LTools::pavefail,ToString[PaVe[i,{p},{m}],InputForm]];
			res = failed[PaVe[i,{p},{m},PaVeAutoReduce->False]]
		];
		res

	]/; ltLoaded;

LToolsLi2[x_]:=
	LoopTools`Li2[x]/; ltLoaded;


LToolsLi2omx[x_]:=
	LoopTools`Li2omx[x]/; ltLoaded;

LToolsSetMudim[x_]:=
	LoopTools`SetMudim[x]/; ltLoaded;

LToolsGetMudim[]:=
	LoopTools`GetMudim[]/; ltLoaded;

LToolsSetDelta[x_]:=
	LoopTools`SetDelta[x]/; ltLoaded;

LToolsGetDelta[]:=
	LoopTools`GetDelta[]/; ltLoaded;

LToolsSetUVDiv[x_]:=
	LoopTools`SetUVDiv[x]/; ltLoaded;

LToolsGetUVDiv[]:=
	LoopTools`GetUVDiv[]/; ltLoaded;

LToolsSetLambda[x_]:=
		LoopTools`SetLambda[x]/; ltLoaded;

LToolsGetLambda[]:=
	LoopTools`GetLambda[]/; ltLoaded;

LToolsSetMinMass[x_]:=
	LoopTools`SetMinMass[x]/; ltLoaded;

LToolsGetMinMass[]:=
	LoopTools`GetMinMass[]/; ltLoaded;

LToolsClearCache[]:=
	LoopTools`ClearCache[]/; ltLoaded;

LToolsMarkCache[]:=
	LoopTools`MarkCache[]/; ltLoaded;

LToolsRestoreCache[]:=
	LoopTools`RestoreCache[]/; ltLoaded;

LToolsSetMaxDev[x_]:=
	LoopTools`SetMaxDev[x]/; ltLoaded;

LToolsGetMaxDev[]:=
	LoopTools`GetMaxDev[]/; ltLoaded;

LToolsSetWarnDigits[x_]:=
	LoopTools`SetWarnDigits[x]/; ltLoaded;

LToolsGetWarnDigits[]:=
	LoopTools`GetWarnDigits[]/; ltLoaded;

LToolsSetErrDigits[x_]:=
	LoopTools`SetErrDigits[x]/; ltLoaded;

LToolsGetErrDigits[]:=
	LoopTools`GetErrDigits[]/; ltLoaded;

LToolsSetVersionKey[x_]:=
	LoopTools`SetVersionKey[x]/; ltLoaded;

LToolsGetVersionKey[]:=
	LoopTools`GetVersionKey[]/; ltLoaded;

LToolsSetDebugKey[x_]:=
	LoopTools`SetDebugKey[x]/; ltLoaded;

LToolsGetDebugKey[]:=
	LoopTools`GetDebugKey[]/; ltLoaded;

LToolsSetDebugRange[x_,y_]:=
	LoopTools`SetDebugRange[x,y]/; ltLoaded;

LToolsSetCmpBits[x_]:=
	LoopTools`SetCmpBits[x]/; ltLoaded;

LToolsGetCmpBits[]:=
	LoopTools`GetCmpBits[]/; ltLoaded;

LToolsSetDiffEps[x_]:=
	LoopTools`SetDiffEps[x]/; ltLoaded;

LToolsGetDiffEps[]:=
	LoopTools`GetDiffEps[]/; ltLoaded;

LToolsGetZeroEps[]:=
	LoopTools`GetZeroEps[]/; ltLoaded;

LToolsDRResult[c0_,c1_,c2_]:=
	LoopTools`DRResult[c0,c1,c2]/; ltLoaded;

LToolsDR1eps=
	LoopTools`DR1eps/; ltLoaded;


LToolsKeyA0=
	LoopTools`KeyA0/; ltLoaded;

LToolsKeyBget=
	LoopTools`KeyBget/; ltLoaded;

LToolsKeyC0=
	LoopTools`KeyC0/; ltLoaded;

LToolsKeyD0=
	LoopTools`KeyD0/; ltLoaded;

LToolsKeyE0=
	LoopTools`KeyE0/; ltLoaded;

LToolsKeyEget=
	LoopTools`KeyEget/; ltLoaded;

LToolsKeyCEget=
	LoopTools`KeyCEget/; ltLoaded;

LToolsKeyAll=
	LoopTools`KeyAll/; ltLoaded;

LToolsDebugA=
	LoopTools`DebugA/; ltLoaded;

LToolsDebugB=
	LoopTools`DebugB/; ltLoaded;

LToolsDebugC=
	LoopTools`DebugC/; ltLoaded;

LToolsDebugD=
	LoopTools`DebugD/; ltLoaded;

LToolsDebugE=
	LoopTools`DebugE/; ltLoaded;

LToolsDebugAll=
	LoopTools`DebugAll/; ltLoaded;

LToolsA0[args__]:=
	LToolsA0i["aa0",args];

LToolsA00[args__]:=
	LToolsA0i["aa00",args];

LToolsB0[args__]:=
	LToolsB0i["bb0",args];

LToolsB1[args__]:=
	LToolsB0i["bb1",args];

LToolsB00[args__]:=
	LToolsB0i["bb00",args];

LToolsB11[args__]:=
	LToolsB0i["bb11",args];

LToolsB001[args__]:=
	LToolsB0i["bb001",args];

LToolsB111[args__]:=
	LToolsB0i["bb111",args];

LToolsDB0[args__]:=
	LToolsB0i["dbb0",args];

LToolsDB1[args__]:=
	LToolsB0i["dbb1",args];

LToolsDB00[args__]:=
	LToolsB0i["dbb00",args];

LToolsDB11[args__]:=
	LToolsB0i["dbb11",args];

LToolsC0[args__]:=
	LToolsC0i["cc0",args];

LToolsD0[args__]:=
	LToolsD0i["dd0",args];

LToolsE0[args__]:=
	LToolsE0i["ee0",args];

End[]

