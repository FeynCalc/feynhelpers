## QGBinaryFile

`QGBinaryFile` is an option for `QGCreateAmp`, which specifies the full path to the QGRAF binary. When set to `Automatic`, the default binary is`"qgraf"` on Linux and macOS or `"qgraf.exe"` on Windows, which resides in `FileNameJoin[{$FeynHelpersDirectory, "ExternalTools", "QGRAF", "Binary"}]`.

If you provide a different location, you must ensure that the containing directory is user-writable, since `QGCreateAmp` will need to save an automatically generated `"qgraf.dat"` in that directory and delete it afterwards.

### See also

[Overview](Extra/FeynHelpers.md), [QGCreateAmp](QGCreateAmp.md).

### Examples