Get["/home/vs/.Mathematica/Applications/FIESTA5/FIESTA5.m"];


If[$FrontEnd===Null,
  projectDirectory=DirectoryName[$InputFileName],
  projectDirectory=NotebookDirectory[]
];
SetDirectory[projectDirectory];
resFileName = "numres_" <> StringRiffle[ToString[#, InputForm] & /@ {1., 1., 1.}, "_"]<>"_fiesta.m";
Print["Working directory: ", projectDirectory];
Print["The results will be saved to: ", resFileName];


uf = UF[{p1},{m1^2 - p1^2, m2^2 - (p1 + q)^2}, {q^2 -> qq, m1 -> 1, m2 -> 1, qq -> 1}];
SetOptions[FIESTA, "ComplexMode" -> True,"ReturnErrorWithBrackets" -> True,"Integrator" -> "quasiMonteCarlo"];
pref = 1;
resRaw = SDEvaluate[uf,{1, 1},0];
res = resRaw*pref;
Print["Final result: ", res];
Put[res, resFileName];