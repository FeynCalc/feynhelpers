## KIRA usage examples

The main idea behind the FeynHelpers interface to KIRA is to facilitate the generation of KIRA config files for reducing the given sets of loop integrals written in the FeynCalc notation (i.e. as `GLI`s with the corresponding lists of `FCTopology` symbols) to masters.

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

The first step is to generate the job file.

```mathematica
KiraCreateJobFile[topos, ints, NotebookDirectory[]]
```

Notice that it is crucial to provide the list of integrals to be reduced, as the code will need some of their properties (top sectors) when writing the job file.

The next steps are to create a file containing the list of integrals and a configuration file for the reduction. Notice that we must specify the mass dimension of all kinematic invariants appearing in the topology using the option `KiraMassDimensions`

```mathematica
KiraCreateIntegralFile[ints, topos, NotebookDirectory[]]
KiraCreateConfigFiles[topos, ints, NotebookDirectory[], 
 KiraMassDimensions -> {pp -> 1}]
```

In the case of complicated topologies the reduction must be done on a powerful workstation or computer cluster and can take hours, days or even weeks. But as long as everything is simple enough, there should be no harm running it directly from the notebook via

```mathematica
KiraRunReduction[NotebookDirectory[], topos, 
 KiraBinaryPath -> FileNameJoin[{$HomeDirectory, "bin", "kira"}],
 KiraFermatPath -> FileNameJoin[{$HomeDirectory, "bin", "ferl64", "fer64"}]]
```

Here it is important not only to specify the correct path to the KIRA binary (`KiraBinaryPath`) but also the one pointing to a suitable FERMAT binary (`KiraFermatPath`). The latter will be set via the shell environment variable `FERMATPATH`.

Finally, in order to load the reduction tables into Mathematica it is convenient to use 

```mathematica
tables=KiraImportResults[topos, NotebookDirectory[]]
```

which returns a list of replacement rules that can be directly applied to the given amplitude or perhaps exported to FORM.
