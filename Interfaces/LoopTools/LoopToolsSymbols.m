(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: LoopToolsSymbols													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Access to LoopTools symbols									*)

(* ------------------------------------------------------------------------ *)

LToolsA0i::usage=
"LToolsA0i corresponds to the A0i function in LoopTools. The only difference is
that the id should be entered as a string, e.g. \"a0\" instead of a0.

See ?LoopToolsA0i for further information regarding this LoopTools symbol.";

LToolsB0i::usage=
"LToolsB0i corresponds to the B0i function in LoopTools. The only difference is
that the id should be entered as a string, e.g. \"b0\" instead of b0.

See ?LoopToolsB0i for further information regarding this LoopTools symbol.";

LToolsC0i::usage=
"LToolsC0i corresponds to the C0i function in LoopTools. The only difference is
that the id should be entered as a string, e.g. \"c0\" instead of c0.

See ?LoopToolsC0i for further information regarding this LoopTools symbol.";

LToolsD0i::usage=
"LToolsD0i corresponds to the D0i function in LoopTools. The only difference is
that the id should be entered as a string, e.g. \"d0\" instead of d0.

See ?LoopToolsD0i for further information regarding this LoopTools symbol.";

LToolsE0i::usage=
"LToolsE0i corresponds to the E0i function in LoopTools. The only difference is
that the id should be entered as a string, e.g. \"e0\" instead of e0.

See ?LoopToolsE0i for further information regarding this LoopTools symbol.";

LToolsPaVe::usage=
"LToolsPaVe corresponds to the PaVe function in LoopTools.

See ?LoopToolsPaVe for further information regarding this LoopTools symbol.";

LToolsLi2::usage=
"LToolsLi2 corresponds to the Li2 function in LoopTools.

See ?LoopToolsLi2 for further information regarding this LoopTools symbol.";

LToolsLi2omx::usage=
"LToolsLi2omx corresponds to the Li2omx function in LoopTools.

See ?LoopToolsLi2omx for further information regarding this LoopTools symbol.";

LToolsSetMudim::usage=
"LToolsSetMudim corresponds to the SetMudim function in LoopTools.

See ?LoopToolsSetMudim for further information regarding this LoopTools
symbol.

LToolsSetMudim is also an option for LToolsEvaluate that sets the numerical
value for the scale parameter $\\mu^2$. The default value is 1.";

LToolsGetMudim::usage=
"LToolsGetMudim corresponds to the GetMudim function in LoopTools.

See ?LoopToolsGetMudim for further information regarding this LoopTools
symbol.";

LToolsSetDelta::usage=
"LToolsSetDelta corresponds to the SetDelta function in LoopTools.

See ?LoopToolsSetDelta for further information regarding this LoopTools
symbol.";

LToolsGetDelta::usage=
"LToolsGetDelta corresponds to the GetDelta function in LoopTools.

See ?LoopToolsGetDelta for further information regarding this LoopTools
symbol.";

LToolsSetUVDiv::usage=
"LToolsSetUVDiv corresponds to the SetUVDiv function in LoopTools.

See ?LoopToolsSetUVDiv for further information regarding this LoopTools
symbol.";

LToolsGetUVDiv::usage=
"LToolsGetUVDiv corresponds to the GetUVDiv function in LoopTools.

See ?LoopToolsGetUVDiv for further information regarding this LoopTools
symbol.";

LToolsSetLambda::usage=
"LToolsSetLambda corresponds to the SetLambda function in LoopTools.

See ?LoopToolsSetLambda for further information regarding this LoopTools
symbol.

LToolsSetLambda is also an option for LToolsEvaluate that sets the numerical
value for the IR regularization parameter $\\lambda^2$.

Setting $\\lambda^2$  to -2 or -1 will make LoopTools return the coefficients
of the $1/\\varepsilon$ and $1/\\varepsilon$-poles respectively. The value 0
yields the finite part of the integral where IR divergences are regularized
dimensionally.

When $\\lambda^2$ is set to some positive value (say 2.), LoopTools will return
the finite part of the integral with IR divergences being regularized using a
fictitious mass. The result will naturally depend on the value of $\\lambda^2$.

It is important to keep in mind that for  $\\lambda^2 = -1$ LoopTools also
returns the UV-pole, although this not so clearly stated in the official
manual.

Notice that the option LToolsSetLambda is ignored, as long as LToolsFullResult
is set to True.";

LToolsGetLambda::usage=
"LToolsGetLambda corresponds to the GetLambda function in LoopTools.

See ?LoopToolsGetLambda for further information regarding this LoopTools
symbol.";

LToolsSetMinMass::usage=
"LToolsSetMinMass corresponds to the SetMinMass function in LoopTools.

See ?LoopToolsSetMinMass for further information regarding this LoopTools
symbol.";

LToolsGetMinMass::usage=
"LToolsGetMinMass corresponds to the GetMinMass function in LoopTools.

See ?LoopToolsGetMinMass for further information regarding this LoopTools
symbol.";

LToolsClearCache::usage=
"LToolsClearCache corresponds to the ClearCache function in LoopTools.

See ?LoopToolsClearCache for further information regarding this LoopTools
symbol.";

LToolsMarkCache::usage=
"LToolsMarkCache corresponds to the MarkCache function in LoopTools.

See ?LoopToolsMarkCache for further information regarding this LoopTools
symbol.";

LToolsRestoreCache::usage=
"LToolsRestoreCache corresponds to the RestoreCache function in LoopTools.

See ?LoopToolsRestoreCache for further information regarding this LoopTools
symbol.";

LToolsSetMaxDev::usage=
"LToolsSetMaxDev corresponds to the SetMaxDev function in LoopTools.

See ?LoopToolsSetMaxDev for further information regarding this LoopTools
symbol.";

LToolsGetMaxDev::usage=
"LToolsGetMaxDev corresponds to the GetMaxDev function in LoopTools.

See ?LoopToolsGetMaxDev for further information regarding this LoopTools
symbol.";

LToolsSetWarnDigits::usage=
"LToolsSetWarnDigits corresponds to the SetWarnDigits function in LoopTools.

See ?LoopToolsSetWarnDigits for further information regarding this LoopTools
symbol.";

LToolsGetWarnDigits::usage=
"LToolsGetWarnDigits corresponds to the GetWarnDigits function in LoopTools.

See ?LoopToolsGetWarnDigits for further information regarding this LoopTools
symbol.";

LToolsSetErrDigits::usage=
"LToolsSetErrDigits corresponds to the SetErrDigits function in LoopTools.

See ?LoopToolsSetErrDigits for further information regarding this LoopTools
symbol.";

LToolsGetErrDigits::usage=
"LToolsGetErrDigits corresponds to the GetErrDigits function in LoopTools.

See ?LoopToolsGetErrDigits for further information regarding this LoopTools
symbol.";

LToolsSetVersionKey::usage=
"LToolsSetVersionKey corresponds to the SetVersionKey function in LoopTools.

See ?LoopToolsSetVersionKey for further information regarding this LoopTools
symbol.";

LToolsGetVersionKey::usage=
"LToolsGetVersionKey corresponds to the SetVersionKey function in LoopTools.

See ?LoopToolsGetVersionKey for further information regarding this LoopTools
symbol.";

LToolsSetDebugKey::usage=
"LToolsSetDebugKey corresponds to the SetDebugKey function in LoopTools.

See ?LoopToolsSetDebugKey for further information regarding this LoopTools
symbol.

Use LToolsSetDebugKey[-1] to obtain the most complete debugging output. This
can be useful when investigating issues with the evaluation of certain
kinematic limits in LoopTools.";

LToolsGetDebugKey::usage=
"LToolsGetDebugKey corresponds to the GetDebugKey function in LoopTools.

See ?LoopToolsGetDebugKey for further information regarding this LoopTools
symbol.";

LToolsSetDebugRange::usage=
"LToolsSetDebugRange corresponds to the SetVersionKey function in LoopTools.

See ?LoopToolsSetDebugRange for further information regarding this LoopTools
symbol.";

LToolsSetCmpBits::usage=
"LToolsSetCmpBits corresponds to the SetCmpBits function in LoopTools.

See ?LoopToolsSetCmpBits for further information regarding this LoopTools
symbol.";

LToolsGetCmpBits::usage=
"LToolsGetCmpBits corresponds to the SetCmpBits function in LoopTools.

See ?LoopToolsGetCmpBits for further information regarding this LoopTools
symbol.";

LToolsSetDiffEps::usage=
"LToolsSetDiffEps corresponds to the SetDiffEps function in LoopTools.

See ?LoopToolsSetDiffEps for further information regarding this LoopTools
symbol.";

LToolsGetDiffEps::usage=
"LToolsGetDiffEps corresponds to the GetDiffEps function in LoopTools.

See ?LoopToolsGetDiffEps for further information regarding this LoopTools
symbol.";

LToolsGetZeroEps::usage=
"LToolsGetZeroEps corresponds to the GetZeroEps function in LoopTools.

See ?LoopToolsGetZeroEps for further information regarding this LoopTools
symbol.";

LToolsDRResult::usage=
"LToolsDRResult corresponds to the DRResult function in LoopTools.

See ?LoopToolsDRResult for further information regarding this LoopTools
symbol.";

LToolsDR1eps::usage=
"LToolsDR1eps corresponds to the DRResult function in LoopTools.

See ?LoopToolsDR1eps for further information regarding this LoopTools symbol.";

LToolsA0::usage=
"LToolsA0 corresponds to the A0 function in LoopTools.

See ?LoopToolsA0 for further information regarding this LoopTools symbol.";

LToolsA00::usage=
"LToolsA00 corresponds to the A00 function in LoopTools.

See ?LoopToolsA00 for further information regarding this LoopTools symbol.";

LToolsB0::usage=
"LToolsB0 corresponds to the B0 function in LoopTools.

See ?LoopToolsB0 for further information regarding this LoopTools symbol.";

LToolsB1::usage=
"LToolsB1 corresponds to the B1 function in LoopTools.

See ?LoopToolsB1 for further information regarding this LoopTools symbol.";

LToolsB00::usage=
"LToolsB00 corresponds to the B00 function in LoopTools.

See ?LoopToolsB00 for further information regarding this LoopTools symbol.";

LToolsB11::usage=
"LToolsB11 corresponds to the B11 function in LoopTools.

See ?LoopToolsB11 for further information regarding this LoopTools symbol.";

LToolsB001::usage=
"LToolsB001 corresponds to the B001 function in LoopTools.

See ?LoopToolsB001 for further information regarding this LoopTools symbol.";

LToolsB111::usage=
"LToolsB111 corresponds to the B111 function in LoopTools.

See ?LoopToolsB111 for further information regarding this LoopTools symbol.";

LToolsDB0::usage=
"LToolsDB0 corresponds to the DB0 function in LoopTools.

See ?LoopToolsDB0 for further information regarding this LoopTools symbol.";

LToolsDB1::usage=
"LToolsDB1 corresponds to the DB1 function in LoopTools.

See ?LoopToolsDB1 for further information regarding this LoopTools symbol.";

LToolsDB00::usage=
"LToolsDB00 corresponds to the DB00 function in LoopTools.

See ?LoopToolsDB00 for further information regarding this LoopTools symbol.";

LToolsDB11::usage=
"LToolsDB11 corresponds to the DB11 function in LoopTools.

See ?LoopToolsDB11 for further information regarding this LoopTools symbol.";

LToolsC0::usage=
"LToolsC0 corresponds to the C0 function in LoopTools.

See ?LoopToolsC0 for further information regarding this LoopTools symbol.";

LToolsD0::usage=
"LToolsD0 corresponds to the D0 function in LoopTools.

See ?LoopToolsD0 for further information regarding this LoopTools symbol.";

LToolsE0::usage=
"LToolsE0 corresponds to the E0 function in LoopTools.

See ?LoopToolsE0 for further information regarding this LoopTools symbol.";

LToolsKeyA0::usage=
"LToolsKeyA0 corresponds to KeyA0 in LoopTools.

See ?LoopToolsKeyA0 for further information regarding this LoopTools symbol.";

LToolsKeyBget::usage=
"LToolsKeyBget corresponds to KeyBget in LoopTools.

See ?LoopToolsKeyBget for further information regarding this LoopTools symbol.";

LToolsKeyC0::usage=
"LToolsKeyC0 corresponds to KeyC0 in LoopTools.

See ?LoopToolsKeyC0 for further information regarding this LoopTools symbol.";

LToolsKeyD0::usage=
"LToolsKeyD0 corresponds to KeyD0 in LoopTools.

See ?LoopToolsKeyD0 for further information regarding this LoopTools symbol.";

LToolsKeyE0::usage=
"LToolsKeyE0 corresponds to KeyE0 in LoopTools.

See ?LoopToolsKeyE0 for further information regarding this LoopTools symbol.";

LToolsKeyEget::usage=
"LToolsKeyEget corresponds to KeyEget in LoopTools.

See ?LoopToolsKeyEget for further information regarding this LoopTools symbol.";

LToolsKeyCEget::usage=
"LToolsKeyCEget corresponds to KeyCEget in LoopTools.

See ?LoopToolsKeyCEget for further information regarding this LoopTools
symbol.";

LToolsKeyAll::usage=
"LToolsKeyAll corresponds to KeyAll in LoopTools.

See ?LoopToolsKeyAll for further information regarding this LoopTools symbol.";

LToolsDebugA::usage=
"LToolsDebugA corresponds to DebugA in LoopTools.

See ?LoopToolsDebugA for further information regarding this LoopTools symbol.";

LToolsDebugB::usage=
"LToolsDebugB corresponds to DebugB in LoopTools.

See ?LoopToolsDebugB for further information regarding this LoopTools symbol.";

LToolsDebugC::usage=
"LToolsDebugC corresponds to DebugC in LoopTools.

See ?LoopToolsDebugC for further information regarding this LoopTools symbol.";

LToolsDebugD::usage=
"LToolsDebugD corresponds to DebugD in LoopTools.

See ?LoopToolsDebugD for further information regarding this LoopTools symbol.";

LToolsDebugE::usage=
"LToolsDebugE corresponds to DebugE in LoopTools.

See ?LoopToolsDebugE for further information regarding this LoopTools symbol.";

LToolsDebugAll::usage=
"LToolsDebugAll corresponds to DebugAll in LoopTools.

See ?LoopToolsDebugAll for further information regarding this LoopTools
symbol.";

LTools::failmsg=
"Interface to LoopTools has encountered an error and must abort the evaluation. The \
error description reads: `1`";

LTools::pavefail=
"Warning! LoopTools failed to evaluate the following PaVe function: `1`";

Begin["`Package`"]

ltFailed;

End[]

Begin["`LoopTools`Private`"]

ltVerbose::usage="";

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

LToolsA0i[id_String, m_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`A0i[idVal,m]
	]/; FeynCalc`Package`ltLoaded;

LToolsB0i[id_String, p_, m1_, m2_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`B0i[idVal, p, m1, m2]
	]/; FeynCalc`Package`ltLoaded;

LToolsC0i[id_String, p1_, p2_, p1p2_, m1_, m2_, m3_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`C0i[idVal, p1, p2, p1p2, m1, m2, m3]
	]/; FeynCalc`Package`ltLoaded;

LToolsD0i[id_String, p1_, p2_, p3_, p4_, p1p2_, p2p3_, m1_, m2_, m3_, m4_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`D0i[idVal, p1, p2, p3, p4, p1p2, p2p3, m1, m2, m3, m4]
	]/; FeynCalc`Package`ltLoaded;

LToolsE0i[id_String, p1_, p2_, p3_, p4_, p5_, p1p2_, p2p3_, p3p4_, p4p5_, p5p1_, m1_, m2_, m3_, m4_, m5_]:=
	Block[{idVal},

		If[	MemberQ[idList, id],
			idVal = ToExpression["LoopTools`" <> id],
			Message[LTools::failmsg,"Unknown id " <> id];
			Abort[]
		];

		LoopTools`E0i[idVal, p1, p2, p3, p4, p5, p1p2, p2p3, p3p4, p4p5, p5p1, m1, m2, m3, m4, m5]
	]/; FeynCalc`Package`ltLoaded;


LToolsPaVe[i__Integer, {p___}, {m__}, OptionsPattern[]]:=
	Block[{res},
		(*  LoopTools`PaVe[i,{p},{m}]] won't work, as the id (e.g. bb0) will end up in the global context. So we
			essentially duplicate the original LoopTools function here *)
		res = (ToExpression["Hold[LoopTools`" <> #1 <> "0i]"][ToExpression["LoopTools`" <> #2 <> #2 <> ToString /@ Sort[{i}]],
			p, m] &)[FromCharacterCode[Length[{m}] + 64], FromCharacterCode[Length[{m}] + 96]];
		res = ReleaseHold[res];
		If[	res===Indeterminate,
			Message[LTools::pavefail,ToString[PaVe[i,{p},{m}],InputForm]];
			res = FCGV["LToolsFailed"][PaVe[i,{p},{m},PaVeAutoReduce->False]]
		];
		res

	]/; FeynCalc`Package`ltLoaded;

LToolsLi2[x_]:=
	LoopTools`Li2[x]/; FeynCalc`Package`ltLoaded;

LToolsLi2omx[x_]:=
	LoopTools`Li2omx[x]/; FeynCalc`Package`ltLoaded;

LToolsSetMudim[x_]:=
	LoopTools`SetMudim[x]/; FeynCalc`Package`ltLoaded;

LToolsGetMudim[]:=
	LoopTools`GetMudim[]/; FeynCalc`Package`ltLoaded;

LToolsSetDelta[x_]:=
	LoopTools`SetDelta[x]/; FeynCalc`Package`ltLoaded;

LToolsGetDelta[]:=
	LoopTools`GetDelta[]/; FeynCalc`Package`ltLoaded;

LToolsSetUVDiv[x_]:=
	LoopTools`SetUVDiv[x]/; FeynCalc`Package`ltLoaded;

LToolsGetUVDiv[]:=
	LoopTools`GetUVDiv[]/; FeynCalc`Package`ltLoaded;

LToolsSetLambda[x_]:=
		LoopTools`SetLambda[x]/; FeynCalc`Package`ltLoaded;

LToolsGetLambda[]:=
	LoopTools`GetLambda[]/; FeynCalc`Package`ltLoaded;

LToolsSetMinMass[x_]:=
	LoopTools`SetMinMass[x]/; FeynCalc`Package`ltLoaded;

LToolsGetMinMass[]:=
	LoopTools`GetMinMass[]/; FeynCalc`Package`ltLoaded;

LToolsClearCache[]:=
	LoopTools`ClearCache[]/; FeynCalc`Package`ltLoaded;

LToolsMarkCache[]:=
	LoopTools`MarkCache[]/; FeynCalc`Package`ltLoaded;

LToolsRestoreCache[]:=
	LoopTools`RestoreCache[]/; FeynCalc`Package`ltLoaded;

LToolsSetMaxDev[x_]:=
	LoopTools`SetMaxDev[x]/; FeynCalc`Package`ltLoaded;

LToolsGetMaxDev[]:=
	LoopTools`GetMaxDev[]/; FeynCalc`Package`ltLoaded;

LToolsSetWarnDigits[x_]:=
	LoopTools`SetWarnDigits[x]/; FeynCalc`Package`ltLoaded;

LToolsGetWarnDigits[]:=
	LoopTools`GetWarnDigits[]/; FeynCalc`Package`ltLoaded;

LToolsSetErrDigits[x_]:=
	LoopTools`SetErrDigits[x]/; FeynCalc`Package`ltLoaded;

LToolsGetErrDigits[]:=
	LoopTools`GetErrDigits[]/; FeynCalc`Package`ltLoaded;

LToolsSetVersionKey[x_]:=
	LoopTools`SetVersionKey[x]/; FeynCalc`Package`ltLoaded;

LToolsGetVersionKey[]:=
	LoopTools`GetVersionKey[]/; FeynCalc`Package`ltLoaded;

LToolsSetDebugKey[x_]:=
	LoopTools`SetDebugKey[x]/; FeynCalc`Package`ltLoaded;

LToolsGetDebugKey[]:=
	LoopTools`GetDebugKey[]/; FeynCalc`Package`ltLoaded;

LToolsSetDebugRange[x_,y_]:=
	LoopTools`SetDebugRange[x,y]/; FeynCalc`Package`ltLoaded;

LToolsSetCmpBits[x_]:=
	LoopTools`SetCmpBits[x]/; FeynCalc`Package`ltLoaded;

LToolsGetCmpBits[]:=
	LoopTools`GetCmpBits[]/; FeynCalc`Package`ltLoaded;

LToolsSetDiffEps[x_]:=
	LoopTools`SetDiffEps[x]/; FeynCalc`Package`ltLoaded;

LToolsGetDiffEps[]:=
	LoopTools`GetDiffEps[]/; FeynCalc`Package`ltLoaded;

LToolsGetZeroEps[]:=
	LoopTools`GetZeroEps[]/; FeynCalc`Package`ltLoaded;

LToolsDRResult[c0_,c1_,c2_]:=
	LoopTools`DRResult[c0,c1,c2]/; FeynCalc`Package`ltLoaded;

LToolsDR1eps=
	LoopTools`DR1eps/; FeynCalc`Package`ltLoaded;


LToolsKeyA0=
	LoopTools`KeyA0/; FeynCalc`Package`ltLoaded;

LToolsKeyBget=
	LoopTools`KeyBget/; FeynCalc`Package`ltLoaded;

LToolsKeyC0=
	LoopTools`KeyC0/; FeynCalc`Package`ltLoaded;

LToolsKeyD0=
	LoopTools`KeyD0/; FeynCalc`Package`ltLoaded;

LToolsKeyE0=
	LoopTools`KeyE0/; FeynCalc`Package`ltLoaded;

LToolsKeyEget=
	LoopTools`KeyEget/; FeynCalc`Package`ltLoaded;

LToolsKeyCEget=
	LoopTools`KeyCEget/; FeynCalc`Package`ltLoaded;

LToolsKeyAll=
	LoopTools`KeyAll/; FeynCalc`Package`ltLoaded;

LToolsDebugA=
	LoopTools`DebugA/; FeynCalc`Package`ltLoaded;

LToolsDebugB=
	LoopTools`DebugB/; FeynCalc`Package`ltLoaded;

LToolsDebugC=
	LoopTools`DebugC/; FeynCalc`Package`ltLoaded;

LToolsDebugD=
	LoopTools`DebugD/; FeynCalc`Package`ltLoaded;

LToolsDebugE=
	LoopTools`DebugE/; FeynCalc`Package`ltLoaded;

LToolsDebugAll:=
	LoopTools`DebugAll/; FeynCalc`Package`ltLoaded;

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

