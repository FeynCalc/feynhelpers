![1ftg3ucp91fwc](img/1ftg3ucp91fwc.svg)

```mathematica
 
```

## PSDLoadNumericalResults

`PSDLoadNumericalResults[files]` is a simple function that loads numerical results generated by the pySecDec script `integrate__int.py` into Mathematica. The argument `files` is the output of `PSDCreatePythonScripts` that contains the full paths to `generate_int.py` and `integrate_int.py`.

Furthermore, the function requires the options `PSDComplexParameterRules` and `PSDRealParameterRules` that must be assigned exactly the same values that were used when evaluating PSDCreatePythonScripts. From this information the function will recover the full path to the `numres_*_mma.m` file and load it.

The options `Normal` (set to `True` by default) and `Chop` (set to `10^(-10)` by default) tell the function to convert the expression from `SeriesData` to a polynomial and to remove numerical artefacts.

The output for each integral is a list containing two entries. The first entry is the numerical result, while the second one provides numerical errors.

### See also

[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md).

### Examples

```mathematica
files = {
    FileNameJoin[{$FeynHelpersDirectory, "Documentation", "Examples", "prop1LX11", "integrate_int.py"}], 
    FileNameJoin[{$FeynHelpersDirectory, "Documentation", "Examples", "prop1LX11", "generate_int.py"}]};
```

```mathematica
FCCompareNumbers[PSDLoadNumericalResults[files, PSDRealParameterRules -> {qq -> 1. , m1 -> 2. , m2 -> 3.}], 
  {-1.819085009768877 + eps^(-1), 0}, FCVerbose -> -1]
```

$$\{0,0\}$$