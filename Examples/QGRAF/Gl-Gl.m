(* ::Package:: *)

(* :Title: Gl-Gl														  *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2014-2024 Vladyslav Shtabovenko
*)

(* :Summary:  Gl -> Gl, QCD, 2-loops										*)

(* ------------------------------------------------------------------------ *)



(* ::Title:: *)
(*Gluon self-energy*)


(* ::Section:: *)
(*Load FeynCalc and the necessary add-ons or other packages*)


description="Gl -> Gl, QCD, 2-loops";
If[ $FrontEnd === Null,
	$FeynCalcStartupMessages = False;
	Print[description];
];
If[ $Notebooks === False,
	$FeynCalcStartupMessages = False
];
$LoadAddOns={"FeynHelpers"};
<<FeynCalc`

FCCheckVersion[10,0,0];


(* ::Section:: *)
(*Generate Feynman diagrams*)


qgModel="QCDOneFlavor";


qgOutput=QGCreateAmp[2,{"Gl[p]"}->{"Gl[p]"},QGModel->qgModel,
QGLoopMomentum->l,QGOptions->{"notadpole","onshell"},
QGOutputDirectory->FileNameJoin[{$FeynCalcDirectory,"Database","GlToGlAt2L"}]];


tikzStyles=QGTZFCreateFieldStyles[qgModel,qgOutput,
QGFieldStyles->{{"Gl","gluon","g"},
{"Gh","fermion","c"},
{"Ghbar","anti fermion","\\bar{c}"},
{"Q","fermion","q"},
{"Qbar","anti fermion","\\bar{q}"}}];


QGTZFCreateTeXFiles[qgOutput,Split->True];


QGLoadInsertions["QGCommonInsertions.m"];


amps=QGConvertToFC[qgOutput,DiracChainJoin->True];


amps[[1]]
