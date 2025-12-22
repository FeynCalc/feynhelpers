SetDirectory[FileNameJoin[{DirectoryName["/home/vs/.Mathematica/Applications/FIRE6/FIRE6.m"],"extra","LiteRed","Setup"}]];
Get["LiteRed.m"];


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
Quiet[CreateNewBasis[topology, Directory->FileNameJoin[{Directory[],"LR"}]], {DiskSave::overwrite,DiskSave::dir}];
Quiet[GenerateIBP[topology], FrontEndObject::notavail];
Quiet[AnalyzeSectors[topology], FrontEndObject::notavail];
Quiet[FindSymmetries[topology, EMs->True], FrontEndObject::notavail];
Quiet[DiskSave[topology], {DiskSave::overwrite,DiskSave::dir}];
