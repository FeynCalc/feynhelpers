## FerCommand

`FerCommand[str, args]` is an auxiliary function that returns a Fermat command corresponding to `str` (possibly using arguments `args`) as a list of strings.

At the moment only a very limited set of Fermat instructions is implemented.

### See also

[Overview](Extra/FeynHelpers.md).

### Examples

```mathematica
FerCommand["Quit"]
```

$$\text{$\&$q;}$$

```mathematica
FerCommand["StopReadingFromTheInputFile"]
```

$$\text{$\&$x;}$$

```mathematica
FerCommand["EnableUglyDisplay"]
```

$$\text{$\&$(U=1);}$$

```mathematica
FerCommand["ReadFromAnInputFile", "myFile.txt"]
```

$$\text{$\&$(R='myFile.txt');}$$

```mathematica
FerCommand["SaveToAnOutputFile", "myFile.txt"]
```

$$\text{$\&$(S='myFile.txt');}$$

```mathematica
FerCommand["SaveSpecifiedVariablesToAnOutputFile", {x, y, z}]
```

$$\text{!($\&$o, x, y, z);}$$

```mathematica
FerCommand["ReducedRowEchelonForm", "mat"]
```

$$\text{Redrowech(mat);}$$

```mathematica
FerCommand["AdjoinPolynomialVariable", x]
```

$$\text{$\&$(J=x);}$$