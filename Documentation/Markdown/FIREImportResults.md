## FIREImportResults

`FIREImportResults[topoName, path]`  imports the content of a FIRE .tables file and converts the results to replacement rules for `GLI`s with the id `topoName`.

Notice that `topoName` can be also a list of replacement rules that link FIRE ids to `FCTopology` ids. For the sake of convenience one can also use full `FCTopology` objects instead of their ids as in  `FIREImportResults[topo, path]` or `FIREImportResults[{topo1, topo2, ...}, path]`.

If `path` represents a full path to a file, then this file is loaded. If it is just a path to a directory, then `path/topoName/topoName` is assumed to be the full path.

### See also

[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIRECreateStartFile](FIRECreateStartFile.md), [FIRERunReduction](FIRERunReduction.md)

### Examples

```mathematica
ibpTables = FileNameJoin[{$FeynHelpersDirectory, "Documentation", "Examples", "prop3L1topo010000100.tables"}];
```

```mathematica
ibpRules = FIREImportResults["prop3L1topo010000100", ibpTables];
```

```mathematica
ibpRules // Length
```

$$112$$

```mathematica
ibpRules[[1 ;; 2]]
```

$$\left\{G^{\text{prop3L1topo010000100}}(1,1,-2,1,1,-2,1,1,0)\to \frac{\left(d^2-8 d+16\right) \;\text{m1}^8 G^{\text{prop3L1topo010000100}}(0,1,1,1,1,1,1,0,0)}{16 d^2-32 d+16}+\frac{\left(-35 d^5+456 d^4-2092 d^3+4048 d^2-3136 d+768\right) \;\text{m1}^6 G^{\text{prop3L1topo010000100}}(0,0,1,1,1,1,1,0,0)}{216 d^5-1296 d^4+3000 d^3-3360 d^2+1824 d-384}+\frac{\left(42 d^6-484 d^5+2333 d^4-5568 d^3+6572 d^2-3456 d+576\right) \;\text{m1}^4 G^{\text{prop3L1topo010000100}}(0,0,1,1,1,1,0,0,0)}{216 d^6-1620 d^5+4944 d^4-7860 d^3+6864 d^2-3120 d+576},G^{\text{prop3L1topo010000100}}(1,1,-1,1,1,-1,1,1,-1)\to \frac{\left(6 d-3 d^2\right) \;\text{m1}^6 G^{\text{prop3L1topo010000100}}(0,1,1,1,1,1,1,0,0)}{32 d^2-64 d+32}+\frac{\left(-61 d^4+380 d^3-860 d^2+864 d-320\right) \;\text{m1}^4 G^{\text{prop3L1topo010000100}}(0,0,1,1,1,1,1,0,0)}{144 d^4-768 d^3+1488 d^2-1248 d+384}+\frac{\left(42 d^4-253 d^3+550 d^2-520 d+176\right) \;\text{m1}^2 G^{\text{prop3L1topo010000100}}(0,0,1,1,1,1,0,0,0)}{72 d^4-384 d^3+744 d^2-624 d+192}\right\}$$

```mathematica
ibpRulesTest = FIREImportResults[{3110 -> "prop3L1topo010000100"}, ibpTables];
```

```mathematica
ibpRules === ibpRulesTest
```

$$\text{True}$$

```mathematica
ibpRulesTest[[3 ;; 4]]
```

$$\left\{G^{\text{prop3L1topo010000100}}(1,1,-1,1,1,-2,1,1,0)\to \frac{(4-d) \;\text{m1}^6 G^{\text{prop3L1topo010000100}}(0,1,1,1,1,1,1,0,0)}{8 d-8}+\frac{(8-5 d) \;\text{m1}^4 G^{\text{prop3L1topo010000100}}(0,0,1,1,1,1,1,0,0)}{12 d-12}+\frac{(3 d-8) \;\text{m1}^2 G^{\text{prop3L1topo010000100}}(0,0,1,1,1,1,0,0,0)}{6 d-6},G^{\text{prop3L1topo010000100}}(1,1,-2,1,1,-1,1,1,0)\to \frac{(4-d) \;\text{m1}^6 G^{\text{prop3L1topo010000100}}(0,1,1,1,1,1,1,0,0)}{8 d-8}+\frac{(8-5 d) \;\text{m1}^4 G^{\text{prop3L1topo010000100}}(0,0,1,1,1,1,1,0,0)}{12 d-12}+\frac{(3 d-8) \;\text{m1}^2 G^{\text{prop3L1topo010000100}}(0,0,1,1,1,1,0,0,0)}{6 d-6}\right\}$$

```mathematica
topo = FCTopology[prop3L1topo010000100, {SFAD[{{I*p1, 0}, {0, -1}, 1}], SFAD[{{I*p2, 0}, {-m1^2, -1}, 1}], SFAD[{{I*p3, 0}, {0, -1}, 1}], SFAD[{{I*(p1 - p2), 0}, {0, -1}, 1}], SFAD[{{I*(p2 - p3), 0}, {0, -1}, 1}], SFAD[{{I*(p1 + q1), 0}, {0, -1}, 1}], SFAD[{{I*(p2 + q1), 0}, {-m1^2, -1}, 1}], SFAD[{{I*(p3 + q1), 0}, {0, -1}, 1}], SFAD[{{0, -p1 . p3}, {0, -1}, 1}]}, {p1, p2, p3}, {q1}, {SPD[q1, q1] -> m1^2}, {}];
```