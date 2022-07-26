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
