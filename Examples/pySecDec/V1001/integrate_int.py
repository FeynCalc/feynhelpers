#!/usr/bin/env python3
from pySecDec.integral_interface import IntegralLibrary, series_to_mathematica, series_to_maple, series_to_sympy
import sympy as sp

li = IntegralLibrary('loopint/loopint_pylink.so')

li.use_Qmc(
)

num_params_real = [5.]
num_params_complex = []

integral_without_prefactor, prefactor, integral_with_prefactor = li(verbose = True,
real_parameters = num_params_real,
complex_parameters = num_params_complex
)

result, error = map(sp.sympify, series_to_sympy(integral_with_prefactor))

num_params_real_str = '_'.join(str(val) for val in num_params_real)
if num_params_real_str!='':
    num_params_real_str = '_' + num_params_real_str

num_params_complex_str = '_'.join(str(val) for val in num_params_complex)
if num_params_complex_str!='':
    num_params_complex_str = '_' + num_params_complex_str

print('Numerical result')
res_file = open(''.join(['numres',num_params_real_str,num_params_complex_str,'_psd.txt']),'w')
for power in [-4, -3, -2, -1, 0, 1]:
    val = complex(result.coeff('eps', power))
    err = complex(error.coeff('eps', power))
    out=(f'eps^{power:<2} {val: .16f} +/- {err: .16e}')
    res_file.write(out)
    res_file.write('\n')
    print(out)
res_file.close()

res_mma= series_to_mathematica(integral_with_prefactor)

res_file = open(''.join(['numres',num_params_real_str,num_params_complex_str,'_mma.m']),'w')
res_file.write(''.join(['{',res_mma[0],',']))
res_file.write(''.join([res_mma[1],'}']))
res_file.close()

res_maple= series_to_maple(integral_with_prefactor)
res_file = open(''.join(['numres',num_params_real_str,num_params_complex_str,'_maple.mpl']),'w')
res_file.write(''.join(['[',res_maple[0],',']))
res_file.write(''.join([res_maple[1],']']))
res_file.close()