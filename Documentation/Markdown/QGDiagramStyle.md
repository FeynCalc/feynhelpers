## QGDiagramStyle

`QGDiagramStyle` is an option for `QGCreateAmp`, which specifies the QGRAF style file for generating the diagrams. If you provide only the file name, they style will be loaded from the standard directory containing model and style files (`$QGStylesDirectory`).

If you specify the full path, the style file will be loaded from there. The default value is a custom style file for FeynMP `"latex.sty"`. If the option value is set to an empty string, no diagram file will be generated.

### See also

[Overview](Extra/FeynHelpers.md), [QGCreateAmp](QGCreateAmp.md).

### Examples