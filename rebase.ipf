#pragma rtGlobals=1		// Use modern global access method.


Function rebase(baseWAV,Xdatawav, Ydatawav)
	Wave baseWAV
	String Xdatawav
	String Ydatawav
	
	Variable i,loc,value, lgth	
	Wavestats/Q/M=0 baseWAV
	lgth = V_npnts
	
	Wave dum1 = $Xdatawav
	Wave dum2 = $Ydatawav
	Make/O/N=(lgth) $Ydatawav+"_rebase"
	Wave dum3 = $Ydatawav+"_rebase"
	
	for (i= 0; i<(lgth);i+=1)
		loc = baseWAV[i]
		FindValue/T=1.01/V=(loc) dum1
		value = dum2[V_value]
		dum3[i] = value
	endfor
	
End
