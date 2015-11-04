

FeynBurn::usage="";

$FIREPackage::usage="";


AddPropagators::usage="AddPropagators is an option for FeynBurn. Normally, for loop integrals \
that don't have enough propagators to form a complete basis, FeynBurn will automatically include \
missing propagators and put them to unity after the reduction is complete. In some cases it may \
be desirable to choose the missing propagators manually. This can be done by specifying the \
propagators via AddPropagators->{prop1,prop2,...}. E.g.





";

FeynBurn::usage="FeynBurn[expr,{q1,q2,..},{p1,p2,..}] reduces loop integrals with loop \
momenta q1,q2,... and external momenta p1,p2,... with integration-by-parts (IBP) relations. \
The evaluation is done on a parellel kernel using A.V. Smirnov's and V.A. Smirnov's FIRE. \
FeynBurn expects that the input doesn't contain any loop integrals with linearly dependent \
propagators. Therefore, prior to starting the reduction, use ApartFF.";

FeynBurn::tens=
"Warning! Your input contains loop integrals that have either loop momenta \
with free indices or loop momenta contracted with Dirac matrices and/or Epsilon tensors. \
Those integrals will be ignored, because FIRE doesn't handle such cases. Please perform \
the tensor reduction first.";

FeynBurn::convfail=
"Error! Conversion of the integral `1` to FIRE failed. Evaluation aborted. Reason: `2`";

FeynBurn::lindep=
"Error! The input contains integrals with linearly dependent propagators. Please perform
partial fractioning with ApartFF first. Problematic integrals are: `1`";

FeynBurn::badcomp=
"Error! You chose to complete the propagator basis by yourself, but the inclusion of the \
propagators `1` that you specified either does not do give a complete basis for `2` or produces an
overdetermined basis.";

Begin["`Package`"]
End[]

Begin["`FIRE`Private`"]

fbVerbose::usage="";

$FIREPackage = "FIRE5`FIRE5`";


Options[FeynBurn] = {
	AddPropagators -> Automatic,
	FCVerbose -> False
};

FeynBurn[expr_, qs_List/;qs=!={}, extMom_List, OptionsPattern[]] :=
	Block[ {rest, loopInts, intsUnique,
			fireList,fireRes,finalRepList,res,
			multiloop=False,needApart, allFine, needCompletion,tmpList
			},

		If [OptionValue[FCVerbose]===False,
			fbVerbose=$VeryVerbose,
			If[MatchQ[OptionValue[FCVerbose], _Integer?Positive | 0],
				fbVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1,"FeynBurn: Entering with: ", expr, FCDoControl->fbVerbose];
		FCPrint[1,"FeynBurn: Loop momenta: ", qs, " ", FCDoControl->fbVerbose];
		FCPrint[1,"FeynBurn: External momenta: ", extMom, " ", FCDoControl->fbVerbose];

		(* 	If the user specifies more than one loop momentum, only multiloop integrals
			are treated in the expression.	*)
		If[	Length[qs]>1,
			multiloop=True
		];

		{rest,loopInts,intsUnique} = FCLoopExtract[expr,qs,loopIntegral,FCLoopSplit->{2,3},MultiLoop->multiloop,PaVe->False];

		(* 	If the input contains loop integrals with loop momenta that are uncontracted,
			or contracted with Dirac matrices or epsilon tensors, issue a warning.*)
		If [  FCLoopSplit[rest,qs][[4]]=!=0,
			Message[FeynBurn::tens]
		];


		(*	Check that the propagators of each integral form a basis	*)
		tmpList=Map[{#, FCLoopBasisIncompleteQ[#,qs,FCI->True],
			FCLoopBasisOverdeterminedQ[#,qs,FCI->True]}&,(intsUnique/.loopIntegral->Identity)];

		needApart=Cases[tmpList,{_,True|False,True}];
		allFine=Cases[tmpList,{_,False,False}];
		needCompletion=Cases[tmpList,{_,True,False}];

		If[needApart=!={},
			Message[FeynBurn::lindep,ToString[needApart,InputForm]];
			Abort[]
		];

		(* Check that we correctly decomposed the list of unique integrals*)
		If[	Sort[Join[allFine,needCompletion]]=!=Sort[tmpList],
			Print["Error..."];
			Abort[]
		];


		allFine=Map[{#[[1]],{}}&,allFine];
		needCompletion=Map[FCLoopBasisFindCompletion[#[[1]],qs]&,needCompletion];
		fireList = Map[{toFIRE[FCE[#[[1]]],qs],#[[2]]}&,Sort[Join[allFine,needCompletion]]];
		fireList= Map[Join[#[[1]],Thread[List[(FCE/@#[[2]]), 0]]]&,fireList]/.{SPD[a_,b_]:>a*b};

		FCPrint[3,"FeynBurn: Fire list: ", fireList, " ", FCDoControl->fbVerbose];

		(* Process the integrals *)
		If[	fireList=!={},
			fireRes=Map[runFIRE[qs,extMom,#,OptionValue[AddPropagators]]&, fireList],
			fireRes={}
		];

		(* Solutions list *)
		finalRepList= MapThread[Rule[#1,#2]&,{intsUnique,fireRes}];
		(* Final result *)
		res = rest + FCI[loopInts/.finalRepList];

		FCPrint[1,"FeynBurn: Leaving with: ", res, FCDoControl->fbVerbose];
		res
	];

fromFIRE[props_List,qs_List]:=
	Block[{pow,tmp,res,head,headSP},
		res= props /. Power -> pow /. {
			{y_, int_Integer?Negative} :> headSP[(y//.
				{a_. q1_*q2_ +x_:0/;!FreeQ2[q1,qs] && !FreeQ2[q2,qs] && FreeQ[{q1,q2},SPD] :>
					a SPD[q1,q2]+ x,
					a_. pow[q_,2]+x_:0/;!FreeQ2[q,qs]:>a*SPD[q,q]+x}),-int],
			{_, 0} :> Unevaluated[Sequence[]],
			{x_, int_Integer?Positive} :>
				(tmp=FCSplit[x,qs]; Power[FAD[{head[(tmp[[2]]/.pow[mom_, 2]:>mom)],
				head[(tmp[[1]]/.{-pow[m_, 2]:>m})]}],int])};
		FCPrint[4,"fromFIRE: Intermediate result :", res, FCDoControl->fbVerbose];
		res = FeynAmpDenominatorCombine[Times@@(res /.pow->Power /.headSP->Power /. head->Identity)];
		FCPrint[4,"fromFIRE: Final result :", res, FCDoControl->fbVerbose];
		res
	];

toFIRE[int_,qs_List] :=
	Block[{one,two,res,pow,check},

		If[	!MatchQ[int,FAD[b__]/;!FreeQ2[{b},qs]] &&
			!MatchQ[int,((qps : Times[SPD[_, _]^_. ..] ) FAD[b__])/;!FreeQ2[{b,qps},qs]],
			Message[FeynBurn::convfail,ToString[int,InputForm],"toFIRE can't recognize the form of the integral."];
			Abort[]
		];
		res = Tally[ReplaceAll[List@@(one*two*FeynAmpDenominatorSplit[int,FCE->True]),one | two -> Unevaluated[Sequence[]]]];

		res = res/.Power -> pow /.	{pow[x_, i1_Integer], i2_Integer} :> {x, i1*i2} //. {
									{SPD[x_, y_], i_Integer} :> {x*y,-i}, (* scalar products count as negative propagators*)
									{FAD[mom_],i_Integer}/;Head[mom]=!=List:> {mom^2,i},

									(* massHead is here to protect complicated mass terms like a*m or I*m etc. *)
									{FAD[{mom_,mass_}],i_Integer}:> {mom^2-massHead[mass]^2,i}
									};

		FCPrint[4,"toFIRE: Intermediate result :", res, FCDoControl->fbVerbose];

		If[!MatchQ[res, {{_, _Integer} ..}],
			Message[FeynBurn::convfail,int,res];
			Abort[]
		];

		(* 	check that there is one-to-one correspondence between the list
			of propagators and the original integral *)
		check = fromFIRE[res,qs];

		If[((int-(check/.massHead->Identity))//FCI//FDS) =!= 0,
			Message[FeynBurn::convfail,int,ToString[(int-check)//FCI//FDS,InputForm]];
			Abort[]
		];

		res
	];


runFIRE[qs_List,ext_List,props_List,addprops_,file_:ToFileName[{$FeynCalcDirectory, "Database"}, "tempFIRE"]]:=
	Block[{internal,external,prs,propagators,replacements, integral, kernel, outFIRE, gList,
		pList,g,repList,solsList,res,null1,null2,tmp},


		If[	addprops=!=Automatic && Head[addprops]===List && addprops=!={},

			(* If the user wants to compete the basis by hand	*)
			prs = Join[Cases[props,{_,x_/;x=!=0}],Map[{#,0}&,addprops]];

			(* 	Check that with this completion the basis is indeed complete and not
				overdetermined	*)
			tmp=fromFIRE[prs /. {a_ b_,0}:>{a b,-1} /. {a_^2 - b_^2,0}:>{a^2-b^2,1},qs];
			FCPrint[3,"runFIRE: Integral with missing propagators (user input):", tmp, FCDoControl->fbVerbose];
			If[!(!FCLoopBasisIncompleteQ[tmp,qs,FCI->True] && !FCLoopBasisOverdeterminedQ[tmp,qs,FCI->True]),
				Message[FeynBurn::badcomp,ToString[addprops,InputForm],ToString[tmp,InputForm]];
				Abort[]
			],
			prs = props
		];

		(* 	We take only loop and external momenta that are explicitly present in the integral.
			Otherwise FIRE might "wrongly" set the integral to zero *)
		internal=Select[qs,!FreeQ2[{prs},#]&];
		external=Select[ext, !FreeQ2[{prs},#]&];

		(*	unique propagators	*)
		propagators= prs/.{a_,_Integer}:>a;

		(*	kinematics for external momenta	*)
		replacements=Map[Rule[Apply[Times, #], SPD[#[[1]], #[[2]]]] &, Union[Sort /@ Tuples[external, 2]]];

		(*	this is the integral F[1,xxx] that FIRE will simplify	*)
		integral = {1,prs/.{_,a_Integer}:>a};


		FCPrint[3,"runFIRE: FIRE's Internal :", StandardForm[internal], FCDoControl->fbVerbose];
		FCPrint[3,"runFIRE: FIRE's External :", StandardForm[external], FCDoControl->fbVerbose];
		FCPrint[3,"runFIRE: FIRE's Propagators :", StandardForm[propagators], FCDoControl->fbVerbose];
		FCPrint[3,"runFIRE: FIRE's Replacements :", StandardForm[replacements], FCDoControl->fbVerbose];
		FCPrint[3,"runFIRE: FIRE's Intitial Data File :", StandardForm[file], FCDoControl->fbVerbose];
		FCPrint[3,"runFIRE: FIRE's F integral :", StandardForm[integral], FCDoControl->fbVerbose];


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
				(*	Make FIRE detect the boundary conditions automatically*)
				(*TODO Idea: have FIRE config file*)
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

		(* LaunchKernels[1] returns an object in MMA 8 and 9, but a list element in MMA 10 and above*)
		If[	$VersionNumber>=10,
				outFIRE = Total[outFIRE];
		];

		FCPrint[3,"runFIRE: Output of FIRE: ", outFIRE, FCDoControl->fbVerbose];

		gList = Cases[Expand2[outFIRE, g]+null1+null2, g[__] ,Infinity];
		FCPrint[3,"gList: ", gList, FCDoControl->fbVerbose];

		pList = Map[MapThread[{#1, #2} &, {propagators, (#/. g[_, i_] :> i)}]&,gList];
		pList = Map[(#/. {_,0}:>Unevaluated[Sequence[]])&,pList];
		FCPrint[3,"pList: ", pList, FCDoControl->fbVerbose];

		solsList=fromFIRE[#,qs]&/@pList;
		repList= MapThread[Rule[#1,#2]&,{gList,solsList}];

		FCPrint[3,"repList: ", repList, FCDoControl->fbVerbose];

		res = outFIRE/.repList/. massHead->Identity;
		res
	];

End[]
