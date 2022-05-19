## PSDContourDeformation

`PSDContourDeformation` is an option for `PSDLoopPackage` and other functions of the pySecDec interface. It is a boolean switch that will be passed to pySecDec's `loop_package` argument `contour_deformation`. The default value is `True`. However, if you know in advance that your integral has no imaginary part, setting this option to `False` will greatly improve the peformance.

### See also

[Overview](Extra/FeynHelpers.md), [PSDLoopPackage](PSDLoopPackage.md).

### Examples