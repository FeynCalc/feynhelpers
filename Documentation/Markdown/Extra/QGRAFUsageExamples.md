## QGRAF usage examples

The main idea behind the FeynHelpers interface to QGRAF is to facilitate the generation of Feynman diagrams using QGRAF and the subsequent conversion of the obtained amplitudes into the FeynCalc notation.

The main high-level function of this interface is called `QGCreateAmp`. In the simplest case we need to provide following arguments and options

- the 1st argument is the number of loops, e.g. `0`, `1` or `2`
- the 2nd argument is the process we are considering, e.g. `{"El[p1]","Ael[p2]"}->{"El[p3]","Ael[p4]"}` for $e^- (p_1) e^+ (p_2) \to e^- (p_3) e^+ (p_4)$
- the option `QGModel` specifies the QGRAF model used to generate the diagrams. FeynHelpers has several simple built-in models such as one flavor QED (`"QEDOneFlavor"`), one flavor QCD (`"QCDOneFlavor"`) etc. To use a custom model this option should be given the full path to the corresponding file.
- the option `QGLoopMomentum` provides the naming scheme for the loop momenta, e.g. `l` or `q`
- the option `QGOptions` is a list of string that will be passed to the `options=` statement in the `qgraf.dat` file. The most useful ones are `"notadpole"` and `"onshell"`
- the option `QGOutputDirectory` specifies the path to the directory containing the QGRAF output

Here is a simple 1-loop example that incorporates all of the above

```mathematica
qgOutput=QGCreateAmp[1,{"El[p1]","Ael[p2]"}->{"El[p3]","Ael[p4]"},QGModel->"QEDOneFlavor",
QGLoopMomentum->l,QGOptions->{"notadpole","onshell"},
QGOutputDirectory->FileNameJoin[{$FeynCalcDirectory,"Database","ElAelToElAelAt1L"}]];
```

The output is a list containing two elements which are full paths to the two files `amplitudes.m` and `diagrams-raw.tex`. Since QGRAF has no built-in capabilities for visualizing the generated Feynman diagrams, we need to use extra tools for this task. The most convenient way to do this is to employ `lualatex` together with the TikZ-Feyman package. By evaluating 

```mathematica
tikzStyles=QGTZFCreateFieldStyles[qgModel,"QEDOneFlavor",
QGFieldStyles->{{"Ga","photon","\\gamma"},
{"El","fermion","e^-"},
{"Ael","anti fermion","e^+"}}];
```
we can create a file containing the styling for the fields present in our model, so that the diagrams will look nice. Then, 

```
QGTZFCreateTeXFiles[qgOutput,Split->True];
```
will generate a TeX file for each of the diagrams located in `FileNameJoin[{$FeynCalcDirectory,"Database","ElAelToElAelAt1L","TeX"}]]`. Provided that we have `GNU parallel` and `pdfunite` installed, we can now switch to the terminal, enter the corresponding directory and generate the diagrams via

```
./makeDiagrams.sh
./glueDiagrams.sh
```

If everything goes as expected, this will give us a file `allDiagrams.pdf` containing all the generated diagrams.

Coming back to the analytic part of the calculation, we need to load the list of Feynman rules for the vertices and propagators present in the generated amplitudes. Again, FeynHelpers contains a built-in collection of Feynman rules that can be loaded using 

```mathematica
QGLoadInsertions["QGCommonInsertions.m"];
```

If we need to use some new rules for a custom model, then `QGLoadInsertions` should be given the full path to the corresponding insertions file. Finally, with

```mathematica
amps=QGConvertToFC[qgOutput,DiracChainJoin->True];
```

we obtain the list of our amplitudes ready for a subsequent evaluation within FeynCalc.