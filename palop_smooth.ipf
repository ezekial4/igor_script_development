#pragma rtGlobals=1		// Use modern global access method.

function Palop_smooth(wavein, sampwid,stdev)
	String wavein
	Variable stdev
	Variable sampwid
	
	make/O/n=(sampwid+1) xs,g_1, g_2,g_3, g_4,g_tot, term1
	xs=p-(sampwid/2)
	
// 	   Make/O/N=2001 xs, f_x, f_x_err, f_x_sm
//	   xs=-10+0.01*p
//	
//      f_x=0.5*tanh(xs)+0.5
//      
//      SetRandomSeed .5
//      f_x_err=f_x+enoise(.1)
      
      variable alph = 1/(sqrt(2)*stdev)

	term1 = exp(-alph^2*xs^2)
	
	Variable const = alph/sqrt(pi)
	g_1=4*term1
	
	g_2=(6/sqrt(2))*term1^(1/2)
	
	g_3=(4/sqrt(3))*term1^(1/3)
	
	g_4=(1/2)*term1^(1/4)

	g_tot = const*(g_1-g_2+g_3-g_4)
	
	Wavestats/Q/M=1 $wavein
	Variable endrow =V_npnts
		
	Wave smoother = $wavein
	make/o/n=1 $wavein+"_paloped" 
	make/o/n=(sampwid) holder
	
	Variable i
	for (i=0;i<(endrow);i+=sampwid)
		holder = smoother[p+i]
		Convolve/A g_tot, holder
		Concatenate {holder}, $wavein+"_paloped" 
	endfor
	
	Wavestats/Q/M=1 $wavein+"_paloped" 
	
	If (V_endrow> endrow)
		 DeletePoints (endrow), inf, $wavein+"_paloped" 
	endif
end
	