## FIRECreateConfigFile

`FIRECreateConfigFile[topo, fireID, path]` automatically generates a FIRE .config file  for the given topology `topo` with the FIRE-identifier `fireID` and saves it to `path/topoName` as `topoName.config` where `topoName` is the `FCTopology`-identifier. The function returns the full path to the generated .config file.

If the directory specified in `path/topoName` does not exist, it will be created automatically. If it already exists, its content will be automatically overwritten, unless the option `OverwriteTarget` is set to `False`.

If no `fireID` is given, i.e. the function is called as `FIRECreateConfigFile[topo,  path]`, then the default value `4242` is used.

It is also possible to invoke  the routine as `FIRECreateConfigFile[{topo1, topo2, ...}, {id1, id2, ...}, {path1, path2, ...}]` or `FIRECreateConfigFile[{topo1, topo2, ...}, {path1, path2, ...}]`if one needs to process a list of topologies.

The syntax  `FIRECreateConfigFile[{topo1, topo2, ...}, {id1, id2, ...}, path]` or `FIRECreateConfigFile[{topo1, topo2, ...}, path]` is also allowed. This implies that all config files will go into the corresponding subdirectories of path, e.g. `path/topoName1`, `path/topoName2` etc.

The default name of the file containing loop integrals for the reduction is `"LoopIntegrals.m"`. It can be changed via the option `FIREIntegrals`.

To customize the content of the .config file one can use following  options:

- `FIREBucket` (corresponds to `#bucket`, default value `29`)
- `FIRECompressor` (corresponds to `#compressor`, default value `"zstd"`)
- `FIREFThreads` (corresponds to `#fthreads`, default value $2 \times N_{CPU}$)
- `FIRELThreads` (corresponds to `#lthreads`, default value `2`)
- `FIREPosPref` (corresponds to `#pospref`, unset by default)
- `FIRESThreads` (corresponds to `#sthreads`, default value $N_{CPU}$)
- `FIREThreads` (corresponds to `#threads`, default value $N_{CPU}$)

### See also

[Overview](Extra/FeynHelpers.md), [FIREBucket](FIREBucket.md), [FIRECompressor](FIRECompressor.md), [FIREFthreads](FIREFthreads.md), [FIRELthreads](FIRELthreads.md), [FIREIntegrals](FIREIntegrals.md), [FIREPosPref](FIREPosPref.md), [FIRESthreads](FIRESthreads.md), [FIREThreads](FIREThreads.md).

### Examples

```mathematica
topo = FCTopology["asyR1prop2Ltopo01310X11111N1", {SFAD[{{I*p1, 0}, {0, -1}, 1}], SFAD[{{I*p3, 0}, {-mg^2, -1}, 1}], SFAD[{{0, -2*p3 . q}, {0, -1}, 1}], SFAD[{{I*(p1 + q), 0}, {-mb^2, -1}, 1}], SFAD[{{0, p1 . p3}, {0, -1}, 1}]}, {p1, p3}, {q}, {SPD[q, q] -> mb^2}, {}]
```

$$\text{FCTopology}\left(\text{asyR1prop2Ltopo01310X11111N1},\left\{\frac{1}{(-\text{p1}^2-i \eta )},\frac{1}{(-\text{p3}^2+\text{mg}^2-i \eta )},\frac{1}{(-2 (\text{p3}\cdot q)-i \eta )},\frac{1}{(-(\text{p1}+q)^2+\text{mb}^2-i \eta )},\frac{1}{(\text{p1}\cdot \text{p3}-i \eta )}\right\},\{\text{p1},\text{p3}\},\{q\},\left\{q^2\to \text{mb}^2\right\},\{\}\right)$$

```mathematica
fileName = FIRECreateConfigFile[topo, FileNameJoin[{$FeynCalcDirectory, "Database"}]];
fileName // FilePrint

(*#compressor zstd
#threads 8
#fthreads s16
#lthreads 4
#sthreads 8
#variables d, mb, mg
#bucket 29
#start
#folder ./
#problem 4242 asyR1prop2Ltopo01310X11111N1.start
#integrals LoopIntegrals.m
#output asyR1prop2Ltopo01310X11111N1.tables*)
```

```mathematica
fileName = FIRECreateConfigFile[topo, FileNameJoin[{$FeynCalcDirectory, "Database"}], FIREIntegrals -> "LIs.m", FIRELthreads -> 4];
fileName // FilePrint

(*#compressor zstd
#threads 8
#fthreads s16
#lthreads 4
#sthreads 8
#variables d, mb, mg
#bucket 29
#start
#folder ./
#problem 4242 asyR1prop2Ltopo01310X11111N1.start
#integrals LIs.m
#output asyR1prop2Ltopo01310X11111N1.tables*)
```

```mathematica
fileName = FIRECreateConfigFile[topo, FileNameJoin[{$FeynCalcDirectory, "Database"}], FIREIntegrals -> "LIs.m", FIRELthreads -> 4];
fileName // FilePrint

(*#compressor zstd
#threads 8
#fthreads s16
#lthreads 4
#sthreads 8
#variables d, mb, mg
#bucket 29
#start
#folder ./
#problem 4242 asyR1prop2Ltopo01310X11111N1.start
#integrals LIs.m
#output asyR1prop2Ltopo01310X11111N1.tables*)
```

```mathematica
topos = {
   FCTopology["asyR3prop2Ltopo01310X11111N1", {SFAD[{{I*p1, 0}, {0, -1}, 1}], SFAD[{{I*p3, 0}, {-mg^2, -1}, 1}], SFAD[{{0, -2*p3 . q}, {0, -1}, 1}], SFAD[{{0, -2*p1 . q}, {0, -1}, 1}], SFAD[{{I*(p1 - p3), 0}, {0, -1}, 1}]}, {p1, p3}, {q}, {SPD[q, q] -> mb^2},  {}], 
   
   FCTopology["asyR1prop2Ltopo01310X11111N1", {SFAD[{{I*p1, 0}, {0, -1}, 1}], SFAD[{{I*p3, 0}, {-mg^2, -1}, 1}], SFAD[{{0, -2*p3 . q}, {0, -1}, 1}], SFAD[{{I*(p1 + q), 0}, {-mb^2, -1}, 1}], SFAD[{{0, p1 . p3}, {0, -1}, 1}]}, {p1, p3}, {q}, {SPD[q, q] -> mb^2}, {}] 
  }
```

$$\left\{\text{FCTopology}\left(\text{asyR3prop2Ltopo01310X11111N1},\left\{\frac{1}{(-\text{p1}^2-i \eta )},\frac{1}{(-\text{p3}^2+\text{mg}^2-i \eta )},\frac{1}{(-2 (\text{p3}\cdot q)-i \eta )},\frac{1}{(-2 (\text{p1}\cdot q)-i \eta )},\frac{1}{(-(\text{p1}-\text{p3})^2-i \eta )}\right\},\{\text{p1},\text{p3}\},\{q\},\left\{q^2\to \text{mb}^2\right\},\{\}\right),\text{FCTopology}\left(\text{asyR1prop2Ltopo01310X11111N1},\left\{\frac{1}{(-\text{p1}^2-i \eta )},\frac{1}{(-\text{p3}^2+\text{mg}^2-i \eta )},\frac{1}{(-2 (\text{p3}\cdot q)-i \eta )},\frac{1}{(-(\text{p1}+q)^2+\text{mb}^2-i \eta )},\frac{1}{(\text{p1}\cdot \text{p3}-i \eta )}\right\},\{\text{p1},\text{p3}\},\{q\},\left\{q^2\to \text{mb}^2\right\},\{\}\right)\right\}$$

```mathematica
fileNames = FIRECreateConfigFile[topos, {1150, 1160}, FileNameJoin[{$FeynCalcDirectory, "Database"}]];
```

```mathematica
FilePrint[fileNames[[1]]];

(*#compressor zstd
#threads 8
#fthreads s16
#lthreads 4
#sthreads 8
#variables d, mb, mg
#bucket 29
#start
#folder ./
#problem 1150 asyR3prop2Ltopo01310X11111N1.start
#integrals LoopIntegrals.m
#output asyR3prop2Ltopo01310X11111N1.tables*)
```

```mathematica
FilePrint[fileNames[[2]]];

(*#compressor zstd
#threads 8
#fthreads s16
#lthreads 4
#sthreads 8
#variables d, mb, mg
#bucket 29
#start
#folder ./
#problem 1160 asyR1prop2Ltopo01310X11111N1.start
#integrals LoopIntegrals.m
#output asyR1prop2Ltopo01310X11111N1.tables*)
```