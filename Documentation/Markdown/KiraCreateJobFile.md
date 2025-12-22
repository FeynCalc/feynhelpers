## KiraCreateJobFile

KiraCreateJobFile[topo, sectors, {r,s}, path] can be used to generate Kira job files from an `FCTopology` or a list thereof. Here `sectors` is a list of sectors need to be reduced, e.g. `{{1,0,0,0}, {1,1,0,0}, {1,1,1,0}}` etc. The values of `r` and `s` correspond to the maximal positive and negative powers that may appear in the loop integrals to be reduced.

The functions creates the corresponding yaml files and saves them  in `path/topoName`. Using `KiraCreateJobFile[{topo1, topo2, ...}, {sectors1, sectors2, ...}, {{r1,s1}, {r2,s2}, ...},  path]` will save the scripts to `path/topoName1`, `path/topoName2` etc. The syntax using `KiraCreateJobFile[{topo1, topo2, ...}, {sectors1, sectors2, ...}, {{r1,s1}, {r2,s2}, ...},  {path1, path2, ...}]` is also possible.

It is also possible to supply a list of `GLI`s instead of sectors. In that case `FCLoopFindSectors` and `KiraGetRS` will be used to determine the top sector for each topology.

The syntax  `KiraCreateJobFile[{topo1, topo2, ...}, {sectors1, sectors2, ...}, {{r1,s1}, {r2,s2}, ...}, path]` or `KiraCreateJobFile[{topo1, topo2, ...}, {glis1, glis2, ...},  path]` is also allowed. This implies that all config files will go into the corresponding subdirectories of path, e.g. `path/topoName1/config`, `path/topoName2/config` etc.

The default name for job files is `job.yaml` and can be changed via the option `KiraJobFileName`.

### See also

[Overview](Extra/FeynHelpers.md), [KiraCreateConfigFiles](KiraCreateConfigFiles.md), [KiraJobFileName](KiraJobFileName.md), [KiraIntegrals](KiraIntegrals.md)

### Examples

```mathematica
topo = FCTopology[prop3lX1, {SFAD[{p1, m^2}], SFAD[p2], SFAD[{p3, m^2}], SFAD[Q - p1 - p2 - p3], 
    SFAD[Q - p1 - p2], SFAD[Q - p1], SFAD[Q - p2], SFAD[p1 + p3], SFAD[p2 + p3]}, {p1, p2, p3}, {Q}, {}, {}]
```

$$\text{FCTopology}\left(\text{prop3lX1},\left\{\frac{1}{(\text{p1}^2-m^2+i \eta )},\frac{1}{(\text{p2}^2+i \eta )},\frac{1}{(\text{p3}^2-m^2+i \eta )},\frac{1}{((-\text{p1}-\text{p2}-\text{p3}+Q)^2+i \eta )},\frac{1}{((-\text{p1}-\text{p2}+Q)^2+i \eta )},\frac{1}{((Q-\text{p1})^2+i \eta )},\frac{1}{((Q-\text{p2})^2+i \eta )},\frac{1}{((\text{p1}+\text{p3})^2+i \eta )},\frac{1}{((\text{p2}+\text{p3})^2+i \eta )}\right\},\{\text{p1},\text{p2},\text{p3}\},\{Q\},\{\},\{\}\right)$$

```mathematica
KiraCreateJobFile[topo, {{1, 1, 1, 1, 1, 1, 1, 1, 1}}, {4, 4}, FileNameJoin[{$FeynCalcDirectory, "Database"}]]
```

$$\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/prop3lX1/job.yaml}$$

```mathematica
KiraCreateJobFile[topo, {
   GLI[prop3lX1, {1, 1, 1, 1, 1, 1, 1, 0, 0}], 
   GLI[prop3lX1, {1, 1, 1, 1, 1, 1, 1, 0, 1}]}, 
  FileNameJoin[{$FeynCalcDirectory, "Database"}], KiraJobFileName -> "job2.yaml"]
```

$$\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/prop3lX1/job2.yaml}$$