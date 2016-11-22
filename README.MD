# Description

FeynHelpers is a collection of interfaces that allow you to use other HEP-related tools from your FeynCalc session.

# Requirements

FeynHelpers is designed as an add-on for FeynCalc. To use it you need at least FeynCalc 9.2 and Mathematica 8.

# Supported tools

Tools that are currently supported are
 * FIRE 5.2
 * Package-X 2.0

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
    InstallFeynCalc[]
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

# Usage

For usage information see the accompanying paper and supplied examples.

# Acknowledgments

If you use FeynHelpers in you work, please cite

* V. Shtabovenko, "FeynHelpers: Connecting FeynCalc to FIRE and Package-X", TUM-EFT 75/15, arXiv:1611.06793

Also don't forget to cite the authors of the tools that you are calling from FeynHelpers, which are

* [FIRE](http://inspirehep.net/record/1310407?ln=en) if you use FIREBurn
* [Package X](http://inspirehep.net/record/1347391/) if you use PaXEvaluate

# License

* The code of FeynHelpers is licensed under GNU GPLv3. 
* This __does not__ apply to the packages for which FeynHelpers provides an interface to FeynCalc. For the licensing of those packages please check the informations provided by the respective authors.
