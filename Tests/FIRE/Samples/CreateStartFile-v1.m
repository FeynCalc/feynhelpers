Get["/home/vs/.Mathematica/Applications/FIRE6/FIRE6.m"];


If[$FrontEnd===Null,
  projectDirectory=DirectoryName[$InputFileName],
  projectDirectory=NotebookDirectory[]
];
SetDirectory[projectDirectory];
Print["Working directory: ", projectDirectory];


Internal={p1, p3};
External={q1};
Propagators={m3^2 - p1^2, -m1^2 - p1^2 - 2*p1*q1, -p3^2, -m1^2 - p3^2 - 2*p3*q1, -p1^2 + 2*p1*p3 - p3^2};
Replacements={q1^2 -> m1^2};
PrepareIBP[];
Prepare[AutoDetectRestrictions -> True];
SaveStart["prop2LtopoG10"];
