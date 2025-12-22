## FerMatrixToFermatArray

`FerMatrixToFermatArray[mat,varName]` is an auxiliary function that converts the matrix `mat` to a Fermat array named `varName`, where the latter must be a string.

The function returns a string that represents the matrix, a list of auxiliary variables (introduced to be compatible with the restrictions of Fermat) and a replacement rule for converting auxiliary variables back into the original variables.

### See also

[Overview](Extra/FeynHelpers.md).

### Examples

```mathematica
FerMatrixToFermatArray[{{a, b}, {c, d}}, "mat"]
```

$$\{\text{Array mat[2,2];$\backslash $n[mat]:=[[fv1, fv3, fv2, fv4]];},\{\text{fv1},\text{fv2},\text{fv3},\text{fv4}\},\{\text{fv1}\to a,\text{fv2}\to b,\text{fv3}\to c,\text{fv4}\to d\}\}$$