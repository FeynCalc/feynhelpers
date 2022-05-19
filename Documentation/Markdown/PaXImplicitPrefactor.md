## PaXImplicitPrefactor

`PaXImplicitPrefactor` is an option for `PaXEvaluate`. It specifies the prefactor that does not show up explicitly in the input expression, but is understood to appear in front of every 1-loop integral. For technical reasons, `PaXImplicitPrefactor` should not depend on the number of dimensions `D`. Instead you should explicitly specify what `D` is (e.g. `4-2 Epsilon`). The default value is `1`.


If the standard prefactor $1/(2 \pi)^D$ is implicit in your calculations, use `ImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)` .

### See also

[Overview](Extra/FeynHelpers.md), [PaXEvaluate](PaXEvaluate.md).

### Examples