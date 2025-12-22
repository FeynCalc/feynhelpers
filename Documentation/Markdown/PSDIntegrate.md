## PSDIntegrate

`PSDIntegrate[]` is an auxiliary function that creates input for pySecDec's numerical integration routines. The output is returned in form of a string.

`PSDIntegrate` is used by `PSDCreatePythonScripts` when assembling the integration script.

### See also

[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md), [PSDLoopIntegralFromPropagators](PSDLoopIntegralFromPropagators.md), [PSDLoopPackage](PSDLoopPackage.md), [PSDLoopRegions](PSDLoopRegions.md).

### Examples

```mathematica
PSDIntegrate[PSDRealParameterValues -> {11., 42.}]
```

$$\{\text{.use$\_$Qmc($\backslash $n)},\text{(real$\_$parameters = num$\_$params$\_$real,$\backslash $ncomplex$\_$parameters = num$\_$params$\_$complex$\backslash $n)},\text{[11., 42.]},\text{[]}\}$$

```mathematica
PSDIntegrate[PSDRealParameterValues -> {2., 4.}, PSDIntegrator -> "Vegas", PSDMinEval -> 10^5]
```

$$\{\text{.use$\_$Vegas($\backslash $nminxeval = 100000)},\text{(minxeval = 100000,$\backslash $nreal$\_$parameters = num$\_$params$\_$real,$\backslash $ncomplex$\_$parameters = num$\_$params$\_$complex$\backslash $n)},\text{[2., 4.]},\text{[]}\}$$