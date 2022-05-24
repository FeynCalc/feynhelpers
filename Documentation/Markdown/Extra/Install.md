## Installation

The installation of FeynHelpers from scratch is a two step process. Apart from
installing the actual FeynCalc addon (step 1) it is also necessary to set up
the tools to which FeynHelpers provides FeynCalc interfaces (step 2). 

Due to the fact that these tools are written in different programming languages 
and usually must be compiled on user's machine, it is not possible to fully 
automatize this second step. Instead, we expect the user to install the relevant tools
manually.

In the following we provide some relevant instructions but without any warranty
that this will work on your machine. *If you are experiencing issues setting up
a particular tools please contact the corresponding developer team.*

### FeynHelpers

#### Automatic installation

* Run the following instruction in a Kernel or Notebook session of Mathematica to install the stable version


    ```
    Import["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]
    InstallFeynHelpers[]
    ```

* If you like the bleeding edge and you are already using the development version of FeynCalc, you can also install the development version of FeynHelpers

```
Import["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]
InstallFeynHelpers[InstallFeynHelpersDevelopmentVersion->True]
```


#### Manual installation

* Create a directory _FeynHelpers_ inside

	```
	FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns"}]
	```

	and put the source code there.

### Fermat

You can download FERMAT binaries for Linux or macOS from the [developer's website](https://home.bway.net/lewis/zip.html).

#### Linux

* Copy the directory `ferl64` to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "Fermat"}]`.

#### macOS

* Copy the directory `ferm64` to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "Fermat"}]`.

#### Windows

* Currently there is no native Windows version of FERMAT. The Linux version appears to be usable via WSL, but currently there is no support for that in FeynHelpers.

### FIRE

You can download the source code of FIRE from the [developer's website](https://bitbucket.org/feynmanIntegrals/fire). The content should be extracted to `FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE"}]`.

#### Linux

* The instructions for compiling FIRE from source on Linux are provided [here](https://bitbucket.org/feynmanIntegrals/fire/src/master/README.md).

#### macOS

* The instructions for compiling FIRE from source on macOS can be found [here](https://bitbucket.org/feynmanIntegrals/fire/issues/10/issue-of-the-installation-on-macos).

#### Windows

* There is no native Windows port of FIRE. It should be possible to compile FIRE on WSL with an Ubuntu installation, but currently there is no support for that in FeynHelpers.


### LoopTools

On the [developer's website](http://www.feynarts.de/looptools/) you can download not only the source code but also precompiled binaries

#### Linux or macOS

* Copy the self-compiled or precompiled MathLink executable `LoopTools`  to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "LoopTools"}]`.

#### Windows

* Rename the self-compiled or precompiled MathLink executable `LoopTools.exe` to `LoopTools` and copy it to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "LoopTools"}]`.

### pySecDec

The installation instructions for pySecDec can be found [here](https://secdec.readthedocs.io/en/stable/installation.html#download-the-program-and-install). FeynHelpers
does not require pySecDec to _generate_ the corresponding Python scripts. However, in order to actually compute the given loop integrals one has to run those scripts, which is possible only when pySecDec is installed.

#### Linux or macOS

It should be possible to install pySecDec via pip automatically.

#### Windows

It could be possible to set up pySecDec on WSL, but currently it is unclear whether this can work.

### Package-X

Currently the installation of Package-X is handled by the automatic installer. Since Package-X is a Mathematica package that only needs
to be copied to the correct location, the installation is easy to automatize.

Alternatively, you can download Package-X from the [developer's website](https://packagex.hepforge.org/) and copy the folder `X` to `FileNameJoin[{$UserBaseDirectory, "Applications"}]`. If you can load Package-X by evaluating ``X` `` in a notebook, then the installation was successful.

### QGRAF

You can download the source code of QFRAF from the [developer's website](http://cfif.ist.utl.pt/~paulo/qgraf.html).

#### Linux and macOS

The compilation instructions can be found in the section "Compiling" of the manual `qgraf-3.6.0.pdf` inside the tarball. Having compiled the program you need to rename the binary to `qgraf` and put it to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "QGRAF", "Binary"}]`.

#### Windows

You can download and install the [MinGW compiler](https://sourceforge.net/projects/mingw-w64/files/mingw-w64). Do not forget to change the architecture from i686 to x86_64 in the install
wizard. Then it should be possible to compile QGRAF with statically linked libraries via `gfortran.exe -static qgraf-3.x.y.f08`. Finally rename the resulting binary to `qgraf.exe` and put it to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "QGRAF", "Binary"}]`.




