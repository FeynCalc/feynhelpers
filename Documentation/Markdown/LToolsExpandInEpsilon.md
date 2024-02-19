## LToolsExpandInEpsilon

`LToolsExpandInEpsilon` is an option for `LToolsEvaluate`. When set to `True` (default), the result returned by LoopTools and multiplied with proper conversion factors will be expanded around $\varepsilon = 0$ to $\mathcal{O}(\varepsilon^0)$.

The $\varepsilon$-dependent conversion factors arise from the differences in the normalization between Passarino-Veltman functions in FeynCalc and LoopTools. In addition to that, the prefactor specified via `LToolsImplicitPrefactor` may also depend on $\varepsilon$.

Setting this option to `False` will leave the prefactors unexpanded, which  might sometimes be useful when examining the obtained results.

### See also

[Overview](Extra/FeynHelpers.md), [LToolsEvaluate](LToolsEvaluate.md), [LToolsImplicitPrefactor](LToolsImplicitPrefactor.md).

### Examples

```mathematica
LToolsLoadLibrary[]
```

$$\text{LoopTools library loaded.}$$

```mathematica
(* ====================================================
   FF 2.0, a package to evaluate one-loop integrals
 written by G. J. van Oldenborgh, NIKHEF-H, Amsterdam
 ====================================================
 for the algorithms used see preprint NIKHEF-H 89/17,
 'New Algorithms for One-loop Integrals', by G.J. van
 Oldenborgh and J.A.M. Vermaseren, published in 
 Zeitschrift fuer Physik C46(1990)425.
 ====================================================*)
```

The default behavior of `LToolsEvaluate` is to do the $\varepsilon$-expansion automatically

```mathematica
LToolsEvaluate[FAD[q, q - p], q, InitialSubstitutions -> {SPD[p] -> 1}]
```

$$\frac{0.\, +9.8696 i}{\varepsilon }-(31.0063\, -2.74429 i)$$

This can be disabled by setting `LToolsExpandInEpsilon` to `False`

```mathematica
LToolsEvaluate[FAD[q, q - p], q, InitialSubstitutions -> {SPD[p] -> 1}, LToolsExpandInEpsilon -> False]
```

$$\frac{(0.\, +1. i) \pi ^{2-\varepsilon } \Gamma (1-\varepsilon )^2 \Gamma (\varepsilon +1)}{\varepsilon  \Gamma (1-2 \varepsilon )}-\frac{(3.14159\, -2. i) \pi ^{2-\varepsilon } \Gamma (1-\varepsilon )^2 \Gamma (\varepsilon +1)}{\Gamma (1-2 \varepsilon )}$$