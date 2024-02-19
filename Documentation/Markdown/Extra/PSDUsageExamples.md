## pySecDec usage examples

The main idea behind the FeynHelpers interface to pySecDec is to facilitate the generation of pySecDec scripts for integrals written in the FeynCalc notation (i.e. as `GLI`s with the corresponding lists of `FCTopology` symbols).

The main high-level function of this interface is called `PSDCreatePythonScripts`. In the simplest case we need two provide following arguments and options

- the 1st argument is some `GLI`
- the 2nd argument is the `FCTopology` to which this `GLI` belongs
- the 3rd argument is where to put the directory with pySecDec scripts. For quick tests one can simply use `NotebookDirectory[]`
- the option `PSDRequestedOrder` specifies the order in $\varepsilon$ to which the integral should be evaluated (default is `0`)
- the option `PSDRealParameterRules` is a list of rules for replacing kinematic invariants with numerical values which are real numbers. For complex numbers you need to use `PSDComplexParameterRules`
- if the script directory already exists, the function will by default refuse to overwrite it. Setting the option `OverwriteTarget` to `True` you can tell the code that you do not care about that

Here is a simple 1-loop example that incorporates all of the above

```mathematica
int = GLI[prop1L, {1, 1}]
topo = FCTopology[prop1L, {FAD[{p1, m1}], FAD[{p1 + q, m2}]}, {p1}, {q}, {Hold[SPD][q] -> qq}, {}]
files = PSDCreatePythonScripts[int, topo, NotebookDirectory[], 
  PSDRealParameterRules -> {qq -> 1., m1 -> 2., m2 -> 3.}, OverwriteTarget -> True]
```

The output is a list containing two elements which are full paths to the two pySecDec script files `generate_int.py` and `integrate_int.py`. You can now switch to the terminal, enter the corresponding directory and perform the integral evaluation by first running

```mathematica
python generate_int.py
```

Here is a sample output of this script

```mathematica
running "sum_package" for loopint
running "make_package" for "loopint_integral"
computing Jacobian determinant for primary sector 0
total number sectors before symmetry finding: 2
total number sectors after symmetry finding (iterative): 2
total number sectors after symmetry finding (light Pak): 2
total number sectors after symmetry finding (full Pak): 2
writing FORM files for sector 1
writing FORM files for sector 2
expanding the prefactor exp(EulerGamma*eps)*gamma(eps) (regulators: [eps] , orders: [0] )
 + (1)*eps**-1 + (0)
"loopint_integral" done
```

Now you need to compile the generated library files. This can be done via

```mathematica
make -j8 -C loopint
```

where 8 stands for the number threads to be run simultaneously. It depends on how powerful the CPU in your machine is.

Finally, entering

```mathematica
python integrate_int.py
```

will perform the actual numerical evaluation and save the obtained results to `numres_*_psd.txt`, `numres_*_mma.m` and `numres_*_maple.mpl`. Here `*` stands for the numerical values of kinematic invariants present in the integral. You can
modify those values without the need to recompile the libraries by simply editing the arrays `num_params_real` and `num_params_complex` in `integrate_int.py`.

For Mathematica users the file `numres_*_mma.m` is probably the most useful one. You can load the content of this file into your Mathematica session using the function `PSDLoadNumericalResults`. To that aim you just need to give it
the output of `PSDCreatePythonScripts` and set the options `PSDRealParameterRules` and `PSDComplexParameterRules` to the same values that were used when invoking `PSDCreatePythonScripts`

```mathematica
PSDLoadNumericalResults[files, PSDRealParameterRules -> {qq -> 1., m1 -> 2., m2 -> 3.}]
```