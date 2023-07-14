## Tensor reduction with Fermat

One of the most useful functions exposed by the Fermat interface is `FerSolve`
that is vastly superior to Mathematica's `Solve` when dealing with very large
symbolic systems of equations.

A typical situation where one needs to solve such equations is the derivation
of tensor decomposition formulas. To this aim FeynCalc's `Tdec` can directly
use `FerSolve`, once FeynHelpers is loaded. One just needs to set
the option `Solve` to `FerSolve`.

The following example calculates tensor reduction formula for a rank 6 integral
with 2 loop momenta and two external momenta. The Fermat part requires only 40
seconds on a modern laptop to solve the corresponding $52 \times 52$ symbolic system.

```
Tdec[{{p1, mu1}, {p1, mu2}, {p1, mu3}, {p1, mu4}, {p2, mu5}, {p2, mu6}},
{Q1, Q2}, Solve -> FerSolve, UseTIDL -> False, FCVerbose -> 1]
```