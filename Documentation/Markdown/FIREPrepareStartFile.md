## FIREPrepareStartFile

`FIREPrepareStartFile[topo, path]` can be used to convert an `FCTopology` object `topo` into a FIRE. start-file.

The functions creates the corresponding Mathematica script `CreateStartFile.m` and saves it in `path/topoName`. Notice that the script still needs to be evaluated in Mathematica to generate the actual FIRE .start-file. This can be conveniently done using `FIRECreateStartFile`.

Using `FIREPrepareStartFile[{topo1, topo2, ...},  path]` will save the scripts to `path/topoName1`, `path/topoName2` etc. The syntax `FIREPrepareStartFile[{topo1, topo2, ...},  {path1, path2, ...}]` is also possible.

The default path to the FIRE package is `FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE6", "FIRE6.m"}]`. It can be adjusted using the option `FIREPath`.

### See also

[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIRECreateStartFile](FIRECreateStartFile.md), [FIRERunReduction](FIRERunReduction.md)

### Examples

```mathematica
topo = FCTopology["prop3lX1", {SFAD[{p1, m^2}], SFAD[p2], SFAD[{p3, m^2}], SFAD[Q - p1 - p2 - p3], SFAD[Q - p1 - p2], SFAD[Q - p1], SFAD[Q - p2], SFAD[p1 + p3], SFAD[p2 + p3]}, {p1, p2, p3}, {Q}, {}, {}]
```

$$\text{FCTopology}\left(\text{prop3lX1},\left\{\frac{1}{(\text{p1}^2-m^2+i \eta )},\frac{1}{(\text{p2}^2+i \eta )},\frac{1}{(\text{p3}^2-m^2+i \eta )},\frac{1}{((-\text{p1}-\text{p2}-\text{p3}+Q)^2+i \eta )},\frac{1}{((-\text{p1}-\text{p2}+Q)^2+i \eta )},\frac{1}{((Q-\text{p1})^2+i \eta )},\frac{1}{((Q-\text{p2})^2+i \eta )},\frac{1}{((\text{p1}+\text{p3})^2+i \eta )},\frac{1}{((\text{p2}+\text{p3})^2+i \eta )}\right\},\{\text{p1},\text{p2},\text{p3}\},\{Q\},\{\},\{\}\right)$$

```mathematica
fileName = FIREPrepareStartFile[topo, FileNameJoin[{$FeynCalcDirectory, "Database"}]];
fileName // FilePrint

(*(* Generated on Sun 15 May 2022 20:01:25 *)

Get["/home/vs/.Mathematica/Applications/FIRE6/FIRE6.m"];
Internal={p1, p2, p3};
External={Q};
Propagators={-m^2 + p1^2, p2^2, -m^2 + p3^2, p1^2 + 2*p1*p2 + p2^2 + 2*p1*p3 + 2*p2*p3 + p3^2 - 2*p1*Q - 2*p2*Q - 2*p3*Q + Q^2, p1^2 + 2*p1*p2 + p2^2 - 2*p1*Q - 2*p2*Q + Q^2, p1^2 - 2*p1*Q + Q^2, p2^2 - 2*p2*Q + Q^2, p1^2 + 2*p1*p3 + p3^2, p2^2 + 2*p2*p3 + p3^2};
Replacements={};
PrepareIBP[];
Prepare[AutoDetectRestrictions -> True];
SaveStart["/home/vs/.Mathematica/Applications/FeynCalc/Database/prop3lX1/prop3lX1"];*)
```