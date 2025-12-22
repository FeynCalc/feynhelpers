![0eugcbgadj6yz](img/0eugcbgadj6yz.svg)

## KiraGetRS

`KiraGetRS[{sec1, {gli1, ...}}]` returns the number of positive and negative propagator powers ($r$ and $s$ in the Kira/Reduze syntax) for the `GLI` integrals belonging to sector `sec1`. The input can be also a list of such entries.

If the option `Max` is set to `True` (default), only the largest `{r,s}` combination made of the largest `r` and the largest `s` values in this sector will be returned. Otherwise, the function will return the `{r,s}`-pair for each `GLI`.

`KiraGetRS` can directly handle the output of `FCLoopFindSectors`. Furthermore, the function can also deal with a simple list of `GLI`s as in `KiraGetRS[{gli1,gli2,...}]`.

If the option `Top` is set to `True`, and the input is a list of the form `{{sec1, {gli11, ...}}, {sec2, {gli21, ...}}, ...}` then the output will consists of a list of top sectors and the largest possible `{r,s}` combination.

### See also

[Overview](Extra/FeynHelpers.md), [KiraLabelSector](KiraLabelSector.md), [KiraCreateJobFile](KiraCreateJobFile.md).

### Examples

```mathematica
KiraGetRS[{GLI[topo1, {1, 1, 1, 1}], GLI[topo1, {2, 1, 2, 1}], 
   GLI[topo2, {1, 0, 1, 1}], GLI[topo3, {1, 0, 1, -1}]}]
```

$$\{6,1\}$$

```mathematica
KiraGetRS[{GLI[topo1, {1, 1, 1, 1}], GLI[topo1, {2, 1, 2, 1}], 
   GLI[topo2, {1, 0, 1, 1}], GLI[topo3, {1, 0, 1, -1}]}, Max -> False]
```

$$\left(
\begin{array}{cc}
 2 & 1 \\
 3 & 0 \\
 4 & 0 \\
 6 & 0 \\
\end{array}
\right)$$

```mathematica
out = FCLoopFindSectors[{GLI[topo1, {1, 1, 1, 1}], GLI[topo1, {2, 1, 2, 1}], 
    GLI[topo2, {1, 0, 1, 1}], GLI[topo3, {1, 0, 1, -1}]}]
```

$$\left(
\begin{array}{ccc}
 \left\{\{1,0,1,0\},\left\{G^{\text{topo3}}(1,0,1,-1)\right\}\right\} & \left\{\{1,0,1,1\},\left\{G^{\text{topo2}}(1,0,1,1)\right\}\right\} & \left\{\{1,1,1,1\},\left\{G^{\text{topo1}}(1,1,1,1),G^{\text{topo1}}(2,1,2,1)\right\}\right\} \\
 \{1,0,1,0\} & \{1,0,1,1\} & \{1,1,1,1\} \\
\end{array}
\right)$$

```mathematica
KiraGetRS[out]
```

$$\left(
\begin{array}{cc}
 \{1,0,1,0\} & \{2,1\} \\
 \{1,0,1,1\} & \{3,0\} \\
 \{1,1,1,1\} & \{6,0\} \\
\end{array}
\right)$$

```mathematica
KiraGetRS[out, Top -> True]
```

$$\left\{\left(
\begin{array}{cccc}
 1 & 1 & 1 & 1 \\
\end{array}
\right),\{6,1\}\right\}$$