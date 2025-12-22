## PaXContinuedDiLog

`PaXContinuedDiLog` corresponds to `ContinuedDiLog` in Package-X.

### See also

[Overview](Extra/FeynHelpers.md).

### Examples

```mathematica
(*Just to load Package-X*)
  PaXEvaluate[A0[1]];
```

`PaXContinuedDiLog` uses ``X`ContinuedDiLog`` for numerical evaluations

```mathematica
PaXContinuedDiLog[{3.2, 1.0}, {1.1, 1.0}]
```

$$-1.7089$$

```mathematica
X`ContinuedDiLog[{3.2, 1.0}, {1.1, 1.0}]
```

$$-1.7089$$

The same goes for derivatives and series expansions

```mathematica
D[PaXContinuedDiLog[{x, xInf}, {y, yInf}], x]
```

$$-\frac{y (-\log (x+i \;\text{xInf}\epsilon )-\log (y+i \;\text{yInf}\epsilon ))}{1-x y}$$

```mathematica
Series[PaXContinuedDiLog[{x, xInf}, {y, yInf}], {x, 1, 2}]
```

$$\mathcal{L}_2(1+i \;\text{xInf}\epsilon ,y+i \;\text{yInf}\epsilon )-\frac{(x-1) y \log (y+i \;\text{yInf}\epsilon )}{y-1}+\frac{(x-1)^2 \left(y^2 \log (y+i \;\text{yInf}\epsilon )-y^2+y\right)}{2 (y-1)^2}+O\left((x-1)^3\right)$$