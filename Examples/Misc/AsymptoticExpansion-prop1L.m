(* ::Package:: *)

(* :Title: AsymptoticExpansion-prop1L								*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 1990-2024 Rolf Mertig
	Copyright (C) 1997-2024 Frederik Orellana
	Copyright (C) 2014-2024 Vladyslav Shtabovenko
*)

(* :Summary: Asymptotic expansion of a 1L propagator type integral in
			 m^2/q^2. *)

(* ------------------------------------------------------------------------ *)



(* ::Section:: *)
(*Load FeynCalc and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of a particular loop integral that enters the decay of a Higgs into two photons, as explained by S. Weinzierl"];
];
If[$Notebooks === False, $FeynCalcStartupMessages = False];
$LoadAddOns={"FeynHelpers"};
<<FeynCalc`
$FAVerbose = 0;


(* ::Section:: *)
(*Load asy*)


Get["asy21.m"]
SetOptions[QHull,Executable->"/usr/bin/qhull"];


(* ::Section:: *)
(*Define the integral*)


intRaw=SFAD[{l,m1^2},{l+q,m1^2}]


kinematics={SPD[q]->m2^2}


{int,topo}=FCLoopFindTopologies[intRaw,{l},FinalSubstitutions->kinematics,Head->Identity,Names->prop1L];
topo=First[topo]
id=topo[[1]]


(* ::Text:: *)
(*We will use the variable la for our asymptotic expansion*)


DataType[la,FCVariable]=True;


(* ::Text:: *)
(*The expansion will be done up to 4th order in m1/m2*)


laPower=4;


(* ::Text:: *)
(*We will put the reductions to this directory*)


fireFCDir=FileNameJoin[{NotebookDirectory[],"FIRE"}];


Quiet[CreateDirectory[FileNameJoin[{fireFCDir,"FinalMasters"}]]];


Quiet[CreateDirectory[FileNameJoin[{ParentDirectory[fireFCDir],"FinalExpressions",ToString@FCLoopGLIToSymbol[int]}]]];


(* ::Section:: *)
(*Visualize the integral (if possible, optional)*)


SetOptions[FCLoopGraphPlot, GraphPlot-> {MultiedgeStyle->0.35,Frame->True},Style->{
{"InternalLine",_,_,mm_/;!FreeQ[mm,m]}->{Black,Thick}
}];


FCLoopGraphPlot[FCLoopIntegralToGraph[int,topo]]


(* ::Section:: *)
(*Use asy to reveal the contributing regions*)


propsFC=FCLoopIntegralToPropagators[FCLoopFromGLI[int,topo],topo[[3]],Negative->True]
propsAsy=FCE[FeynAmpDenominatorExplicit[%,Head->Function[x,1/x]]]/.SPD->Times


asyOutput=AlphaRepExpand[{l},propsAsy,{q^2->m2^2},{m2->x^0,m1->x^1},Verbose->False]
asyRescaling=Abs[(Min/@asyOutput)];
asyFinal=MapThread[(#1+#2)&,{asyOutput,asyRescaling}]


(* ::Text:: *)
(*To be able to expand in 4-momenta and masses we need to shift the loop momentum accordingly in each region*)


(* ::Text:: *)
(*1st region: l ~ m1*)


momShifts1={l->l-q};
propsR1=ReplaceAll[{propsFC,props},momShifts1];
topoR1=FCReplaceMomenta[topo,momShifts1]
ExpandAll[(1/propsR1[[2]])]
asyOutput=AlphaRepExpand[{l},propsAsy,{q^2->m2^2},{m2->x^0,m1->x^1},Verbose->False]
asyRescaling=Abs[(Min/@asyOutput)];
asyFinal=MapThread[(#1+#2)&,{asyOutput,asyRescaling}]


(* ::Text:: *)
(*2nd region: l ~ m2*)


propsR2={propsFC,props}
topoR2=topo


(* ::Text:: *)
(*3rd region: l ~ m1*)


propsR3={propsFC,props}
topoR3=topo


(* ::Section:: *)
(*Define the topologies for each region*)


topoWithScaling[id,1]=FCLoopAddScalingParameter[topoR1,la,{l->la^1 l,q->la^0 q,m1->la^1 m1}]


topoWithScaling[id,2]=FCLoopAddScalingParameter[topoR2,la,{l->la^0 l,q->la^0 q,m1->la^1 m1}]


topoWithScaling[id,3]=FCLoopAddScalingParameter[topoR3,la,{l->la^1 l,q->la^0 q,m1->la^1 m1}]


(* ::Section:: *)
(*Rules for eliminating eikonal propagators*)


fromGFADRules={m2^2->SPD[q]}


(* ::Section:: *)
(*Region 1*)


nRegion=1;


intExpanded[id,nRegion,1]=FCLoopGLIExpand[ int,{topoWithScaling[id,nRegion]},{la,0,laPower}]


intExpanded[id,nRegion,2]=FromGFAD[FCLoopFromGLI[Sequence@@intExpanded[id,nRegion,1]]/.x_FeynAmpDenominator/;FreeQ2[x,{l}]:>FeynAmpDenominatorExplicit[x],
InitialSubstitutions->fromGFADRules]


(* ::Input:: *)
(**)


intExpanded[id,nRegion,3]=FCLoopFindTopologies[intExpanded[id,nRegion,2],{l},
Head->{Identity,gliProduct},Names->"asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"NAux",
FCVerbose->-1,FinalSubstitutions->kinematics]


auxTopo[id,nRegion]=FCLoopBasisFindCompletion[intExpanded[id,nRegion,3][[2]]]/.Table["asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"NAux"<>ToString[i]->
"asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"N"<>ToString[i],{i,1,4}]
auxRule[id,nRegion]=FCLoopCreateRuleGLIToGLI[auxTopo[id,nRegion],List/@intExpanded[id,nRegion,3][[2]]]//Flatten


intExpanded[id,nRegion,4]={(intExpanded[id,nRegion,3]/.auxRule[id,nRegion])[[1]],auxTopo[id,nRegion]}


topoMappings[id,nRegion]=FCLoopFindTopologyMappings[intExpanded[id,nRegion,4][[2]]]


intExpanded[id,nRegion,5]=FCLoopTensorReduce[intExpanded[id,nRegion,4],Head->gliProduct]


intExpanded[id,nRegion,6]=FCLoopApplyTopologyMappings[intExpanded[id,nRegion,5],topoMappings[id,nRegion],Head->gliProduct]


FIREPrepareStartFile[#,fireFCDir]&/@Last[topoMappings[id,nRegion]]
FIRECreateConfigFile[#,fireFCDir]&/@Last[topoMappings[id,nRegion]]
FIRECreateIntegralFile[intExpanded[id,nRegion,6],Last[topoMappings[id,nRegion]],fireFCDir]


FIRECreateLiteRedFiles[fireFCDir,Last[topoMappings[id,nRegion]]]


FIRECreateStartFile[fireFCDir,Last[topoMappings[id,nRegion]]]


FIRERunReduction[fireFCDir,Last[topoMappings[id,nRegion]]]


ibpRules[id,nRegion]=FIREImportResults[Last[topoMappings[id,nRegion]],fireFCDir]//Flatten;


Cases2[Last/@ibpRules[id,nRegion],GLI]
mappings[id,nRegion]=FCLoopFindIntegralMappings[%,Last[topoMappings[id,nRegion]]]


Put[{mappings[id,nRegion][[2]],Last[topoMappings[id,nRegion]]},FileNameJoin[{fireFCDir,"FinalMasters",ToString[FCLoopGLIToSymbol[int]]<>"R"<>ToString[nRegion]<>".m"}]]


res[id,nRegion]=Collect2[intExpanded[id,nRegion,6]/.ibpRules[id,nRegion]/.mappings[id,nRegion][[1]],GLI,la]


Put[{res[id,nRegion],Last[topoMappings[id,nRegion]]},
FileNameJoin[{ParentDirectory[fireFCDir],"FinalExpressions",ToString@FCLoopGLIToSymbol[int],ToString[FCLoopGLIToSymbol[int]]<>"R"<>ToString[nRegion]<>".m"}]]


(* ::Section:: *)
(*Region 2*)


nRegion=2;


intExpanded[id,nRegion,1]=FCLoopGLIExpand[ int,{topoWithScaling[id,nRegion]},{la,0,laPower}]


intExpanded[id,nRegion,2]=FromGFAD[FCLoopFromGLI[Sequence@@intExpanded[id,nRegion,1]]/.x_FeynAmpDenominator/;FreeQ2[x,{l}]:>FeynAmpDenominatorExplicit[x],
InitialSubstitutions->fromGFADRules]


intExpanded[id,nRegion,3]=FCLoopFindTopologies[intExpanded[id,nRegion,2],{l},
Head->{Identity,gliProduct},Names->"asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"NAux",
FCVerbose->-1,FinalSubstitutions->kinematics]


auxTopo[id,nRegion]=FCLoopBasisFindCompletion[intExpanded[id,nRegion,3][[2]]]/.Table["asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"NAux"<>ToString[i]->
"asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"N"<>ToString[i],{i,1,4}]
auxRule[id,nRegion]=FCLoopCreateRuleGLIToGLI[auxTopo[id,nRegion],List/@intExpanded[id,nRegion,3][[2]]]//Flatten


intExpanded[id,nRegion,4]={(intExpanded[id,nRegion,3]/.auxRule[id,nRegion])[[1]],auxTopo[id,nRegion]}


topoMappings[id,nRegion]=FCLoopFindTopologyMappings[intExpanded[id,nRegion,4][[2]]]


intExpanded[id,nRegion,5]=FCLoopTensorReduce[intExpanded[id,nRegion,4],Head->gliProduct]


intExpanded[id,nRegion,6]=FCLoopApplyTopologyMappings[intExpanded[id,nRegion,5],topoMappings[id,nRegion],Head->gliProduct]


FIREPrepareStartFile[#,fireFCDir]&/@Last[topoMappings[id,nRegion]]
FIRECreateConfigFile[#,fireFCDir]&/@Last[topoMappings[id,nRegion]]
FIRECreateIntegralFile[intExpanded[id,nRegion,6],Last[topoMappings[id,nRegion]],fireFCDir]


FIRECreateLiteRedFiles[fireFCDir,Last[topoMappings[id,nRegion]]]


FIRECreateStartFile[fireFCDir,Last[topoMappings[id,nRegion]]]


FIRERunReduction[fireFCDir,Last[topoMappings[id,nRegion]]]


ibpRules[id,nRegion]=FIREImportResults[Last[topoMappings[id,nRegion]],fireFCDir]//Flatten;


Cases2[Last/@ibpRules[id,nRegion],GLI]
mappings[id,nRegion]=FCLoopFindIntegralMappings[%,Last[topoMappings[id,nRegion]]]


Put[{mappings[id,nRegion][[2]],Last[topoMappings[id,nRegion]]},FileNameJoin[{fireFCDir,"FinalMasters",ToString[FCLoopGLIToSymbol[int]]<>"R"<>ToString[nRegion]<>".m"}]]


res[id,nRegion]=Collect2[intExpanded[id,nRegion,6]/.ibpRules[id,nRegion]/.mappings[id,nRegion][[1]],GLI,la]


Put[{res[id,nRegion],Last[topoMappings[id,nRegion]]},
FileNameJoin[{ParentDirectory[fireFCDir],"FinalExpressions",ToString@FCLoopGLIToSymbol[int],ToString[FCLoopGLIToSymbol[int]]<>"R"<>ToString[nRegion]<>".m"}]]


(* ::Section:: *)
(*Region 3*)


nRegion=3;


intExpanded[id,nRegion,1]=FCLoopGLIExpand[ int,{topoWithScaling[id,nRegion]},{la,0,laPower}]


intExpanded[id,nRegion,2]=FromGFAD[FCLoopFromGLI[Sequence@@intExpanded[id,nRegion,1]]/.x_FeynAmpDenominator/;FreeQ2[x,{l}]:>FeynAmpDenominatorExplicit[x],
InitialSubstitutions->fromGFADRules]


intExpanded[id,nRegion,3]=FCLoopFindTopologies[intExpanded[id,nRegion,2],{l},
Head->{Identity,gliProduct},Names->"asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"NAux",
FCVerbose->-1,FinalSubstitutions->kinematics]


auxTopo[id,nRegion]=FCLoopBasisFindCompletion[intExpanded[id,nRegion,3][[2]]]/.Table["asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"NAux"<>ToString[i]->
"asyR"<>ToString[nRegion]<>ToString[FCLoopGLIToSymbol[int]]<>"N"<>ToString[i],{i,1,4}]
auxRule[id,nRegion]=FCLoopCreateRuleGLIToGLI[auxTopo[id,nRegion],List/@intExpanded[id,nRegion,3][[2]]]//Flatten


intExpanded[id,nRegion,4]={(intExpanded[id,nRegion,3]/.auxRule[id,nRegion])[[1]],auxTopo[id,nRegion]}


topoMappings[id,nRegion]=FCLoopFindTopologyMappings[intExpanded[id,nRegion,4][[2]]]


intExpanded[id,nRegion,5]=FCLoopTensorReduce[intExpanded[id,nRegion,4],Head->gliProduct]


intExpanded[id,nRegion,6]=FCLoopApplyTopologyMappings[intExpanded[id,nRegion,5],topoMappings[id,nRegion],Head->gliProduct]


FIREPrepareStartFile[#,fireFCDir]&/@Last[topoMappings[id,nRegion]]
FIRECreateConfigFile[#,fireFCDir]&/@Last[topoMappings[id,nRegion]]
FIRECreateIntegralFile[intExpanded[id,nRegion,6],Last[topoMappings[id,nRegion]],fireFCDir]


FIRECreateLiteRedFiles[fireFCDir,Last[topoMappings[id,nRegion]]]


FIRECreateStartFile[fireFCDir,Last[topoMappings[id,nRegion]]]


FIRERunReduction[fireFCDir,Last[topoMappings[id,nRegion]]]


ibpRules[id,nRegion]=FIREImportResults[Last[topoMappings[id,nRegion]],fireFCDir]//Flatten;


Cases2[Last/@ibpRules[id,nRegion],GLI]
mappings[id,nRegion]=FCLoopFindIntegralMappings[%,Last[topoMappings[id,nRegion]]]


Put[{mappings[id,nRegion][[2]],Last[topoMappings[id,nRegion]]},FileNameJoin[{fireFCDir,"FinalMasters",ToString[FCLoopGLIToSymbol[int]]<>"R"<>ToString[nRegion]<>".m"}]]


res[id,nRegion]=Collect2[intExpanded[id,nRegion,6]/.ibpRules[id,nRegion]/.mappings[id,nRegion][[1]],GLI,la]


Put[{res[id,nRegion],Last[topoMappings[id,nRegion]]},
FileNameJoin[{ParentDirectory[fireFCDir],"FinalExpressions",ToString@FCLoopGLIToSymbol[int],ToString[FCLoopGLIToSymbol[int]]<>"R"<>ToString[nRegion]<>".m"}]]


(* ::Section:: *)
(*Putting everything together*)


ClearAll[regions,finalExpr,asyTopos,mappingRules,presentGLIs]


regions=Get/@FileNames["*.m",FileNameJoin[{ParentDirectory[fireFCDir],"FinalExpressions",ToString@FCLoopGLIToSymbol[int]}]];


{finalExpr,asyTopos}=Transpose[regions];
asyTopos=Flatten[asyTopos];
finalExpr=Total[finalExpr];


mappingRules=FCLoopFindIntegralMappings[Cases2[finalExpr,GLI],asyTopos]


presentGLIs=Cases2[finalExpr/.mappingRules[[1]],GLI]


intsToGraphs=FCLoopIntegralToGraph[presentGLIs,asyTopos]
intPlots=MapThread[FCLoopGraphPlot[#1,GraphPlot->{MultiedgeStyle->0.35,Frame->True,FrameLabel->Style[#2,FontSize->7.5,FontWeight->Bold]}]&,{intsToGraphs,presentGLIs}];
Magnify[Grid[Partition[intPlots,UpTo[4]]],1.5]


{knownMasters,miTopos}=Transpose[{Get[FileNameJoin[{$FeynCalcDirectory,"Examples","MasterIntegrals","Mincer","prop1L00.m"}]]/.{qq->m2^2},
Get[FileNameJoin[{$FeynCalcDirectory,"Examples","MasterIntegrals","Tadpoles","tad1L.m"}]]
}];
miTopos=Flatten[miTopos];
knownMasters=Flatten[knownMasters];


finalMappingRules=FCLoopFindIntegralMappings[Join[presentGLIs,Cases2[knownMasters,GLI]],Join[asyTopos,miTopos],PreferredIntegrals->Cases2[knownMasters,GLI]]


mappingRules[[1]]


rawAnalyticResult=FCReplaceD[finalExpr/.mappingRules[[1]]/.finalMappingRules[[1]]//.knownMasters/.FCI@SPD[q]->m2^2,D->4-2ep]


resultExpanded1=Series[rawAnalyticResult/.la->1,{ep,0,3}]//Normal;


resultExpanded2=resultExpanded1//ReplaceAll[#,{Log[-m2^2-I eta]->2Log[m2]-I Pi}]&;


resultExpanded3=Series[resultExpanded2/.{m1->la m1},{la,0,laPower}]//Normal//ReplaceAll[#,la->1]&;


resultFinal=Collect2[resultExpanded3//PowerExpand//FunctionExpand,ep,m1,m2]


Put[{int->resultFinal,topo}/.prop1L1->prop1Lm11asy,FileNameJoin[{$FeynCalcDirectory,"Examples","MasterIntegrals","propXLMassive","prop1Lm11asy.m"}]]


(*files=FSACreateMathematicaScripts[int,FCLoopSwitchEtaSign[topo,-1],FileNameJoin[{NotebookDirectory[], "FIESTA"}],
FSAParameterRules -> { m2 -> 10.},OverwriteTarget->True,FSASDExpandAsy->True,FSASDExpandAsyOrder->4,FSAOrderInEps->3,
FSAExpandVar->m1,FSAIntegratorOptions -> {{"maxeval", "100000"}, {"epsrel", "1.000000E-05"}, {"epsabs", "1.000000E-12"}, {"integralTransform", "korobov"}}]*)


(*FSARunIntegration[files[[1]]]*)


(*v1=Collect2[FSALoadNumericalResults[files],ep,m1]*)


(*v2=Collect2[Collect2[ExpandAll[resultFinal/.la->1/. { m2 -> 10.}],ep]//ExpandAll//Chop[#,10^-5]&,ep,m1]*)


(*FCCompareNumbers[v1,v2,DigitCount->2,Chop->10^-5]*)

