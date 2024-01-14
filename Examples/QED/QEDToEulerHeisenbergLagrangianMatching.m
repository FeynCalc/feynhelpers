(* ::Package:: *)

(* :Title: QEDToEulerHeisenbergLagrangianMatching                   *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2024 Rolf Mertig
	Copyright (C) 1997-2024 Frederik Orellana
	Copyright (C) 2014-2024 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the matching coefficients in the
			  Euler-Heisenberg Lagrangian                          *)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*QED to Euler-Heisenberg Lagrangian matching*)


(* ::Text:: *)
(*This example uses custom Euler-Heisenberg-Lagrangian model created with FeynRules. Please evaluate the file*)
(*FeynCalc/Examples/FeynRules/EulerHeisenberg/EulerHeisenberg.m before running it for the first time*)


(* ::Subsection:: *)
(*Load FeynCalc and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the matching coefficients in the Euler-Heisenberg Lagrangian"];
];
$LoadAddOns={"FeynArts","FeynHelpers"};
<< FeynCalc`
$FAVerbose=0;


(* ::Subsection:: *)
(*Important options*)


FAPatch[PatchModelsOnly->True];


(* ::Subsection:: *)
(*Generate the diagrams*)


(* ::Text:: *)
(*4-photon scattering diagrams in full QED*)


Paint[diags1 = InsertFields[CreateTopologies[1,2 -> 2 ], {V[1],V[1]} -> {V[1],V[1]},
		InsertionLevel -> {Particles},ExcludeParticles->{S[1],S[2],S[3],V[2],V[3],F[3],F[4],
		U[1],U[2],U[3],U[4],F[2,{2}],F[2,{3}]}], ColumnsXRows -> {3, 2},
		SheetHeader -> False,  Numbering -> None,ImageSize->{768,512}];


(* ::Text:: *)
(*4-photon scattering diagram in the Euler-Heisenberg Lagrangian*)


Paint[diags2=InsertFields[CreateTopologies[0,2 -> 2],{V[1],V[1]} -> {V[1],V[1]},
InsertionLevel -> {Classes},Model -> FileNameJoin[{"EulerHeisenberg","EulerHeisenberg"}],
GenericModel->FileNameJoin[{"EulerHeisenberg","EulerHeisenberg"}]], ColumnsXRows -> {1, 1},
		SheetHeader -> False,  Numbering -> None,ImageSize->{512,256}];


(* ::Subsection:: *)
(*Kinematics*)


(* ::Text:: *)
(*Following A. Grozin's lecture notes (arXiv:0908.4392), for matching we consider on-shell forward scattering, i.e p1=p3, p2=p4.*)
(*In this case our small expansion parameter is the relative momentum (p1-p2) = 2 p1.p2 << m_e*)


FCClearScalarProducts[];
SPD[p1,p1]=0;
SPD[p2,p2]=0;
SPD[p1,p2]=p1p2;


(* ::Subsection:: *)
(*Scattering amplitudes*)


ampsQED=FCFAConvert[CreateFeynAmp[diags1, Truncated -> True,GaugeRules->{},PreFactor->1],
IncomingMomenta->{p1,p2},OutgoingMomenta->{p1,p2},LoopMomenta->{k},UndoChiralSplittings->True,
ChangeDimension->D,List->False,SMP->True,List->False]//FCTraceFactor


ampsEH=FCFAConvert[CreateFeynAmp[diags2, Truncated -> True,GaugeRules->{},PreFactor->1],
IncomingMomenta->{p1,p2},OutgoingMomenta->{p1,p2},UndoChiralSplittings->True,
ChangeDimension->D,List->False,SMP->True,List->False]//Collect2[#,{c1,c2}]&


(* ::Subsubsection:: *)
(*Matching*)


(* ::Text:: *)
(*Our goal is to determine the matching coefficients c1 and 2. Following Grozin, the simplest way to do so is to write the matching condition as *)
(*a tensor equation T_QED^{mu nu rho si} = c1 T_1^{mu nu rho si} + c2 T_2^{mu nu rho si}, where on the left hand side we have the QED amplitude*)
(*and on the right hand side the amplitude in the Euler-Heisenberg EFT. The QED amplitude needs to be expanded up to 2 order in p1.p2 By contracting *)
(*this equation with g^{mu nu}  g^{rho si} and g^{mu rho}  g^{nu si} we can determine the values of c1 and c2.*)


Eq1EH=Contract[ampsEH MTD[Lor1,Lor2]MTD[Lor3,Lor4]]
Eq2EH=Contract[ampsEH MTD[Lor1,Lor3]MTD[Lor2,Lor4]]
Eq1QED=(((ampsQED MTD[Lor1,Lor2]MTD[Lor3,Lor4])//Contract)/.DiracTrace->Tr);
Eq2QED=(((ampsQED MTD[Lor1,Lor3]MTD[Lor2,Lor4])//Contract)/.DiracTrace->Tr);


(Eq1EH/.D->4)//Collect2[#,c1,c2,FCFactorOut-> p1p2^2 32 I/SMP["m_e"]^4]&
(Eq2EH/.D->4)//Collect2[#,c1,c2,FCFactorOut-> p1p2^2 32I/SMP["m_e"]^4]&


(* ::Text:: *)
(*With FeynHelpers the matching on the QED side is straightforward. First we do the tensor decomposition*)


Eq1QEDeval1=TID[Eq1QED,k];
Eq2QEDeval1=TID[Eq2QED,k];


(* ::Text:: *)
(*and then the expansion*)


rule={FCI[FAD[{k,SMP["m_e"]},{k-p2,SMP["m_e"]}]]->FCI[FAD[{k,SMP["m_e"]},{k,SMP["m_e"]}]],
FCI[FAD[{k,SMP["m_e"],2},{k-p2,SMP["m_e"]}]]->FCI[FAD[{k,SMP["m_e"],2},{k,SMP["m_e"]}]],
FCI[FAD[{k,SMP["m_e"]},{k-p1,SMP["m_e"]}]]->FCI[FAD[{k,SMP["m_e"]},{k,SMP["m_e"]}]],
FCI[FAD[{k,SMP["m_e"],2},{k-p1,SMP["m_e"]}]]->FCI[FAD[{k,SMP["m_e"],2},{k,SMP["m_e"]}]]
}


tmp1=FIREBurn[Eq1QEDeval1,{k},{p1,p2},FCLoopIBPReducableQ->True]//FDS[#,k]&;
tmp2=FIREBurn[Eq2QEDeval1/.rule,{k},{p1,p2},FCLoopIBPReducableQ->True]//FDS[#,k]&;


tmp11=ToPaVe[tmp1,k]//FCFactorOut[#,8 I/p1p2 Pi^2 SMP["e"]^4,Head->hold]&//
ReplaceAll[#,hold[x_]:>Collect2[ExpandAll[x],FeynCalc`Package`PaVeHeadsList,Factoring->Simplify]]&


tmp22=ToPaVe[tmp2,k]//FCFactorOut[#,-8 I/p1p2 Pi^2 SMP["e"]^4,Head->hold]&//
ReplaceAll[#,hold[x_]:>Collect2[ExpandAll[x],FeynCalc`Package`PaVeHeadsList,Factoring->FullSimplify]]&


list=Cases2[FCLoopIsolate[tmp11,{},Head->loop],loop]


(Collect2[PaXEvaluateUVIRSplit[-32 SMP["m_e"]^2 Pi^4 #,k,PaXSeries->{{p1p2,0,3}},PaXImplicitPrefactor->1/(2Pi)^D]//FCHideEpsilon,{p1p2}])&/@(list/.(loop->Identity))//TableForm


Eq1QEDeval2=PaXEvaluate[tmp11,k,PaXSeries->{{p1p2,0,2}},PaXImplicitPrefactor->1/(2Pi)^D]
Eq2QEDeval2=PaXEvaluate[tmp22,k,PaXSeries->{{p1p2,0,2}},PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*Since the result is finite for Epsilon->0, we may also set D=4 on the Euler-Heisenberg EFT side. Solving the linear system yields.*)


sols=Solve[{(Eq1EH/.D->4)==Eq1QEDeval2,
(Eq2EH/.D->4)==Eq2QEDeval2},{c1,c2}]/. SMP["e"]^4->(4Pi SMP["alpha_fs"])^2


(* ::Text:: *)
(*These are the famous results that were originally obtained by Euler and Heisenberg.*)


coeff1=(c1/.First[sols])
coeff2=(c2/.First[sols])


coeff1Pich=-SMP["alpha_fs"]^2/36;
coeff2Pich=(7*SMP["alpha_fs"]^2)/90;
Print["Check with Pich, arXiv:hep-ph/9806303, Eq 2.2: ",
 If[{coeff1Pich,coeff2Pich}-{coeff1,coeff2}==={0,0},
		"CORRECT.", "!!! WRONG !!!"]];
