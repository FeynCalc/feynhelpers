#!/usr/bin/env python3
if __name__ == "__main__":
    from pySecDec import sum_package, loop_package, loop_regions, LoopIntegralFromPropagators
    import pySecDec as psd

    li =     LoopIntegralFromPropagators(
    ['(p1 + q)**2', '-m1**2 + p3**2', '(p1 - p3)**2', '-m1**2 + (p3 + q)**2'],
    loop_momenta = ['p1', 'p3'],
    powerlist = [1, 1, 1, 1],
    dimensionality = '4 - 2*eps',
    Feynman_parameters = 'x',
    replacement_rules = [('q**2','m1**2')],
    regulators = ['eps']
    )

    import os,shutil
    if os.path.isdir('loopint'):
        if input('The directory loopint already exists, do you want to overwrite it (y/n)? ') in ['y','Y','j']:
            shutil.rmtree('loopint')
        else:
            exit(1)

    loop_package(
    name = 'loopint',
    loop_integral = li,
    requested_orders = [1],
    real_parameters = ['m1'],
    contour_deformation = True,
    additional_prefactor = '(1)*exp(2*EulerGamma*eps)',
    decomposition_method = 'geometric'
    )
