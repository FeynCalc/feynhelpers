(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: QGCommonInsertions												*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2023 Vladyslav Shtabovenko
*)

(* :Summary: 	Common insertions for polarization vectors, propagators
				and vertices that are suitable for the included QGRAF
				models														*)

(* ------------------------------------------------------------------------ *)

QGCommonInsertionsDimension::usage="";
QGCommonInsertionsGauge::usage="";

$QGCommonInsertionsExternalColors::usage="
$QGCommonInsertionsExternalColors specifies the colors of the external particles \
for the QGCommonInsertions set of insertion rules. For example, \ \n
$QGCommonInsertionsExternalColors = {{Q[p1], i}, {Q[p2], j}, {Gl[p3], a}} \ \n
will set the fundamental color indices of the external quarks Q[p1] and Q[p2] to \
i and j respectively, while the adjoint color index of the external gluon \
Gl[p3] will be set to a.";

$QGCommonInsertionsExternalLorentzIndices::usage="
$QGCommonInsertionsExternalLorentzIndices specifies the Lorent indices of truncated \
polarization vectors. For example, \ \n
$QGCommonInsertionsExternalLorentzIndices = {{Gl[p1], mu}, {Gl[p2], nu}} \ \n
will set the Lorentz indices of the truncated polarization vectors for the gluons \
Gl[p1] and Gl[p2] to mu and nu respectively.";

$QGCommonInsertionsStrongCouplingSign::usage="

$QGCommonInsertionsStrongCouplingSign specifies the sign of the strong coupling
constant g_s. The default value is -1 which is compatible with the convention \
used in the SM model of FeynArts. This convention is also used in \ \n \n

M. Boehm, A. Denner and H. Joos, Gauge Theories of the Strong and Electroweak Interactions \ \n
S. Pokorski, Gauge Fiekd Theories \ \n
J. Collins, Foundations of Perturbative QCD \ \n
R. K. Ellis, W. J. Stirling and B. R. Weber, QCD and Collider Physics \ \n \n

Setting this value to 1 will use the convention that is compatible with \ \n \n

M. E. Peskin and D. V. Schroeder, An Introduction to Quantum Field Theory \ \n

??Yndurain
??Narison
??Pascual Tarrach
??Muta";

$QGCommonInsertionsElectricChargeSign::usage="";

QGCommonInsertionsGauge = GaugeXi;



$QGCommonInsertionsExternalColors={};
$QGCommonInsertionsExternalLorentzIndices={};
$QGCommonInsertionsStrongCouplingSign=-1;
$QGCommonInsertionsElectricChargeSign=+1;


(*
$QGCommonInsertionsFeynmpParticleLabels::usage="";
$QGCommonInsertionsFeynmpParticleStlyes::usage="";


$QGCommonInsertionsFeynmpParticleLabels={
	"QGTEXPLOT_LABEL_El" -> "$e^-$",
	"QGTEXPLOT_LABEL_Ael" -> "$e^+$",
	"QGTEXPLOT_LABEL_Mu" -> "$\\mu^-$",
	"QGTEXPLOT_LABEL_Amu" -> "$\\mu^+$",
	"QGTEXPLOT_LABEL_Tau" -> "$\\tau^-$",
	"QGTEXPLOT_LABEL_Atau" -> "$\\tau^+$",
	"QGTEXPLOT_LABEL_Ga" -> "$\\gamma$"
	};
$QGCommonInsertionsFeynmpParticleStlyes={
	"QGTEXPLOT_STYLE_El" -> "fermion",
	"QGTEXPLOT_STYLE_Ael" -> "fermion",
	"QGTEXPLOT_STYLE_Mu" -> "fermion",
	"QGTEXPLOT_STYLE_Amu" -> "fermion",
	"QGTEXPLOT_STYLE_Tau" -> "fermion",
	"QGTEXPLOT_STYLE_Atau" -> "fermion",
	"QGTEXPLOT_STYLE_Ga" -> "photon"
};
*)

{

(* ---------------- Polarizations ---------------- *)

(* ++++++++++++++++ Truncated polarizations ++++++++++++++++ *)

QGTruncatedPolarization[x_[_, p_], _] :>
	1/; FreeQ[$QGCommonInsertionsExternalColors,x[p]] && FreeQ[$QGCommonInsertionsExternalLorentzIndices,x[p]],


(* ++++++++++++++++ Photon polarization ++++++++++++++++ *)

QGPolarization[Ga[i_, p_], 0] :>
	Pair[LorentzIndex[FCMakeIndex["QGILor",i],D], Momentum[Polarization[p, -(-1)^i I], D]],

QGTruncatedPolarization[Ga[i_, p_], 0] :>
	Block[{qglor},
		qglor = Last[Last[SelectNotFree[$QGCommonInsertionsExternalLorentzIndices,Ga[p]]]];
		MTD[qglor,FCMakeIndex["QGILor",i]]
	]/; !FreeQ[$QGCommonInsertionsExternalLorentzIndices,Ga[p]],

(* ++++++++++++++++ Gluon polarization ++++++++++++++++ *)

QGPolarization[Gl[i_, p_], 0] :>
	Pair[LorentzIndex[FCMakeIndex["QGILor",i],D], Momentum[Polarization[p, -(-1)^i I], D]]/;
		FreeQ[$QGCommonInsertionsExternalColors,Gl[p]],

(* specific color of the external gluon *)
QGPolarization[Gl[i_, p_], 0] :>
	Block[{qgcol},
		qgcol = Last[Last[SelectNotFree[$QGCommonInsertionsExternalColors,Gl[p]]]];
		Pair[LorentzIndex[FCMakeIndex["QGILor",i],D], Momentum[Polarization[p, -(-1)^i I], D]] *
		SUNDelta[qgcol,FCMakeIndex["QGICola",i]]
	]/; !FreeQ[$QGCommonInsertionsExternalColors,Gl[p]],

QGTruncatedPolarization[Gl[i_, p_], 0] :>
	Block[{qgcol,qglor},
		qgcol = SelectNotFree[$QGCommonInsertionsExternalColors,Gl[p]];
		qglor = SelectNotFree[$QGCommonInsertionsExternalLorentzIndices,Gl[p]];
		(
			If[	TrueQ[qgcol=!={}],
				qgcol = Last[Last[qgcol]];
				SUNDelta[qgcol,FCMakeIndex["QGICola",i]], 1
			] *
			If[	TrueQ[qglor=!={}],
				qglor = Last[Last[qglor]];
				MTD[qglor, FCMakeIndex["QGILor",i]], 1
			]
		)
	]/; !FreeQ[$QGCommonInsertionsExternalColors,Gl[p]] || !FreeQ[$QGCommonInsertionsExternalLorentzIndices,Gl[p]],

(* ++++++++++++++++ Incoming fermion (u spinor) polarization ++++++++++++++++ *)

QGPolarization[q_[i_, p_], mass_]/; MemberQ[{Q,Qi,Qj,El,Mu,Tau}, q] :>
	DCHN[FCMakeIndex["QGIDir",i], Spinor[Momentum[p, D], mass]]/;
		FreeQ[$QGCommonInsertionsExternalColors,q[p]] && OddQ[i],

(* specific color of the external quark *)
QGPolarization[q_[i_, p_], mass_]/; MemberQ[{Q,Qi,Qj}, q] :>
	Block[{qgcol},
		qgcol = Last[Last[SelectNotFree[$QGCommonInsertionsExternalColors,q[p]]]];
		DCHN[FCMakeIndex["QGIDir",i], Spinor[Momentum[p, D], mass]] *
		SUNFDelta[qgcol,FCMakeIndex["QGIColf",i]]
	]/; !FreeQ[$QGCommonInsertionsExternalColors,q[p]] && OddQ[i],

(* ++++++++++++++++ Outgoing fermion (ubar spinor) polarization ++++++++++++++++ *)

QGPolarization[q_[i_, p_], mass_]/; MemberQ[{Q,Qi,Qj,El,Mu,Tau}, q] :>
	DCHN[Spinor[Momentum[p, D], mass], FCMakeIndex["QGIDir",i]]/;
		FreeQ[$QGCommonInsertionsExternalColors,q[p]] && EvenQ[i],

(* specific color of the external quark *)
QGPolarization[q_[i_, p_], mass_]/; MemberQ[{Q,Qi,Qj}, q] :>
	Block[{qgcol},
		qgcol = Last[Last[SelectNotFree[$QGCommonInsertionsExternalColors,q[p]]]];
		DCHN[Spinor[Momentum[p, D], mass], FCMakeIndex["QGIDir",i]] *
		SUNFDelta[qgcol,FCMakeIndex["QGIColf",i]]
	]/; !FreeQ[$QGCommonInsertionsExternalColors,q[p]] && EvenQ[i],

(* ++++++++++++++++ Incoming antifermion (vbar spinor) polarization ++++++++++++++++ *)

QGPolarization[qbar_[i_, p_], mass_]/; MemberQ[{Qbar,Qibar,Qjbar,Ael,Amu,Atau}, qbar] :>
	DCHN[Spinor[-Momentum[p, D], mass], FCMakeIndex["QGIDir",i]]/;
		FreeQ[$QGCommonInsertionsExternalColors,qbar[p]] && OddQ[i],

(* specific color of the external antiquark *)
QGPolarization[qbar_[i_, p_], mass_]/; MemberQ[{Qbar,Qibar,Qjbar}, qbar] :>
	Block[{qgcol},
		qgcol = Last[Last[SelectNotFree[$QGCommonInsertionsExternalColors,qbar[p]]]];
		DCHN[Spinor[-Momentum[p, D], mass], FCMakeIndex["QGIDir",i]] *
		SUNFDelta[qgcol,FCMakeIndex["QGIColf",i]]
	]/; !FreeQ[$QGCommonInsertionsExternalColors,qbar[p]] && OddQ[i],

(* ++++++++++++++++ Outgoing antifermion (v spinor) polarization ++++++++++++++++ *)

QGPolarization[qbar_[i_, p_], mass_]/; MemberQ[{Qbar,Qibar,Qjbar,Ael,Amu,Atau}, qbar] :>
	DCHN[FCMakeIndex["QGIDir",i], Spinor[-Momentum[p, D], mass]]/;
		FreeQ[$QGCommonInsertionsExternalColors,qbar[p]] && EvenQ[i],

(* specific color of the external antiquark *)
QGPolarization[qbar_[i_, p_], mass_]/; MemberQ[{Qbar,Qibar,Qjbar}, qbar] :>
	Block[{qgcol},
		qgcol = Last[Last[SelectNotFree[$QGCommonInsertionsExternalColors,qbar[p]]]];
		DCHN[FCMakeIndex["QGIDir",i], Spinor[-Momentum[p, D], mass]] *
		SUNFDelta[qgcol,FCMakeIndex["QGIColf",i]]
	]/; !FreeQ[$QGCommonInsertionsExternalColors,qbar[p]] && EvenQ[i],

(* ++++++++++++++++ Truncated fermion or antifermion polarization ++++++++++++++++ *)

QGTruncatedPolarization[qqbar_[i_, p_], _]/; MemberQ[{Q,Qi,Qj,Qbar,Qibar,Qjbar}, q] :>
	Block[{qgcol},
		qgcol = Last[Last[SelectNotFree[$QGCommonInsertionsExternalColors,qqbar[p]]]];
		SUNFDelta[qgcol,FCMakeIndex["QGIColf",i]]
	]/; !FreeQ[$QGCommonInsertionsExternalColors,qqbar[p]],

(* ++++++++++++++++ Ghost polarization ++++++++++++++++ *)

(* Ghost external states *)
(QGPolarization|QGTruncatedPolarization)[(x: (Gh|Ghbar))[_, p_], 0] :>
	1/; FreeQ[$QGCommonInsertionsExternalColors,x[p]],

(* specific color of the external ghost *)
(QGPolarization|QGTruncatedPolarization)[(x: (Gh|Ghbar))[i_, p_], 0] :>
	Block[{qgcol},
		qgcol = Last[Last[SelectNotFree[$QGCommonInsertionsExternalColors,x[p]]]];
		SUNDelta[qgcol,FCMakeIndex["QGICola",i]]
	]/; !FreeQ[$QGCommonInsertionsExternalColors,x[p]],


(* ---------------- Propagators ---------------- *)

(* Quark propagator *)
QGPropagator[q_[i_, p_], qbar_[j_, _], mass_]/; MemberQ[{{Q, Qbar}, {Qi, Qibar}, {Qj, Qjbar}}, {q, qbar}] :>
	I SUNFDelta@@(FCMakeIndex["QGIColf",{i,j}]) DCHN[GSD[p]+mass,FCMakeIndex["QGIDir",i],FCMakeIndex["QGIDir",j]] FAD[{p, mass}],

(* Lepton propagator *)
QGPropagator[q_[i_, p_], qbar_[j_, _], mass_]/; MemberQ[{{El, Ael}, {Mu, Amu}, {Tau, Atau}}, {q, qbar}] :>
	I DCHN[GSD[p]+mass,FCMakeIndex["QGIDir",i],FCMakeIndex["QGIDir",j]] FAD[{p, mass}],


(* Gluon propagator *)
QGPropagator[Gl[i_, p_], Gl[j_, _], 0] :>
	-I SUNDelta@@(FCMakeIndex["QGICola",{i,j}]) (
		MTD@@(FCMakeIndex["QGILor",{i,j}]) FAD[{p,0}] - (1 - QGCommonInsertionsGauge) FVD[p,FCMakeIndex["QGILor",i]] FVD[p,FCMakeIndex["QGILor",j]] FAD[{p, 0, 2}]
	),

(* Photon propagator *)
QGPropagator[Ga[i_, p_], Ga[j_, _], 0] :>
	-I (MTD@@(FCMakeIndex["QGILor",{i,j}]) FAD[{p,0}] - (1 - QGCommonInsertionsGauge) FVD[p,FCMakeIndex["QGILor",i]] FVD[p,FCMakeIndex["QGILor",j]] FAD[{p, 0, 2}]),

(* Ghost propagator *)
QGPropagator[Gh[i_, x_], Ghbar[j_, _], 0] :>
	I SUNDelta@@(FCMakeIndex["QGICola",{i,j}]) FAD[{x, 0}],

(* ---------------- Vertices ---------------- *)
(* all the momenta are ingoing! *)

(* QCD 4-gluon vertex *)
QGVertex[Gl[i_, _], Gl[j_, _], Gl[k_, _], Gl[l_, _]] :>
	Block[{qgdummyIndex},
		qgdummyIndex = ToString[Unique["Dummy"]];

	-I SMP["g_s"]^2 (
		SUNF@@(FCMakeIndex["QGICola",{i,j,qgdummyIndex}]) SUNF@@(FCMakeIndex["QGICola",{k,l,qgdummyIndex}]) *
			(MTD@@(FCMakeIndex["QGILor",{i,k}]) MTD@@(FCMakeIndex["QGILor",{j,l}]) - MTD@@(FCMakeIndex["QGILor",{i,l}]) MTD@@(FCMakeIndex["QGILor",{j,k}])) +

		SUNF@@(FCMakeIndex["QGICola",{i,k,qgdummyIndex}]) SUNF@@(FCMakeIndex["QGICola",{j,l,qgdummyIndex}]) *
			(MTD@@(FCMakeIndex["QGILor",{i,j}]) MTD@@(FCMakeIndex["QGILor",{k,l}]) - MTD@@(FCMakeIndex["QGILor",{i,l}]) MTD@@(FCMakeIndex["QGILor",{j,k}])) +

		SUNF@@(FCMakeIndex["QGICola",{i,l,qgdummyIndex}]) SUNF@@(FCMakeIndex["QGICola",{j,k,qgdummyIndex}]) *
			(MTD@@(FCMakeIndex["QGILor",{i,j}]) MTD@@(FCMakeIndex["QGILor",{k,l}]) - MTD@@(FCMakeIndex["QGILor",{i,k}]) MTD@@(FCMakeIndex["QGILor",{j,l}])))
	],

(* QCD 3-gluon vertex *)
QGVertex[Gl[i_, p1_], Gl[j_, p2_], Gl[k_, p3_]] :>
	$QGCommonInsertionsStrongCouplingSign SMP["g_s"] SUNF[FCMakeIndex["QGICola",i], FCMakeIndex["QGICola",j], FCMakeIndex["QGICola",k]] (
			MTD[FCMakeIndex["QGILor",i], FCMakeIndex["QGILor",j]] FVD[p1 - p2, FCMakeIndex["QGILor",k]] +
			MTD[FCMakeIndex["QGILor",j], FCMakeIndex["QGILor",k]] FVD[p2 - p3, FCMakeIndex["QGILor",i]] +
			MTD[FCMakeIndex["QGILor",i], FCMakeIndex["QGILor",k]] FVD[p3 - p1, FCMakeIndex["QGILor",j]]
	),

(* QCD quark-gluon vertex *)
QGVertex[qbar_[i_, _], q_[j_, _], Gl[k_, _]]/; MemberQ[{{Q, Qbar}, {Qi, Qibar}, {Qj, Qjbar}}, {q, qbar}] :>
	I $QGCommonInsertionsStrongCouplingSign *
	SMP["g_s"] DCHN[GAD[FCMakeIndex["QGILor",k]],FCMakeIndex["QGIDir",i], FCMakeIndex["QGIDir",j]] SUNTF@@({FCMakeIndex["QGICola",k],FCMakeIndex["QGIColf",i],FCMakeIndex["QGIColf",j]}),

(* QCD gluon-ghost vertex *)
QGVertex[Ghbar[i_, p_], Gl[j_, _], Gh[k_, _]] :>
	- $QGCommonInsertionsStrongCouplingSign SMP["g_s"] SUNF@@(FCMakeIndex["QGICola",{i,j,k}]) (-FVD[p, FCMakeIndex["QGILor",j]]),

(* QED lepton-photon vertex *)
QGVertex[qbar_[i_, _], q_[j_, _], Ga[k_, _]]/; MemberQ[{{El, Ael}, {Mu, Amu}, {Tau, Atau}}, {q, qbar}] :>
	I $QGCommonInsertionsElectricChargeSign *
	SMP["e"] DCHN[GAD[FCMakeIndex["QGILor",k]],FCMakeIndex["QGIDir",i], FCMakeIndex["QGIDir",j]],

(* QED quark-photon vertex *)
QGVertex[qbar_[i_, _], q_[j_, _], Ga[k_, _]]/; MemberQ[{{Qi, Qibar}}, {q, qbar}] :>
	I QuarkQ *
	SMP["e"] DCHN[GAD[FCMakeIndex["QGILor",k]],FCMakeIndex["QGIDir",i], FCMakeIndex["QGIDir",j]]

}
