## LToolsSetDebugKey

`LToolsSetDebugKey` corresponds to the `SetDebugKey` function in LoopTools.

See ``?LoopTools`SetDebugKey`` for further information regarding this LoopTools symbol.

Use `LToolsSetDebugKey[-1]` to obtain the most complete debugging output. This can be useful when investigating issues with the evaluation of certain kinematic limits in LoopTools.

### See also

[Overview](Extra/FeynHelpers.md), [LToolsGetDebugKey](LToolsGetDebugKey.md).

### Examples

```mathematica
LToolsLoadLibrary[]
```

$$\text{LoopTools library loaded.}$$

```
(* ====================================================
   FF 2.0, a package to evaluate one-loop integrals
 written by G. J. van Oldenborgh, NIKHEF-H, Amsterdam
 ====================================================
 for the algorithms used see preprint NIKHEF-H 89/17,
 'New Algorithms for One-loop Integrals', by G.J. van
 Oldenborgh and J.A.M. Vermaseren, published in 
 Zeitschrift fuer Physik C46(1990)425.
 ====================================================*)
```

```mathematica
LToolsEvaluate[C0[0, 0, 0, 0, 1, 0], q]
```

![127qwxc1krziv](img/127qwxc1krziv.svg)

$$\text{FeynCalc$\grave{ }$LoopTools$\grave{ }$Private$\grave{ }$ltFailed}\left(\text{C}_0(0,0,0,0,0,1)\right)+\frac{1.}{\varepsilon }$$

```mathematica
LToolsSetDebugKey[-1]
```

$$-1$$

```mathematica
LToolsEvaluate[C0[0, 0, 0, 0, 1, 0], q]

(* Bcoeff           4
   p     =   0.0000000000000000     
   m1    =   0.0000000000000000     
   m2    =   0.0000000000000000     
 bb0       =              (-1.7219455507509331,0.0000000000000000)
 bb1       =              (0.86097277537546657,0.0000000000000000)
 bb11      =             (-0.57398185025031101,0.0000000000000000)
 bb111     =              (0.43048638768773329,0.0000000000000000)
 dbb0      =   (9.99999999999999978E+122,9.99999999999999978E+122)
 dbb0:1    =   (9.99999999999999978E+122,9.99999999999999978E+122)
 dbb1      =   (9.99999999999999978E+122,9.99999999999999978E+122)
 dbb1:1    =   (9.99999999999999978E+122,9.99999999999999978E+122)
 dbb00     =              (0.14349546256257775,0.0000000000000000)
 dbb001    =        (-7.17477312812888762E-002,0.0000000000000000)
 ====================================================
 Bcoeff           5
   p     =   0.0000000000000000     
   m1    =   0.0000000000000000     
   m2    =   1.0000000000000000     
 bb0       =            (-0.72194555075093314,-0.0000000000000000)
 bb0:1     =               (1.0000000000000000,0.0000000000000000)
 bb1       =              (0.61097277537546657,0.0000000000000000)
 bb1:1     =             (-0.50000000000000000,0.0000000000000000)
 bb00      =        (-5.54863876877332851E-002,0.0000000000000000)
 bb00:1    =              (0.25000000000000000,0.0000000000000000)
 bb11      =            (-0.46287073913919996,-0.0000000000000000)
 bb11:1    =              (0.33333333333333331,0.0000000000000000)
 bb001     =         (6.47687029029332950E-002,0.0000000000000000)
 bb001:1   =             (-0.16666666666666666,0.0000000000000000)
 bb111     =              (0.36798638768773329,0.0000000000000000)
 bb111:1   =             (-0.25000000000000000,0.0000000000000000)
 dbb0      =       (0.50000000000000000,-1.00000000000000001E-050)
 dbb1      =       (-0.16666666666666669,5.00000000000000004E-051)
 dbb00     =  (7.40510181181333327E-002,-8.33333333333333290E-052)
 dbb00:1   =        (-8.33333333333333287E-002,0.0000000000000000)
 dbb11     =  (8.33333333333333148E-002,-3.33333333333333316E-051)
 dbb001    =  (-4.74421757257333238E-002,4.16666666666666645E-052)
 dbb001:1  =         (4.16666666666666644E-002,0.0000000000000000)
 ====================================================
 Ccoeff           6
   p1    =   0.0000000000000000     
   p2    =   0.0000000000000000     
   p1p2  =   0.0000000000000000     
   m1    =   0.0000000000000000     
   m2    =   0.0000000000000000     
   m3    =   1.0000000000000000     
collinear C0, perm = 312
C0collDR, perm = 123
 p1 =   0.0000000000000000     
 p2 =   0.0000000000000000     
 p3 =   0.0000000000000000     
 m1 =   0.0000000000000000     
 m2 =   0.0000000000000000     
 m3 =   1.0000000000000000     
 C0collDR: qltri3
 C0collDR:0 =                                             (NaN,NaN)
 C0collDR:1 =               (1.0000000000000000,0.0000000000000000)
 C0collDR:2 =               (0.0000000000000000,0.0000000000000000)
 cc0       =                                             (NaN,NaN)
 cc0:1     =               (1.0000000000000000,0.0000000000000000)
 cc1       =                                             (NaN,NaN)
 cc1:1     =                                             (NaN,NaN)
 cc1:2     =                                             (NaN,NaN)
 cc2       =                                             (NaN,NaN)
 cc2:1     =                                             (NaN,NaN)
 cc2:2     =                                             (NaN,NaN)
 cc00      =                                             (NaN,NaN)
 cc00:1    =                                             (NaN,NaN)
 cc00:2    =                                             (NaN,NaN)
 cc11      =                                             (NaN,NaN)
 cc11:1    =                                             (NaN,NaN)
 cc11:2    =                                             (NaN,NaN)
 cc12      =                                             (NaN,NaN)
 cc12:1    =                                             (NaN,NaN)
 cc12:2    =                                             (NaN,NaN)
 cc22      =                                             (NaN,NaN)
 cc22:1    =                                             (NaN,NaN)
 cc22:2    =                                             (NaN,NaN)
 cc001     =                                             (NaN,NaN)
 cc001:1   =                                             (NaN,NaN)
 cc001:2   =                                             (NaN,NaN)
 cc002     =                                             (NaN,NaN)
 cc002:1   =                                             (NaN,NaN)
 cc002:2   =                                             (NaN,NaN)
 cc111     =                                             (NaN,NaN)
 cc111:1   =                                             (NaN,NaN)
 cc111:2   =                                             (NaN,NaN)
 cc112     =                                             (NaN,NaN)
 cc112:1   =                                             (NaN,NaN)
 cc112:2   =                                             (NaN,NaN)
 cc122     =                                             (NaN,NaN)
 cc122:1   =                                             (NaN,NaN)
 cc122:2   =                                             (NaN,NaN)
 cc222     =                                             (NaN,NaN)
 cc222:1   =                                             (NaN,NaN)
 cc222:2   =                                             (NaN,NaN)
 cc0000    =                                             (NaN,NaN)
 cc0000:1  =                                             (NaN,NaN)
 cc0000:2  =                                             (NaN,NaN)
 cc0011    =                                             (NaN,NaN)
 cc0011:1  =                                             (NaN,NaN)
 cc0011:2  =                                             (NaN,NaN)
 cc0012    =                                             (NaN,NaN)
 cc0012:1  =                                             (NaN,NaN)
 cc0012:2  =                                             (NaN,NaN)
 cc0022    =                                             (NaN,NaN)
 cc0022:1  =                                             (NaN,NaN)
 cc0022:2  =                                             (NaN,NaN)
 cc1111    =                                             (NaN,NaN)
 cc1111:1  =                                             (NaN,NaN)
 cc1111:2  =                                             (NaN,NaN)
 cc1112    =                                             (NaN,NaN)
 cc1112:1  =                                             (NaN,NaN)
 cc1112:2  =                                             (NaN,NaN)
 cc1122    =                                             (NaN,NaN)
 cc1122:1  =                                             (NaN,NaN)
 cc1122:2  =                                             (NaN,NaN)
 cc1222    =                                             (NaN,NaN)
 cc1222:1  =                                             (NaN,NaN)
 cc1222:2  =                                             (NaN,NaN)
 cc2222    =                                             (NaN,NaN)
 cc2222:1  =                                             (NaN,NaN)
 cc2222:2  =                                             (NaN,NaN)
 ====================================================*)
```

![1l4kn1yut71v8](img/1l4kn1yut71v8.svg)

$$\text{FeynCalc$\grave{ }$LoopTools$\grave{ }$Private$\grave{ }$ltFailed}\left(\text{C}_0(0,0,0,0,0,1)\right)+\frac{1.}{\varepsilon }$$