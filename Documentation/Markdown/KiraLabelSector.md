```mathematica
 
```

## KiraLabelSector

`KiraLabelSector[sec]` returns the standard Kira labelling $S$ for the given sector `sec` (e.g. `{1,1,0,1,1}`).

### See also

[Overview](Extra/FeynHelpers.md), [KiraCreateJobFile](KiraCreateJobFile.md).

### Examples

```mathematica
KiraLabelSector[{1, 1, 0, 1, 1}]
```

$$27$$

```mathematica
KiraLabelSector[{1, 1, 0, 0, 0}]
```

$$3$$

```mathematica
KiraLabelSector[{{1, 1, 0, 1, 1}, {1, 1, 1, 0, 0}}]
```

$$\{27,7\}$$

```mathematica
KiraLabelSector[{1, 1, 0, 0, 0}]
```

$$3$$