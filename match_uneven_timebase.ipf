#pragma rtGlobals=1		// Use modern global access method.


Function match_uneven_timebase(timewav,datawav)
	Wave timewav
	String datawav
	
	Variable i,loc,value, lgth	
	Wavestats/Q/M=0 timewav
	lgth = V_npnts
	
	Wave dum1 = $"t_"+datawav
	Wave dum2 = $datawav
	Make/O/N=(lgth) $datawav+"_valu"
	Wave dum3 = $datawav+"_valu"
	
	for (i= 0; i<(lgth);i+=1)
		loc = timewav[i]
		FindValue/T=0.01/V=(loc) dum1
		value = dum2[V_value]
		Make/O/N=(lgth) $datawav+"_valu"
		Wave dum3 = $datawav+"_valu"
		dum3[i] = value
	endfor
	
End
