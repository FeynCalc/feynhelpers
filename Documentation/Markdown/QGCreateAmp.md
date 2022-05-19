## QGCreateAmp

`QGCreateAmp[nLoops, {"InParticle1[p1]","InParticle1[p2]", ...} -> {"OutParticle1[k1]", "OutParticle1[k2]", ...}]` 
calls `QGRAF` to generate Feynman amplitudes and (optionally) the corresponding diagrams, using the specified  model and style files.

The function returns a list with the paths to two files,  where the first file contains the amplitudes and the second file the diagrams (graphical representations of the amplitudes).

### See also

[Overview](Extra/FeynHelpers.md), [QGConvertToFC](QGConvertToFC.md), [QGLoadInsertions](QGLoadInsertions.md).

### Examples