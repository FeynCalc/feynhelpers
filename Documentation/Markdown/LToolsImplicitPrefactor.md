## LToolsImplicitPrefactor

`LToolsImplicitPrefactor` is an option for `LToolsEvaluate`. It specifies a prefactor that does not show up explicitly in the input expression, but is understood to appear in front of every Passarino-Veltman function. The default value is `1`.

You may want to use `LToolsImplicitPrefactor->1/(2Pi)^D` when working with 1-loop amplitudes, if no explicit prefactor has been introduced from the very beginning.

### See also

[Overview](Extra/FeynHelpers.md), [LToolsEvaluate](LToolsEvaluate.md).

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

Here the prefactor $i \pi^2$ arises from the conversion of $\int d^D q\, 1/(q^2-m^2)$ to $A_0(m^2)$

```mathematica
LToolsEvaluate[FAD[{q, m}], q, InitialSubstitutions -> {m -> 5}]
```

$$\frac{0.\, +246.74 i}{\varepsilon }-(0.\, +972.359 i)$$

```mathematica
LToolsEvaluate[FAD[{q, m}], q, InitialSubstitutions -> {m -> 5}, Head -> keep]
```

$$\frac{i \pi ^2 \;\text{keep}(25.)}{\varepsilon }+i \pi ^2 (\text{keep}(-55.4719)-\gamma  \;\text{keep}(25.)-\text{keep}(25.) \log (\pi ))$$

This recovers the textbook prefactor

```mathematica
LToolsEvaluate[FAD[{q, m}], q, InitialSubstitutions -> {m -> 5}, LToolsImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)]
```

$$\frac{0.\, +0.158314 i}{\varepsilon }-(0.\, +0.0419639 i)$$

```mathematica
(PaXEvaluate[FAD[{q, m}], q, PaXImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)] /. {m -> 5, ScaleMu^2 -> 1}) // N
```

$$\frac{0.\, +0.158314 i}{\varepsilon }-(0.\, +0.0419639 i)$$

If the input expression contains both loop and non-loop terms, only the terms containing a `PaVe`-function will be multiplied
by the implicit prefactor

```mathematica
LToolsEvaluate[extra + FAD[{q, m}], q, InitialSubstitutions -> {m -> 2}, LToolsExpandInEpsilon -> False]
```

$$\frac{(0.\, +4. i) \pi ^{2-\varepsilon } \Gamma (\varepsilon +1) \Gamma (1-\varepsilon )^2}{\varepsilon  \Gamma (1-2 \varepsilon )}-\frac{(0.\, +1.54518 i) \pi ^{2-\varepsilon } \Gamma (\varepsilon +1) \Gamma (1-\varepsilon )^2}{\Gamma (1-2 \varepsilon )}+\text{extra}$$