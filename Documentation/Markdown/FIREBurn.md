## FIREBurn

`FIREBurn[expr, {q1, q2, ...}, {p1, p2, ...}]` reduces loop integrals with loop momenta `q1, q2, ...` and external momenta `p1, p2, ...` with integration-by-parts (IBP) relations.

`FIREBurn` expects that the input does not contain any loop integrals with linearly dependent propagators. Therefore, prior to starting the reduction, use `ApartFF`.

The evaluation is done on a parallel kernel using A.V. Smirnov's and V.A. Smirnov's FIRE.

### See also

[Overview](Extra/FeynHelpers.md).

### Examples

```mathematica
int = SFAD[{p, m^2, 2}, {{0, 2 p . k}, m^2, 3}]
```

$$\frac{1}{(p^2-m^2+i \eta )^2.(2 (k\cdot p)-m^2+i \eta )^3}$$

```mathematica
FIREBurn[int, {p}, {k}, Timing -> False]
```

$$-\frac{(D-5) (D-3) k^2 \left(D m^2-4 k^2-6 m^2\right)}{m^4 \left(m^2-4 k^2\right)^3 (2 (k\cdot p)-m^2+i \eta ).(p^2-m^2+i \eta )}-\frac{(D-2) \left(2 D^2 k^2-24 D k^2+66 k^2+m^2\right)}{2 m^4 \left(m^2-4 k^2\right)^3 (p^2-m^2+i \eta )}$$