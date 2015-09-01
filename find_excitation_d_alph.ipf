#pragma rtGlobals=1		// Use modern global access method.

function Find_Excitation_D_alph(ne,te)
	Variable ne
	Variable te
	
	If (ne < 1e18 || ne > 1e20 )
		Abort "Density out of Range, must be >=5e18 m**-3 and <=1e20 m**-3)"
	endif
	If (te < 1 || te > 1500)
		Abort "Temp. out of Range, must be >=1eV and <=1500eV)"
	endif

	Variable PEC_value
	if (ne >=1e18 && ne <=1.5e18)
		MAKE/O POLY_CONS ={-13.5641,12.0695,-12.9392,8.22862,-9.18345,12.674,-4.7559,-8.14181,11.5483,-6.8482,2.28705,-0.447155,0.0479146,-0.0021791}
		PEC_value = 10^poly(poly_cons,log(te))	
	endif
	if (ne >1.5e18 && ne <=2.5e18)
		MAKE/O POLY_CONS ={-13.5049,11.8569,-14.2509,10.9513,-5.81845,2.1808,-0.549589,0.0813786,-0.00521342}
		PEC_value = 10^poly(poly_cons,log(te))	
	endif
	if (ne >2.5e18 && ne <=7.5e18)
		MAKE/O POLY_CONS ={-13.5256,11.8079,-14.2496,10.971,-5.83564,2.19395,-0.555219,0.0824931,-0.00529481}
		PEC_value = 10^poly(poly_cons,log(te))	
	endif
	if (ne >7.5e18 && ne <=1.5e19)
		MAKE/O POLY_CONS ={-13.6154,11.877,-13.0854,9.15384,-9.10152,9.61042,-2.16566,-6.37309,7.43266,-3.92977,1.18996,-0.21219,0.0207775,-0.000863448}
		PEC_value = 10^poly(poly_cons,log(te))	
	endif
	if (ne >1.5e18 && ne <=3.5e19)
		MAKE/O POLY_CONS ={-13.6029,11.6511,-14.2096,11.0276,-5.91342,2.24698,-0.573591,0.085524,-0.00548396}
		PEC_value = 10^poly(poly_cons,log(te))	
	endif
	if (ne >3.5e18 && ne <=7.5e19)
		MAKE/O POLY_CONS ={-13.7126,11.4547,-14.0866,11.1047,-6.06895,2.34179,-0.601228,0.0893912,-0.00568991}
		PEC_value = 10^poly(poly_cons,log(te))	
	endif
	if (ne >7.5e18 && ne <=1e20)
		MAKE/O POLY_CONS ={-13.8247,11.3156,-13.9889,11.0807,-6.10729,2.39764,-0.629483,0.0956193,-0.00619539}
		PEC_value = 10^poly(poly_cons,log(te))	
	endif

	killwaves poly_cons
	return PEC_value
End