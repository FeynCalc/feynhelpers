(* ::Package:: *)

{

(* ++++++++++++++++ External states ++++++++++++++++ *)	

QGPolarization[(Phi)[i_, _], _] :>
	1,	

(* ++++++++++++++++ Propagators  ++++++++++++++++ *)	

(* Scalar field propagator *)
QGPropagator[Phi[_, p_], Phi[_, _], mass_] :>
	I FAD[{p,mass}],

(* ++++++++++++++++ Vertices  ++++++++++++++++ *)	

QGVertex[Phi[_, _], Phi[_, _], Phi[_, _], Phi[_, _]] :>
	-I SMP["la"]
}
