## PSDLoopIntegralFromPropagators

`PSDLoopIntegralFromPropagators[int, topo]` is an auxiliary function that converts the given loop integral (in the `GLI` representation) belonging to the topology `topo` into input for pySecDec's `LoopIntegralFromPropagators` routine. The output is given as a list of two elements, containing a string and the prefactor of the integral. `PSDLoopIntegralFromPropagators`

`PSDLoopIntegralFromPropagators` is used by `PSDCreatePythonScripts` when assembling the generation script.

### See also

[Overview](Extra/FeynHelpers.md), [PSDCreatePythonScripts](PSDCreatePythonScripts.md), [PSDIntegrate](PSDIntegrate.md), [PSDLoopPackage](PSDLoopPackage.md), [PSDLoopRegions](PSDLoopRegions.md).

### Examples

```mathematica
topo = FCTopology["prop3lX1", {SFAD[{p1, m^2}], SFAD[p2], SFAD[{p3, m^2}], SFAD[Q - p1 - p2 - p3], SFAD[Q - p1 - p2], SFAD[Q - p1], SFAD[Q - p2], SFAD[p1 + p3], SFAD[p2 + p3]}, {p1, p2, p3}, {Q}, {}, {}]
```

$$\text{FCTopology}\left(\text{prop3lX1},\left\{\frac{1}{(\text{p1}^2-m^2+i \eta )},\frac{1}{(\text{p2}^2+i \eta )},\frac{1}{(\text{p3}^2-m^2+i \eta )},\frac{1}{((-\text{p1}-\text{p2}-\text{p3}+Q)^2+i \eta )},\frac{1}{((-\text{p1}-\text{p2}+Q)^2+i \eta )},\frac{1}{((Q-\text{p1})^2+i \eta )},\frac{1}{((Q-\text{p2})^2+i \eta )},\frac{1}{((\text{p1}+\text{p3})^2+i \eta )},\frac{1}{((\text{p2}+\text{p3})^2+i \eta )}\right\},\{\text{p1},\text{p2},\text{p3}\},\{Q\},\{\},\{\}\right)$$

```mathematica
PSDLoopIntegralFromPropagators[GLI["prop3lX1", {1, 1, 1, 1, 1, 1, 0, 0, 0}], topo]
```

$$\{\text{LoopIntegralFromPropagators($\backslash $n['p2**2', '(-p1 + Q)**2', '-m**2 + p3**2', '-m**2 + p1**2', '(-p1 - p2 + Q)**2', '(-p1 - p2 - p3 + Q)**2'],$\backslash $nloop$\_$momenta = ['p1', 'p2', 'p3'],$\backslash $npowerlist = [1, 1, 1, 1, 1, 1],$\backslash $ndimensionality = '4 - 2*eps',$\backslash $nFeynman$\_$parameters = 'x',$\backslash $nreplacement$\_$rules = [],$\backslash $nregulators = ['eps']$\backslash $n)},1\}$$

```mathematica
PSDLoopIntegralFromPropagators[GLI["prop3lX1", {1, 1, 1, 1, 1, 0, 0, 0, 0}], topo, FinalSubstitutions -> {FCI@SPD[Q] -> QQ, m^2 -> mm}]
```

$$\{\text{LoopIntegralFromPropagators($\backslash $n['p2**2', '-m**2 + p3**2', '-m**2 + p1**2', '(-p1 - p2 + Q)**2', '(-p1 - p2 - p3 + Q)**2'],$\backslash $nloop$\_$momenta = ['p1', 'p2', 'p3'],$\backslash $npowerlist = [1, 1, 1, 1, 1],$\backslash $ndimensionality = '4 - 2*eps',$\backslash $nFeynman$\_$parameters = 'x',$\backslash $nreplacement$\_$rules = [('Q**2','QQ'), ('m**2','mm')],$\backslash $nregulators = ['eps']$\backslash $n)},1\}$$