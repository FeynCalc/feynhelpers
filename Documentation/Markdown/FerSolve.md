## FerSolve

`FerSolve[eqs, vars]` solves the system of linear equations `eqs` for the variables `vars` by calculating the row-reduced form of the corresponding augmented matrix using Fermat by R. Lewis.

The location of script, input and output files is controlled by the options `FerScriptFile`, `FerInputFile`, `FerOutputFile`. When set to `Automatic` (default), these files will be automatically created via
`CreateTemporary[]`. If the option `Delete` is set to `True` (default), the files will be deleted after a successful Fermat run.

### See also

[Overview](Extra/FeynHelpers.md), [FerRowReduce](FerRowReduce.md).

### Examples

The syntax of FerSolve is very similar to that of `Solve`

```mathematica
FerSolve[{a x + y == 7, b x - y == 1}, {x, y}]

(*FerRunScript: Running Fermat.
FerRunScript: Done running Fermat, timing: 0.6790
FerSolve: Verifying the result.
FerSolve: Done verifying the result, timing: 0.000630*)
```

$$\left\{x\to \frac{8}{a+b},y\to -\frac{a-7 b}{a+b}\right\}$$

```mathematica
Solve[{a x + y == 7, b x - y == 1}, {x, y}]
```

$$\left\{\left\{x\to \frac{8}{a+b},y\to -\frac{a-7 b}{a+b}\right\}\right\}$$

```mathematica
FerSolve[{2 x + y c == 2, 4 x == c}, {x, y}]

(*FerRunScript: Running Fermat.
FerRunScript: Done running Fermat, timing: 0.1560
FerSolve: Verifying the result.
FerSolve: Done verifying the result, timing: 0.000496*)
```

$$\left\{x\to \frac{c}{4},y\to -\frac{c-4}{2 c}\right\}$$

```mathematica
Solve[{2 x + y c == 2, 4 x == c}, {x, y}]
```

$$\left\{\left\{x\to \frac{c}{4},y\to -\frac{c-4}{2 c}\right\}\right\}$$

However, for larger systems of equations `FerSolve` is superior to `Solve` owing to better algorithms implemented in Fermat

```mathematica
eqs = {M0 == (1 - f1 - f2 - f3 - f4 - f5 - f6 - f7 - f8 - f9 - f10 - 
             f11 - f12 - f13 - f14 - f15 - f16)*m0, 
     M1 == f1*m0 + (1 - f1 - f2 - f3 - f4 - f5 - f6 - f7 - f8 - f9 - 
               f10 - f11 - f12 - f13 - f14 - f15 - f16)*m1, 
     M2 == f1*m1 + 
         f2*m0 + (1 - f1 - f2 - f3 - f4 - f5 - f6 - f7 - f8 - f9 - f10 - 
               f11 - f12 - f13 - f14 - f15 - f16)*m2, 
     M4 == f1*m3 + f2*m2 + f3*m1 + f4*m0, 
     M5 == f2*m3 + f3*m2 + f4*m1 + f5*m0, 
     M6 == f3*m3 + f4*m2 + f5*m1 + f6*m0, 
     M7 == f4*m3 + f5*m2 + f6*m1 + f7*m0, 
     M8 == f5*m3 + f6*m2 + f7*m1 + f8*m0, 
     M9 == f6*m3 + f7*m2 + f8*m1 + f9*m0, 
     M10 == f7*m3 + f8*m2 + f9*m1 + f10*m0, 
     M11 == f8*m3 + f9*m2 + f10*m1 + f11*m0, 
     M12 == f9*m3 + f10*m2 + f11*m1 + f12*m0, 
     M13 == f10*m3 + f11*m2 + f12*m1 + f13*m0, 
     M14 == f11*m3 + f12*m2 + f13*m1 + f14*m0, 
     M15 == f12*m3 + f13*m2 + f14*m1 + f15*m0, 
     M16 == f13*m3 + f14*m2 + f15*m1 + f16*m0};
```

```mathematica
vars = {f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, 
     f15, f16};
```

```mathematica
sol1 = FerSolve[eqs, vars];

(*FerRunScript: Running Fermat.
FerRunScript: Done running Fermat, timing: 11.21
FerSolve: Verifying the result.
FerSolve: Done verifying the result, timing: 0.3670*)
```

```mathematica
sol1[[1]]
```

$$\text{f1}\to -\frac{\text{M0} \;\text{m1}-\text{m0} \;\text{M1}}{\text{m0}^2}$$