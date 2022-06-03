# FeynHelpers

[![license: GPLv3](https://img.shields.io/badge/license-GPLv3-brightgreen.svg)](https://github.com/FeynCalc/feynhelpers/blob/master/LICENSE)
[![latest release](https://img.shields.io/github/release/FeynCalc/feynhelpers.svg)](https://github.com/FeynCalc/feynhelpers/releases)
![compatibility](https://img.shields.io/badge/Mathematica-8.x_9.x_10.x_11.x_12.x-brightgreen.svg)

FeynHelpers is a collection of interfaces that allow you to use other HEP-related tools from your [FeynCalc](http://www.feyncalc.org/) session.

# Requirements

FeynHelpers is designed as an add-on for FeynCalc. To use it you need at least FeynCalc 9.2 and Mathematica 8.

The development version of FeynHelpers requires the latest development version of FeynCalc and Mathematica 10.

# Manual

FeynHelpers manual is still work in progress but is already mature enough to be useful for normal users. 

The PDF version of the manual can be found [here](https://github.com/FeynCalc/feynhelpers-manual/releases/tag/dev-manual). If you prefer the web version, please visit this [website](https://feyncalc.github.io/referenceFeynHelpersDev).

For usage information see also the accompanying paper [arXiv:1611.06793](https://arxiv.org/abs/1611.06793) and the supplied examples.

Notice that the current manual applies to the development version of FeynHelpers. Hence, it may describe functionality that is not available in the stable version.

# Installation

The installation instructions can be found [here](https://feyncalc.github.io/FeynHelpersBookDev/Extra/Install.html)



## Experimental Fermat interface

The development version features an interface to the CAS [Fermat](http://home.bway.net/lewis/) by R. Lewis. At the moment
the main function of this interface is `FerSolve`, which employs Fermat to solve systems of linear equations. Notice that to run `FerSolve` you need to download the Fermat binary and put `ferl6` (Linux) or `ferm6` (macOS) to `FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "Fermat"}]`.


Some examples for running FerSolve would be


```
FerSolve[{a x + y == 7, b x - y == 1}, {x, y}]
```

```
FerSolve[{2 x + y c == 2, 4 x == c}, {x, y}]
```

```
eqs = {M0 == (1 - f1 - f2 - f3 - f4 - f5 - f6 - f7 - f8 - f9 - f10 - 
      f11 - f12 - f13 - f14 - f15 - f16)*m0, 
  M1 == f1*m0 + (1 - f1 - f2 - f3 - f4 - f5 - f6 - f7 - f8 - f9 - 
       f10 - f11 - f12 - f13 - f14 - f15 - f16)*m1, 
  M2 == f1*m1 + 
    f2*m0 + (1 - f1 - f2 - f3 - f4 - f5 - f6 - f7 - f8 - f9 - f10 - 
       f11 - f12 - f13 - f14 - f15 - f16)*m2, 
  M4 == f1*m3 + f2*m2 + f3*m1 + f4*m0, 
  M5 == f2*m3 + f3*m2 + f4*m1 + f5*m0, 
  M6 == f3*m3 + f4*m2 + f5*m1 + f6*m0, 
  M7 == f4*m3 + f5*m2 + f6*m1 + f7*m0, 
  M8 == f5*m3 + f6*m2 + f7*m1 + f8*m0, 
  M9 == f6*m3 + f7*m2 + f8*m1 + f9*m0, 
  M10 == f7*m3 + f8*m2 + f9*m1 + f10*m0, 
  M11 == f8*m3 + f9*m2 + f10*m1 + f11*m0, 
  M12 == f9*m3 + f10*m2 + f11*m1 + f12*m0, 
  M13 == f10*m3 + f11*m2 + f12*m1 + f13*m0, 
  M14 == f11*m3 + f12*m2 + f13*m1 + f14*m0, 
  M15 == f12*m3 + f13*m2 + f14*m1 + f15*m0, 
  M16 == f13*m3 + f14*m2 + f15*m1 + f16*m0};
vars = {f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, 
  f15, f16}
FerSolve[eqs, vars]
```

`FerSolve` can be also employed for calculating new tensor reduction with `Tdec`. For example,

```
$LoadAddOns = {"FeynHelpers"};
<< FeynCalc`

Tdec[{{p1, mu1}, {p1, mu2}, {p1, mu3}, {p1, mu4}, {p2, mu5}, {p2, 
   mu6}}, {Q1, Q2}, Solve -> FerSolve, UseTIDL -> False, 
 FCVerbose -> 1]
```

## Experimental QGRAF interface

The interface to QGRAF is still work in progress. Just to 
give a general idea of how it is supposed to work, here is a simple QED 2-loop example

```
SetDirectory[NotebookDirectory[]];
QGLoadInsertions[];
out = QGCreateAmp[2, {"El[p]"} -> {"El[p]"}, QGLoopMomentum -> l, 
  QGModel -> "QEDOneFlavor", QGShowOutput -> False]
  
QGConvertToFC[out[[1]], DiracChainJoin -> True]  

QGPrepareDiagramsTeX[out[[2]], "dias.tex"]
(*or QGPrepareDiagramsTeX[out[[2]], "Dias", Split -> True] *)
```

# Acknowledgments

If you use FeynHelpers in you work, please have a look [here](https://feyncalc.github.io/FeynHelpersBookDev/Extra/Cite.html).

# License

* The code of FeynHelpers is covered by the GNU General Public License 3.
* This __does not__ apply to the packages for which FeynHelpers provides an interface to FeynCalc. For the licensing of those packages please check the informations provided by the respective authors.
