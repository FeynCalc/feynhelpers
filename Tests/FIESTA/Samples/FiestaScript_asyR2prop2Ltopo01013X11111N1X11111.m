Get["/home/vs/.Mathematica/Applications/FIESTA5/FIESTA5.m"];


If[$FrontEnd===Null,
  projectDirectory=DirectoryName[$InputFileName],
  projectDirectory=NotebookDirectory[]
];
SetDirectory[projectDirectory];
resFileName = "numres_" <> StringRiffle[ToString[#, InputForm] & /@ {1.}, "_"]<>"_fiesta.m";
Print["Working directory: ", projectDirectory];
Print["The results will be saved to: ", resFileName];


uf = UF[{p1, p3},{-p3^2, -p1^2, mb^2 - (p3 + q)^2, mb^2 - (p1 + q)^2, -p3^2 + p1*(-p1 + 2*p3)}, {q^2 -> mb^2, mb -> 1}];
SetOptions[FIESTA, "NumberOfSubkernels" -> 4,"ComplexMode" -> True,"ReturnErrorWithBrackets" -> True,"Integrator" -> "quasiMonteCarlo","IntegratorOptions" -> {{"maxeval", "50000"}, {"epsrel", "1.000000E-05"}, {"epsabs", "1.000000E-12"}, {"integralTransform", "korobov"}}];
pref = 1;
resRaw = SDEvaluate[uf,{1, 1, 1, 1, 1},2];
res = resRaw*pref;
Print["Final result: ", res];
Put[res, resFileName];