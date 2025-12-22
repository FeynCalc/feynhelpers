Get["/home/vs/.Mathematica/Applications/FIRE6/FIRE6.m"];


If[$FrontEnd===Null,
  projectDirectory=DirectoryName[$InputFileName],
  projectDirectory=NotebookDirectory[]
];
SetDirectory[projectDirectory];
Print["Working directory: ", projectDirectory];
LaunchKernels[2];


Internal={p1, p3};
External={q1};
Propagators={m3^2 - p1^2, -m1^2 - p1^2 - 2*p1*q1, -p3^2, -m1^2 - p3^2 - 2*p3*q1, -p1^2 + 2*p1*p3 - p3^2};
Replacements={q1^2 -> m1^2};
PrepareIBP[];
Quiet[Prepare[AutoDetectRestrictions -> True,Parallel -> True,LI -> True], LaunchKernels::nodef];
TransformRules[FileNameJoin[{Directory[],"LR"}],"prop2LtopoG10.lbases",4242];
SaveSBases["prop2LtopoG10"];
