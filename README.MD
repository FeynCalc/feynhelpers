# Description

FeynHelpers is a collection of interfaces that allow you to use other HEP-related tools from your FeynCalc session.

# Warning

In the present state FeynHelpers is **NOT READY** for productive use. In particular, you should **NEVER** rely on the results that were obtained solely with FeynHelpers but not checked with any other tools or by hand. However, you are encouraged to report bugs and suggest improvements.

# Requirements

FeynHelpers is designed as an add-on for FeynCalc. To use it you need at least FeynCalc 9 and Mathematica 8.

# Supported tools

Tools that are currently supported are
 * FIRE
 * Package-X

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
* The automatic installer can also install Package-X for you. It will offer you this possiblity at the end of the installation process

* If you want to use FIRE, you will need to install the package by hand. It should be possible to load FIRE via

	```
	<< FIRE5`
	```
	
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

## Loading the add-on

To load FeynHelpers with FeynCalc, use

```
$LoadAddOns={"FeynHelpers"};
<< FeynCalc`
```

## PaXEvaluate

* PaXEvaluate is a function that fetches analytic expressions for Passarino-Veltman coefficient and scalar functions with up to 3-legs from Package-X.

* The syntax is `PaxEvaluate[expr,q]`, where `expr` is the expression that you want to evaluate and `l` denotes the loop momentum
* There are also some options, from which `PaXImplicitPrefactor` is the most important one. It denotes an implicit prefactor of the loop integral, i.e. a prefactor that is not written explicitly but understood. For example, using `FAD[{q, m}]` with `PaXImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)` corresponds to entering  the integral `\[Integral] d q^D / (2Pi)^D 1/(q^2 - m^2)`, i.e. the usual 1-loop tadpole integral with the "textbook" prefactor.

Here is an example of evaluating a tadpole integral

```
PaXEvaluate[FAD[{q, m}], q, PaXImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)]

```

## FIREBurn

Here is an example of IBP-reducing a bubble with propagators in powers

```
FIREBurn[FAD[{q, m0, 2}, {q - p, m1, 3}], {q}, {p}]
```

# Acknowledgments

If you use FeynHelpers in you work, please cite

* V. Shtabovenko, "FeynHelpers: Connecting FeynCalc to FIRE and Package-X", TUM-EFT 75/15, in preparation

Also don't forget to cite the authors of the tools that you are calling from FeynHelpers, which are

* [FIRE](http://inspirehep.net/record/1310407?ln=en) if you use FIREBurn
* [Package X](http://inspirehep.net/record/1347391/) if you use PaXEvaluate

# License

* The code of FeynHelpers is licensed under GNU GPLv3. 
* This __does not__ apply to the packages for which FeynHelpers provides an interface to FeynCalc. For the licensing of those packages please check the informations provided by the respective authors.
