## LToolsEvaluate

`LToolsEvaluate[expr, q]` evaluates Passarino-Veltman functions in `expr` numerically using LoopTools by T. Hahn.

In contrast to the default behavior of LoopTools, the function returns not just the finite part but also the singular pieces proportional to $1\varepsilon$ and $1\varepsilon^2$. This behavior is controlled by the option `LToolsFullResult`.

Notice that the normalization of Passarino-Veltman functions differs between FeynCalc and LoopTools, cf. Section 1.2 of the LoopTools manual. In FeynCalc the overall prefactor is just $1/(i \pi^2)$, while LoopTools employs $1/(i \pi^{D/2} r_{\Gamma})$ with $D = 4 -2 \varepsilon$ and $r_{\Gamma} = \Gamma^2 (1 - \varepsilon) \Gamma (1 + \varepsilon) / \Gamma(1-2 \varepsilon)$.

When the option `LToolsFullResult` is set to `True`,  `LToolsEvaluate` will automatically  account for this difference by multiplying the LoopTools output with  $1/\pi^{\varepsilon} r_\Gamma$.

However, for `LToolsFullResult -> False` no such conversion will occur. This is because  the proper conversion between different $\varepsilon$-dependent normalizations requires the knowledge of the poles: when terms proportional to $\varepsilon$ multiply the poles, they generate finite contributions. In this sense it is not recommended to use `LToolsEvaluate` with `LToolsFullResult` set to `False`, unless you precisely understand what you are doing.

### See also

[Overview](Extra/FeynHelpers.md), [LToolsExpandInEpsilon](LToolsExpandInEpsilon.md), [LToolsFullResult](LToolsFullResult.md), [LToolsImplicitPrefactor](LToolsImplicitPrefactor.md), [LToolsSetMudim](LToolsSetMudim.md), [LToolsSetLambda](LToolsSetLambda.md).

### Examples

Before using `LToolsEvaluate` we need to evaluate `LToolsLoadLibray[]` to establish a connection with the Mathlink executable. The value of the option `LToolsPath` contains the full path to this file. You might need to adjust it accordingly if LoopTools is installed in a different directory.

```mathematica
OptionValue[LToolsLoadLibrary, LToolsPath]
```

$$\text{/home/vs/.Mathematica/Applications/FeynCalc/AddOns/FeynHelpers/ExternalTools/LoopTools/LoopTools}$$

Notice that `LToolsEvaluate` can also load the library by itself on the first run, in case you forget to do so.

```mathematica
LToolsLoadLibrary[]
```

$$\text{LoopTools library loaded.}$$

```
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

The value of the scale $\mu$ can be set via the option `LToolsSetMudim`. Evaluating the `PaVe`-function $A_0(m^2)$ at $m^2 = 1/10$ with $\mu^2=20$ yields

```mathematica
LToolsEvaluate[A0[m^2], LToolsSetMudim -> 20, InitialSubstitutions -> {m^2 -> 1/10}]
```

$$0.457637\, +\frac{0.1}{\varepsilon }$$

Cross-checking this result with Package-X yields the same value

```mathematica
(PaXEvaluate[A0[1/10]] /. ScaleMu^2 -> 20) // N
```

$$0.457637\, +\frac{0.1}{\varepsilon }$$

More complicated input is also possible

```mathematica
exp = a FAD[{q, m}, q - p] + b FAD[{q, M, 2}]
```

$$\frac{a}{\left(q^2-m^2\right).(q-p)^2}+\frac{b}{\left(q^2-M^2\right)^2}$$

```mathematica
res = LToolsEvaluate[exp, q, InitialSubstitutions -> {m -> 0.12352, M -> 5.14321, SPD[p] -> 0.8813}, LToolsImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon), LToolsSetMudim -> 23^2]
```

$$\frac{(0.\, +0.00633257 i) ((1.\, +0. i) a+(1.\, +0. i) b)}{\varepsilon }+(0.0661028\, +0.01955 i) ((0.\, +1. i) a+(0.128951\, +0.436013 i) b)$$

Compare to Package-X

```mathematica
chk = (PaXEvaluate[exp, q, PaXImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)] /. {ScaleMu^2 ->23^2, m -> 0.12352, M -> 5.14321, FCI@SPD[p] -> 0.8813}) // N
```

$$\frac{(0.\, +0.00633257 i) (a+b)}{\varepsilon }-(0.\, +0.00633257 i) (-14.4075 a-4.94944 b)+(-0.01955-0.0251337 i) a$$

```mathematica
FCCompareNumbers[res, chk]
```

$$\text{FCCompareNumbers: Minimal number of significant digits to agree in: }6$$

$$\text{FCCompareNumbers: Chop is set to }\;\text{1.$\grave{ }$*${}^{\wedge}$-10}$$

$$\text{FCCompareNumbers: No number is set to 0. by Chop at this stage. }$$

$$0$$