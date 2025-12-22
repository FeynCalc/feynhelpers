## PaXEvaluateIR

`PaXEvaluateIR[expr,q]` is like `PaXEvaluate` but with the difference that it returns only the IR-divergent part of the result.

### See also

[Overview](Extra/FeynHelpers.md), [PaXEvaluate](PaXEvaluate.md), [PaXEvaluateUV](PaXEvaluateUV.md), [PaXEvaluateUVIRSplit](PaXEvaluateUVIRSplit.md).

### Examples

```mathematica
PaXEvaluateIR[B0[SPD[p], 0, m^2], PaXSeries -> {{SPD[p], m^2, 1}}, PaXAnalytic -> True]
```

$$\frac{1}{2 \varepsilon _{\text{IR}}}-\frac{p^2}{2 m^2 \varepsilon _{\text{IR}}}$$