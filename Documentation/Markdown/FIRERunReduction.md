## FIRERunReduction

`FIRERunReduction[path]` runs C++ FIRE on the FIRE .config file specified by path.  To that aim the FIRE binary is started in the background via `RunProcess`. The function returns `True` if the evaluation succeeds and `False` otherwise.

If `path` represents a full path to a file, then this file is used as the .config file. If it is just a path to a directory, then `path/topoName/topoName.config` is assumed to be the full path.

The default path to the FIRE binary is `FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE6", "bin", "FIRE6"}]`. It can be modified via the option `FIREBinaryPath`.

### See also

[Overview](Extra/FeynHelpers.md), [FIRECreateConfigFile](FIRECreateConfigFile.md), [FIRECreateStartFile](FIRECreateStartFile.md).

### Examples

```mathematica
FIRERunReduction[FileNameJoin[{$FeynHelpersDirectory, "Documentation", "Examples", "asyR2prop2Ltopo13311X01201N1"}], FCVerbose -> 3]
```

$$\text{FIRERunReduction: Full path to the FIRE binary: }\;\text{/home/vs/.Mathematica/Applications/FIRE6/bin/FIRE6}$$

$$\text{FIRERunReduction: Working directory: }\;\text{/home/vs/.Mathematica/Applications/FeynCalc/AddOns/FeynHelpers/Documentation/Examples/asyR2prop2Ltopo13311X01201N1/}$$

$$\text{FIRERunReduction: Config file: }\;\text{asyR2prop2Ltopo13311X01201N1}$$

$$\text{True}$$