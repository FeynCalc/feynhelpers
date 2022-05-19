## LToolsSetLambda

`LToolsSetLambda` corresponds to the `SetLambda` function in LoopTools.

See ``?LoopTools`SetLambda`` for further information regarding this LoopTools symbol.

`LToolsSetLambda` is also an option for `LToolsEvaluate` that sets the numerical value for the IR regularization parameter $\lambda^2$.

Setting $\lambda^2$  to `-2` or `-1` will make LoopTools return the coefficients of the $1/\varepsilon$ and $1/\varepsilon$-poles respectively. The value `0` yields the finite part of the integral where IR divergences are regularized dimensionally.

When $\lambda^2$ is set to some positive value (say `2.`), `LoopTools` will return the finite part of the integral with IR divergences being regularized using a fictitious mass. The result will naturally depend on the value of $\lambda^2$.

It is important to keep in mind that for  $\lambda^2 = -1$ LoopTools also returns the UV-pole, although this not so clearly stated in the official manual.

Notice that the option `LToolsSetLambda` is ignored, as long as `LToolsFullResult` is set to `True`.

### See also

[Overview](Extra/FeynHelpers.md), [LToolsEvaluate](LToolsEvaluate.md)

### Examples