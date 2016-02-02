# Description

FeynHelpers is a collection of intefaces that allow you to use other HEP-related tools from your FeynCalc session.

# Warning

In the present state FeynHelpers is **NOT READY** for productive use. In particular, you should **NEVER** rely on the results that were obtained solely with FeynHelpers but not checked with any other tools or by hand. However, you are encouraged to report bugs and suggest improvements.

# Supported tools

Tools that are currently supported are 
 * FIRE
 * Package-X

# Installation

FeynHelpers is designed as an add-on for FeynCalc. Therefore, you need to create a directory FeynHelpers inside 

```
FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns"}]
```

and put the source code there. To load FeynHelpers with FeynCalc, use

```
$LoadAddOns={"FeynHelpers"};
<< FeynCalc`
```

Apart from FeynCalc and FeynHelpers you of course also need FIRE and Package-X installed. It should be possible to load Package-X via

```
<<X`
```

and FIRE via

```
<< FIRE5`
```


# Usage

Here is an example of evaluating a tadpole integral

```
PaXEvaluate[FAD[{q, m}], q, PaXImplicitPrefactor -> 1/(2 Pi)^(4 - 2 Epsilon)]

```

Here is an example of IBP-reducing a bubble with propagators in powers

```
FIREBurn[FAD[{q, m0, 2}, {q - p, m1, 3}], {q}, {p}]
```

# Acknowledgements

If you use FeynHelpers in you work, please cite 

* V. Shtabovenko, "FeynHelpers: Connecting FeynCalc to FIRE and Package-X", TUM-EFT 75/15, in preparation

Also don't forget to cite the authors of the tools that you are calling from FeynHelpers, which are

* [FIRE](http://inspirehep.net/record/1310407?ln=en) if you use FIREBurn 
* [Package X](http://inspirehep.net/record/1347391/) if you use PaXEvaluate 

# License

The code of FeynHelpers is licenced under LGPLv3. This doesn't apply to the packages for which FeynHelpers provides an interface to FeynCalc. For the licensing of those packages please check the informations provided by the respective authors.