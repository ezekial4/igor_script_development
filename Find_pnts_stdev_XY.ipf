#pragma rtGlobals=1		// Use modern global access method.

Function Find_pnts_stdev_XY(timewav,datawav,errcalc,ishot)
	Wave timewav
	String datawav
	Variable errcalc
	Variable ishot
	
	Variable i,loc,value, lgth	
	Wavestats/Q/M=0 timewav
	lgth = V_npnts
	
	Wave dum1 = $"t_"+datawav+"_"+num2istr(ishot)
	Wave dum2 = $datawav+"_"+num2istr(ishot)+"_sm"
	Make/O/N=(lgth) $datawav+"_valu"
	Wave dum3 = $datawav+"_valu"
	
	if(errcalc ==1)
		Make/O/N=(lgth) $datawav+"_std_valu"
		Wave dum4 = $datawav+"_"+num2istr(ishot)+"_sdev"
		Wave dum5 = $datawav+"_std_valu"
	endif
	
	for (i= 0; i<(lgth);i+=1)
		loc = timewav[i]
		FindValue/T=1.1/V=(loc) dum1
		value = dum2[V_value]
		Make/O/N=(lgth) $datawav+"_valu"
		Wave dum3 = $datawav+"_valu"
		dum3[i] = value
		
		if (errcalc ==1)
			value = dum4[V_value]
			dum5[i] = value
		endif
	endfor
	
End