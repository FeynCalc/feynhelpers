Get["/home/vs/.Mathematica/Applications/FIRE6/FIRE6.m"];
Internal={p1, p3};
External={q1};
Propagators={m3^2 - p1^2, -m1^2 - p1^2 - 2*p1*q1, -p3^2, -m1^2 - p3^2 - 2*p3*q1, -p1^2 + 2*p1*p3 - p3^2};
Replacements={q1^2 -> m1^2};
PrepareIBP[];
Prepare[AutoDetectRestrictions -> True];
SaveStart["/tmp/prop2LtopoG10/prop2LtopoG10"];
