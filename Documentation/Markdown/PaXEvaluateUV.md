## PaXEvaluateUV

`PaXEvaluateUV[expr,q]` is like `PaXEvaluate` but with the difference that it returns only the UV-divergent part of the result.

The evaluation is using H. Patel's Package-X.

### See also

[Overview](Extra/FeynHelpers.md), [PaXEvaluateIR](PaXEvaluateIR.md), [PaXEvaluate](PaXEvaluate.md), [PaXEvaluateUVIRSplit](PaXEvaluateUVIRSplit.md).

### Examples

```mathematica
int = -FAD[{k, m}] + 2*FAD[k, {k - p, m}]*(m^2 + SPD[p, p])
```

$$\frac{2 \left(m^2+p^2\right)}{k^2.\left((k-p)^2-m^2\right)}-\frac{1}{k^2-m^2}$$

```mathematica
PaXEvaluateUV[%, k, PaXImplicitPrefactor -> 1/(2 Pi)^D, FCE -> True]
```

$$\frac{i m^2}{16 \pi ^2 \varepsilon _{\text{UV}}}+\frac{i p^2}{8 \pi ^2 \varepsilon _{\text{UV}}}$$

Notice that with `PaVeUVPart` one can get the same result

```mathematica
res = PaVeUVPart[ToPaVe[int, k], Prefactor -> 1/(2 Pi)^D]
```

$$-\frac{i 2^{1-2 D} \pi ^{2-2 D} \left(2^{D+1} \pi ^D m^2-(2 \pi )^D m^2+2^{D+1} \pi ^D p^2\right)}{D-4}$$

```mathematica
Series[FCReplaceD[res, D -> 4 - 2 EpsilonUV], {EpsilonUV, 0, 0}] // Normal // SelectNotFree2[#, EpsilonUV] & // ExpandAll
```

$$\frac{i m^2}{16 \pi ^2 \varepsilon _{\text{UV}}}+\frac{i p^2}{8 \pi ^2 \varepsilon _{\text{UV}}}$$

```mathematica
int2 = TID[FVD[2 k - p, mu] FVD[2 k - p, nu] FAD[{k, m}, {k - p, m}] - 2 MTD[mu, nu] FAD[{k, m}], k]
```

$$\frac{-(1-D) p^2 p^{\text{mu}} p^{\text{nu}}-D p^2 p^{\text{mu}} p^{\text{nu}}-4 m^2 p^2 g^{\text{mu}\;\text{nu}}+p^4 g^{\text{mu}\;\text{nu}}+4 m^2 p^{\text{mu}} p^{\text{nu}}}{(1-D) p^2 \left(k^2-m^2\right).\left((k-p)^2-m^2\right)}+\frac{2 \left(-(1-D) p^2 g^{\text{mu}\;\text{nu}}-D p^{\text{mu}} p^{\text{nu}}-p^2 g^{\text{mu}\;\text{nu}}+2 p^{\text{mu}} p^{\text{nu}}\right)}{(1-D) p^2 \left(k^2-m^2\right)}$$

```mathematica
PaXEvaluateUV[int2, k, PaXImplicitPrefactor -> 1/(2 Pi)^D, FCE -> True]
```

$$\frac{i p^{\text{mu}} p^{\text{nu}}}{48 \pi ^2 \varepsilon _{\text{UV}}}-\frac{i p^2 g^{\text{mu}\;\text{nu}}}{48 \pi ^2 \varepsilon _{\text{UV}}}$$