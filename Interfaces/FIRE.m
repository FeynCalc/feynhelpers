

FeynBurn::usage="";
FeynBurn2::usage="";
$FIREPackage::usage="";



FeynBurn::tens=
"Warning! Your input contains loop integrals that a has either loop momenta \
with free indices or loop momenta contracted with Dirac matrices. Those integrals
will be ignored, because FIRE doesn't handle such cases. Please simplify the Dirac
algebra of perform tensor reduction first.";

FeynBurn::convfail=
"Error! Conversion of the integral `1` to FIRE failed. Evaluation aborted. Reason: `2`";

AddPropagators::usage=
"fill me";

Begin["`Package`"]
End[]

Begin["`FIRE`Private`"]

$FIREPackage = "FIRE5`FIRE5`";


Options[FeynBurn] = {
	AddPropagators -> {}
};

fromTallyProps[props_List,qs_List]:=
	FAD@@Map[(# /. {prop_, int_Integer} :>
		Sequence@@Table[FCSplit[prop /. Power -> pow, qs] /.
		{mass_,	pow[mom_, 2]} :> {mom, mass} /.
		{-pow[m_, 2] :> m}, {i, 1, int}]) &, props];

fromTallyQPs[qps_List]:=
	Times @@ Map[(# /. {qp_, int_Integer} :>
	Sequence@@Table[qp /. Power->pow /.
	{Times[x_, y_] :> SPD[x, y], pow[x_,2] :> SPD[x,x]}, {i, 1, int}]) &,qps];



(*	purely scalar loop integrals	*)
toFIRE[FAD[b__],qs_List] :=
	Block[{propList,check,pow},
		FCPrint[3, "Integral accepted:",FAD[b]];
		propList = Tally[Sort[{b}]] /. {
			{{mom_, mass_}, int_Integer}:> {mom^2-mass^2,int},
			{mom_, int_Integer}/;Head[mom]=!=List :> {mom^2,int}};
		(* check that the list of propagators looks how it should *)
		If[!MatchQ[propList, {{_, _Integer} ..}],
			Message[FeynBurn::convfail,FAD[b],propList];
			Abort[]
		];
		(* 	check that there is one-to-one correspondence between the list
			of propagators and the original integral *)
		check = fromTallyProps[propList,qs];
		If[((FAD[b]-check)//FCI//FDS) =!= 0,
			Message[FeynBurn::convfail,FAD[b],ToString[((FAD[b]-check)//FCI//FDS),InputForm]];
			Abort[]
		];

		fireFormScalar[propList]
	]/;!FreeQ2[{b},qs];

(*	loop integrals with scalar products involving loop momenta	*)
toFIRE[(qps : Times[SPD[_, _]^_. ..] ) FAD[b__],qs_List] :=
	Block[{propList,qpList,pow,one,check,qpS},
		If[Length[{qps}]>1,
			qpS=Times@@{qps},
			qpS = qps
		];
		FCPrint[3, "Integral accepted:", qpS FAD[b]];

		qpList =Tally[Sort[List @@ (one*qpS /. Power -> pow)]] /.
			{one,1} :> Sequence[] /.
			{pow[x_, i1_Integer], i2_Integer} :> {x, i1*i2} /.
			{SPD[x_, y_], int_Integer} :> {x*y,int};
		(* 	check that there is one-to-one correspondence between the list
			of scalar products and the original denominator *)
		check = fromTallyQPs[qpList];
		If[qpS =!= check,
			Message[FeynBurn::convfail, ToString[qpS FAD[b],InputForm]];
			Abort[]
		];
		propList = toFIRE2[FAD[b],qs]/.fireFormScalar->Identity;
		fireFormQP[propList,qpList]
	]/;!FreeQ2[{qps,b},qs];





FeynBurn[expr_, q_, extMom_List, opts:OptionsPattern[]] :=
	FeynBurn[expr, {q}, extMom,opts]/; Head[q]=!=List;


FeynBurn[expr_, qs_List, extMom_List, OptionsPattern[]] :=
	Block[ {fclsOutput, intsScalar, intsQP, intsScalarUnique,intsQPUnique,null1,null2,
			fireList1,fireList2,fireRes1,fireRes2,finalRepList1,finalRepList2,res
			},


		fclsOutput  = FCLoopSplit[expr,qs];
		If [fclsOutput[[4]]=!=0,
			Message[FeynBurn::tens]
		];

		intsScalar=FCLoopIsolate[fclsOutput[[2]], qs, FCI->True, Head->loopIntegral];
		intsQP=FCLoopIsolate[fclsOutput[[3]], qs, FCI->True, Head->loopIntegral];

		intsScalarUnique = (Cases[intsScalar+null1+null2,loopIntegral[__],Infinity]/.null1|null2->0)//Union;
		intsQPUnique = (Cases[intsQP+null1+null2,loopIntegral[__],Infinity]/.null1|null2->0)//Union;

		fireList1 = Map[If[!FreeQ2[#,qs],toFIRE[FCE[#],qs],#]&, (intsScalarUnique/.loopIntegral->Identity)]/.fireFormScalar->Identity;
		fireList2 = Map[If[!FreeQ2[#,qs],toFIRE[FCE[#],qs],#]&, (intsQPUnique/.loopIntegral->Identity)]/.fireFormQP->List;
				If[!FreeQ2[Join[fireList1,fireList2],{loopIntegral,fireFormScalar,fireFormQP}],
			Message[FeynBurn::convfail,ToString[Join[fireList1,fireList2],InputForm]];
			Abort[]
		];

		(* For now let us process the integrals one by one *)
		If[	fireList1=!={},
			fireRes1=Map[
				If[!FreeQ2[#,qs],runFIRE[qs,extMom,#,{},OptionValue[AddPropagators]],#]&, fireList1],
			fireRes1={}
		];

		If[	fireList2=!={},
			fireRes2=Map[
				If[!FreeQ2[#,qs],runFIRE[qs,extMom,#[[1]],#[[2]],{}],#]&, fireList2],
			fireRes2={}
		];


		(* OK, let's return the final result *)
		finalRepList1= MapThread[Rule[#1,#2]&,{intsScalarUnique,fireRes1}];
		finalRepList2= MapThread[Rule[#1,#2]&,{intsQPUnique,fireRes2}];

		res=FCI[fclsOutput[[1]]+(intsScalar/.finalRepList1)+(intsQP/.finalRepList2)];

		res



	];



runFIRE[qs_List,ext_List,prop_List,qps_List,addprops_List,file_:ToFileName[{$FeynCalcDirectory, "Database"}, "tempFIRE"]]:=
	Block[{internal,external,propagators,replacements, integral, kernel, outFIRE, gList,
		gListProps,gListQPs, pList,qpList,g,fadList,spdList,repList,fakeTailLen=0,
		aux,fullBasis,ourBasis,fakeStuff={}},

		(* 	list of loop momenta; We take only loop momenta that are explicitly present
			in the integral. Otherwise FIRE would "wrongly" set the integral to zero *)

		internal=Select[qs,!FreeQ2[{prop,qps},#]&];
		(* 	list of external momenta; We take only external momenta that are explicitly
			present in the integral. *)
		external=Select[ext, !FreeQ2[{prop,qps},#]&];

		(* list of unique propagators and scalar products involving loop momenta *)
		propagators= Join[prop,qps]/.{a_,_Integer}:>a;

		(* create list of all possible basis elements *)
		aux[x_] :=
			Map[(x*#) &, external];
		fullBasis=Join[Apply[Times, #] & /@ Tuples[internal, {2}],(aux /@ internal) // Flatten] // Union;

		(* determine basis elements availalbe in our integral	*)
		ourBasis=((Expand2[#, internal] /. Plus -> Sequence) & /@ propagators) //Select[#, ! FreeQ2[#1, internal] &] & //
		ReplaceAll[#, {a_ x_ /; FreeQ2[a, Join[internal,external]] :> x}] & // Union;

		(*	if our basis is not complete, we add fake scalar products to make it complete
			With "fake" we mean that even though they appear in the propagator lists,
			their power in the F-integral is 0. Thus they are needed only for the reduction
			itself and are dropped afterwards.
		*)
		FCPrint[1,"FeynBurn: Full basis ",fullBasis];


		If[addprops =!= {},
			tmpprops = Map[FCSplit[#,Join[qs,ext],Expanding->False][[2]]&,propagators];


			fakeStuff=Complement[addprops,tmpprops];
			fakeTailLen= Length[fakeStuff];
			propagators = Join[propagators,fakeStuff]

		];

		(* determine basis elements availalbe in our integral	*)
		finalBasis=((Expand2[#, internal] /. Plus -> Sequence) & /@ propagators) //Select[#, ! FreeQ2[#1, internal] &] & //
		ReplaceAll[#, {a_ x_ /; FreeQ2[a, Join[internal,external]] :> x}] & // Union;

		FCPrint[1,"FeynBurn: Final basis ",finalBasis];



		(*	kinematics for external momenta	*)
		replacements=Map[Rule[Apply[Times, #], SP[#[[1]], #[[2]]]] &, Union[Sort /@ Tuples[external, 2]]];

		(*	 this is the integral F[1,xxx] that FIRE will simplify	*)
		integral = {1,(Join[(prop/.{_,a_Integer}:>a),(qps/.{_,a_Integer}:>-a),Sequence@@Tuples[{0},fakeTailLen]])};


		FCPrint[3,"FIRE's Internal :", StandardForm[internal]];
		FCPrint[3,"FIRE's External :", StandardForm[external]];
		FCPrint[3,"FIRE's Propagators :", StandardForm[propagators]];
		FCPrint[3,"FIRE's Replacements :", StandardForm[replacements]];
		FCPrint[3,"FIRE's Intitial Data File :", StandardForm[file]];
		FCPrint[3,"FIRE's F integral :", StandardForm[integral]];
		(* Start a new kernel	*)
		kernel = LaunchKernels[1];
		(* Dirty trick to prevent the package from flushing the front-end with its Print output  *)
		ParallelEvaluate[Unprotect[System`Print]; System`Print=System`PrintTemporary&, kernel];
		(* Let's ignite the FIRE *)
		ParallelEvaluate[Get["FIRE5`FIRE5`"], kernel];
		With[{internal1=internal},ParallelEvaluate[System`Internal = internal1,kernel]];
		With[{external1=external},ParallelEvaluate[System`External = external1,kernel]];
		With[{propagators1=propagators},ParallelEvaluate[System`Propagators = propagators1,kernel]];
		With[{replacements1=replacements},ParallelEvaluate[System`Replacements = replacements1,kernel]];
		ParallelEvaluate[System`PrepareIBP[], kernel];
		With[{file1=file},ParallelEvaluate[
				System`Prepare[AutoDetectRestrictions -> True];
				System`SaveStart[file1],
				kernel
		]];
		CloseKernels[kernel];

		kernel = LaunchKernels[1];
		(* Dirty trick to prevent the package from flushing the front-end with its Print output  *)
		ParallelEvaluate[Unprotect[System`Print]; System`Print=System`PrintTemporary&, kernel];
		ParallelEvaluate[Get["FIRE5`FIRE5`"], kernel];
		With[{file1={file,1}},ParallelEvaluate[
			System`LoadStart@@file1;
			System`Burn[],
		kernel]];
		outFIRE = (With[{integral1=integral},ParallelEvaluate[System`F@@integral1, kernel]])/.{Global`G->g,Global`d->System`D};
		CloseKernels[kernel];
		FCPrint[1,"Output of FIRE: ", outFIRE];
		If [$VersionNumber>=10,
				outFIRE = Total[outFIRE];
		];
		gList = Cases[Expand2[outFIRE, g]+null1+null2, g[__] ,Infinity];

		FCPrint[3,"gList: ", gList];
		(*Drop fake stuff*)
		gList = gList/. g[z_,x__List]:>g[z, Take[x,Length[x]-Length[fakeTailLen]]];
		FCPrint[3,"gList after dropping fake stuff: ", gList];

		gListProps = gList /. g[z_,x__List]:>g[z,x[[1;;Length[prop]]]];
		gListQPs = gList /.g[z_,x__List]:>g[z,Take[x,-Length[qps]]];

		FCPrint[3,"gListProps: ", gListProps];
		FCPrint[3,"gListQPs: ", gListQPs];

		(*TODO check that all integers in gListProps are either 0 or positive *)
		(*TODO check that all integers in gListQPs are either 0 or negative *)

		pList = Map[MapThread[{#1, #2} &, {propagators[[1;;Length[prop]]], (#/. g[_, i_] :> i)}]&,gListProps];
		qpList = Map[MapThread[{#1, #2} &, {Take[propagators,-Length[qps]], (#/. g[_, i_] :> i)}]&,gListQPs];
		FCPrint[3,"pList: ", pList];
		FCPrint[3,"qpList: ", qpList];

		fadList=fromTallyProps[#,qs]&/@pList;
		spdList=fromTallyQPs/@qpList;
		repList= MapThread[Rule[#1,#2*#3]&,{gList,fadList,spdList}];
		outFIRE/.repList
	];

End[]
