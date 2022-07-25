## FerRowReduce

`FerRowReduce[mat]`uses Fermat to obtain the row-reduced echelon form of matrix `mat`.  An important difference to Mathematica's `RowReduce` is that Fermat does not assume all symbolic variables to be nonzero by default.

The location of script, input and output files is controlled by the options `FerScriptFile`, `FerInputFile`, `FerOutputFile`. When set to `Automatic` (default), these files will be automatically created via `CreateTemporary[]`. If the option `Delete` is set to `True` (default), the files will be deleted after a successful Fermat run.

### See also

[Overview](Extra/FeynHelpers.md), [FerRowReduce](FerRowReduce.md).

### Examples

The syntax of FerSolve is very similar to that of `Solve`

```mathematica
res1 = RowReduce[{{3, 1, a}, {2, 1, b}}]
```

$$\left(
\begin{array}{ccc}
 1 & 0 & a-b \\
 0 & 1 & 3 b-2 a \\
\end{array}
\right)$$

```mathematica
res2 = FerRowReduce[{{3, 1, a}, {2, 1, b}}] // Normal

(*FerRunScript: Running Fermat.
FerRunScript: Done running Fermat, timing: 0.5115*)
```

$$\left(
\begin{array}{ccc}
 1 & 0 & a-b \\
 0 & 1 & 3 b-2 a \\
\end{array}
\right)$$

```mathematica
res1 === res2
```

$$\text{True}$$

This is an example for [Mathematica SE](https://mathematica.stackexchange.com/questions/228098/how-to-write-a-more-concise-rowreduce-function-that-can-deal-with-symbolic-mat?noredirect=1&lq=1), where RowReduce assumes $a \neq 0$

```mathematica
RowReduce[{{1, a, 2}, {0, 1, 1}, {-1, 1, 1}}]
```

$$\left(
\begin{array}{ccc}
 1 & 0 & 0 \\
 0 & 1 & 0 \\
 0 & 0 & 1 \\
\end{array}
\right)$$

```mathematica
FerRowReduce[{{1, a, 2}, {0, 1, 1}, {-1, 1, 1}}] // Normal 
  
 


(*FerRunScript: Running Fermat.
FerRunScript: Done running Fermat, timing: 0.1393*)
```

$$\left(
\begin{array}{ccc}
 1 & 0 & 2-a \\
 0 & 1 & 1 \\
 0 & 0 & 2-a \\
\end{array}
\right)$$