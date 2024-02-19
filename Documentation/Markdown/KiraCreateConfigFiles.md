## KiraCreateConfigFiles

`KiraCreateConfigFiles[topo, sectors, path]` can be used to generate Kira configuration files (`integralfamilies.yaml` and `kinematics.yaml`) from an FCTopology or list thereof. Here `sectors` is a list of sectors need to be reduced, e.g. `{{1,0,0,0}, {1,1,0,0}, {1,1,1,0}}` etc.

The functions creates the corresponding yaml files and saves them  in path/topoName/config. Using `KiraCreateConfigFiles[{topo1, topo2, ...}, {sectors1, sectors2, ...},  path]` will save the scripts to `path/topoName1`, `path/topoName2` etc. The syntax `KiraCreateConfigFiles[{topo1, topo2, ...}, {sectors1, sectors2, ...},  {path1, path2, ...}]` is also possible.

If the directory specified in `path/topoName` does not exist, it will be created automatically. If it already exists, its content will be automatically overwritten, unless the option `OverwriteTarget` is set to `False`.

It is also possible to supply a list of `GLI`s instead of sectors. In that case `FCLoopFindSectors` will be used to determine the top sector for each topology.

The syntax  `KiraCreateConfigFiles[{topo1, topo2, ...}, {sectors1, sectors2, ...}, path]` or `KiraCreateConfigFiles[{topo1, topo2, ...}, {glis1, glis2, ...},  path]` is also allowed. This implies that all config files will go into the corresponding subdirectories of path, e.g. `path/topoName1/config`, `path/topoName2/config` etc.

The mass dimension of all kinematic variables should be specified via the option `KiraMassDimensions` e.g. as in `{{m1->1},{M->1},{msq->2}}`.

If the amplitude originally contained any external momenta that were eliminated using momentum conservation, .e.g. by replacing $k_2$ by $P-k_1$ for $P=k_1+k_2$, those momenta must be nevertheless specified via the option `KiraImplicitIncomingMomenta`.

### See also

[Overview](Extra/FeynHelpers.md), [KiraMassDimensions](KiraMassDimensions.md), [KiraImplicitIncomingMomenta](KiraImplicitIncomingMomenta.md).

### Examples

```mathematica
topo = FCTopology["asyR1prop2Ltopo01310X11111N1", {SFAD[{p1, 0}], 
    SFAD[{p3, mg^2}], SFAD[{{0, 2*p3 . q}}], 
    SFAD[{(p1 + q), mb^2}], SFAD[{{0, p1 . p3}}]}, 
   {p1, p3}, {q}, {Hold[SPD][q, q] -> mb^2}, {}]
```

$$\text{FCTopology}\left(\text{asyR1prop2Ltopo01310X11111N1},\left\{\frac{1}{(\text{p1}^2+i \eta )},\frac{1}{(\text{p3}^2-\text{mg}^2+i \eta )},\frac{1}{(2 (\text{p3}\cdot q)+i \eta )},\frac{1}{((\text{p1}+q)^2-\text{mb}^2+i \eta )},\frac{1}{(\text{p1}\cdot \;\text{p3}+i \eta )}\right\},\{\text{p1},\text{p3}\},\{q\},\left\{\text{Hold}[\text{SPD}][q,q]\to \;\text{mb}^2\right\},\{\}\right)$$

```mathematica
fileName = KiraCreateConfigFiles[topo, {{1, 1, 1, 1, 1}}, 
    FileNameJoin[{$FeynCalcDirectory, "Database"}], KiraMassDimensions -> {mb -> 1, mg -> 1}];
```

```mathematica
fileName[[1]] // FilePrint

(*integralfamilies:
  - name: asyR1prop2Ltopo01310X11111N1
    loop_momenta: [p1, p3]
    top_level_sectors: [b11111]
    propagators:
      - [ "p1", 0]
      - [ "p3", "mg^2"]
      - { bilinear: [ [ "2*p3", "q"], 0] }
      - [ "p1 + q", "mb^2"]
      - { bilinear: [ [ "p1", "p3"], 0] }*)
```

```mathematica
fileName[[2]] // FilePrint

(*kinematics:
  incoming_momenta: [q]
  outgoing_momenta: [q]
  momentum_conservation: []
  kinematic_invariants:
    - [mb, 1]
    - [mg, 1]
  scalarproduct_rules:
    - [ [ q, q],mb^2]*)
```

```mathematica
topos = {
   FCTopology["asyR3prop2Ltopo01310X11111N1", {SFAD[{{-p1, 0}, {0, 1}, 1}], SFAD[{{-p3, 0}, {mg^2, 1}, 1}], SFAD[{{0, 2*p3 . q}, {0, 1}, 1}], 
     SFAD[{{0, 2*p1 . q}, {0, 1}, 1}], SFAD[{{-p1 + p3, 0}, {0, 1}, 1}]}, {p1, p3}, {q}, {Hold[SPD][q, q] -> mb^2}, {}], 
   FCTopology["asyR1prop2Ltopo01310X11111N1", {SFAD[{{-p1, 0}, {0, 1}, 1}], SFAD[{{-p3, 0}, {mg^2, 1}, 1}], SFAD[{{0, 2*p3 . q}, {0, 1}, 1}], 
      SFAD[{{-p1 - q, 0}, {mb^2, 1}, 1}], SFAD[{{0, -p1 . p3}, {0, 1}, 1}]}, {p1, p3}, {q}, {Hold[SPD][q, q] -> mb^2}, {}] 
   }
```

$$\left\{\text{FCTopology}\left(\text{asyR3prop2Ltopo01310X11111N1},\left\{\frac{1}{(\text{p1}^2+i \eta )},\frac{1}{(\text{p3}^2-\text{mg}^2+i \eta )},\frac{1}{(2 (\text{p3}\cdot q)+i \eta )},\frac{1}{(2 (\text{p1}\cdot q)+i \eta )},\frac{1}{((\text{p3}-\text{p1})^2+i \eta )}\right\},\{\text{p1},\text{p3}\},\{q\},\left\{\text{Hold}[\text{SPD}][q,q]\to \;\text{mb}^2\right\},\{\}\right),\text{FCTopology}\left(\text{asyR1prop2Ltopo01310X11111N1},\left\{\frac{1}{(\text{p1}^2+i \eta )},\frac{1}{(\text{p3}^2-\text{mg}^2+i \eta )},\frac{1}{(2 (\text{p3}\cdot q)+i \eta )},\frac{1}{((-\text{p1}-q)^2-\text{mb}^2+i \eta )},\frac{1}{(-\text{p1}\cdot \;\text{p3}+i \eta )}\right\},\{\text{p1},\text{p3}\},\{q\},\left\{\text{Hold}[\text{SPD}][q,q]\to \;\text{mb}^2\right\},\{\}\right)\right\}$$

```mathematica
{GLI["asyR3prop2Ltopo01310X11111N1", {1, 1, 1, 1, 2}], GLI["asyR1prop2Ltopo01310X11111N1", {1, 1, 1, 1, 2}]}
```

$$\left\{G^{\text{asyR3prop2Ltopo01310X11111N1}}(1,1,1,1,2),G^{\text{asyR1prop2Ltopo01310X11111N1}}(1,1,1,1,2)\right\}$$

```mathematica
fileNames = KiraCreateConfigFiles[topos, {GLI["asyR3prop2Ltopo01310X11111N1", {1, 1, 1, 1, 2}], GLI["asyR1prop2Ltopo01310X11111N1", {1, 1, 1, 1, 2}]}, 
   FileNameJoin[{$FeynCalcDirectory, "Database"}], KiraMassDimensions -> {mb -> 1, mg -> 1}]
```

$$\left(
\begin{array}{cc}
 \;\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/asyR3prop2Ltopo01310X11111N1/config/integralfamilies.yaml} & \;\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/asyR3prop2Ltopo01310X11111N1/config/kinematics.yaml} \\
 \;\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/asyR1prop2Ltopo01310X11111N1/config/integralfamilies.yaml} & \;\text{/home/vs/.Mathematica/Applications/FeynCalc/Database/asyR1prop2Ltopo01310X11111N1/config/kinematics.yaml} \\
\end{array}
\right)$$

```mathematica
FilePrint[fileNames[[1]][[1]]]

(*integralfamilies:
  - name: asyR3prop2Ltopo01310X11111N1
    loop_momenta: [p1, p3]
    top_level_sectors: [b11111]
    propagators:
      - [ "p1", 0]
      - [ "p3", "mg^2"]
      - { bilinear: [ [ "2*p3", "q"], 0] }
      - { bilinear: [ [ "2*p1", "q"], 0] }
      - [ "-p1 + p3", 0]*)
```

```mathematica
FilePrint[fileNames[[1]][[2]]]

(*kinematics:
  incoming_momenta: [q]
  outgoing_momenta: [q]
  momentum_conservation: []
  kinematic_invariants:
    - [mb, 1]
    - [mg, 1]
  scalarproduct_rules:
    - [ [ q, q],mb^2]*)
```

```mathematica
FilePrint[fileNames[[2]][[1]]]

(*integralfamilies:
  - name: asyR1prop2Ltopo01310X11111N1
    loop_momenta: [p1, p3]
    top_level_sectors: [b11111]
    propagators:
      - [ "p1", 0]
      - [ "p3", "mg^2"]
      - { bilinear: [ [ "2*p3", "q"], 0] }
      - [ "-p1 - q", "mb^2"]
      - { bilinear: [ [ "-p1", "p3"], 0] }*)
```

```mathematica
FilePrint[fileNames[[2]][[2]]]

(*kinematics:
  incoming_momenta: [q]
  outgoing_momenta: [q]
  momentum_conservation: []
  kinematic_invariants:
    - [mb, 1]
    - [mg, 1]
  scalarproduct_rules:
    - [ [ q, q],mb^2]*)
```