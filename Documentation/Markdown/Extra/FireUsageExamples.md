## FIRE usage examples

The main idea behind the FeynHelpers interface to FIRE is to facilitate the generation of FIRE scripts for reducing the given sets of loop integrals written in the FeynCalc notation (i.e. as `GLI`s with the corresponding lists of `FCTopology` symbols) to masters.

If needed, the reduction can be done by running the corresponding scripts from a Mathematica notebook, although we do not recommend using this approach for complicated calculations. 

Let us assume that upon simplifying some amplitude we have a list of topologies and the corresponding loop integrals that need to be reduced.

```mathematica
topos = {FCTopology["fctopology1", {SFAD[{{q2, 0}, {0, 1}, 1}], SFAD[{{q1, 0}, {0, 1}, 1}], SFAD[{{q1 + q2, 0}, {0, 1}, 1}], SFAD[{{p + q1, 0}, {0, 1}, 1}], SFAD[{{p - q2, 0}, {0, 1}, 1}]}, {q1, q2}, {p}, {Hold[Pair][Momentum[p, D], Momentum[p, D]] -> pp}, {}]};
```

```mathematica
ints = {GLI["fctopology1", {-2, 1, 1, 2, 1}], GLI["fctopology1", {-1, 0, 1, 2, 1}], GLI["fctopology1", {-1, 1, 0, 2, 1}], 
 GLI["fctopology1", {-1, 1, 1, 1, 1}], GLI["fctopology1", {-1, 1, 1, 2, 0}], GLI["fctopology1", {-1, 1, 1, 2, 1}], 
 GLI["fctopology1", {0, -1, 1, 2, 1}], GLI["fctopology1", {0, 0, 0, 2, 1}], GLI["fctopology1", {0, 0, 1, 1, 1}], 
 GLI["fctopology1", {0, 0, 1, 2, 0}], GLI["fctopology1", {0, 0, 1, 2, 1}], GLI["fctopology1", {0, 1, -1, 2, 1}], 
 GLI["fctopology1", {0, 1, 0, 1, 1}], GLI["fctopology1", {0, 1, 0, 2, 0}], GLI["fctopology1", {0, 1, 0, 2, 1}], 
 GLI["fctopology1", {0, 1, 1, 0, 1}], GLI["fctopology1", {0, 1, 1, 1, 0}], GLI["fctopology1", {0, 1, 1, 1, 1}], 
 GLI["fctopology1", {0, 1, 1, 2, -1}], GLI["fctopology1", {0, 1, 1, 2, 0}], GLI["fctopology1", {0, 1, 1, 2, 1}], 
 GLI["fctopology1", {1, -1, 1, 1, 1}], GLI["fctopology1", {1, 0, 0, 1, 1}], GLI["fctopology1", {1, 0, 1, 0, 1}], 
 GLI["fctopology1", {1, 0, 1, 1, 0}], GLI["fctopology1", {1, 0, 1, 1, 1}], GLI["fctopology1", {1, 1, -1, 1, 1}], 
 GLI["fctopology1", {1, 1, 0, 0, 1}], GLI["fctopology1", {1, 1, 0, 1, 0}], GLI["fctopology1", {1, 1, 0, 1, 1}], 
 GLI["fctopology1", {1, 1, 1, -1, 1}], GLI["fctopology1", {1, 1, 1, 0, 0}], GLI["fctopology1", {1, 1, 1, 0, 1}], 
 GLI["fctopology1", {1, 1, 1, 1, -1}], GLI["fctopology1", {1, 1, 1, 1, 0}], GLI["fctopology1", {1, 1, 1, 1, 1}]}
```

The first step is to generate scripts for creating .sbases and .lbases files required by FIRE for the actual reduction. Those files are specific to the given topology, which is why we need to provide the list of the relevant topologies and as well as a path to the directory that will contain reductions files. Each topology will receive a separate subdirectory created from its name.

```mathematica
FIREPrepareStartFile[topos,NotebookDirectory[]]
```

If everything works as expected each topology directory will contain two Mathematica scripts, `CreateLiteRedFiles.m` and `CreateStartFile.m`. Both of them must be evaluated in the correct order. The first script analyzes the topology using LiteRed, while the second one uses this information to create 
.sbases and .lbases files. In the case of complicated topologies, running those scripts can take many minutes or even couple of hours. For simple topologies the process is usually so fast, that one can conveniently run it during the notebook evaluation. To this aim one may use

```mathematica
FIRECreateStartFile[NotebookDirectory[],topos]
```

The next step is to create a file containing the list of integrals and a configuration file for the reduction.

```mathematica
FIRECreateConfigFile[topos,NotebookDirectory[]]
FIRECreateIntegralFile[ints,topos,NotebookDirectory[]]
```

In particular, `FIRECreateConfigFile` offers a lot of options for fine-tuning the reduction parameters as one normally do it when writing such files by hand.

Again, in the case of complicated topologies the reduction must be done on a powerful workstation or computer cluster and can take hours, days or even weeks. But as long as everything is simple enough, there should be no harm running it directly from the notebook via

```mathematica
FIRERunReduction[NotebookDirectory[],topos]
```

Notice, that in this case FeynHelpers runs the C++ version of FIRE via a shell script. To that aim FIRE must be properly compiled from source.

Finally, in order to load the reduction tables into Mathematica it is convenient to use 

```mathematica
tables=FIREImportResults[topos,NotebookDirectory[]]
```

which returns a list of replacement rules that can be directly applied to the given amplitude or perhaps exported to FORM.
