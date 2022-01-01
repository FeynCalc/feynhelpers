(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: QGConvertToFC													*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2018-2021 Vladyslav Shtabovenko
*)

(* :Summary: 	Runs QGRAF and generates the diagrams						*)

(* ------------------------------------------------------------------------ *)


QGConvertToFC::usage=
"QGConvertToFC converts a QGRAF amplitude to FeynCalc."

QGConvertToFC::fail=
"QGConvertToFC has encountered an error and must abort the evaluation. The \
error description reads: `1`";

Begin["`Package`"]

End[]

Begin["`QGConvertToFC`Private`"]


Options[QGConvertToFC] = {
	ChangeDimension 				-> False,
	Contract 						-> False,
	DiracChainJoin					-> False,
	FinalSubstitutions				-> {},
	Heads 							-> {QGVertex,QGPolarization,QGTruncatedPolarization,QGPropagator},
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
	TransversePolarizationVectors	-> {}
};

QGConvertToFC[amps_String, opts:OptionsPattern[]]/; FileExistsQ[amps] :=
	QGConvertToFC[Get[amps], opts];

QGConvertToFC[diag_, opts:OptionsPattern[]] :=
	QGConvertToFC[{diag}, opts]/; Head[diag]=!=List;

QGConvertToFC[diags_List, OptionsPattern[]] :=
	Block[{ repRuleInsertions, optQGInsertionRule, optHeads,
			diagsConverted, repRuleLorentzIndices, headsList, headsListEval,
			repRulePolVectors,liNames,polVecs,dim, loopMoms, repRuleHeads,
			sunNames, sunfNames, repRuleSUNIndices, repRuleSUNFIndices,
			prefactor,liOld,sunOld,sunfOld, len, repRuleMomenta},



		optQGInsertionRule 	= 	OptionValue[QGInsertionRule];
		optHeads			= 	OptionValue[Heads];
		loopMoms			=	OptionValue[LoopMomenta];
		liNames				=	OptionValue[LorentzIndexNames];
		sunNames			=	OptionValue[SUNIndexNames];
		sunfNames			=	OptionValue[SUNFIndexNames];
		polVecs				=	OptionValue[TransversePolarizationVectors];
		dim					=	OptionValue[ChangeDimension];
		prefactor			=	OptionValue[Prefactor];

		If[	!FreeQ[Head/@(QGInsertionRule/@optQGInsertionRule),QGInsertionRule],
			Message[QGConvertToFC::fail,"Some of the specified insertion rules have not been loaded yet."];
		];

		If[	QGInsertionRule[]==={},
			Message[QGConvertToFC::fail,"No insertion rules are available."];
			Abort[]
		];


		repRuleInsertions = Flatten[Join[QGInsertionRule/@optQGInsertionRule]];
		repRuleMomenta={};
		repRuleLorentzIndices={};
		repRuleSUNIndices={};
		repRuleSUNFIndices={};
		repRulePolVectors={};

		diagsConverted = diags;

		If[	OptionValue[QGTruncatedPolarization] && !FreeQ[diagsConverted,QGPolarization],
			diagsConverted = diagsConverted /. QGPolarization -> QGTruncatedPolarization
		];

		headsList = Cases2[diagsConverted, optHeads];

		headsListEval = headsList /. Dispatch[repRuleInsertions];

		repRuleHeads = Thread[Rule[headsList,headsListEval]];

		diagsConverted= diagsConverted /. Dispatch[repRuleHeads];

		If[	!FreeQ2[diagsConverted, optHeads],
			Print["Warning! Some insertion rules are missing."]
		];

		diagsConverted = prefactor diagsConverted;

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

		diagsConverted = diagsConverted /. repRuleMomenta /.repRuleLorentzIndices/.repRuleSUNIndices/.
			repRuleSUNFIndices/. repRulePolVectors;

		If[	OptionValue[ChangeDimension]=!=False,
			diagsConverted= ChangeDimension[diagsConverted,dim]
		];

		If[	TrueQ[OptionValue[DiracChainJoin]],
			diagsConverted = DiracChainJoin/@diagsConverted
		];

		If[	TrueQ[OptionValue[PauliChainJoin]],
			diagsConverted = PauliChainJoin/@diagsConverted
		];

		If[	TrueQ[OptionValue[Contract]],
			diagsConverted = Contract/@diagsConverted
		];

		If[	!OptionValue[List],
			diagsConverted = Total[diagsConverted]
		];

		If[	OptionValue[FinalSubstitutions]=!={},
			diagsConverted = diagsConverted /. OptionValue[FinalSubstitutions]
		];

		Return[diagsConverted]

	];


End[]

