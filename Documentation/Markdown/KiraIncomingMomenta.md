## KiraIncomingMomenta

`KiraIncomingMomenta` is an option for `KiraCreateConfigFiles` and other functions of the Kira interface.

It specifies incoming momenta in the original amplitude. The default value is `Automatic`, meaning that FeynHelpers will simply treat all external momenta present in the topology as incoming ones. This is the safest way to do the reduction.

Alternatively, the user may want to specify the momenta by hand. In that case the same should be done also for the options `KiraOutgoingMomenta` and `KiraMomentumConservation`.

### See also

[Overview](Extra/FeynHelpers.md), [KiraCreateConfigFiles](KiraCreateConfigFiles.md).

### Examples