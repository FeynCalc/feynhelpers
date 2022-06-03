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
		Print["Numerical evaluation of the loop integral eik2Lv1 using pySecDec"];
];
If[$Notebooks === False, $FeynCalcStartupMessages = False];
$LoadAddOns= {"FeynHelpers"};
<<FeynCalc`;


(* ::Section:: *)
(*Generate Python scripts*)


int=SFAD[{p1,mg^2},{p3,mg^2},{{0,2 p1 . n}},{{0,2 n . (p1+p3)}}]


(* ::Text:: *)
(*This integral is purely real, so to save time we explicitly disable the contour deformation. We want to obtain the result up to first order in ep.*)


PSDCreatePythonScripts[int,{p1,p3},
FCGetNotebookDirectory[],PSDRealParameterRules->{qq->5.,mg->3.},
FinalSubstitutions->{SPD[n]->1,SPD[q]->qq},PSDContourDeformation->False,PSDRequestedOrder->1,OverwriteTarget->True]


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


(* ::Section:: *)
(*Check the final results*)


knownResults = 44.41322-140.65835 eps;
FCCompareResults[{FCCompareNumbers[Normal[finalRes],knownResults,Chop->10^(-6),FCVerbose->-1]},{0},
Text->{"\tCompare to the known result:","CORRECT.","WRONG!"}, Interrupt->{Hold[Quit[1]],Automatic}]
Print["\tCPU Time used: ", Round[N[TimeUsed[],3],0.001], " s."];



