(* ::Package:: *)

(* :Title: QEDRenormalizationOneLoop                                       *)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2020 Rolf Mertig
	Copyright (C) 1997-2020 Frederik Orellana
	Copyright (C) 2014-2020 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the QED renormalization constants at 1-loop  *)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*QED Renormalization at  1-loop*)


(* ::Text:: *)
(*This example uses custom QED model created with FeynRules. Please evaluate the file*)
(*FeynCalc/Examples/FeynRules/QED/GenerateModelQED.m before running it for the first time*)


(* ::Subsection:: *)
(*Load FeynCalc, FeynArts and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the QED renormalization constants at 1-loop"];
];
$LoadAddOns={"FeynArts","FeynHelpers"};
<< FeynCalc`
$FAVerbose = 0


(* ::Subsection:: *)
(*Important options*)


FAPatch[PatchModelsOnly->True];
$KeepLogDivergentScalelessIntegrals=True;


(* ::Subsection:: *)
(*Generate the diagrams*)


params={InsertionLevel->{Particles},Model -> FileNameJoin[{"QED","QED"}],
GenericModel -> FileNameJoin[{"QED","QED"}],ExcludeParticles->{F[2,{2|3}]}};
top[i_,j_]:=CreateTopologies[1, i -> j,
ExcludeTopologies -> {Tadpoles,WFCorrections,WFCorrectionCTs}];
topCT[i_,j_]:=CreateCTTopologies[1, i ->j,
ExcludeTopologies ->{Tadpoles,WFCorrections,WFCorrectionCTs}];

{diagElectronSE,diagElectronSECT} = InsertFields[#, {F[2,{1}]} -> {F[2,{1}]},
Sequence@@params]&/@{top[1,1],topCT[1,1]};
{diagPhotonSE,diagPhotonSECT} = InsertFields[#, {V[1]} -> {V[1]},
Sequence@@params]&/@{top[1,1],topCT[1,1]};
{diagVertex,diagVertexCT} = InsertFields[#,  {F[2,{1}],V[1]}->{F[2,{1}]},
Sequence@@params]&/@{top[2,1],topCT[2,1]};


Paint[diagElectronSE, ColumnsXRows -> {1, 1},SheetHeader->None,
Numbering -> None,ImageSize->{256,256}];
Paint[diagElectronSECT, ColumnsXRows -> {1, 1},SheetHeader->None,
Numbering -> None,ImageSize->{256,256}];
Paint[diagPhotonSE, ColumnsXRows -> {1, 1},SheetHeader->None,
Numbering -> None,ImageSize->{256,256}];
Paint[diagPhotonSECT, ColumnsXRows -> {1, 1},SheetHeader->None,
Numbering -> None,ImageSize->{256,256}];
Paint[diagVertex, ColumnsXRows -> {1, 1},SheetHeader->None,
Numbering -> None,ImageSize->{256,256}];
Paint[diagVertexCT, ColumnsXRows -> {1, 1},SheetHeader->None,
Numbering -> None,ImageSize->{256,256}];


(* ::Subsection:: *)
(*Electron self-energy*)


(* ::Text:: *)
(*First of all we need to generate the amplitudes and convert them into FeynCalc notation. We choose l to be the loop momentum and p the external momentum.*)


{ampElectronSE,ampElectronSECT}=Contract[FCFAConvert[CreateFeynAmp[#, Truncated -> True,PreFactor->1,
GaugeRules->{}],IncomingMomenta->{p}, OutgoingMomenta->{p},LoopMomenta->{l},DropSumOver->True,
UndoChiralSplittings->True,ChangeDimension->D,List->False,SMP->True, FinalSubstitutions->{Zm->SMP["Z_m"],
Zpsi->SMP["Z_psi"],SMP["e"]->Sqrt[4Pi SMP["alpha_fs"]]}]]&/@{diagElectronSE,diagElectronSECT}


(* ::Text:: *)
(*Tensor reduction allows us to express the electron self-energy in tems of the Passarino-Veltman coefficient functions.*)


ampElectronSE1=TID[ampElectronSE,l,ToPaVe->True]//DiracSimplify


(* ::Text:: *)
(*With PaxEvaluateUVIRSplit we obtain the full analytic result for the self-energy diagram*)


ampElectronSE2=PaXEvaluateUVIRSplit[ampElectronSE1,PaXImplicitPrefactor->1/(2Pi)^D]//Collect2[#,DiracGamma]&//FCHideEpsilon


(* ::Text:: *)
(*This is the amplitude for the self-energy counter-term*)


ampElectronSECT2=ampElectronSECT//ReplaceAll[#,{SMP["Z_psi"]->1+alpha SMP["d_psi"],
SMP["Z_m"]->1+alpha SMP["d_m"]}]&//Series[#,{alpha,0,1}]&//Normal//ReplaceAll[#,alpha->1]&


(* ::Text:: *)
(*Now we add the 1-loop SE diagram and the SE counter-term and discard all the finite pieces*)


tmp[1]=SelectNotFree2[(ampElectronSECT2+ampElectronSE2),{SMP["Delta_UV"],SMP["Delta_IR"],SMP["d_m"],SMP["d_psi"]}]


(* ::Text:: *)
(*Equating our result to zero and solving for d_psi and d_m we obtain  the renormalization constants in the minimal subtraction schemes.*)


sol[1]=Solve[SelectNotFree2[tmp[1], DiracGamma]==0,SMP["d_psi"]]//Flatten//Simplify;
sol[2]=Solve[(SelectFree2[tmp[1], DiracGamma]==0)/.sol[1],SMP["d_m"]]//Flatten//Simplify;
solMS=Join[sol[1],sol[2]]/.{SMP["d_psi"]->SMP["d_psi^MS"],SMP["d_m"]->SMP["d_m^MS"],SMP["Delta_UV"]->1/EpsilonUV}
solMSbar=Join[sol[1],sol[2]]/.{SMP["d_psi"]->SMP["d_psi^MSbar"],SMP["d_m"]->SMP["d_m^MSbar"]}


(* ::Text:: *)
(*For the on-shell scheme it is convenient to define the scalar product p.p as psq, since we will need to expand in this quantity*)


FCClearScalarProducts[];
SPD[p,p]=psq;


(* ::Text:: *)
(*It is also convenient to split the self-energy into a scalar (SigmaS) and a vector (SigmaV) part.*)


SigmaS=Simplify[Cancel[SelectFree2[ampElectronSE1,DiracGamma]/(SMP["m_e"]I)]]


SigmaV=Simplify[Cancel[SelectNotFree2[ampElectronSE1,DiracGamma]/(FCI[GSD[p]]I)]]


(* ::Text:: *)
(*According to the on-shell renormalization condition, the mass renormalization constant is given by the sum of SigmaS and SigmaV evaluated at p.p =0*)


solOS={SMP["d_m^OS"]->FCHideEpsilon[PaXEvaluateUVIRSplit[SigmaS+SigmaV,PaXImplicitPrefactor->1/(2Pi)^D,
PaXSeries->{{psq,SMP["m_e"]^2,0}},PaXAnalytic->True,FCVerbose->0]]//
FCFactorOut[#,(-3/(4Pi)SMP["alpha_fs"])]&}


(* ::Text:: *)
(*For the wave-function renormalization constant we need the derivative of SigmaS+SigmaV evaluated at p.p=0*)


tmp[2]=Simplify[(PaXEvaluateUVIRSplit[SigmaS+SigmaV,PaXImplicitPrefactor->1/(2Pi)^D,PaXSeries->{{psq,SMP["m_e"]^2,1}},
PaXAnalytic->True,FCVerbose->0]-PaXEvaluateUVIRSplit[SigmaS+SigmaV,PaXImplicitPrefactor->1/(2Pi)^D,
PaXSeries->{{psq,SMP["m_e"]^2,0}},PaXAnalytic->True,FCVerbose->0])/(psq-SMP["m_e"]^2)]//FCHideEpsilon


(* ::Text:: *)
(*as well as SigmaV at p.p=0*)


tmp[3]=PaXEvaluateUVIRSplit[SigmaV,PaXImplicitPrefactor->1/(2Pi)^D,
PaXSeries->{{psq,SMP["m_e"]^2,0}},PaXAnalytic->True]//FCHideEpsilon


(* ::Text:: *)
(*Combining both pieces we can determine Subscript[\[Delta], \[Psi]] in the on-shell scheme*)


aux={SMP["d_psi^OS"]->Simplify[-tmp[3]-2SMP["m_e"]^2 tmp[2]]}
solOS=Union[Join[solOS,aux]];


(* ::Subsection:: *)
(*Photon self-energy*)


(* ::Text:: *)
(*Again, first we obtain the amplitudes*)


{ampPhotonSE,ampPhotonSECT}=FCTraceFactor[Contract[FCFAConvert[CreateFeynAmp[#, Truncated -> True,
PreFactor->1,GaugeRules->{}],IncomingMomenta->{q},OutgoingMomenta->{q},LoopMomenta->{l},
DropSumOver->True,UndoChiralSplittings->True,ChangeDimension->D,List->False,SMP->True,
FinalSubstitutions->{ZA->SMP["Z_A"],Zpsi->SMP["Z_psi"],Zxi->SMP["Z_xi"],
SMP["e"]->Sqrt[4Pi SMP["alpha_fs"]]}]]]&/@{diagPhotonSE,diagPhotonSECT}


(* ::Text:: *)
(*then we do the tensor decomposition*)


ampPhotonSE1=TID[ampPhotonSE,l,ToPaVe->True]


(* ::Text:: *)
(*and finally obtain the explicit results.*)


ampPhotonSE2=PaXEvaluateUVIRSplit[ampPhotonSE1,PaXImplicitPrefactor->1/(2Pi)^D]//FCHideEpsilon


(* ::Text:: *)
(*This is the counter-term amplitude*)


ampPhotonSECT2=ampPhotonSECT//ReplaceRepeated[#,{SMP["Z_xi"]->SMP["Z_A"],
SMP["Z_A"]->1+alpha SMP["d_A"]}]&//Normal//ReplaceAll[#,alpha->1]&


(* ::Text:: *)
(*Now we add the 1-loop SE diagram and the SE counter-term and discard all the finite pieces*)


tmp[4]=(ampPhotonSECT2+ampPhotonSE2)//SelectNotFree2[#,{SMP["Delta_UV"],SMP["d_A"]}]&//Simplify


(* ::Text:: *)
(*Equating this to zero and solving for d_A we obtain the wave-function renormalization constant for the photon in the minimal subtraction schemes.*)


sol[3]=Solve[tmp[4]==0,SMP["d_A"]]//Flatten;
tmp[5]=sol[3]/.{SMP["d_A"]->SMP["d_A^MS"],SMP["Delta_UV"]->1/EpsilonUV}
solMS=Union[Join[solMS,tmp[5]]];
tmp[6]=sol[3]/.{SMP["d_A"]->SMP["d_A^MSbar"]}
solMSbar=Union[Join[solMSbar,tmp[6]]];


SPD[q,q]=qsq;


(* ::Text:: *)
(*Here we extract Pi(q^2)*)


tmp[7]=(ampPhotonSE1//Simplify)/(-I FCI[qsq MTD[Lor1,Lor2]-FVD[q,Lor1]FVD[q,Lor2]])


(* ::Text:: *)
(*This is the derivative of  Pi(q^2) evaluated at q^2 = 0*)


tmp[8]=FCHideEpsilon[(PaXEvaluateUVIRSplit[qsq tmp[7],PaXImplicitPrefactor->1/(2Pi)^D,
PaXSeries->{{qsq,0,1}},PaXAnalytic->True]/qsq)-PaXEvaluateUVIRSplit[qsq tmp3,
PaXImplicitPrefactor->1/(2Pi)^D,PaXSeries->{{qsq,0,0}},PaXAnalytic->True]]


(* ::Text:: *)
(*and from here we obtain d_A in the on-shell scheme*)


tmp[9]={SMP["d_A^OS"]->-FCFactorOut[tmp[8],SMP["alpha_fs"]/(3Pi)]}
solOS=Union[Join[solOS,tmp[9]]];


(* ::Subsection:: *)
(*Electron-photon vertex*)


(* ::Text:: *)
(*The last piece is the vertex diagram*)


{ampVertex,ampVertexCT}=Contract[FCFAConvert[CreateFeynAmp[#, Truncated -> True,PreFactor->1,
GaugeRules->{}],IncomingMomenta->{p1,k},OutgoingMomenta->{p2},LoopMomenta->{l},DropSumOver->True,
UndoChiralSplittings->True,ChangeDimension->D,List->False,SMP->True,
FinalSubstitutions->{k->p2-p1,ZA->SMP["Z_A"],Zpsi->SMP["Z_psi"],
Ze->SMP["Z_e"]}]&/@{diagVertex,diagVertexCT}]//ReplaceAll[#,SMP["e"]^3->4Pi SMP["alpha_fs"]SMP["e"]]&


(* ::Text:: *)
(*The result of the tensor reduction is quite large, since we keep the full gauge dependence and do not specify the kinematics*)


ampVertex1=TID[ampVertex,l,ToPaVe->True,UsePaVeBasis->True]


(* ::Text:: *)
(*As we are interested in the UV piece only, there is no need to obtain the full analytic result*)


tmp[10]=PaXEvaluateUV[ampVertex1,PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*This is the amplitude from the counter-term vertex*)


ampVertexCT2=Normal[Series[ampVertexCT/.{SMP["Z_A"]->1+alpha SMP["d_A"],
SMP["Z_e"]->1+alpha SMP["d_e"],SMP["Z_psi"]->1+alpha SMP["d_psi"]},{alpha,0,1}]]/.alpha->1


(* ::Text:: *)
(*Adding both amplitudes and equating them to zero gives*)


tmp[11]=(Cancel[(tmp[10]+ampVertexCT2)/(-FCI [I SMP["e"] GAD[Lor1]])]//Simplify)==0


(* ::Text:: *)
(*After plugging in d_Psi and d_m that were determined previously, we can confirm Ward's identity which fixes the relation between d_A and d_e*)


Simplify[tmp[11]/.{SMP["d_psi"]->SMP["d_psi^MS"]}/.solMS]


Simplify[tmp[11]/.EpsilonUV->1/SMP["Delta_UV"]/.{SMP["d_psi"]->SMP["d_psi^MSbar"]}/.solMSbar]


(* ::Text:: *)
(*Finally, we want to look at the vertex in the on-shell scheme*)


FCClearScalarProducts[];
SPD[p1,p1]=SMP["m_e"]^2;
SPD[p2,p2]=SMP["m_e"]^2;


(* ::Text:: *)
(*Here we sandwich the amplitude between two spinors with 4-momenta p1 and p2.*)


tmp[12]=SpinorUBarD[p2,SMP["m_e"]].ampVertex.SpinorUD[p1,SMP["m_e"]]//TID[#,
l,UsePaVeBasis->True,ToPaVe->True]&//DiracSimplify;


(* ::Text:: *)
(*Collecting the terms *)


tmp[13]=(ExpandScalarProduct[tmp[12]]/.FCI@FVD[p1,Lor1]->FCI[FVD[p1p2,Lor1]-FVD[p2,Lor1]])//
Collect2[#,LorentzIndex]&


(* ::Text:: *)
(*and applying Gordon decomposition we can bring the expression to the form dictated by the Lorentz covariance.*)


tmp[14]=(1/(SMP["e"] I)tmp[13]/.{FCI[FVD[p1p2,i_]SpinorUBarD[p2,m_].SpinorUBarD[p1,m_]]:>
FCI[SpinorUBarD[p2,m].(2m GAD[i]-I DiracSigma[GAD[i],GSD[p2-p1]]).SpinorUD[p1,m]]})//
DotSimplify//Collect2[#,LorentzIndex]&;


(* ::Text:: *)
(*This is  F_2(0)*)


tmp[15]=Simplify[SelectNotFree2[tmp[14],DiracSigma]/
FCI[I/(2SMP["m_e"])SpinorUBarD[p2,SMP["m_e"]].DiracSigma[GAD[Lor1],GSD[p2-p1]].SpinorUBarD[p1,SMP["m_e"]]]]


(* ::Text:: *)
(*its explicit value reproduces the beautiful result by Schwinger for (g-2)/2*)


PaXEvaluateUVIRSplit[tmp[15]/.{FCI[SPD[p1,p2]]->SMP["m_e"]^2},PaXImplicitPrefactor->1/(2Pi)^D]


(* ::Text:: *)
(*We need F_1(0) to recover the on-shell renormalization condition*)


tmp[16]=Cancel[DotSimplify[(tmp[14]/.p2->p1)]/FCI[SpinorUBarD[p1,SMP["m_e"]]. GAD[Lor1].SpinorUD[p1,SMP["m_e"]]]]


tmp[17]=PaXEvaluateUVIRSplit[tmp[16],PaXImplicitPrefactor->1/(2Pi)^D,PaXAnalytic->True]//FCHideEpsilon


(* ::Text:: *)
(*Adding things up we again confirm Ward's identity, this time in the on-shell scheme*)


Simplify[((tmp[17]+(ampVertexCT2/(I SMP["e"]FCI[GAD[Lor1]])))/.{SMP["d_psi"]->SMP["d_psi^OS"]}/.solOS)==0]


(* ::Text:: *)
(*At the end we summarize our results*)


solOS//TableForm


solMS//TableForm


solMSbar//TableForm


(* ::Subsection:: *)
(*Check with the literature*)


solOSLit={SMP["d_A^OS"] -> -(SMP["alpha_fs"]*(Log[ScaleMu^2/SMP["m_e"]^2] + SMP["Delta_UV"]))/(3*Pi), 
 SMP["d_m^OS"] -> -(SMP["alpha_fs"]*(4 + 3*Log[ScaleMu^2/SMP["m_e"]^2] + 3*SMP["Delta_UV"]))/(4*Pi), 
 SMP["d_psi^OS"] -> -(SMP["alpha_fs"]*(4 + 3*Log[ScaleMu^2/SMP["m_e"]^2] - (-3 + GaugeXi[V[1]])*SMP["Delta_IR"] + 
      GaugeXi[V[1]]*SMP["Delta_UV"]))/(4*Pi)};
solMSLit={SMP["d_A^MS"] -> -SMP["alpha_fs"]/(3*EpsilonUV*Pi), SMP["d_m^MS"] -> (-3*SMP["alpha_fs"])/(4*EpsilonUV*Pi), 
 SMP["d_psi^MS"] -> -(GaugeXi[V[1]]*SMP["alpha_fs"])/(4*EpsilonUV*Pi)};
solMSbarLit={SMP["d_A^MSbar"] -> -(SMP["alpha_fs"]*SMP["Delta_UV"])/(3*Pi), SMP["d_m^MSbar"] -> (-3*SMP["alpha_fs"]*SMP["Delta_UV"])/(4*Pi), 
 SMP["d_psi^MSbar"] -> -(GaugeXi[V[1]]*SMP["alpha_fs"]*SMP["Delta_UV"])/(4*Pi)};


Print["Check with the literature: ", If[Union[Flatten[{solOS-solOSLit,solMS-solMSLit,solMSbar-solMSbarLit}]]==={0},
		"CORRECT.", "!!! WRONG !!!"]];
