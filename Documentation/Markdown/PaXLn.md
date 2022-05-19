## PaXLn

`PaXLn` corresponds to `Ln` in Package-X.

### See also

[Overview](Extra/FeynHelpers.md).

### Examples

```mathematica
(*Just to load Package-X*)
  PaXEvaluate[A0[1]];
```

`PaXLn` uses ``X`Ln`` for numerical evaluations

```mathematica
PaXLn[-4.5, 1]
```

$$1.50408\, +3.14159 i$$

```mathematica
X`Ln[-4.5, 1]
```

$$1.50408\, +3.14159 i$$

The same goes for derivatives and series expansions

```mathematica
D[PaXLn[x, \[Alpha]], x]
```

$$\frac{1}{x}$$

```mathematica
Series[PaXLn[x, \[Alpha]], {x, 1, 2}]
```

$$\log (1+i \alpha \epsilon )+(x-1)-\frac{1}{2} (x-1)^2+O\left((x-1)^3\right)$$