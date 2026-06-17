## FIREReduceLoopIntegrals

`FIREReduceLoopIntegrals[glis, topos, path]` performs IBP reduction of loop
integral listed in `glis` from the families given in `topos` using C++ FIRE. It returns reduction tables obtained from FIRE.


Since all processes are started from the current Mathematica notebook, it can be reliably used only for simple integrals and topologies.

### See also

[Overview](Extra/FeynHelpers.md), [FIRERunReduction](FIRERunReduction.md).

### Examples

```mathematica
glis = Get[FileNameJoin[{$FeynHelpersDirectory, "Documentation", "Examples", "glglToHH1L", "glis.m"}]];
```

```mathematica
glis // Length

(*79*)
```

```mathematica
glis[[1 ;; 5]]

(*{GLI[glglToHH1Ltopo1, {-1, 1, 1, 1}], GLI[glglToHH1Ltopo1, {0, 0, 1, 1}], GLI[glglToHH1Ltopo1, {0, 1, 0, 1}],GLI[glglToHH1Ltopo1, {0, 1, 1, 0}], GLI[glglToHH1Ltopo1, {0, 1, 1, 1}]}*)
```

```mathematica
topos = Get[FileNameJoin[{$FeynHelpersDirectory, "Documentation", "Examples", "glglToHH1L", "topos.m"}]];
```

```mathematica
topos[[1]] // FCE
```

$$\text{FCTopology}\left[\text{glglToHH1Ltopo1},\left\{\text{SFAD}\left[\left\{\{k,0\},\left\{\text{mt}^2,1\right\},1\right\}\right],\text{SFAD}\left[\left\{\{k+\text{q1},0\},\left\{\text{mt}^2,1\right\},1\right\}\right],\text{SFAD}\left[\left\{\{k+\text{p2}+\text{q1},0\},\left\{\text{mt}^2,1\right\},1\right\}\right],\text{SFAD}\left[\left\{\{k+\text{p2}+\text{q1}+\text{q2},0\},\left\{\text{mt}^2,1\right\},1\right\}\right]\right\},\{k\},\{\text{p2},\text{q1},\text{q2}\},\left\{s\to 2 \;\text{mh}^2-t-u,\text{Hold}[\text{Pair}][\text{Momentum}[\text{p1},D],\text{Momentum}[\text{p2},D]]\to \frac{1}{2} \left(2 \;\text{mh}^2-t-u\right),\text{Hold}[\text{Pair}][\text{Momentum}[\text{p1},D],\text{Momentum}[\text{q1},D]]\to -\frac{\text{mh}^2}{2}+\frac{t}{2},\text{Hold}[\text{Pair}][\text{Momentum}[\text{p1},D],\text{Momentum}[\text{q2},D]]\to -\frac{\text{mh}^2}{2}+\frac{u}{2},\text{Hold}[\text{Pair}][\text{Momentum}[\text{p2},D],\text{Momentum}[\text{p2},D]]\to 0,\text{Hold}[\text{Pair}][\text{Momentum}[\text{p2},D],\text{Momentum}[\text{q1},D]]\to -\frac{\text{mh}^2}{2}+\frac{u}{2},\text{Hold}[\text{Pair}][\text{Momentum}[\text{p2},D],\text{Momentum}[\text{q2},D]]\to -\frac{\text{mh}^2}{2}+\frac{t}{2},\text{Hold}[\text{Pair}][\text{Momentum}[\text{q1},D],\text{Momentum}[\text{q1},D]]\to \;\text{mh}^2,\text{Hold}[\text{Pair}][\text{Momentum}[\text{q1},D],\text{Momentum}[\text{q2},D]]\to -\text{mh}^2+\frac{1}{2} \left(2 \;\text{mh}^2-t-u\right),\text{Hold}[\text{Pair}][\text{Momentum}[\text{q2},D],\text{Momentum}[\text{q2},D]]\to \;\text{mh}^2\right\},\{\}\right]$$

```mathematica
dir = FileNameJoin[{$TemporaryDirectory, "Docu-Reduction-glglToHH-1L"}];
```

```mathematica
tables = FIREReduceLoopIntegrals[glis, topos, dir];
```

$$\text{FIREPrepareStartFile: }\;\text{Created }3\text{ script files.}$$

```mathematica
(*Creating config file (1/3) for glglToHH1Ltopo1 (glglToHH1Ltopo1.config)... done.
Creating config file (2/3) for glglToHH1Ltopo2 (glglToHH1Ltopo2.config)... done.
Creating config file (3/3) for glglToHH1Ltopo3 (glglToHH1Ltopo3.config)... done.

glglToHH1Ltopo1, number of loop integrals: 15
glglToHH1Ltopo2, number of loop integrals: 32
glglToHH1Ltopo3, number of loop integrals: 32

Creating LiteRed files (1/3) for glglToHH1Ltopo1... done, timing: 3.369
Creating LiteRed files (2/3) for glglToHH1Ltopo2... done, timing: 3.343
Creating LiteRed files (3/3) for glglToHH1Ltopo3... done, timing: 3.346

Creating FIRE files (1/3) for glglToHH1Ltopo1... done, timing: 6.265
Creating FIRE files (2/3) for glglToHH1Ltopo2... done, timing: 6.150
Creating FIRE files (3/3) for glglToHH1Ltopo3... done, timing: 6.392

Running reduction (1/3) for glglToHH1Ltopo1... done, timing: 0.8302
Running reduction (2/3) for glglToHH1Ltopo2... done, timing: 4.168
Running reduction (3/3) for glglToHH1Ltopo3... done, timing: 4.170

Importing reduction tables (1/3) for FileBaseName[glglToHH1Ltopo1]... done.
Importing reduction tables (2/3) for FileBaseName[glglToHH1Ltopo2]... done.
Importing reduction tables (3/3) for FileBaseName[glglToHH1Ltopo3]... done.
*)
```

$$\text{FIRECreateConfigFile: }\;\text{Created }3\text{ .config files.}$$

$$\text{FIRECreateIntegralFile: }\;\text{Created }3\text{ integral files.}$$

$$\text{FIRECreateLiteRedFiles: }\;\text{Run }3\text{ script files.}$$

$$\text{FIRECreateStartFile: }\;\text{Run }3\text{ script files.}$$

$$\text{FIRERunReduction: }\;\text{Reduced }3\text{ topologies.}$$

$$\text{FIREImportResults: }\;\text{Imported }3\text{ reduction tables.}$$

```mathematica
tables[[1 ;; 3]]
```

$$\left\{G^{\text{glglToHH1Ltopo1}}(1,1,1,1)\to G^{\text{glglToHH1Ltopo1}}(1,1,1,1),G^{\text{glglToHH1Ltopo1}}(1,1,-1,1)\to \frac{G^{\text{glglToHH1Ltopo1}}(0,0,0,1) \left(-D \;\text{mh}^2+D u+2 \;\text{mh}^2-2 u\right)}{2 \;\text{mh}^2 \;\text{mt}^2-2 \;\text{mt}^2 t}+\frac{G^{\text{glglToHH1Ltopo1}}(0,0,1,1) \left(3 \;\text{mh}^4-\text{mh}^2 t-\text{mh}^2 u-t u\right)}{\text{mh}^4-2 \;\text{mh}^2 t+t^2}+\frac{G^{\text{glglToHH1Ltopo1}}(0,1,0,1) \left(-\text{mh}^4-2 \;\text{mh}^2 t+t^2+2 t u\right)}{\text{mh}^4-2 \;\text{mh}^2 t+t^2}+\frac{G^{\text{glglToHH1Ltopo1}}(0,1,1,1) \left(\text{mh}^4-t u\right)}{\text{mh}^2-t},G^{\text{glglToHH1Ltopo1}}(1,1,0,1)\to G^{\text{glglToHH1Ltopo1}}(0,1,1,1)\right\}$$