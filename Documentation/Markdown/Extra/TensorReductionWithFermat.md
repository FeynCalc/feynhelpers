## Tensor reduction with Fermat

One of the most useful functions exposed by the Fermat interface is `FerSolve`
that is vastly superior to Mathematica's `Solve` when dealing with very large
symbolic systems of equations.

A typical situation where one needs to solve such equations is the derivation
of tensor decomposition formulas. To this aim FeynCalc's `Tdec` can directly
use `FerSolve`, once FeynHelpers is loaded. One just needs to set
the option `Solve` to `FerSolve`. 


The following example calculates tensor reduction formula for a rank 6 integral
with 2 loop momenta and two external momenta. The Fermat part requires only 40
seconds on a modern laptop to solve the corresponding $52 \times 52$ symbolic system.

```
Tdec[{{p1, mu1}, {p1, mu2}, {p1, mu3}, {p1, mu4}, {p2, mu5}, {p2, mu6}},
{Q1, Q2}, Solve -> FerSolve, UseTIDL -> False, FCVerbose -> 1]
```

### FeynHelpers

#### Automatic installation

Run the following instruction in a Kernel or Notebook session of Mathematica to install the stable version


```
Import["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]
InstallFeynHelpers[]
```

If you like the bleeding edge and you are already using the development version of FeynCalc, you can also install the development version of FeynHelpers

```
Import["https://raw.githubusercontent.com/FeynCalc/feynhelpers/master/install.m"]
InstallFeynHelpers[InstallFeynHelpersDevelopmentVersion->True]
```


#### Manual installation

Create a directory _FeynHelpers_ inside

```
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

#### Linux

The instructions for compiling FIRE from source on Linux are provided [here](https://bitbucket.org/feynmanIntegrals/fire/src/master/README.md).

#### macOS

The instructions for compiling FIRE from source on macOS can be found [here](https://bitbucket.org/feynmanIntegrals/fire/issues/10/issue-of-the-installation-on-macos).

#### Windows

There is no native Windows port of FIRE. It should be possible to compile FIRE on WSL with an Ubuntu installation, but currently there is no support for that in FeynHelpers.


### LoopTools

On the [developer's website](http://www.feynarts.de/looptools/) you can download not only the source code but also precompiled binaries

#### Linux or macOS

Copy the self-compiled or precompiled MathLink executable `LoopTools`  to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "LoopTools"}]`.

#### Windows

Rename the self-compiled or precompiled MathLink executable `LoopTools.exe` to `LoopTools` and copy it to `FileNameJoin[{$UserBaseDirectory, "Applications", "FeynCalc", "AddOns", "FeynHelpers", "ExternalTools", "LoopTools"}]`.

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

You can download the source code of QGRAF from the [developer's website](http://cfif.ist.utl.pt/~paulo/qgraf.html).

#### Linux and macOS

The compilation instructions can be found in the section "Compiling" of the manual `qgraf-3.x.y.pdf` inside the tarball. For example,
on a Linux system equipped with a GNU Fortran compiler something like
```
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




