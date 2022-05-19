(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: PSDIntegrate														*)

(*
	This software is covered by the GNU General Public License 3.
	Copyright (C) 2021-2022 Vladyslav Shtabovenko
*)

(* :Summary: 	Creates pySecDec input for the integration					*)

(* ------------------------------------------------------------------------ *)

PSDIntegrate::usage=
"PSDIntegrate[] is an auxiliary function that
creates input for pySecDec's numerical integration routines.
The output is returned in form of a string.";

PSDIntegrator::usage=
"PSDIntegrator is an option of PSDIntegrate and other functions of the
pySecDec interface. It specifies the integrator to be used when performing
the numerical evaluation of the integral. The default value is \"Qmc\"";

(*https://secdec.readthedocs.io/en/stable/full_reference.html?highlight=loop_package#integral-interface*)

PSDNumberOfPresamples::usage=
"PSDNumberOfPresamples is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the number_of_presamples parameter to
be passed to pySecDec's IntegralLibrary function.";

PSDDeformationParametersMaximum::usage=
"PSDDeformationParametersMaximum is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the deformation_parameters_maximum parameter to
be passed to pySecDec's IntegralLibrary function.";

PSDDeformationParametersMinimum::usage=
"PSDDeformationParametersMinimum is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the deformation_parameters_minimum parameter to
be passed to pySecDec's IntegralLibrary function.";

PSDDeformationParametersDecreaseFactor::usage=
"PSDDeformationParametersMinimum is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the deformation_parameters_decrease_factor parameter to
be passed to pySecDec's IntegralLibrary function.";

PSDEpsRel::usage=
"PSDEpsRel is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the epsrel parameter to
be passed to pySecDec's pySecDec's IntegralLibrary function.";

PSDEpsAbs::usage=
"PSDEpsAbs is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the epsabs parameter to
be passed to pySecDec's pySecDec's IntegralLibrary function.";

PSDMaxEval::usage=
"PSDMaxEval is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the maxeval parameter to
be passed to pySecDec's numerical integration library.";

PSDMinEval::usage=
"PSDMinEval is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the mineval parameter to
be passed to pySecDec's numerical integration library.";


PSDMaxIncreaseFac::usage=
"PSDMaxIncreaseFac is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the maxincreasefac parameter to
be passed to pySecDec's numerical integration library.";

PSDMinEpsRel::usage=
"PSDMinEpsRel is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the min_epsrel parameter to
be passed to pySecDec's numerical integration library.";

PSDMinEpsAbs::usage=
"PSDMinEpsAbs is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the min_epsabs parameter to
be passed to pySecDec's numerical integration library.";


PSDMaxEpsRel::usage=
"PSDMaxEpsRel is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the max_epsrel parameter to
be passed to pySecDec's numerical integration library.";

PSDMaxEpsAbs::usage=
"PSDMaxEpsAbs is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the max_epsabs parameter to
be passed to pySecDec's numerical integration library.";

PSDMinDecreaseFactor::usage=
"PSDMinDecreaseFactor is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the min_decrease_factor parameter to
be passed to pySecDec's numerical integration library.";

PSDDecreaseToPercentage::usage=
"PSDDecreaseToPercentage is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the decrease_to_percentage parameter to
be passed to pySecDec's numerical integration library.";

PSDNumberOfThreads::usage=
"PSDNumberOfThreads is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the number_of_threads parameter to
be passed to pySecDec's numerical integration library.";

PSDResetCudaAfter::usage=
"PSDResetCudaAfter is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the reset_cuda_after parameter to
be passed to pySecDec's numerical integration library.";

PSDVerbose::usage=
"PSDVerbose is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the verbose parameter to
be passed to pySecDec's numerical integration library.";

PSDErrorMode::usage=
"PSDErrorMode is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the errormode parameter to
be passed to pySecDec's numerical integration library.";

(*Qmc specific*)

PSDErrorModeQmc::usage=
"PSDErrorMode is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the errormode parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";

PSDTransform::usage=
"PSDTransform is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the transform parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";

PSDFitFunction::usage=
"PSDFitFunction is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the fitfunction parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";

PSDGeneratingVectors::usage=
"PSDGeneratingVectors is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the generatingvectors parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";

PSDCPUThreads::usage=
"PSDCPUThreads is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the cputhreads parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";


PSDEvaluateMinn::usage=
"PSDEvaluateMinn is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the evaluateminn parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";

PSDMinn::usage=
"PSDMinn is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the minn parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";

PSDMinm::usage=
"PSDMinm is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the minm parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";

PSDVerbosity::usage=
"PSDVerbosity is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the verbosity parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Qmc integrator.";

(*Vegas specific*)

PSDFlags::usage=
"PSDFlags is an option for PSDIntegrate and other functions of the
pySecDec interface. It specifies the value of the flags parameter to
be passed to pySecDec's integral_interface function. Notice that this
option applies only to the Vegas, Suave, Cuhre and Divonne integrators.";

(**)

PSDRealParameterValues::usage=
"PSDRealParameterValues is an option for PSDIntegrate and other functions of the
pySecDec interface. It is a list of real numbers that will be passed to
pySecDec's IntegralLibrary function via the argument real_parameters";

PSDComplexParameterValues::usage=
"PSDComplexParameterValues is an option for PSDIntegrate and other functions of the
pySecDec interface. It is a list of real numbers that will be passed to
pySecDec's IntegralLibrary function via the argument complex_parameters";

PSDIntegrate::failmsg =
"Error! PSDIntegrate has encountered a fatal problem and must abort the computation. \
The problem reads: `1`"

Begin["`Package`"]
End[]

Begin["`PSDIntegrate`Private`"]

psiVerbose::usage="";

Options[PSDIntegrate] = {
	FCVerbose								-> False,
	PSDCPUThreads							-> Default,
	PSDComplexParameterValues				-> {},
	PSDDecreaseToPercentage					-> Default,
	PSDDeformationParametersDecreaseFactor	-> Default,
	PSDDeformationParametersMaximum			-> Default,
	PSDDeformationParametersMinimum			-> Default,
	PSDEpsAbs								-> Default,
	PSDEpsRel								-> Default,
	PSDErrorMode							-> Default,
	PSDFitFunction							-> Default,
	PSDGeneratingVectors					-> Default,
	PSDIntegrator							-> "Qmc",
	PSDMaxEpsAbs							-> Default,
	PSDMaxEpsRel							-> Default,
	PSDMaxEval								-> Default,
	PSDMaxIncreaseFac						-> Default,
	PSDMinDecreaseFactor					-> Default,
	PSDMinEpsAbs							-> Default,
	PSDMinEpsRel							-> Default,
	PSDMinEval								-> Default,
	PSDNumberOfPresamples					-> Default,
	PSDNumberOfThreads						-> Default,
	PSDRealParameterValues					-> {},
	PSDResetCudaAfter						-> Default,
	PSDTransform							-> Default,
	PSDVerbose								-> Default,
	PSDVerbosity							-> Default,
	PSDWallClockLimit						-> Default,
	PSDEvaluateMinn							-> Default,
	PSDMinn									-> Default,
	PSDMinm									-> Default,
	PSDFlags								-> Default
};


PSDIntegrate[OptionsPattern[]] :=
	Block[{	res, optPSDIntegrator, optPSDNumberOfPresamples,
			optPSDCPUThreads, optPSDDecreaseToPercentage, optPSDDeformationParametersDecreaseFactor,
			optPSDDeformationParametersMaximum, optPSDDeformationParametersMinimum, optPSDEpsAbs,
			optPSDEpsRel, optPSDErrorMode, optPSDFitFunction, optPSDGeneratingVectors, optPSDMaxEpsAbs,
			optPSDMaxEpsRel, optPSDMaxEval, optPSDMaxIncreaseFac, optPSDMinDecreaseFactor, optPSDMinEpsAbs,
			optPSDMinEpsRel, optPSDMinEval, optPSDNumberOfThreads, optPSDResetCudaAfter, optPSDTransform,
			optPSDVerbose, optPSDWallClockLimit, optPSDComplexParameterValues, optPSDRealParameterValues,
			integratorString, optPSDEvaluateMinn, optPSDMinn, optPSDMinm, optPSDFlags, optPSDVerbosity,
			integrationString, useString},

		If[	OptionValue[FCVerbose]===False,
			psiVerbose=$VeryVerbose,
			If[	MatchQ[OptionValue[FCVerbose], _Integer],
				psiVerbose=OptionValue[FCVerbose]
			];
		];

		FCPrint[1,"PSDIntegrate: Entering.", FCDoControl->psiVerbose];

		optPSDIntegrator							= OptionValue[PSDIntegrator];
		optPSDNumberOfPresamples					= OptionValue[PSDNumberOfPresamples];
		optPSDCPUThreads							= OptionValue[PSDCPUThreads];
		optPSDDecreaseToPercentage 					= OptionValue[PSDDecreaseToPercentage];
		optPSDDeformationParametersDecreaseFactor	= OptionValue[PSDDeformationParametersDecreaseFactor];
		optPSDDeformationParametersMaximum 			= OptionValue[PSDDeformationParametersMaximum];
		optPSDDeformationParametersMinimum 			= OptionValue[PSDDeformationParametersMinimum];
		optPSDEpsAbs								= OptionValue[PSDEpsAbs];
		optPSDEpsRel								= OptionValue[PSDEpsRel];
		optPSDErrorMode								= OptionValue[PSDErrorMode];
		optPSDFitFunction							= OptionValue[PSDFitFunction];
		optPSDGeneratingVectors						= OptionValue[PSDGeneratingVectors];
		optPSDMaxEpsAbs								= OptionValue[PSDMaxEpsAbs];
		optPSDMaxEpsRel								= OptionValue[PSDMaxEpsRel];
		optPSDMaxEval								= OptionValue[PSDMaxEval];
		optPSDMaxIncreaseFac						= OptionValue[PSDMaxIncreaseFac];
		optPSDMinDecreaseFactor						= OptionValue[PSDMinDecreaseFactor];
		optPSDMinEpsAbs								= OptionValue[PSDMinEpsAbs];
		optPSDMinEpsRel								= OptionValue[PSDMinEpsRel];
		optPSDMinEval								= OptionValue[PSDMinEval];
		optPSDNumberOfThreads						= OptionValue[PSDNumberOfThreads];
		optPSDResetCudaAfter						= OptionValue[PSDResetCudaAfter];
		optPSDTransform								= OptionValue[PSDTransform];
		optPSDVerbose								= OptionValue[PSDVerbose];

		optPSDComplexParameterValues 				= OptionValue[PSDComplexParameterValues];
		optPSDRealParameterValues  					= OptionValue[PSDRealParameterValues];

		optPSDEvaluateMinn							= OptionValue[PSDEvaluateMinn];
		optPSDMinn									= OptionValue[PSDMinn];
		optPSDMinm									= OptionValue[PSDMinm];
		optPSDFlags									= OptionValue[PSDFlags];
		optPSDVerbosity								= OptionValue[PSDVerbosity];


		(*Need to validate all options first*)

		If[	!MemberQ[{"Qmc","Vegas","Suave","Divonne","Cuhre","CQuad","CudaQmc"}, optPSDIntegrator],
			Message[PSDIntegrate::failmsg, "Incorrect value of the optPSDIntegrator option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDNumberOfPresamples, _Integer?Positive] || optPSDNumberOfPresamples===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDNumberOfPresamples option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDCPUThreads, _Integer?Positive] || optPSDCPUThreads===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDCPUThreads option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDDecreaseToPercentage, _Real?Positive] || optPSDDecreaseToPercentage===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDDecreaseToPercentage option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDDeformationParametersDecreaseFactor, _Real?Positive] || optPSDDeformationParametersDecreaseFactor===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDDeformationParametersDecreaseFactor option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDDeformationParametersMaximum, _Real?Positive] || optPSDDeformationParametersMaximum===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDDeformationParametersMaximum option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDDeformationParametersMinimum, _Real?Positive] || optPSDDeformationParametersMinimum===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDDeformationParametersMinimum option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDEpsAbs, _Real?Positive] || optPSDEpsAbs===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDEpsAbs option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDEpsRel, _Real?Positive] || optPSDEpsRel===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDEpsRel option."];
			Abort[];
		];


		(*TODO Split PSDErrorMode from PSDErrorModeQmc *)
		If[	!(MemberQ[{"default","all","largest"}, optPSDErrorMode] || optPSDErrorMode===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDErrorMode option."];
			Abort[];
		];

		If[	!(MemberQ[{"default","none","polysingular"}, optPSDFitFunction] || optPSDFitFunction===Default ),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDFitFunction option."];
			Abort[];
		];

		If[	!(MemberQ[{"default","cbcpt_dn1_100","cbcpt_dn2_6","cbcpt_cfftw1_6","cbcpt_cfftw2_10"}, optPSDGeneratingVectors] || optPSDGeneratingVectors===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDGeneratingVectors option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDMaxEpsAbs, _Real?Positive] || optPSDMaxEpsAbs===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMaxEpsAbs option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDMaxEpsRel, _Real?Positive] || optPSDMaxEpsRel===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMaxEpsRel option."];
			Abort[];
		];


		If[	!(MatchQ[optPSDMaxEval, _Integer?Positive] || optPSDMaxEval===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMaxEval option."];
			Abort[];
		];


		If[	!(MatchQ[optPSDMaxIncreaseFac, _Real?Positive] || optPSDMaxIncreaseFac===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMaxIncreaseFac option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDMinDecreaseFactor, _Real?Positive] || optPSDMinDecreaseFactor===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMinDecreaseFactor option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDMinEpsAbs, _Real?Positive] || optPSDMinEpsAbs===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMinEpsAbs option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDMinEpsRel, _Real?Positive] || optPSDMinEpsRel===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMinEpsRel option."];
			Abort[];
		];


		If[	!(MatchQ[optPSDMinEval, _Integer?Positive] || optPSDMinEval===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMinEval option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDNumberOfThreads, _Integer?Positive] || optPSDNumberOfThreads===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDNumberOfThreads option."];
			Abort[];
		];


		If[	!(MatchQ[optPSDResetCudaAfter, _Integer?Positive] || optPSDResetCudaAfter===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDResetCudaAfter option."];
			Abort[];
		];


		If[	!(MemberQ[{"none", "baker",
			"sidi1", "sidi2", "sidi3", "sidi4", "sidi5", "sidi6",
			"korobov1", "korobov2", "korobov3", "korobov4", "korobov5", "korobov6",
			"korobov1#1", "korobov1#2", "korobov1#3", "korobov1#4", "korobov1#5", "korobov1#6",
			"korobov2#1", "korobov2#2", "korobov2#3", "korobov2#4", "korobov2#5", "korobov2#6",
			"korobov3#1", "korobov3#2", "korobov3#3", "korobov3#4", "korobov3#5", "korobov3#6",
			"korobov4#1", "korobov4#2", "korobov4#3", "korobov4#4", "korobov4#5", "korobov4#6",
			"korobov5#1", "korobov5#2", "korobov5#3", "korobov5#4", "korobov5#5", "korobov5#6",
			"korobov6#1", "korobov6#2", "korobov6#3", "korobov6#4", "korobov6#5", "korobov6#6"}, optPSDTransform] || optPSDTransform===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDTransform option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDVerbose, True|False] || optPSDVerbose === Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of PSDVerbose option."];
			Abort[];
		];


		If[	!MatchQ[optPSDRealParameterValues, {___?NumericQ}],
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDRealParameterValues option."];
			Abort[];
		];

		If[	!MatchQ[optPSDComplexParameterValues, {___?NumericQ}],
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDComplexParameterValues option."];
			Abort[];
		];


		If[	!(MatchQ[optPSDEvaluateMinn, _Integer?Positive] || optPSDEvaluateMinn===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDEvaluateMinn option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDMinn, _Integer?Positive] || optPSDMinn===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMinn option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDMinm, _Integer?Positive] || optPSDMinm===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDMinm option."];
			Abort[];
		];

		If[	!(MatchQ[optPSDFlags, _Integer?Positive] || optPSDFlags===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDFlags option."];
			Abort[];
		];

		If[	!(MemberQ[{0,1,2,3,4}, optPSDVerbosity] || optPSDVerbosity===Default),
			Message[PSDIntegrate::failmsg, "Incorrect value of the PSDVerbosity option."];
			Abort[];
		];

		FCPrint[1,"PSDIntegrate: Done parsing the options.", FCDoControl->psiVerbose];

		optPSDRealParameterValues =
			StringReplace[ToString[Map[ToString[#]&, optPSDRealParameterValues]], {"{" -> "[", "}" -> "]"}];

		optPSDComplexParameterValues =
			StringReplace[ToString[Map[ToString[#]&, optPSDComplexParameterValues]], {"{" -> "[", "}" -> "]"}];

		FCPrint[2,"PSDIntegrate: real_parameters: ", optPSDRealParameterValues, FCDoControl->psiVerbose];
		FCPrint[2,"PSDIntegrate: complex_parameters: ", optPSDComplexParameterValues, FCDoControl->psiVerbose];

		integratorString =
			Switch[optPSDIntegrator,
						"Qmc",
							useString = ".use_Qmc(";
							{
							If[	optPSDTransform=!=Default,
								"transform = " <> FeynCalc`Package`psdToString[optPSDTransform],
								""
							],
							If[	optPSDFitFunction=!=Default,
								"fitfunction = " <> FeynCalc`Package`psdToString[optPSDFitFunction],
								""
							],
							If[	optPSDGeneratingVectors=!=Default,
								"generatingvectors = " <> FeynCalc`Package`psdToString[optPSDGeneratingVectors],
								""
							],
							If[	optPSDEpsRel=!=Default,
								"epsrel = " <> ToString[optPSDEpsRel],
								""
							],
							If[	optPSDEpsAbs=!=Default,
								"epsabs = " <> ToString[optPSDEpsAbs],
								""
							],
							If[	optPSDMaxEval=!=Default,
								"maxeval = " <> ToString[optPSDMaxEval],
								""
							],
							If[	optPSDErrorMode=!=Default,
								"errormode = " <> FeynCalc`Package`psdToString[optPSDErrorMode],
								""
							],
							If[	optPSDEvaluateMinn=!=Default,
								"evaluateminn = " <> ToString[optPSDEvaluateMinn],
								""
							],
							If[	optPSDMinn=!=Default,
								"minn = " <> ToString[optPSDMinn],
								""
							],
							If[	optPSDMinm=!=Default,
								"minm = " <> ToString[optPSDMinm],
								""
							],
							If[	optPSDVerbosity=!=Default,
								"verbosity = " <> ToString[optPSDVerbosity],
								""
							]
						},


						"Vegas",
							useString = ".use_Vegas(";
							{
							If[	optPSDEpsRel=!=Default,
								"epsrel = " <> ToString[optPSDEpsRel],
								""
							],
							If[	optPSDEpsAbs=!=Default,
								"epsabs = " <> ToString[optPSDEpsAbs],
								""
							],

							If[	optPSDFlags=!=Default,
								"epsabs = " <> ToString[optPSDEpsAbs],
								""
							],


							If[	optPSDMinEval=!=Default,
								"minxeval = " <> ToString[optPSDMinEval],
								""
							],

							If[	optPSDMaxEval=!=Default,
								"maxeval = " <> ToString[optPSDMaxEval],
								""
							]
						},
					"Suave",
						Message[PSDIntegrate::failmsg, "The support for the Suave integrator is not yet implemented."];
						Abort[],
					"Divonne",
						Message[PSDIntegrate::failmsg, "The support for the Divonne integrator is not yet implemented."];
						Abort[],
					"Cuhre",
						Message[PSDIntegrate::failmsg, "The support for the Cuhre integrator is not yet implemented."];
						Abort[],
					"CQuad",
						Message[PSDIntegrate::failmsg, "The support for the CQuad integrator is not yet implemented."];
						Abort[],
					"CudaQmc",
						Message[PSDIntegrate::failmsg, "The support for the CudaQmc integrator is not yet implemented."];
						Abort[],

					_,
						Message[PSDIntegrate::failmsg, "Invalid choice of the integrator."];
						Abort[]
				];

		FCPrint[3,"PSDIntegrate: integratorString: ", integratorString, FCDoControl->psiVerbose];


		integrationString = {

			If[	optPSDNumberOfPresamples=!=Default,
				"number_of_presamples = " <> ToString[optPSDNumberOfPresamples],
				""
			],
			If[	optPSDDeformationParametersMaximum=!=Default,
				"deformation_parameters_maximum = " <> ToString[optPSDDeformationParametersMaximum],
				""
			],
			If[	optPSDDeformationParametersMinimum=!=Default,
				"deformation_parameters_minimum = " <> ToString[optPSDDeformationParametersMinimum],
				""
			],
			If[	optPSDDeformationParametersDecreaseFactor=!=Default,
				"deformation_parameters_decrease_factor = " <> ToString[optPSDDeformationParametersDecreaseFactor],
				""
			],
			If[	optPSDEpsRel=!=Default,
				"epsrel = " <> ToString[optPSDEpsRel],
				""
			],
			If[	optPSDEpsAbs=!=Default,
				"epsabs = " <> ToString[optPSDEpsAbs],
				""
			],

			If[	optPSDMinEval=!=Default,
				"minxeval = " <> ToString[optPSDMinEval],
				""
			],
			If[	optPSDMaxEval=!=Default,
				"maxeval = " <> ToString[optPSDMaxEval],
				""
			],
			If[	optPSDMaxIncreaseFac=!=Default,
				"maxincreasefac = " <> ToString[optPSDMaxIncreaseFac],
				""
			],
			If[	optPSDMinEpsRel=!=Default,
				"min_epsrel = " <> ToString[optPSDMinEpsRel],
				""
			],

			If[	optPSDMinEpsAbs=!=Default,
				"min_epsabs = " <> ToString[optPSDMinEpsAbs],
				""
			],
			If[	optPSDMaxEpsRel=!=Default,
				"max_epsrel = " <> ToString[optPSDMaxEpsRel],
				""
			],
			If[	optPSDMaxEpsAbs=!=Default,
				"max_epsabs = " <> ToString[optPSDMaxEpsAbs],
				""
			],
			If[	optPSDMinDecreaseFactor=!=Default,
				"min_decrease_factor = " <> ToString[optPSDMinDecreaseFactor],
				""
			],

			If[	optPSDDecreaseToPercentage=!=Default,
				"decrease_to_percentage = " <> ToString[optPSDDecreaseToPercentage],
				""
			],

			If[	optPSDNumberOfThreads=!=Default,
				"number_of_threads = " <> ToString[optPSDNumberOfThreads],
				""
			],

			If[	optPSDResetCudaAfter=!=Default,
				"reset_cuda_after = " <> ToString[optPSDResetCudaAfter],
				""
			],

			If[	optPSDVerbose=!=Default,
				"verbose = " <> ToString[optPSDVerbose],
				""
			],
			"real_parameters = num_params_real",

			"complex_parameters = num_params_complex"
		};

		FCPrint[3,"PSDIntegrate: integrationString: ", integrationString, FCDoControl->psiVerbose];


		{integratorString, integrationString} = {integratorString, integrationString} /. "" -> Unevaluated[Sequence[]];


		integratorString = useString<>"\n"<>StringJoin[StringRiffle[integratorString, ",\n"]]<>")";

		integrationString = "("<>StringJoin[StringRiffle[integrationString, ",\n"]]<>"\n)";


		res = Join[StringJoin/@{integratorString, integrationString},{optPSDRealParameterValues,optPSDComplexParameterValues}];


		res

	];

End[]
