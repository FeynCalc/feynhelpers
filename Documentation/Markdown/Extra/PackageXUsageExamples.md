## Package-X usage examples

The syntax of the FeynHelpers interface to Package-X is very simple. There is essentially only one command `PaXEvalute` that does all the job of evaluating Passarino-Veltman functions analytically.

Let us start with something simple, e.g. the $A_0$ function in the standard normalization of Denner et al. (used in LoopTools  and many other packages)

```mathematica
res=PaXEvaluateUVIRSplit[A0[m^2]]
```

A nice feature of Package-X is the ability to explicitly distinguish between UV and IR poles, which can be important for renormalization or matching calculations. To this aim we have 3 functions at our disposal that essentially act in the same way as `PaXEvaluate` but label the poles accordingly. These are `PaXEvaluateUVIRSplit`, `PaXEvaluateUV` and `PaXEvaluateIR`. For example,

```mathematica
PaXEvaluateUVIRSplit[A0[m^2]]
```

We can also abbreviate the singularity structure with `SMP["Delta_UV"]` using

```mathematica
res2=FCHideEpsilon[res]
```

or make it explicit again

```mathematica
FCShowEpsilon[res2]
```

To evaluate `FAD`-type integrals, we need to specify the loop momentum explicitly. Furthermore, when we enter loop integrals as `FAD*SPD`, we usually also imply that they have the standard normalization with $1/(2\pi)^D$.
We do not have to write the prefactor out explicitly, but we must of course include it when we are evaluating our master integrals
symbolically or numerically.

When employing `PaXEvaluate` this can be taken into account via the option `PaXImplicitPrefactor`

```mathematica
PaXEvaluate[FAD[{q, m}], q, PaXImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)]
```

When it comes to the evaluation of functions with complicated kinematics, Package-X is sometimes a bit stubborn

```mathematica
PaXEvaluate[PaVe[0, 0, 1, {SP[p, p], SP[p, p], m^2}, {m^2, m^2, m^2}]]
```

It knows that there is no simple way to express the full result for the $C_0$ function, so it prefers to keep in the implicit form. Using the option `PaXC0Expand` we can obtain the (admittedly quite large and complicated) result nonetheless

```mathematica
PaXEvaluate[PaVe[0, 0, 1, {SP[p, p], SP[p, p], m^2}, {m^2, m^2, m^2}], PaXC0Expand -> True]
```

Notice that if we are interested only in the UV-divergent piece, we can get it rather easily without going through the full result.

```mathematica
PaXEvaluateUV[PaVe[0, 0, 1, {SP[p, p], SP[p, p], m^2}, {m^2, m^2, m^2}], PaXC0Expand -> True]
```

Notice that the UV-poles can be revealed using the built-in function `PaVeUVPart`

```mathematica
PaVeUVPart[PaVe[0, 0, 1, {SP[p, p], SP[p, p], m^2}, {m^2, m^2, m^2}]]
```

Furthermore, Package-X can expand coefficient functions in their arguments, which is very useful for many applications. In `PaXEvaluate` the corresponding option is called `PaXSeries`

```mathematica
PaXEvaluate[B0[SPD[p1, p1], m1^2, m2^2], PaXSeries -> {{m1, 0, 2}}]
```

By default Package-X tries to do expansion around the final results, which is usually not what we want. With the option `PaXAnalytic` the expansion will be done on the level of Feynman parameters, as one would do it by hand

```mathematica
PaXEvaluate[B0[SPD[p1, p1], m1^2, m2^2], PaXSeries -> {{m1, 0, 2}}, PaXAnalytic -> True]
```

We can also do a double expansion in `m1` and `m2`

```mathematica
PaXEvaluate[B0[SPD[p1, p1], m1^2, m2^2], PaXSeries -> {{m1, 0, 2}, {m2, 0, 2}}, PaXAnalytic -> True]
```

and reveal the origin of the poles

```mathematica
PaXEvaluateUVIRSplit[B0[SPD[p1, p1], m1^2, m2^2], PaXSeries -> {{m1, 0, 2}}, PaXAnalytic -> True]
```

```mathematica
PaXEvaluateUVIRSplit[B0[SPD[p1, p1], m1^2, m2^2], PaXSeries -> {{m1, 0, 2}, {m2, 0, 2}}, PaXAnalytic -> True]
```