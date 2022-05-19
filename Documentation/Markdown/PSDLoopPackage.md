## PSDLoopPackage

`PSDLoopPackage[name, loopIntegral, order]` is an auxiliary function that creates input for pySecDec's `loop_package` routine. The result is returned as a string.

`PSDLoopPackage` is used by `PSDCreatePythonScripts` when assembling the generation script.

### See also

[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md), [PSDIntegrate](PSDIntegrate.md), [PSDLoopIntegralFromPropagators](PSDLoopIntegralFromPropagators.md), [PSDLoopRegions](PSDLoopRegions.md).

### Examples

```mathematica
PSDLoopPackage["loopint", "li", 2]
```

$$\text{loop$\_$package($\backslash $nname = 'loopint',$\backslash $nloop$\_$integral = li,$\backslash $nrequested$\_$orders = [2],$\backslash $ndecomposition$\_$method = 'geometric'$\backslash $n)}$$

```mathematica
PSDLoopPackage["loopint", "li", 0, PSDDecompositionMethod -> "iterative", 
  PSDAdditionalPrefactor -> "2", PSDContourDeformation -> False]
```

$$\text{loop$\_$package($\backslash $nname = 'loopint',$\backslash $nloop$\_$integral = li,$\backslash $nrequested$\_$orders = [0],$\backslash $ncontour$\_$deformation = False,$\backslash $nadditional$\_$prefactor = '2',$\backslash $ndecomposition$\_$method = 'iterative'$\backslash $n)}$$