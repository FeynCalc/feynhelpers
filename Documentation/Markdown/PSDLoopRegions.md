## PSDLoopRegions

`PSDLoopRegions[name, loopIntegral, order, smallnessParameter]` is an auxiliary function that creates input for pySecDec's `loop_regions` routine. The results is returned as a string.

`PSDLoopPackage` is used by `PSDCreatePythonScripts` when assembling the generation script for an asymptotic expansion.

### See also

[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md), [PSDIntegrate](PSDIntegrate.md), [PSDLoopIntegralFromPropagators](PSDLoopIntegralFromPropagators.md), [PSDLoopPackage](PSDLoopPackage.md).

### Examples

```mathematica
PSDLoopRegions["loopint", "li", 2, z]
```

$$\text{loop$\_$regions($\backslash $nname = 'loopint',$\backslash $nloop$\_$integral = li,$\backslash $nsmallness$\_$parameter = 'z',$\backslash $nexpansion$\_$by$\_$regions$\_$order = 2,$\backslash $ndecomposition$\_$method = 'geometric'$\backslash $n)}$$