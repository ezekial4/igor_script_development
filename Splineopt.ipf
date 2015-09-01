#pragma rtGlobals=1		// Use modern global access method.

Function Splineopt(y_data,x_data,y_err_str,int_knots,tol,itermax)
	String y_data
	String x_data
	String y_err_str
	Variable int_knots    // Initial guess at number of knots
	Variable tol               // reduced chi_sq toloerance
	Variable itermax       // maximum iterations for error analysis
	Variable outpnts = 8
	
	Wave y_error =$y_err_str
	
	if(waveexists(error_wave)==0)
		Make/O/N=3 error_wave=0
	endif
	
	//First fit
	splinefit(y_data,x_data,y_error,int_knots,outpnts)
	//End
		
	Variable upper = 1+tol
	Variable lower = 1-tol
	
	Print "---New Try---"
	Printf "Lower Bound:  %g\r  Initial Reduced Chi_sq: %g\r",lower,error_wave[1]	
	Printf "Upper Bound: %g\r",upper	
	
	Variable fit_param = error_wave[1]
	Do
		Do
			If (fit_param < lower)
				int_knots +=1
			Endif
			If (fit_param > upper)
				int_knots -=1
			Endif
		
			If (int_knots < 4)
				Abort "Aborted! Number of knots got too low, try higher tolerance"
			Endif
		
		splinefit(y_data,x_data,y_error,int_knots,outpnts)
		fit_param = error_wave[1]
		While (fit_param > upper)	
		
		splinefit(y_data,x_data,y_error,int_knots,outpnts)
		fit_param = error_wave[1]
	While (fit_param < lower)
	
	Wavestats/Q/m=0 $y_data
	Variable y_lgth = V_npnts
	
	Variable i,j
	Make/O/N=(outpnts,itermax) mat_spline_str = 0
	Make/O/N=(y_lgth)  y_random, y_random_cs
	
	Wave dummy =$y_data
	Wave dummy2 = $y_data+"_cs"
	
	For(i=1;i<(itermax+1);i+=1)
		y_random = dummy +(y_error*enoise(2))
		splinefit("y_random",x_data,y_error,int_knots,outpnts)
		j = i-1	
		mat_spline_str[][j] = y_random_cs[p]
	Endfor
	
	Duplicate/O dummy2 $y_data+"_splavg",$y_data+"_splplus",$y_data+"_splminus", $y_data+"_splsdev"
	Wave dummy3 = $y_data+"_splavg"
	Wave dummy4 = $y_data+"_splplus"
	Wave dummy5 = $y_data+"_splminus"
	Wave dummy6 = $y_data+"_splsdev"
	
	For(i=0;i<(outpnts+1);i+=1)
		ImageStats/G={i,i,0,(itermax-1)} mat_spline_str	
		dummy3[i] = V_avg
	       dummy6[i] = V_sdev
	Endfor

		dummy4 = dummy3 + dummy6
		dummy5 = dummy3 - dummy6
		
	//Get new red. chi_sq
	Variable loc,splinevalue	
	Wave dummy7 = $x_data
	for (i= 0; i<(y_lgth);i+=1)
		loc = dummy7[i]
		FindValue/T=0.001/V=(loc) $x_data+"_CS"
		splinevalue = dummy2[V_value]
		Make/O/N=(y_lgth) y_diff_sq
		Wave dummy = $y_data
		y_diff_sq[i] = ((dummy[i]-splinevalue)^2)/y_error[i]^2
	endfor
	NVAR degrees
	Variable/G chisq = sum(y_diff_sq)
	Variable/G redchisq  = chisq/degrees
	Variable/G prob =(1-statschicdf(chisq , degrees))
	Wave error_wave 
	error_wave[0] = chisq
	error_wave[1] = redchisq
	error_wave[2] = degrees

	Print "************"
 	printf "End Chi_sq: %g\r",error_wave[0]
 	printf "End Reduced Chi_sq: %g\r",error_wave[1]
 	printf "End Deg. of Freedom: %g\r",error_wave[2]
 	printf "Probability of exceeding chi_sq: %g\r",prob
 	
	Killwaves y_random, y_random_cs,mat_spline_str, y_diff_sq
	KillVariables prob
end