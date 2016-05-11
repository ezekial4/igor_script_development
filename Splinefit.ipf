#pragma rtGlobals=1		// Use modern global access method.

Function splinefit(y_data,x_data,y_error,knots,outpnts)
	Variable knots
	String y_data
	String X_data
	Wave y_error
	Variable outpnts
	
	Wavestats/Q y_error
	Variable/G stdev = V_sdev
	Variable/G pnts = V_npnts
	Variable/G free = knots-1
	Variable/G degrees = (pnts - free)
	 	
	Interpolate2/T=2/J=2/N=(outpnts)/E=2/I=3/A=(knots)/X=temp1 $x_data, $y_data
       Duplicate/O temp1 $x_data+"_CS"

	If (outpnts > pnts)
		Variable i,loc
		Wave dummy = $x_data
		Wave dummy3 = $y_data+"_cs"
		Variable wavmax = 8
		Variable splinevalue
		
		for (i= 0; i<(wavmax);i+=1)
			loc = dummy[i]
			FindValue/T=0.001/V=(loc) $x_data+"_CS"
			splinevalue = dummy3[V_value]
			Make/O/N=(pnts) y_diff_sq
			Wave dum1 = $y_data
			y_diff_sq[i] = ((dum1[i]-splinevalue)^2)/y_error[i]^2
		endfor
	else
		Make/O/N=(pnts) y_diff_sq
		Wave dum1 = $y_data
		Wave dum2 = $y_data+"_cs"
		y_diff_sq = ((dum1-dum2)^2)/y_error^2	 	
	Endif
	
	Variable/G chisq = sum(y_diff_sq)
	Variable/G redchisq  = chisq/degrees
	
	
	
	Make/O/N=3 error_wave =0
	error_wave[0] = chisq
	error_wave[1] = redchisq
	error_wave[2] = degrees

	KillWaves y_diff_sq,temp1
	KillVariables chisq, redchisq, degrees, free, pnts, stdev
End
	