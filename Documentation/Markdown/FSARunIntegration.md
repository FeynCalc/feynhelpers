## FSARunIntegration

`FSARunIntegration[path]` evaluates a FIESTA script `FiestaScript.m` in `path`. To that aim a Mathematica kernel is started in the background via `RunProcess`. The function returns `True` if the evaluation succeeds and `False` otherwise.

Alternatively, one can use `FSARunIntegration[path, topo]` where `topo` is an `FCTopology` symbol and the full path is implied to be `path/topoName/FiestaScript.m`.

If you need to process a list of topologies, following syntaxes are possible `FiestaScript.m[{path1,path2, ...}]`, `FiestaScript.m[path, {topo1, topo2, ...}]`

The path to the Mathematica Kernel can be specified via `FSAMathematicaKernelPath`. The default value is `Automatic`.

### See also

[Overview](Extra/FeynHelpers.md), [FSAShowOutput](FSAShowOutput.md), [FSAMathematicaKernelPath](FSAMathematicaKernelPath.md).

### Examples

```mathematica
topo1 = FCTopology[prop1L, {-SFAD[{{I p1, 0}, {-m1^2, -1}, 1}], -SFAD[{{I (p1 + q), 0}, {-m2^2, -1}, 1}]}, {p1}, {q}, {}, {}]
int1 = GLI[prop1L, {1, 1}]
```

$$\text{FCTopology}\left(\text{prop1L},\left\{-\frac{1}{(-\text{p1}^2+\text{m1}^2-i \eta )},-\frac{1}{(-(\text{p1}+q)^2+\text{m2}^2-i \eta )}\right\},\{\text{p1}\},\{q\},\{\},\{\}\right)$$

$$G^{\text{prop1L}}(1,1)$$

```mathematica
fileNames = FSAPrepareSDEvaluate[int1, topo1, FileNameJoin[{$FeynCalcDirectory, "Database"}], 
    FinalSubstitutions -> {SPD[q] -> qq, qq -> 20. , m1 -> 2. , m2 -> 2.}];
```

```mathematica
FSARunIntegration[fileNames[[1]]]
```

$$\text{FSARunIntegration}\left(G^{\text{prop1L}}(1,1)\right)$$