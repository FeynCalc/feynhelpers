## PaXExpandInEpsilon

`PaXExpandInEpsilon` is an option for `PaXEvaluate`. If `ImplicitPrefactor` is not `1` and `SubstituteEpsilon` is set to `True`, then the value of `PaXExpandInEpsilon` determines whether the final result should be again expanded in `Epsilon`.

The expansion is done only up to $\mathcal{O}(\varepsilon^0)$. The default value is `True`.

### See also

[Overview](Extra/FeynHelpers.md), [PaXEvaluate](PaXEvaluate.md).

### Examples