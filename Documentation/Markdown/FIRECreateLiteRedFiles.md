## FIRECreateLiteRedFiles

`FIRECreateLiteRedFiles[path]` creates lbases  files (generated with LiteRed) using the script `CreateLiteRedFiles.m` in `path`. To that aim a Mathematica kernel is started in the background via `RunProcess`. The function returns `True` if the evaluation succeeds and `False` otherwise.

Notice that lbases files must be created before generating sbases using FIRECreateStartFiles (or running the
respective scripts directly) .

Alternatively, one can use `FIRECreateLiteRedFiles[path, topo]` where `topo` is an `FCTopology` symbol and the full path is implied to be `path/topoName/CreateStartFile.m`.

If you need to process a list of topologies, following syntaxes are possible `FIRECreateLiteRedFiles[{path1,path2, ...}]`, `FIRECreateLiteRedFiles[path, {topo1, topo2, ...}]`

The path to the Mathematica Kernel can be specified via `FIREMathematicaKernelPath`. The default value is `Automatic`.

### See also

[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIREPrepareStartFile](FIREPrepareStartFile.md), [FIREMathematicaKernelPath](FIREMathematicaKernelPath.md)

### Examples

```mathematica
topo = FCTopology["prop3lX1", {SFAD[{p1, m^2}], SFAD[p2], SFAD[{p3, m^2}], SFAD[Q - p1 - p2 - p3], SFAD[Q - p1 - p2], SFAD[Q - p1], SFAD[Q - p2], SFAD[p1 + p3], SFAD[p2 + p3]}, {p1, p2, p3}, {Q}, {}, {}]
```

$$\text{FCTopology}\left(\text{prop3lX1},\left\{\frac{1}{(\text{p1}^2-m^2+i \eta )},\frac{1}{(\text{p2}^2+i \eta )},\frac{1}{(\text{p3}^2-m^2+i \eta )},\frac{1}{((-\text{p1}-\text{p2}-\text{p3}+Q)^2+i \eta )},\frac{1}{((-\text{p1}-\text{p2}+Q)^2+i \eta )},\frac{1}{((Q-\text{p1})^2+i \eta )},\frac{1}{((Q-\text{p2})^2+i \eta )},\frac{1}{((\text{p1}+\text{p3})^2+i \eta )},\frac{1}{((\text{p2}+\text{p3})^2+i \eta )}\right\},\{\text{p1},\text{p2},\text{p3}\},\{Q\},\{\},\{\}\right)$$

```mathematica
fileName = FIREPrepareStartFile[topo, FileNameJoin[{$FeynCalcDirectory, "Database"}]]
```

$$\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/prop3lX1/CreateStartFile.m}$$

```mathematica
FIRECreateLiteRedFiles[fileName, FCVerbose -> 3]
```

$$\text{FIRECreateLiteRedFiles: Full path to the Math Kernel binary: }\;\text{/media/Data/Software/Mathematica/14.0/Executables/math}$$

$$\text{FIRECreateLiteRedFiles: Full path to the script file: }\;\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/prop3lX1/CreateStartFile.m}$$

$$\text{FIRECreateLiteRedFiles: Working directory: }\;\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/prop3lX1/}$$

$$\text{FIRECreateLiteRedFiles: Script file: }\;\text{CreateStartFile.m}$$

$$\text{True}$$