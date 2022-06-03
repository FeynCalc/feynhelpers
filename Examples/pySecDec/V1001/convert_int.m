(* ::Package:: *)

(* :Title: convert_int                                              		*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2020-2022 Vladyslav Shtabovenko
*)

(* :Summary:  Generates scripts for the numerical evaluation of the given
	integral using pySecDec													*)

(* ------------------------------------------------------------------------ *)


(* ::Section:: *)
(*Load FeynCalc and FeynHelpers*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Numerical evaluation of the loop integral V1001 using pySecDec"];
];
If[$Notebooks === False, $FeynCalcStartupMessages = False];
$LoadAddOns= {"FeynHelpers"};
<<FeynCalc`;


(* ::Section:: *)
(*Generate Python scripts*)


(* ::Text:: *)
(*This is a single-scale 2-loop on-shell integral V1001 from hep-ph/9907431*)


int=SFAD[p1-p3,p1+q,{p3,m1^2},{p3+q,m1^2}]


(* ::Text:: *)
(*To compare with the analytic result on the Appendix C of hep-ph/9907431 we need the result up to first order in ep.*)


PSDCreatePythonScripts[int,{p1,p3},
FCGetNotebookDirectory[],PSDRealParameterRules->{m1->5.},
FinalSubstitutions->{SPD[q]->m1^2},PSDRequestedOrder->1,OverwriteTarget->True]


(* ::Text:: *)
(*The function generates two scripts: "generate_int.py" and "integrate_int.py". This is all the input we need for pySecDec*)


(* ::Section:: *)
(*Run Python scripts*)


(* ::Text:: *)
(*The following three steps should be done by the user outside of Mathematica.*)


(* ::Text:: *)
(*Notice that each step can take considerable amount of time, especially for sufficiently complicated integrals. *)
(*Therefore, it is recommended to run the scripts and the compilation on a sufficiently powerful machine or, ideally, on a cluster.*)


(* ::Text:: *)
(*The first step consists of generating the required FORM and C++ files: "python generate_int.py"*)


(* ::Text:: *)
(*In the second step the resulting files are compiled: "make -j8 -C loopint". You can also use more than 8 processes simultaneously if *)
(*your machine has enough cores and memory.*)


(* ::Text:: *)
(*Finally, we can load the generated library to evaluate our integral at various kinematic points using "python integrate_int.py"*)


(* ::Text:: *)
(*The results are returned in a generic format "numres_*_psd.txt" as well as in form of expressions suitable for Mathematica ("numres_*_mma.m") and *)
(*Maple ("numres_*_maple.mpl"). The part of the filename abbreviated with * will contain the employed numerical values for the relevant kinematic invariants.*)
(*Their ordering is given by the ordering of the numbers specified in the lists "num_params_real" and "num_params_complex" which are defined in "integrate_int.py".*)
(*You can change those numbers by hand to obtain results at other kinematic points. The output filenames will be adjusted automatically.*)


(* ::Section:: *)
(*Fetch numerical results*)


(* ::Text:: *)
(*The format of the Mathematica results file is a list of two elements containing the real and the imaginary parts.*)


results=FileNames["numres*_mma.m",FCGetNotebookDirectory[]];


currentRes=results[[1]];
finalRes=Get[currentRes][[1]]+I*Get[currentRes][[2]];
Print["Numerical result for the following choice of parameters: ",
StringSplit[StringReplace[FileBaseName[currentRes],{"numres"|"mma"->""}],"_"]];
Print[finalRes];


S2=4/(9Sqrt[3])FCClausen[2,Pi/3];
Ls3/:N[Ls3[x_]]:=-NIntegrate[Log[Abs[2Sin[th/2]]]^2,{th,0,x}];


V1001=E^(2*eps*EulerGamma)*(m1^2)^(-2*eps)*Gamma[1+eps]^2*(1/(2eps^2)+
1/eps(5/2-Pi/Sqrt[3])+19/2+3/2Zeta[2]-4Pi/Sqrt[3]-63/4 S2+Pi/Sqrt[3]Log[3]+eps(
65/2+8 Zeta[2]+3/2Zeta[3]-12 Pi/Sqrt[3]-63S2+63/4 S2 Log[3]+4 Pi/Sqrt[3]Log[3]-1/2Pi/Sqrt[3]Log[3]^2-21/2Pi/Sqrt[3]Zeta[2]-21/2Ls3[2Pi/3]/Sqrt[3]));


(* ::Text:: *)
(*This is the analytic result from hep-ph/9907431*)


resV1001=Normal[Series[V1001,{eps,0,1}]]//FunctionExpand


(* ::Text:: *)
(*For m1 set to 5. it nicely matches our numerical evaluation*)


N[resV1001/.m1->5]


(* ::Section:: *)
(*Check the final results*)


knownResults = N[resV1001/.m1->5];
FCCompareResults[{FCCompareNumbers[Normal[finalRes],knownResults,Chop->10^(-7),FCVerbose->-1]},{0},
Text->{"\tCompare to hep-ph/9907431:","CORRECT.","WRONG!"}, Interrupt->{Hold[Quit[1]],Automatic}]
Print["\tCPU Time used: ", Round[N[TimeUsed[],3],0.001], " s."];



