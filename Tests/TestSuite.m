(* :Title: TestSuite.m                                                  	*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2015-2023 Vladyslav Shtabovenko
																			*)

(* :Summary:    Test Suite for FeynHelpers via MUnit. Doesn't require
	Wolfram	Worbench to run                       							*)

(* ------------------------------------------------------------------------ *)

<< MUnit`
$FeynCalcStartupMessages = False;


$LoadAddOns = {"FeynHelpers"};
<<FeynCalc`
SetOptions[PaXEvaluate]
testRunner[test_String]:=
(If[$VersionNumber < 10,
	FCPrint[0,"Testing ", FileNameTake[test], " ", UseWriteString->True]
];
If[!MUnit`TestRun[test,Loggers->{VerbosePrintLogger[]}],
	FCPrint[0,"\n ERROR! Some tests from ", test, " failed! Test run aborted!\n",UseWriteString->True];
	Exit[1],
	FCPrint[0,"\n\n",UseWriteString->True]
]);

FCPrint[0,"Starting FeynHelpers Test Suite on Mathematica ", $VersionNumber, "\n", UseWriteString->True];

Which[
testType===1,
fcTestList = (FileNames["*.mt", FileNameJoin[{$FeynHelpersDirectory, "Tests", "*"}]]),
testType===2,
fcTestList = StringCases[
FileNames["*.mt",
FileNameJoin[{$FeynHelpersDirectory, "Tests", "*"}],
Infinity], RegularExpression[".*IntegrationTests.*"]]//Flatten,
True,
FCPrint[0,"Error! Uknown test type",UseWriteString->True];
Exit[]
];

If [onlyTest=!="" && Head[onlyTest]===String,
str = ".*"<>ToString[onlyTest]<>".*";
fcTestList = StringCases[fcTestList,RegularExpression[str]]//Flatten;
FCPrint[0,"Only following tests will be checked: ", fcTestList,UseWriteString->True];
FCPrint[0,"\n",UseWriteString->True]
]

testRunner/@fcTestList;
FCPrint[0,"\n",UseWriteString->True];
FCPrint[0,"Done!\n",UseWriteString->True];
Return[1]
