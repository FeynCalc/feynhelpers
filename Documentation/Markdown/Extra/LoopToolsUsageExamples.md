## LoopTools usage examples

The LoopTools interface allows to quickly evaluate Passarino-Veltman functions with suitable kinematics numerically using LoopTools.

Given an amplitude written in terms of `PaVe`-functions

```mathematica
amp = Get[FileNameJoin[{$FeynHelpersDirectory, "Documentation", "Examples", "ampHToGG.m"}]];
```

we can evaluate it by first loading LoopTools via

```mathematica
LToolsLoadLibrary[]
```

and then running

```mathematica
ampEval = LToolsEvaluate[amp, LToolsSetMudim -> 1, InitialSubstitutions -> {mH -> 125, mt -> 173}]
```

where we set $\mu = 1$. The resulting expression is then

```mathematica
Collect2[ampEval /. {D -> 4, mH -> 125, mt -> 173}, Pair]
```
