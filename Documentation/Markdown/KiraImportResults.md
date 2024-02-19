## KiraImportResults

`KiraImportResults[topoName, path]`  imports the content of a Kira reduction table and converts the results to replacement rules for `GLI`s with the id `topoName`.

Notice that `topoName` can be also a list of replacement rules that link FIRE ids to `FCTopology` ids. For the sake of convenience one can also use full `FCTopology` objects instead of their ids as in  `KiraImportResults[topo, path]` or `KiraImportResults[{topo1, topo2, ...}, path]`.

If `path` represents a full path to a file, then this file is loaded. If it is just a path to a directory, then `path/topoName/topoName` is assumed to be the full path.

### See also

[Overview](Extra/FeynHelpers.md), [KiraCreateConfigFiles](KiraCreateConfigFiles.md), [KiraCreateJobFile](KiraCreateJobFile.md), [KiraRunReduction](KiraRunReduction.md)

### Examples

```mathematica
ibpTables = FileNameJoin[{$FeynHelpersDirectory, "Documentation", "Examples", "kira_asyR1prop2Ltopo01310X11111N1.m"}];
```

```mathematica
ibpRules = KiraImportResults["prop3L1topo010000100", ibpTables];
```

```mathematica
ibpRules // Length
```

$$10727$$

```mathematica
ibpRules[[-5 ;;]]
```

$$\left\{G^{\text{asyR1prop2Ltopo01310X11111N1}}(2,1,1,1,1)\to \frac{\left(D^3-8 D^2+20 D-16\right) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,0,1,0)}{\left(8 D^3-112 D^2+504 D-720\right) \;\text{mb}^6 \;\text{mg}^2}+\frac{(D-3) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,1,1,1)}{(4 D-24) \;\text{mb}^4},G^{\text{asyR1prop2Ltopo01310X11111N1}}(1,2,1,1,1)\to \frac{\left(D^2-4 D+4\right) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,0,1,0)}{(16 D-48) \;\text{mb}^4 \;\text{mg}^4}+\frac{(D-3) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,1,1,1)}{4 \;\text{mb}^2 \;\text{mg}^2},G^{\text{asyR1prop2Ltopo01310X11111N1}}(1,1,2,1,1)\to \frac{\left(-4 D^2+24 D-35\right) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,0,1,1)}{(16 D-64) \;\text{mb}^4 \;\text{mg}^2}+\frac{(2-D) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,1,1,0)}{4 \;\text{mb}^4 \;\text{mg}^2},G^{\text{asyR1prop2Ltopo01310X11111N1}}(1,1,1,2,1)\to \frac{\left(D^3-8 D^2+20 D-16\right) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,0,1,0)}{\left(8 D^2-64 D+120\right) \;\text{mb}^6 \;\text{mg}^2}+\frac{(D-3) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,1,1,1)}{4 \;\text{mb}^4},G^{\text{asyR1prop2Ltopo01310X11111N1}}(1,1,1,1,2)\to \frac{\left(-4 D^2+24 D-35\right) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,0,1,1)}{(16 D-64) \;\text{mb}^4 \;\text{mg}^2}+\frac{\left(-D^2+6 D-8\right) G^{\text{asyR1prop2Ltopo01310X11111N1}}(0,1,1,1,0)}{(2 D-10) \;\text{mb}^4 \;\text{mg}^2}\right\}$$