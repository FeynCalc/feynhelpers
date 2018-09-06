# FeynHelpers

[![license: GPLv3](https://img.shields.io/badge/license-GPLv3-brightgreen.svg)](https://github.com/FeynCalc/feynhelpers/LICENSE)
[![latest release](https://img.shields.io/github/release/FeynCalc/feynhelpers.svg)](https://github.com/FeynCalc/feynhelpers/releases)
![compatibility](https://img.shields.io/badge/Mathematica-8.x_9.x_10.x_11.x-brightgreen.svg)

FeynHelpers is a collection of interfaces that allow you to use other HEP-related tools from your [FeynCalc](http://www.feyncalc.org/) session.

# Requirements

FeynHelpers is designed as an add-on for FeynCalc. To use it you need at least FeynCalc 9.2 and Mathematica 8.

# Supported tools

Tools that are currently supported are

 * [FIRE 5.2](https://bitbucket.org/feynmanIntegrals/fire)
 * [Package-X 2.1](https://packagex.hepforge.org)

# Installation

## Automatic installation

* Run the following instruction in a Kernel or Notebook session of Mathematica


    ```
    Import["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]
    InstallFeynHelpers[]
    ```

  If the above code fails with `URLFetch::invhttp: SSL connect error` (e.g. on Mathematica 9 under OS X), try

    ```
    ImportString[URLFetch["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]]
    InstallFeynHelpers[]
    ```

* The automatic installer can also install Package-X and FIRE for you. It will offer you this possiblity at the end of the installation process

## Manual installation

* Create a directory _FeynHelpers_ inside

	```
	FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns"}]
	```

	and put the source code there.

* Install Package-X and FIRE packages.  It should be possible to load Package-X via

	```
	<<X`
	```

	and FIRE via

	```
	<< FIRE5`
	```

## Development version

If you like the bleeding edge and you are already using the development version of FeynCalc, you can also install the development version of FeynHelpers

```
Import["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]
InstallFeynHelpers[InstallFeynHelpersDevelopmentVersion->True]
```

# Usage

For usage information see the accompanying paper [arXiv:1611.06793](https://arxiv.org/abs/1611.06793) and the supplied examples.

# Acknowledgments

If you use FeynHelpers in you work, please cite

* V. Shtabovenko, "FeynHelpers: Connecting FeynCalc to FIRE and Package-X", Comput. Phys. Commun., 218, 48-65, 2017, arXiv:1611.06793

Also don't forget to cite the authors of the tools that you are calling from FeynHelpers, which are

* [FIRE](http://inspirehep.net/record/1310407?ln=en) if you use FIREBurn
* [Package X](http://inspirehep.net/record/1347391/) if you use PaXEvaluate

# License

* The code of FeynHelpers is covered by the GNU General Public License 3.
* This __does not__ apply to the packages for which FeynHelpers provides an interface to FeynCalc. For the licensing of those packages please check the informations provided by the respective authors.
