## FIREAddPropagators

`FIREAddPropagators` is an option for `FIREBurn`. Normally, for loop integrals that do not have enough propagators to form a complete basis, `FIREBurn` will automatically include missing propagators and put them to unity after the reduction is complete. In some cases it may be desirable to choose the missing propagators manually. This can be done by specifying the  propagators via `AddPropagators->{prop1,prop2,...}`.

### See also

[Overview](Extra/FeynHelpers.md), [FIREBurn](FIREBurn.md).

### Examples