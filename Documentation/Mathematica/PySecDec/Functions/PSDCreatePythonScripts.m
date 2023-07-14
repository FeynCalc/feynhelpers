(* ::Package:: *)

 


(* ::Section:: *)
(*PSDCreatePythonScripts*)


(* ::Text:: *)
(*`PSDCreatePythonScripts[int, topo, path]` creates a set of Python scripts needed for the evaluation of the integral `int` (in the `GLI` representation) belonging to the topology `topo`. The files are saved to the directory `path/topoNameXindices`. The function returns a list of two strings that point to the generation and integration scripts for pySecDec.*)


(* ::Text:: *)
(*One can also use the `FeynAmpDenominator`-representation as in `PSDCreatePythonScripts[fadInt, lmoms, path]`, where `lmoms` is the list of the loop momenta on which `fadInt` depends. In this case the generation and integration scripts will directly go into `path`.*)


(* ::Text:: *)
(*Another way to invoke the function would be `PSDCreatePythonScripts[{int1, int2, ...}, {topo1, topo2, ...}, path]` in which case the files will be saved to `path/topoName1Xindices1`, `path/topoName2Xindices2` etc. The syntax `PSDCreatePythonScripts[{int1, int2, ...}, {topo1, topo2, ...}, {path1, path2, ...}]` is also possible.*)


(* ::Text:: *)
(*Unless you are computing a single scale integral with the scale variable set to unity, you must specify all external parameters (e.g. masses and scalar products of external momenta) and their numerical values via the corresponding options. For real-valued parameters use the option `PSDRealParameterRules` as `PSDRealParameterRules->{param1->val1, param2->val2, ...}`. For complex-valued parameters use `PSDComplexParameterRules`with the same syntax. The precise numerical values do not matter at the generation stage, one only has to distinguish between real- and complex-valued parameters. As far as the integration stage is concerned, you can easily change the numerical values when running the corresponding Python script. The values supplied via `PSDRealParameterRules` and `PSDComplexParameterRules` will be the default, though.*)


(* ::Text:: *)
(*Notice that the variables passed to pySecDec must be atomic i.e. you can use `qq`, `m`, `m2`, `M` etc. but not  something like `Pair[Momentum[q],Momentum[q]]`, `mass[2]`, or `sp["p.q"]`. This means that you need to replace scalar products of external momenta that appear in your integrals with some simple symbols. If this has not been done on the level of replacement rules attached to your `FCTopology` objects (5th argument), you can still use the option `FinalSubstitutions`.*)


(* ::Text:: *)
(*Another important option that you most likely would like to specify is `PSDRequestedOrder` which specifies the order in $\varepsilon$ up to which the integral should be evaluated.*)


(* ::Text:: *)
(*The names of generation and integration scripts can be changed via the options `PSDGenerateFileName` and `PSDIntegrateFileName` with the default values being `generate_int.py` and `integrate_int.py` respectively.*)


(* ::Text:: *)
(*The method used for the sector decomposition is controlled by the option `PSDDecompositionMethod`, where `"geometric"` is the default value.*)


(* ::Text:: *)
(*The integrator used for the numerical evaluation of the integral is set by the option `PSDIntegrator`, where `"Qmc"` is the default value. Accordingly, if you want to increase the number of Qmc iterations, you should use the option `PSDMinn`.*)


(* ::Text:: *)
(*If you know in advance that the integral you are computing does not have cuts (i.e. the result is purely real with no imaginary part), then it is highly recommended to disable the contour deformation. This will give you a huge performance boost. The option controlling this pySecDec parameter is called `PSDContourDeformation` and is set to `True` by default.*)


(* ::Text:: *)
(*The prefactor of integrals evaluated by pySecDec is given by  $\frac{1}{i \pi^{D/2}}$ per loop, which is the standard choice for multiloop calculations. However, factors of $\gamma_E$ and $\log(4\pi)$ are not eliminated by default. The FeynHelpers interface takes care of that by adding  an extra $e^{\gamma_E \frac{4-D}{2}}$ per loop. This is controlled by the value of the `PSDAdditionalPrefactor` option. When set to `Default`, the overall prefactor is given by $\frac{e^{\gamma_E \frac{4-D}{2}}}{i \pi^{D/2}}$ per loop. Setting this option to a different value, say `x`, will give you*)
(*$\frac{x}{(i \pi^{D/2})^L}$ as the overall prefactor with $L$ being the number of loops. Notice that in this case `x` must be a string using the pySecDec syntax.*)


(* ::Text:: *)
(*For realistic integrals the generation stage can take a considerable amount of time, especially when done on a laptop. For this reason `PSDCreatePythonScripts` implements some safety measures  to prevent the user from accidentally overwriting or corrupting the existing files. First of all, if the files `generate_int.py` and `integrate_int.py` already exist, the function will not overwrite them by default.*)
(*To change this behavior you need to set the value of the option `OverwriteTarget` to `True`.  In addition to that, pySecDec by itself will abort the generation stage if the output directory for the C++ code*)
(*(specified by the option `PSDOutputDirectory`) already exists. However, you can tweak the corresponding Python script such, that the output directory will be always overwritten without further warnings. To this aim you need to set the option `PSDOverwritePackageDirectory` to `True`.*)


(* ::Subsection:: *)
(*See also*)


(* ::Text:: *)
(*[Overview](Extra/FeynHelpers.md), [PSDIntegrate](PSDIntegrate.md), [PSDLoopIntegralFromPropagators](PSDLoopIntegralFromPropagators.md), [PSDLoopPackage](PSDLoopPackage.md), [PSDLoopRegions](PSDLoopRegions.md).*)


(* ::Subsection:: *)
(*Examples*)


topo1=FCTopology[prop1L, {FAD[{p1, m1}], FAD[{p1+q, m2}]}, {p1}, {q},{},{}]
int1=GLI[prop1L,{1,1}]


fileNames=PSDCreatePythonScripts[int1,topo1,FileNameJoin[{$FeynCalcDirectory,"Database"}],PSDRealParameterRules->{qq->1. , m1->2. , m2->3.},FinalSubstitutions->{FCI@SPD[q]->qq},OverwriteTarget->True];


fileNames[[1]]//FilePrint[#,1;;14]&


fileNames[[2]]//FilePrint[#,1;;14]&


PSDCreatePythonScripts[SFAD[{p, m^2}],{p},FileNameJoin[{$FeynCalcDirectory,"Database","tal1LInt"}],PSDRealParameterRules->{m->1.},OverwriteTarget->True];
