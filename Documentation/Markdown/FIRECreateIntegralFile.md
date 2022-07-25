## FIRECreateIntegralFile

`FIRECreateIntegralFile[ex, topo, fireID, path]` extracts `GLI` symbols from `ex` that belong to the topology `topo`. The resulting list of integrals is saved to `path/topoName/LoopIntegrals.m` and can be referred to in the corresponding FIRE .config file.

If the directory specified in `path/topoName` does not exist, it will be created automatically. If it already exists, its content will be automatically overwritten, unless the option `OverwriteTarget` is set to `False`.

If no `fireID` is given, i.e. the function is called as `FIRECreateIntegralFile[topo,  path]`, then the default value `4242` is used.

Notice that `ex` may also contain integrals from different topologies, as long as all those topologies are provided as a list in the `topo` argument.

It is also possible to invoke  the routine as `FIRECreateIntegralFile[ex, {topo1, topo2, ...}, {id1, id2, ...}, {path1, path2, ...}]` or `FIRECreateIntegralFile[ex, {topo1, topo2, ...}, {path1, path2, ...}]`if one needs to process a list of topologies.

The syntax  `FIRECreateIntegralFile[ex, {topo1, topo2, ...}, {id1, id2, ...}, path]` or `FIRECreateIntegralFile[ex, {topo1, topo2, ...}, path]` is also allowed. This implies that all config files will go into the corresponding subdirectories of path, e.g. `path/topoName1`, `path/topoName2` etc.

The default name of the file containing loop integrals for the reduction is "LoopIntegrals.m". It can be changed via the option `FIREIntegrals`.

### See also

[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIREIntegrals](FIREIntegrals.md).

### Examples

```mathematica
ints = la^8*GLI["asyR3prop2Ltopo01310X11111N1", {-7, 1, 1, 9, 1}] + 
    la^8*GLI["asyR3prop2Ltopo01310X11111N1", {-6, 0, 2, 8, 1}] - 
    la^7*GLI["asyR3prop2Ltopo01310X11111N1", {-6, 1, 1, 8, 1}] - 
    la^8*mg^2*GLI["asyR3prop2Ltopo01310X11111N1", {-6, 1, 2, 8, 1}] + 
    la^8*GLI["asyR3prop2Ltopo01310X11111N1", {-5, -1, 3, 7, 1}] - 
    la^7*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 0, 2, 7, 1}] - 
    2*la^8*mg^2*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 0, 3, 7, 1}] + 
    la^6*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 1, 1, 7, 1}] + 
    la^7*mg^2*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 1, 2, 7, 1}] + 
    la^8*mg^4*GLI["asyR3prop2Ltopo01310X11111N1", {-5, 1, 3, 7, 1}];
```

```mathematica
topo = FCTopology["asyR3prop2Ltopo01310X11111N1", {SFAD[{{I*p1, 0}, {0, -1}, 1}], SFAD[{{I*p3, 0}, {-mg^2, -1}, 1}], SFAD[{{0, -2*p3 . q}, {0, -1}, 1}], SFAD[{{0, -2*p1 . q}, {0, -1}, 1}], SFAD[{{I*(p1 - p3), 0}, {0, -1}, 1}]}, {p1, p3}, {q}, {SPD[q, q] -> mb^2}, {}]
```

$$\text{FCTopology}\left(\text{asyR3prop2Ltopo01310X11111N1},\left\{\frac{1}{(-\text{p1}^2-i \eta )},\frac{1}{(-\text{p3}^2+\text{mg}^2-i \eta )},\frac{1}{(-2 (\text{p3}\cdot q)-i \eta )},\frac{1}{(-2 (\text{p1}\cdot q)-i \eta )},\frac{1}{(-(\text{p1}-\text{p3})^2-i \eta )}\right\},\{\text{p1},\text{p3}\},\{q\},\left\{q^2\to \;\text{mb}^2\right\},\{\}\right)$$

```mathematica
fileName = FIRECreateIntegralFile[ints, topo, FileNameJoin[{$FeynCalcDirectory, "Database"}]];
fileName // FilePrint
```

$$\text{FIRECreateIntegralFile: Number of loop integrals: }10$$

```
(*{{4242, {-7, 1, 1, 9, 1}}, {4242, {-6, 0, 2, 8, 1}}, 
 {4242, {-6, 1, 1, 8, 1}}, {4242, {-6, 1, 2, 8, 1}}, 
 {4242, {-5, -1, 3, 7, 1}}, {4242, {-5, 0, 2, 7, 1}}, 
 {4242, {-5, 0, 3, 7, 1}}, {4242, {-5, 1, 1, 7, 1}}, 
 {4242, {-5, 1, 2, 7, 1}}, {4242, {-5, 1, 3, 7, 1}}}*)
```

```mathematica
fileName = FIRECreateIntegralFile[ints, topo, 1500, FileNameJoin[{$FeynCalcDirectory, "Database"}]];
fileName // FilePrint
```

$$\text{FIRECreateIntegralFile: Number of loop integrals: }10$$

```
(*{{1500, {-7, 1, 1, 9, 1}}, {1500, {-6, 0, 2, 8, 1}}, 
 {1500, {-6, 1, 1, 8, 1}}, {1500, {-6, 1, 2, 8, 1}}, 
 {1500, {-5, -1, 3, 7, 1}}, {1500, {-5, 0, 2, 7, 1}}, 
 {1500, {-5, 0, 3, 7, 1}}, {1500, {-5, 1, 1, 7, 1}}, 
 {1500, {-5, 1, 2, 7, 1}}, {1500, {-5, 1, 3, 7, 1}}}*)
```

```mathematica
FIRECreateIntegralFile[ints, topo, 1500, FileNameJoin[{$FeynCalcDirectory, "Database"}], FCVerbose -> -1];
```

```mathematica
ex2 = c1 GLI[prop1l, {1, 1}] + c2 GLI[prop1l, {2, 0}] + c3 GLI[tad2l, {1, 1, 0}] + c4 GLI[tad2l, {1, 1, 1}] l
```

$$\text{c1} G^{\text{prop1l}}(1,1)+\text{c2} G^{\text{prop1l}}(2,0)+\text{c3} G^{\text{tad2l}}(1,1,0)+\text{c4} l G^{\text{tad2l}}(1,1,1)$$

```mathematica
topos = {
   FCTopology[prop1l, {FAD[{p1, m1}], FAD[{p1 + q, m2}]}, {p1}, {q}, {}, {}], 
   
   FCTopology[tad2l, {FAD[{p1, m1}], FAD[{p2, m2}], FAD[{p1 - p2, m3}]}, {p1, p2}, {}, {}, {}] 
  }
```

$$\left\{\text{FCTopology}\left(\text{prop1l},\left\{\frac{1}{\text{p1}^2-\text{m1}^2},\frac{1}{(\text{p1}+q)^2-\text{m2}^2}\right\},\{\text{p1}\},\{q\},\{\},\{\}\right),\text{FCTopology}\left(\text{tad2l},\left\{\frac{1}{\text{p1}^2-\text{m1}^2},\frac{1}{\text{p2}^2-\text{m2}^2},\frac{1}{(\text{p1}-\text{p2})^2-\text{m3}^2}\right\},\{\text{p1},\text{p2}\},\{\},\{\},\{\}\right)\right\}$$

```mathematica
fileNames = FIRECreateIntegralFile[ex2, topos, {112, 113}, FileNameJoin[{$FeynCalcDirectory, "Database"}]];
```

$$\text{FIRECreateIntegralFile: Number of loop integrals: }2$$

$$\text{FIRECreateIntegralFile: Number of loop integrals: }2$$

```mathematica
fileNames[[1]] // FilePrint

(*{{112, {1, 1}}, {112, {2, 0}}}*)
```

```mathematica
fileNames[[2]] // FilePrint

(*{{113, {1, 1, 0}}, {113, {1, 1, 1}}}*)
```

```mathematica
FIRECreateIntegralFile[ex2, topos, FileNameJoin[{$FeynCalcDirectory, "Database"}], FCVerbose -> -1, 
  FIREIntegrals -> "LIs.m"]
```

$$\{\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/prop1l/LIs.m},\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/tad2l/LIs.m}\}$$