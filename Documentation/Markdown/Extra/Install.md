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

Run the following instruction in a Kernel or Notebook session of Mathematica to install the stable version

```mathematica
Import["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]
InstallFeynHelpers[]
```

If you like the bleeding edge and you are already using the development version of FeynCalc, you can also install the development version of FeynHelpers

```mathematica
Import["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]
InstallFeynHelpers[InstallFeynHelpersDevelopmentVersion->True]
```

#### Manual installation

Create a directory _FeynHelpers_ inside

```mathematica
FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns"}]
```

and put the source code there.

### Fermat

You can download FERMAT binaries for Linux or macOS from the [developer's website](https://home.bway.net/lewis/zip.html).

#### Linux

Copy the directory `ferl64` to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "Fermat"}]`.

#### macOS

Copy the directory `ferm64` to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "Fermat"}]`.

#### Windows

Currently there is no native Windows version of FERMAT. The Linux version appears to be usable via WSL, but currently there is no support for that in FeynHelpers.

### FIRE

You can download the source code of FIRE from the [developer's website](https://bitbucket.org/feynmanIntegrals/fire). The content should be extracted to `FileNameJoin[{$UserBaseDirectory, "Applications", "FIRE"}]`.

We recommend to enable support for zstd, lthreads, tcmalloc, snappy and zlib via

```mathematica
./configure --enable_zlib --enable_snappy --enable_lthreads --enable_tcmalloc --enable_zstd
```

If you compile FIRE without the zstd support, you should change the option `FIRECompressor`
of `FIRECreateConfigFile` to `"lz4"`. However, for performance reasons it is better to use the zstd compression algorithm.

#### Linux

The instructions for compiling FIRE from source on Linux are provided [here](https://bitbucket.org/feynmanIntegrals/fire/src/master/).

#### macOS

The instructions for compiling FIRE from source on macOS can be found [here](https://bitbucket.org/feynmanIntegrals/fire/issues/10/issue-of-the-installation-on-macos).

#### Windows

There is no native Windows port of FIRE. It should be possible to compile FIRE on WSL with an Ubuntu installation, but currently there is no support for that in FeynHelpers.

### Kira

You can download the source code of Kira from the [developer's website](https://gitlab.com/kira-pyred/kira).
FeynHelpers does not require Kira to _generate_ the corresponding yaml files. However, in order to actually do the reduction one has to run those scripts, which is possible only when Kira is installed.

#### Linux and macOS

The instructions for compiling Kira from source on Linux or macOS are provided [here](https://gitlab.com/kira-pyred/kira).

#### Windows

It should be possible to compile Kira on WSL with an Ubuntu installation, but currently there is no support for that in FeynHelpers.

### Package-X

Package-X is not being developed or even maintained anymore. However, the
author of the tool, Hiren H. Patel, kindly gave us permission  to ship `OneLoop.m` (part of Package-X containing library of analytic results for Passarino-Veltman functions) together with FeynHelpers.

Therefore, no separate installation of Package-X is needed. 

Please notice that you are using this library on your own risk. The lack of maintenance
means that newly discovered bugs are not going to be fixed and there is no guarantee that it will continue to work with newer Mathematica versions.

### pySecDec

The installation instructions for pySecDec can be found [here](https://secdec.readthedocs.io/en/stable/installation.html#download-the-program-and-install). FeynHelpers
does not require pySecDec to _generate_ the corresponding Python scripts. However, in order to actually compute the given loop integrals one has to run those scripts, which is possible only when pySecDec is installed.

Notice that the default sector decomposition method configured in the pySecDec method is `geometric`, which requires an external program called [normaliz](https://www.normaliz.uni-osnabrueck.de). Please refer to the [corresponding section](https://secdec.readthedocs.io/en/stable/installation.html?highlight=normaliz#the-geomethod-and-normaliz) in the pySecDec manual for further details on setting `normaliz` up.

#### Linux or macOS

It should be possible to install pySecDec via pip automatically.

#### Windows

It could be possible to set up pySecDec on WSL, but currently it is unclear whether this can work.

### LoopTools

On the [developer's website](http://www.feynarts.de/looptools/) you can download not only the source code but also precompiled binaries

#### Linux or macOS

Copy the self-compiled or precompiled MathLink executable `LoopTools`  to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "LoopTools"}]`.

#### Windows

Rename the self-compiled or precompiled MathLink executable `LoopTools.exe` to `LoopTools` and copy it to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "LoopTools"}]`.

### QGRAF

You can download the source code of QGRAF from the [developer's website](http://cfif.ist.utl.pt/~paulo/qgraf.html).

#### Linux and macOS

The compilation instructions can be found in the section "Compiling" of the manual `qgraf-3.x.y.pdf` inside the tarball. For example,
on a Linux system equipped with a GNU Fortran compiler something like

```mathematica
gfortran qgraf-3.6.3.f08 -o qgraf
```

should do the job. Having compiled the program you need to move the binary file `qgraf` to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "QGRAF", "Binary"}]`.

#### Windows

To extract the source code tarball of QGRAF you need a tool that can deal with tar.gz archives, e.g.
[7-zip](https://www.7-zip.org/).

To build QGRAF from source you need a FORTRAN compiler. You can use the [MinGW compiler](https://sourceforge.net/projects/mingw-w64/files/mingw-w64) via the _MinGW-W64 Online Installer_ (`MinGW-W64-install.exe`). When the `Settings` page appears in the installation wizard, change `Architecture` from `i686` to `x86_64`.

Unfortunately, as of June 2022 the installer is broken and fails with the error message "file was downloaded incorrectly". A possible workaround is described [here](https://sourceforge.net/p/mingw-w64/support-requests/125/). When you reach the `Installation folder` page in the installation wizard, open 

````
C:\Users\YOUR_USER_NAME\AppData\Local\Temp\gentee
````

and drop there the file `x86_64-8.1.0-release-win32-seh-rt_v6-rev0.7z` that you can donwload from [SourceForge](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-posix/seh/x86_64-8.1.0-release-posix-seh-rt_v6-rev0.7z). This skips the broken process of downloading the file by the installer and should get you through the installation.

Finally, open `MiniGW-W64 project` -> `Open Terminal` via the start menu. Go to the folder where you extracted the source code of QGRAF and compile it with `gfortran.exe -static qgraf-3.x.y.f08 -o qgraf.exe`, where `x` and `y` denote the current version numbers.

Run `qgraf.exe` to make sure that it works properly.

Finally, move `qgraf.exe` to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "QGRAF", "Binary"}]`.