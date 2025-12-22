## PaXEvaluateUVIRSplit

`PaXEvaluateUVIRSplit[expr,q]` is like `PaXEvaluate`, but with the difference that it explicitly distinguishes between UV- and IR-divergences.

The evaluation is using H. Patel's Package-X.

### See also

[Overview](Extra/FeynHelpers.md), [PaXEvaluateIR](PaXEvaluateIR.md), [PaXEvaluateUV](PaXEvaluateUV.md), [PaXEvaluate](PaXEvaluate.md).

### Examples

```mathematica
PaXEvaluateUVIRSplit[B0[SPD[p], 0, m^2], PaXSeries -> {{SPD[p], m^2, 1}}, PaXAnalytic -> True]
```

$$\frac{m^2-p^2}{2 m^2 \varepsilon _{\text{IR}}}-\frac{\left(3 m^2-p^2\right) \left(-\log \left(\frac{\mu ^2}{m^2}\right)+\gamma -2+\log (\pi )\right)}{2 m^2}+\frac{1}{\varepsilon _{\text{UV}}}$$