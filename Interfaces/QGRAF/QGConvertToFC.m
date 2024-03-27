(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: QGConvertToFC													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Runs QGRAF and generates the diagrams						*)

(* ------------------------------------------------------------------------ *)


QGConvertToFC::usage=
"QGConvertToFC[{amp1, amp2, ...}] converts a list of QGRAF amplitudes generated
using the styling file feyncalc.sty into amplitudes suitable for further
evaluation using FeynCalc.";

QGConvertToFC::noins=
"QGConvertToFC cannot find some of the required insertion rules `1`. \
Only the following rules are available `2`. Evaluation aborted."

QGConvertToFC::fail=
"QGConvertToFC has encountered an error and must abort the evaluation. The \
error description reads: `1`";

Begin["`Package`"]

End[]

Begin["`QGConvertToFC`Private`"]


qgcVerbose::usage="";

Options[QGConvertToFC] = {
	ChangeDimension 				-> False,
	Contract 						-> False,
	DiracChainJoin					-> False,
	FinalSubstitutions				-> {},
	Heads 							-> {QGVertex,QGPolarization,QGTruncatedPolarization,QGPropagator},
	InitialSubstitutions			-> {},
	List 							-> True,
	LoopMomenta 					-> {},
	LorentzIndexNames				-> {},
	PauliChainJoin					-> False,
	Prefactor						-> 1,
	QGInsertionRule					-> {"QGCommonInsertions"},
	QGTruncatedPolarization 		-> False,
	SMP 							-> False,
	SUNFIndexNames					-> {},
	SUNIndexNames					-> {},
	TransversePolarizationVectors	-> {},
	FCVerbose						-> False
};

QGConvertToFC[{amps_String, (*dias*)_String}, opts:OptionsPattern[]] :=
	QGConvertToFC[amps, opts];

QGConvertToFC[ampsPath_String, OptionsPattern[]] :=
	Block[{ repRuleInsertions, optQGInsertionRule, optHeads,
			ampsConverted, repRuleLorentzIndices, headsList, headsListEval,
			repRulePolVectors,liNames,polVecs,dim, loopMoms, repRuleHeads,
			sunNames, sunfNames, repRuleSUNIndices, repRuleSUNFIndices,
			prefactor,liOld,sunOld,sunfOld, len, repRuleMomenta, time,
			optInitialSubstitutions, amps},

		optQGInsertionRule 		= OptionValue[QGInsertionRule];
		optHeads				= OptionValue[Heads];
		loopMoms				= OptionValue[LoopMomenta];
		liNames					= OptionValue[LorentzIndexNames];
		sunNames				= OptionValue[SUNIndexNames];
		sunfNames				= OptionValue[SUNFIndexNames];
		polVecs					= OptionValue[TransversePolarizationVectors];
		dim						= OptionValue[ChangeDimension];
		prefactor				= OptionValue[Prefactor];
		optInitialSubstitutions = OptionValue[InitialSubstitutions];

		If[	!FileExistsQ[ampsPath],
			Message[QGConvertToFC::fail,"The amplitudes files does not exits!"]
		];

		amps = Get[ampsPath];

		If[	OptionValue[FCVerbose]===False,
			qgcVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				qgcVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1,"QGConvertToFC: Entering.", FCDoControl->qgcVerbose];
		FCPrint[3,"QGConvertToFC: Entering with: ", amps, FCDoControl->qgcVerbose];

		If[	Head[optQGInsertionRule]=!=List,
			Message[QGConvertToFC::fail, "The value of the option QGInsertionRule must be a list."];
			Abort[]
		];

		If[	!FreeQ[Head/@(QGInsertionRule/@optQGInsertionRule),QGInsertionRule],
			Message[QGConvertToFC::fail,"Some of the specified insertion rules have not been loaded yet."];
		];

		If[	QGInsertionRule[]==={},
			Message[QGConvertToFC::fail,"No insertion rules are available."];
			Abort[]
		];


		repRuleInsertions = Flatten[Join[QGInsertionRule/@optQGInsertionRule]];

		If[	!FreeQ[repRuleInsertions,QGInsertionRule],
			Message[QGConvertToFC::noins,SelectNotFree[repRuleInsertions,QGInsertionRule],QGInsertionRule[]];
			Abort[]
		];

		repRuleMomenta={};
		repRuleLorentzIndices={};
		repRuleSUNIndices={};
		repRuleSUNFIndices={};
		repRulePolVectors={};

		ampsConverted = amps;

		If[	OptionValue[QGTruncatedPolarization] && !FreeQ[ampsConverted,QGPolarization],
			ampsConverted = ampsConverted /. QGPolarization -> QGTruncatedPolarization
		];

		headsList = Cases2[ampsConverted, optHeads];

		headsListEval = headsList //. optInitialSubstitutions /. Dispatch[repRuleInsertions];

		repRuleHeads = Thread[Rule[headsList,headsListEval]];

		ampsConverted= ampsConverted /. Dispatch[repRuleHeads];

		If[	!FreeQ2[ampsConverted, optHeads],
			FCPrint[0, "QGConvertToFC: ",FeynCalc`Package`FCStyle["Warning! Some insertion rules are missing.", {Darker[Red,0.55], Bold}], FCDoControl->qgcVerbose]
		];

		ampsConverted = prefactor ampsConverted;

		If[	loopMoms=!={},
			repRuleMomenta = Join[repRuleMomenta,MapIndexed[Rule[ToExpression["LoopMom"<>ToString[First[#2]]],#1]&,loopMoms]]
		];

		If[	liNames=!={},
			liOld = ToExpression /@ (Names["Global`QGILor*"]);
			If[	Length[liOld]>=Length[liNames],
				len = Length[liNames],
				len = Length[liOld]
			];
			repRuleLorentzIndices = MapIndexed[Rule[liOld[[First[#2]]], #1] &, liNames[[1 ;; len]]]
		];
		If[	sunNames=!={},
			sunOld = ToExpression /@ (Names["Global`QGICola*"]);
			If[	Length[sunOld]>=Length[sunNames],
				len = Length[sunNames],
				len = Length[sunOld]
			];
			repRuleSUNIndices = MapIndexed[Rule[sunOld[[First[#2]]], #1] &, sunNames[[1 ;; len]]]
		];
		If[	sunfNames=!={},
			sunfOld = ToExpression /@ (Names["Global`QGIColf*"]);
			If[	Length[sunfOld]>=Length[sunfNames],
				len = Length[sunfNames],
				len = Length[sunfOld]
			];
			repRuleSUNFIndices = MapIndexed[Rule[sunfOld[[First[#2]]], #1] &, sunfNames[[1 ;; len]]]
		];

		If[	polVecs=!={},
			repRulePolVectors = Map[Rule[Polarization[#,Pattern[x,BlankNullSequence[]]],
				Polarization[#,x,Transversality->True]]&,polVecs]
		];

		ampsConverted = ampsConverted /. repRuleMomenta /.repRuleLorentzIndices/.repRuleSUNIndices/.
			repRuleSUNFIndices/. repRulePolVectors;

		If[	OptionValue[ChangeDimension]=!=False,
			time=AbsoluteTime[];
			FCPrint[1,"QGConvertToFC: Applying ChangeDimension.", FCDoControl->qgcVerbose];
			ampsConverted= ChangeDimension[ampsConverted,dim];
			FCPrint[1,"QGConvertToFC: Done applying DChangeDimension, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgcVerbose]
		];

		If[	TrueQ[OptionValue[DiracChainJoin]],
			time=AbsoluteTime[];
			FCPrint[1,"QGConvertToFC: Applying DiracChainJoin.", FCDoControl->qgcVerbose];
			ampsConverted = DiracChainJoin/@ampsConverted;
			FCPrint[1,"QGConvertToFC: Done applying DiracChainJoin, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgcVerbose]
		];

		If[	TrueQ[OptionValue[PauliChainJoin]],
			time=AbsoluteTime[];
			FCPrint[1,"QGConvertToFC: Applying PauliChainJoin.", FCDoControl->qgcVerbose];
			ampsConverted = PauliChainJoin/@ampsConverted;
			FCPrint[1,"QGConvertToFC: Done applying PauliChainJoin, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgcVerbose]
		];

		If[	TrueQ[OptionValue[Contract]],
			time=AbsoluteTime[];
			FCPrint[1,"QGConvertToFC: Applying Contract.", FCDoControl->qgcVerbose];
			ampsConverted = Contract/@ampsConverted;
			FCPrint[1,"QGConvertToFC: Done applying Contract, timing: ", N[AbsoluteTime[] - time, 4], FCDoControl->qgcVerbose]
		];

		If[	!OptionValue[List],
			ampsConverted = Total[ampsConverted]
		];

		If[	OptionValue[FinalSubstitutions]=!={},
			ampsConverted = ampsConverted /. OptionValue[FinalSubstitutions]
		];

		Return[ampsConverted]

	];


End[]

