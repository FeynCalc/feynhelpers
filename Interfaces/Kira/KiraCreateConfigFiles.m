(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: KiraCreateConfigFiles											*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2022-2024 Vladyslav Shtabovenko
*)

(* :Summary: 	Generates config files for KIRA out of FCTopology objects	*)

(* ------------------------------------------------------------------------ *)

KiraCreateConfigFiles::usage=
"KiraCreateConfigFiles[topo, sectors, path] can be used to generate Kira
configuration files (integralfamilies.yaml and kinematics.yaml) from an
FCTopology or list thereof. Here sectors is a list of sectors need to be
reduced, e.g. {{1,0,0,0}, {1,1,0,0}, {1,1,1,0}} etc.

The functions creates the corresponding yaml files and saves them  in
path/topoName/config. Using KiraCreateConfigFiles[{topo1, topo2, ...},
{sectors1, sectors2, ...},  path] will save the scripts to path/topoName1,
path/topoName2 etc. The syntax KiraCreateConfigFiles[{topo1, topo2, ...},
{sectors1, sectors2, ...},  {path1, path2, ...}] is also possible.

If the directory specified in path/topoName does not exist, it will be created
automatically. If it already exists, its content will be automatically
overwritten, unless the option OverwriteTarget is set to False.

It is also possible to supply a list of GLIs instead of sectors. In that case
FCLoopFindSectors will be used to determine the top sector for each topology.

The syntax  KiraCreateConfigFiles[{topo1, topo2, ...}, {sectors1, sectors2,
...}, path] or KiraCreateConfigFiles[{topo1, topo2, ...}, {glis1, glis2, ...},
 path] is also allowed. This implies that all config files will go into the
corresponding subdirectories of path, e.g. path/topoName1/config,
path/topoName2/config etc.

The mass dimension of all kinematic variables should be specified via the
option KiraMassDimensions e.g. as in {{m1->1},{M->1},{msq->2}}.

If the amplitude originally contained any external momenta that were
eliminated using momentum conservation, .e.g. by replacing $k_2$ by $P-k_1$
for $P=k_1+k_2$, those momenta must be nevertheless specified via the option
KiraImplicitIncomingMomenta.";


KiraMassDimensions::usage=
"KiraMassDimensions is an option for KiraCreateConfigFiles and other functions
of the Kira interface.

It specifies the mass dimensions of kinematic invariants occurring in the
given topologies.";


KiraImplicitIncomingMomenta::usage=
"KiraImplicitIncomingMomenta is an option for KiraCreateConfigFiles and other
functions of the Kira interface.

It specifies incoming momenta in the original amplitude that have been
eliminated using momentum conservation. These momenta may not  appear in the
integrals that need to be reduced, but should be nevertheless passed to Kira.
Otherwise the
reduction may not run.";





KiraCreateConfigFiles::failmsg =
"Error! KiraCreateConfigFiles has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`KiraCreateConfigFiles`Private`"]

fpsfVerbose::usage="";
optDimension::usage="";
optComplex::usage="";

kiraQuadraticProp::usage="";
kiraLinearProp::usage="";

Options[KiraCreateConfigFiles] = {
	DateString					-> False,
	FCI							-> False,
	FCVerbose					-> False,
	OverwriteTarget				-> True,
	KiraImplicitIncomingMomenta -> {},
	KiraMassDimensions			-> {}
};

KiraCreateConfigFiles[topos: {__FCTopology}, topSectors: {{{__Integer}..}..}, dir_String, opts:OptionsPattern[]] :=
	MapThread[KiraCreateConfigFiles[#1,#2,dir,opts]&,{topos,topSectors}];

KiraCreateConfigFiles[topos: {__FCTopology}, topSectors: {{{__Integer}..}..}, dirs: {__String}, opts:OptionsPattern[]] :=
	MapThread[KiraCreateConfigFiles[#1,#2,#3,opts]&,{topos,topSectors,dirs}];

KiraCreateConfigFiles[topos: {__FCTopology}, glis:{__GLI}, dirRaw_String, opts:OptionsPattern[]] :=
	KiraCreateConfigFiles[#, glis, dirRaw, opts]&/@topos;

KiraCreateConfigFiles[topoRaw_FCTopology, glis:{__GLI}, dirRaw_String, opts:OptionsPattern[]] :=
	KiraCreateConfigFiles[topoRaw, {FCLoopFindSectors[SelectNotFree[glis, topoRaw[[1]]], Last -> True, GatherBy -> False]},
		dirRaw, opts];

KiraCreateConfigFiles[topoRaw_FCTopology, topSectorsRaw: {{__Integer}..}, dirRaw_String, OptionsPattern[]] :=
	Block[{	topo, topSectors, loopMomenta, extMomenta, incomingMomenta, outgoingMomenta, momentumConservation,
			propagators, dir, fPar, vars, fp, replacements, file, optOverwriteTarget, status,
			optKiraMassDimensions, topoName, kinematicInvariants,scalarProductRules,
			integralfamiliesPath, kinematicsPath, topoID, optKiraImplicitIncomingMomenta},

		If[	OptionValue[FCVerbose]===False,
			fpsfVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				fpsfVerbose=OptionValue[FCVerbose]
			];
		];

		optOverwriteTarget 				= OptionValue[OverwriteTarget];
		optKiraMassDimensions 			= OptionValue[KiraMassDimensions];
		optKiraImplicitIncomingMomenta	= OptionValue[KiraImplicitIncomingMomenta];

		FCPrint[1,"KiraCreateConfigFiles: Entering.", FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: Entering with:", topoRaw, FCDoControl->fpsfVerbose];

		If[	OptionValue[FCI],
			topo = topoRaw,
			topo = FCI[topoRaw]
		];

		If[	!FCLoopValidTopologyQ[topo],
			Message[KiraCreateConfigFiles::failmsg, "The given topology is incorrect."];
			Abort[]
		];

		If[	FCLoopBasisIncompleteQ[topo, FCI->True],
			Message[KiraCreateConfigFiles::failmsg, "Incomplete propagator basis."];
			Abort[]
		];

		If[	FCLoopBasisOverdeterminedQ[topo, FCI->True],
			Message[KiraCreateConfigFiles::failmsg, "Overdetermined propagator basis."];
			Abort[]
		];

		If[	FCLoopScalelessQ[topo, FCI->True],
			Message[KiraCreateConfigFiles::failmsg, "The given topology is scaleless so that all integrals from this family vanish."];
			Abort[]
		];

		If[ TrueQ[FeynCalc`FCLoopBasis`Private`cartesianIntegralQ[topo[[2]]]],
			Message[KiraCreateConfigFiles::failmsg, "Cartesian integrals are not supported."];
			Abort[];
		];

		If[	!FreeQ2[topo,{TemporalPair,TemporalMomentum}],
			Message[KiraCreateConfigFiles::failmsg, "Explicit temporal components are not supported."];
			Abort[]
		];

		If[	FCLoopGetEtaSigns[topo]=!={1},
			Message[KiraCreateConfigFiles::failmsg, "Propagators with minus signs in front of the quadratic terms are note supported."];
			Abort[]

		];

		topoID = topo[[1]];

		(*
			==================================================================
								integralfamilies.yaml
			==================================================================
		*)

		propagators = FCLoopPropagatorsToTopology[topo,FCI->True,ExpandScalarProduct->False,MomentumCombine->True];

		FCPrint[3,"KiraCreateConfigFiles: Output of FCLoopPropagatorsToTopology: ", propagators, FCDoControl->fpsfVerbose];

		propagators = (fcProp/@propagators);

		FCPrint[3,"KiraCreateConfigFiles: Conversion of propagators to the KIRA notation: ", propagators, FCDoControl->fpsfVerbose];

		If[	!FreeQ2[propagators,{fcProp,Pair,CartesianPair,Momentum,CartesianMomentum}],
			Message[KiraCreateConfigFiles::failmsg, "Failed to convert all the occurring propagators to the KIRA notation."];
			Abort[]
		];


		propagators = propagators /. {
				kiraQuadraticProp[mom_, m_ /; m =!= 0] :>
					"- [ \"" <> ToString[mom, InputForm] <> "\", \"" <> ToString[m, InputForm] <> "\"]",
				kiraQuadraticProp[mom_, 0] :>
					"- [ \"" <> ToString[mom, InputForm] <> "\", 0]",
				kiraLinearProp[mom1_, mom2_, 0] :>
					"- { bilinear: [ [ \"" <> ToString[mom1, InputForm] <> "\", \"" <> ToString[mom2, InputForm] <> "\"], 0] }",
				kiraLinearProp[mom1_, mom2_, m_ /; m =!= 0] :>
					"- { bilinear: [ [ \"" <> ToString[mom1, InputForm] <> "\", \"" <> ToString[mom2, InputForm] <> "\",\"" <> ToString[m, InputForm] <> "\"] }"
		};


		FCPrint[3,"KiraCreateConfigFiles: Conversion of propagators to strings: ", propagators, FCDoControl->fpsfVerbose];

		If[	!MatchQ[propagators,{__String}],
			Message[KiraCreateConfigFiles::failmsg, "Failed to convert all the occurring propagators to the KIRA notation."];
			Abort[]
		];



		propagators  = StringRiffle[propagators, "\n      "];



		topoName = "- name: " <> StringReplace[ToString[topoID,InputForm], "\"" -> ""];
		topSectors =
			ToString["top_level_sectors: " @@ Map["b" <> StringReplace[ToString[#,   InputForm], {"," | " " | "}" | "{" -> ""}] &, topSectorsRaw]];
		loopMomenta = ToString["loop_momenta: " @@ topo[[3]]];
		(*TODO: Cut propagators*)

		FCPrint[3,"KiraCreateConfigFiles: name: ", StandardForm[topoName], FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: top_level_sectors: ", StandardForm[topSectors], FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: loop_momenta: ", StandardForm[loopMomenta], FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: propagators: \n", StandardForm[propagators], FCDoControl->fpsfVerbose];


		(*
			==================================================================
								kinematics.yaml
			==================================================================
		*)

		extMomenta = DeleteDuplicates[Join[topo[[4]],optKiraImplicitIncomingMomenta]];

		Switch[Length[extMomenta],
			0,
				incomingMomenta = "incoming_momenta: []";
				outgoingMomenta = "outgoing_momenta: []";
				momentumConservation = "momentum_conservation: []",
			1,
				incomingMomenta = ToString["incoming_momenta: " @@ extMomenta];
				outgoingMomenta = ToString["outgoing_momenta: " @@ extMomenta];
				momentumConservation = "momentum_conservation: []",
			ii_Integer/;ii>1,
				incomingMomenta = ToString["incoming_momenta: " @@ extMomenta];
				outgoingMomenta = "outgoing_momenta: []";
				momentumConservation = ToString["momentum_conservation: " @@ {extMomenta[[1]], Total@(-extMomenta[[2 ;;]])}],
			_,
				Message[KiraCreateConfigFiles::failmsg, "Failed to resolve the number of external momenta."];
				Abort[]
		];


		fPar = FCFeynmanPrepare[topo, Names -> fp, FCI->True,FinalSubstitutions->topo[[5]]][[2]];
		vars = SelectFree[Variables2[fPar], fp, Pair, CartesianPair];

		FCPrint[3,"KiraCreateConfigFiles: Kinematic invariants: ", vars, FCDoControl->fpsfVerbose];

		If[	!MatchQ[vars/.optKiraMassDimensions,{___Integer}],
			Message[KiraCreateConfigFiles::failmsg, "The topology depends on kinematic invariants with unknown mass dimensions: " <>
			ToString[Cases[vars/.optKiraMassDimensions, x_ /; Head[x] =!= Integer, Infinity],InputForm]];
			Abort[]
		];

		kinematicInvariants = mdRule@@@optKiraMassDimensions;

		If[	!MatchQ[kinematicInvariants,{__String}],
			Message[KiraCreateConfigFiles::failmsg, "Failed to convert all the occurring mass dimensions rules to the KIRA notation: " <>
			ToString[Cases[kinematicInvariants, x_ /; Head[x] =!= String, Infinity],InputForm]];
			Abort[]
		];

		kinematicInvariants  = StringRiffle[kinematicInvariants, "\n    "];

		scalarProductRules = ExpandScalarProduct[SelectFree[FRH[topo[[5]]],{Polarization,TemporalMomentum}]];

		scalarProductRules = spRule[#,topo[[4]]]&/@scalarProductRules;

		scalarProductRules = scalarProductRules /. "" :> Unevaluated[Sequence[]];

		If[	!MatchQ[scalarProductRules,{__String}],
			Message[KiraCreateConfigFiles::failmsg, "Failed to convert all the occurring kinematic rules to the KIRA notation: " <>
			ToString[Cases[scalarProductRules, x_ /; Head[x] =!= String, Infinity],InputForm]
			];
			Abort[]
		];

		scalarProductRules  = StringRiffle[scalarProductRules, "\n    "];

		(*TODO: symbol_to_replace_by_one*)

		FCPrint[3,"KiraCreateConfigFiles: incoming_momenta: ", StandardForm[incomingMomenta], FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: outgoing_momenta: ", StandardForm[outgoingMomenta], FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: momentum_conservation: ", StandardForm[momentumConservation], FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: kinematic_invariants: \n", StandardForm[kinematicInvariants], FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: scalarproduct_rules: \n", StandardForm[scalarProductRules], FCDoControl->fpsfVerbose];

		(*
			==================================================================
								file output
			==================================================================
		*)



		(*TODO: More freedom here*)
		dir = FileNameJoin[{dirRaw,StringReplace[ToString[topoID,InputForm], "\"" -> ""],"config"}];

		If[	!DirectoryQ[dir],
			status = CreateDirectory[dir];
			If[	status===$Failed,
				Message[KiraCreateConfigFiles::failmsg, "Failed to create directory ", dir];
				Abort[]
			];
		];

		integralfamiliesPath = FileNameJoin[{dir,"integralfamilies.yaml"}];
		kinematicsPath = FileNameJoin[{dir,"kinematics.yaml"}];

		FCPrint[3,"KiraCreateConfigFiles: Path to integralfamilies.yaml: ", integralfamiliesPath, FCDoControl->fpsfVerbose];
		FCPrint[3,"KiraCreateConfigFiles: Path to kinematics.yaml: ", kinematicsPath, FCDoControl->fpsfVerbose];

		If[	FileExistsQ[integralfamiliesPath] && !optOverwriteTarget,
			Message[KiraCreateConfigFiles::failmsg, "The file ", integralfamiliesPath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		If[	FileExistsQ[kinematicsPath] && !optOverwriteTarget,
			Message[KiraCreateConfigFiles::failmsg, "The file ", kinematicsPath, " already exists and the option OverwriteTarget is set to False."];
			Abort[]
		];

		file = OpenWrite[integralfamiliesPath];
		If[	file===$Failed,
			Message[KiraCreateConfigFiles::failmsg, "Failed to open ", integralfamiliesPath, " for writing."];
			Abort[]
		];
		If[	OptionValue[DateString],
			WriteString[file, "# Generated on "<> DateString[] <>" \n\n"];
		];
		WriteString[file, "integralfamilies:\n"];
		WriteString[file, "  "<>topoName<>"\n"];
		WriteString[file, "    "<>loopMomenta<>"\n"];
		WriteString[file, "    "<>topSectors<>"\n"];
		WriteString[file, "    propagators:\n"];
		WriteString[file, "      "<>propagators<>"\n"];
		Close[file];



		file = OpenWrite[kinematicsPath];
		If[	file===$Failed,
			Message[KiraCreateConfigFiles::failmsg, "Failed to open ", kinematicsPath, " for writing."];
			Abort[]
		];
		If[	OptionValue[DateString],
			WriteString[file, "# Generated on "<> DateString[] <>" \n\n"];
		];
		WriteString[file, "kinematics:\n"];
		WriteString[file, "  "<>incomingMomenta<>"\n"];
		WriteString[file, "  "<>outgoingMomenta<>"\n"];
		WriteString[file, "  "<>momentumConservation<>"\n"];
		WriteString[file, "  kinematic_invariants:\n"];
		WriteString[file, "    "<>kinematicInvariants<>"\n"];
		WriteString[file, "  scalarproduct_rules:\n"];
		WriteString[file, "    "<>scalarProductRules<>"\n"];
		Close[file];




		{integralfamiliesPath, kinematicsPath}
	];

mdRule[a_Symbol, b_Integer]:=
	"- ["<>ToString[a, InputForm] <>", " <> ToString[b, InputForm] <>"]";

spRule[Rule[Pair[Momentum[a_, ___], Momentum[b_, ___]], rhs_], relevantMomenta_List]:=
	"- [ [ " <> ToString[a, InputForm] <> ", " <> ToString[b, InputForm] <> "],"<> ToString[rhs, InputForm] <>"]"/;
	MemberQ[relevantMomenta,a] && MemberQ[relevantMomenta,b];

spRule[Rule[Pair[Momentum[a_, ___], Momentum[b_, ___]], _], relevantMomenta_List]:=
	""/; !MemberQ[relevantMomenta,a] || !MemberQ[relevantMomenta,b];

fcProp[Pair[Momentum[a_, ___], Momentum[a_, ___]] - massSq_]:=
	kiraQuadraticProp[a, massSq];

fcProp[Pair[Momentum[a_, ___], Momentum[a_, ___]]]:=
	kiraQuadraticProp[a, 0];

fcProp[c_. Pair[Momentum[a_, ___], Momentum[b_, ___]] -  massSq_]:=
	kiraLinearProp[c a, b, massSq]/; a=!=b && IntegerQ[c];

fcProp[c_. Pair[Momentum[a_, ___], Momentum[b_, ___]] -  massSq_]:=
	kiraLinearProp[c a, b, massSq]/; a=!=b  && IntegerQ[c];

fcProp[c_. Pair[Momentum[a_, ___], Momentum[b_, ___]]] :=
	kiraLinearProp[c a, b, 0]/; a=!=b && IntegerQ[c];


End[]
