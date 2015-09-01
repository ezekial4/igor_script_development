#pragma rtGlobals=1		// Use modern global access method.

Function trunc_n_interp_v2(basewav,interpnam)
	String basewav
	String interpnam
	
	Wave dum = $basewav
	Wavestats/M=1/Q dum
	Variable truncstart = dum[V_startrow]
	Variable truncend = dum[V_endrow]
	Variable wavpnt = (V_endrow+1)
	
	Wave dum2 = $"t_"+interpnam
	Wavestats/M=1/Q dum2
	Variable check = dum2[V_startrow]
	if (check > truncstart)
		truncstart =0
	endif

	String dum3 
	dum3 = "t_"+interpnam+"_trunc"
	Duplicate/O $"t_"+interpnam $dum3
	String dum4 = interpnam+"_trunc"
	Duplicate/O $interpnam $dum4
	
	FindValue/T=1/V=(truncstart) dum2
	DeletePoints 0, (V_value+1), $dum3
	DeletePoints 0, (V_value+1), $dum4
//			print truncstart, V_VALUE		
	FindValue/T=2/V=(truncend) $dum3
//		print truncend, V_Value
	DeletePoints (V_Value+1), 1e6, $dum3
	DeletePoints (V_Value+1), 1e6, $dum4

	Interpolate2/T=1/N=(wavpnt)/Y=$dum4+"_L"/X=$dum3+"_L" $dum3, $dum4

End