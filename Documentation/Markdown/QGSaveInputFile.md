## QGSaveInputFile

`QGSaveInputFile` is an option for `QGCreateAmp`, which specifies where to save the QGRAF input file `"qgraf.dat"`. This file is automatically created from the input parameters of `QGCreateAmp` but it must be located in the same directory as the QGRAF binary when QGRAF is invoked. The default value is False, which means that `"qgraf.dat"` will be deleted after the successful QGRAF run. When set to `True`, `"qgraf.dat"` will be copied to the current directory.

Specifying an explicit path will make `QGCreateAmp` put `"qgraf.dat"` there. Notice that only the file for generating the amplitudes is saved. The file for generating the diagrams (if exists) is identical except for the difference in the style line.

### See also

[Overview](Extra/FeynHelpers.md), [QGCreateAmp](QGCreateAmp.md).

### Examples