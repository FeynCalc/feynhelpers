## PaXEvaluate

`PaXEvaluate[expr, q]` evaluates scalar 1-loop integrals (up to 4-point functions) in `expr` that depend on the loop momentum `q` in `D` dimensions.

The evaluation is using H. Patel's Package-X.

### See also

[Overview](Extra/FeynHelpers.md), [PaXEvaluateIR](PaXEvaluateIR.md), [PaXEvaluateUV](PaXEvaluateUV.md), [PaXEvaluateUVIRSplit](PaXEvaluateUVIRSplit.md).

### Examples

```mathematica
FAD[{q, m}]
PaXEvaluate[%, q, PaXImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)]
```

$$\frac{1}{q^2-m^2}$$

$$\frac{i m^2}{16 \pi ^2 \varepsilon }-\frac{i m^2 \left(-\log \left(\frac{\mu ^2}{m^2}\right)+\gamma -1-\log (4 \pi )\right)}{16 \pi ^2}$$

```mathematica
FAD[{l, 0}, {q + l, 0}]
PaXEvaluate[%, l, PaXImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)]
```

$$\frac{1}{l^2.(l+q)^2}$$

$$\frac{i}{16 \pi ^2 \varepsilon }+\frac{i \log \left(-\frac{4 \pi  \mu ^2}{q^2}\right)}{16 \pi ^2}-\frac{i (\gamma -2)}{16 \pi ^2}$$

`PaVe` functions do not require the second argument specifying the loop momentum

```mathematica
PaVe[0, {0, Pair[Momentum[p, D], Momentum[p, D]], Pair[Momentum[p, D], Momentum[p, D]]}, {0, 0, M}]
PaXEvaluate[%] 
  
 

```mathematica

$$\text{C}_0\left(0,p^2,p^2,0,0,M\right)$$

$$\frac{1}{\varepsilon  M-\varepsilon  p^2}-\frac{\gamma -\log \left(\frac{\mu ^2}{\pi  M}\right)}{M-p^2}+\frac{\log \left(\frac{M}{M-p^2}\right)}{M-p^2}+\frac{M \log \left(\frac{M}{M-p^2}\right)}{p^2 \left(M-p^2\right)}$$