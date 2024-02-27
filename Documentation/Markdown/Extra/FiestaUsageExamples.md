## FIESTA usage examples

The main idea behind the FeynHelpers interface to FIESTA is to facilitate the generation of FIESTA scripts for integrals written in the FeynCalc notation (i.e. as `GLI`s with the corresponding lists of `FCTopology` symbols). If needed, those scripts can be also evaluated in background.

The main high-level function of this interface is called `FSACreateMathematicaScripts`. In the simplest case we need two provide following arguments and options

- the 1st argument is some `GLI`
- the 2nd argument is the `FCTopology` to which this `GLI` belongs
- the 3rd argument is where to put the directory with FIESTA scripts. For quick tests one can simply use `NotebookDirectory[]`
- the option `FSAOrderInEps` specifies the order in $\varepsilon$ to which the integral should be evaluated (default is `0`)
- the option `FSAParameterRules` is a list of rules for replacing kinematic invariants with numerical values which can be real or complex numbers.
- if the script directory already exists, the function will by default refuse to overwrite it. Setting the option `OverwriteTarget` to `True` you can tell the code that you do not care about that

Here is a simple 1-loop example that incorporates all of the above. Notice that it is crucial to switch the $i \eta$ sign of propagators from plus to minus, otherwise the result will be incorrect.

```mathematica
int = GLI[prop1L, {1, 1}]
topo = FCLoopSwitchEtaSign[FCTopology[prop1L, {FAD[{p1, m1}], FAD[{p1 + q, m2}]}, {p1}, {q}, {}, {}], -1]
files = FSACreateMathematicaScripts[int, topo, NotebookDirectory[], FinalSubstitutions -> {Hold[SPD][q] -> qq}, FSAParameterRules -> {qq -> 30., m1 -> 2., m2 -> 3.}, OverwriteTarget -> True]
```

The output is a list containing two elements. The first one is the full path to the Mathematica script file `FiestaScript.m`, while the second give the name of the output file containing numerical result for the given integral. For simple integrals you can evaluate the script directly in your Mathematica session by running

```mathematica
FSARunIntegration[files[[1]]]
```

Notice that the evaluation of sufficiently complicated integrals can take hours or even days so in general it is not recommended to use  `FSARunIntegration`.

Here is a sample the script file

```mathematica
Get["/home/vs/.Mathematica/Applications/FIESTA5/FIESTA5.m"];


If[$FrontEnd===Null,
  projectDirectory=DirectoryName[$InputFileName],
  projectDirectory=NotebookDirectory[]
];
SetDirectory[projectDirectory];
resFileName = "numres_" <> StringRiffle[ToString[#, InputForm] & /@ {15., 2., 3.}, "_"]<>"_fiesta.m";
Print["Working directory: ", projectDirectory];
Print["The results will be saved to: ", resFileName];


uf = UF[{p1},{m1^2 - p1^2, m2^2 - (p1 + q)^2}, {q^2 -> qq, qq -> 15., m1 -> 2., m2 -> 3.}];
SetOptions[FIESTA, "NumberOfSubkernels" -> 4,"ComplexMode" -> True,"ReturnErrorWithBrackets" -> True,
"Integrator" -> "quasiMonteCarlo","IntegratorOptions" -> {{"maxeval", "50000"}, {"epsrel", "1.000000E-05"}, {"epsabs", "1.000000E-12"}, {"integralTransform", "korobov"}}];
pref = 1;
resRaw = SDEvaluate[uf,{1, 1},0];
res = resRaw*pref;
Print["Final result: ", res];
Put[res, resFileName];
```

To load the numerical results into your Mathematica session you can use the function `FSALoadNumericalResults`. To that aim you just need to give it `files` as input.

```mathematica
FSALoadNumericalResults[files]
```

If you want to perform an asymptotic expansion, you need to set the option `FSASDExpandAsy` to `True`, specify the expansion variable using `FSAExpandVar` and set the desired expansion order via `FSASDExpandAsyOrder`. For example,

```mathematica
int = GLI[prop1L, {1, 1}]
topo = FCLoopSwitchEtaSign[FCTopology[prop1L, {FAD[{p1, m1}], FAD[{p1 + q, m2}]}, {p1}, {q}, {}, {}], -1]
files = FSACreateMathematicaScripts[int, topo, NotebookDirectory[], FinalSubstitutions -> {Hold[SPD][q] -> qq} , FSAParameterRules -> {qq -> 30., m1 -> 2.}, OverwriteTarget -> True, FSASDExpandAsy->True, FSAExpandVar -> m2, FSASDExpandAsyOrder-> 4]
```