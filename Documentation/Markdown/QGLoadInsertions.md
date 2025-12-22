## QGLoadInsertions

`QGLoadInsertions["insertions.m"]` loads insertion rules from `insertions.m` for amplitudes generated with QGRAF.

Specifying only the file name means that `QGLoadInsertions` will search for the file first in `$QGInsertionsDirectory` and then in the current directory. Specifying the full path will force the function to load the file from there directly.

Evaluating `QGLoadInsertions[]` loads some common insertions from `QGCommonInsertions.m` that are shipped with this interface.

### See also

[Overview](Extra/FeynHelpers.md), [QGConvertToFC](QGConvertToFC.md), [QGCreateAmp](QGCreateAmp.md).

### Examples