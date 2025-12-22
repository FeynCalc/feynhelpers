(* ::Package:: *)

 


(* ::Section:: *)
(*LToolsEvaluate*)


(* ::Text:: *)
(*`LToolsEvaluate[expr, q]` evaluates Passarino-Veltman functions in `expr` numerically using LoopTools by T. Hahn.*)


(* ::Text:: *)
(*In contrast to the default behavior of LoopTools, the function returns not just the finite part but also the singular pieces proportional to $1\varepsilon$ and $1\varepsilon^2$. This behavior is controlled by the option `LToolsFullResult`.*)


(* ::Text:: *)
(*Notice that the normalization of Passarino-Veltman functions differs between FeynCalc and LoopTools, cf. Section 1.2 of the LoopTools manual. In FeynCalc the overall prefactor is just $1/(i \pi^2)$, while LoopTools employs $1/(i \pi^{D/2} r_{\Gamma})$ with $D = 4 -2 \varepsilon$ and $r_{\Gamma} = \Gamma^2 (1 - \varepsilon) \Gamma (1 + \varepsilon) / \Gamma(1-2 \varepsilon)$.*)


(* ::Text:: *)
(*When the option `LToolsFullResult` is set to `True`,  `LToolsEvaluate` will automatically  account for this difference by multiplying the LoopTools output with  $1/\pi^{\varepsilon} r_\Gamma$.*)


(* ::Text:: *)
(*However, for `LToolsFullResult -> False` no such conversion will occur. This is because  the proper conversion between different $\varepsilon$-dependent normalizations requires the knowledge of the poles: when terms proportional to $\varepsilon$ multiply the poles, they generate finite contributions. In this sense it is not recommended to use `LToolsEvaluate` with `LToolsFullResult` set to `False`, unless you precisely understand what you are doing.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [LToolsExpandInEpsilon](LToolsExpandInEpsilon.md), [LToolsFullResult](LToolsFullResult.md), [LToolsImplicitPrefactor](LToolsImplicitPrefactor.md), [LToolsSetMudim](LToolsSetMudim.md), [LToolsSetLambda](LToolsSetLambda.md).*)


(* ::Subsection:: *)
(*Examples*)


(* ::Text:: *)
(*Before using `LToolsEvaluate` we need to evaluate `LToolsLoadLibray[]` to establish a connection with the Mathlink executable. The value of the option `LToolsPath` contains the full path to this file. You might need to adjust it accordingly if LoopTools is installed in a different directory.*)


OptionValue[LToolsLoadLibrary,LToolsPath]


(* ::Text:: *)
(*Notice that `LToolsEvaluate` can also load the library by itself on the first run, in case you forget to do so.*)


LToolsLoadLibrary[]


(* ::Text:: *)
(*The value of the scale $\mu$ can be set via the option `LToolsSetMudim`. Evaluating the `PaVe`-function $A_0(m^2)$ at $m^2 = 1/10$ with $\mu^2=20$ yields*)


LToolsEvaluate[A0[m^2],LToolsSetMudim->20,InitialSubstitutions->{m^2->1/10}]


(* ::Text:: *)
(*Cross-checking this result with Package-X yields the same value*)


(PaXEvaluate[A0[1/10]]/.ScaleMu^2->20)//N


(* ::Text:: *)
(*More complicated input is also possible*)


exp=a FAD[{q,m},q-p]+ b FAD[{q,M,2}]


res=LToolsEvaluate[exp,q,InitialSubstitutions->{m->0.12352,M->5.14321,SPD[p]->0.8813},LToolsImplicitPrefactor->1/(2Pi)^(4-2Epsilon),LToolsSetMudim->23^2]


(* ::Text:: *)
(*Compare to Package-X*)


chk=(PaXEvaluate[exp,q,PaXImplicitPrefactor->1/(2Pi)^(4-2Epsilon)]/.{ScaleMu^2->23^2,m->0.12352,M->5.14321,FCI@SPD[p]->0.8813})//N


FCCompareNumbers[res,chk]
