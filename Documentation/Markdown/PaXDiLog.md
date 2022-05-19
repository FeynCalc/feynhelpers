## PaXDiLog

`PaXDiLog` corresponds to `DiLog` in Package-X.

### See also

[Overview](Extra/FeynHelpers.md).

### Examples

```mathematica
(*Just to load Package-X*)
  PaXEvaluate[A0[1]];
```

`PaXDiLog` uses ``X`DiLog`` for numerical evaluations

```mathematica
PaXDiLog[1, 2]
```

$$\frac{\pi ^2}{6}$$

```mathematica
X`DiLog[1, 2]
```

$$\frac{\pi ^2}{6}$$

The same goes for derivatives and series expansions

```mathematica
D[PaXDiLog[x, \[Alpha]], x]
```

$$-\frac{\log (1-x+i \alpha \epsilon )}{x}$$

```mathematica
Series[PaXDiLog[x, \[Alpha]], {x, 0, 5}]
```

$$x+\frac{x^2}{4}+\frac{x^3}{9}+\frac{x^4}{16}+\frac{x^5}{25}+O\left(x^6\right)$$