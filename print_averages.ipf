#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.


Function PNTNAM_wavestat(PNTname, shot, tstart, tend)
	String PNTname
	Variable tstart
	Variable tend
	Variable shot
	
	Wave w1 = $"root:paramDB_"+num2istr(shot)+":"+PNTname
	
	if (cmpstr(PNTname,"NU_E_STAR") == 0)
		Wave tbase = $"root:paramDB_"+num2istr(shot)+":t_NEPED"	
	else
		Wave tbase = $"root:paramDB_"+num2istr(shot)+":t_"+PNTname
	endif
	
	FindValue/T=5/V=(tstart) tbase
	Variable strtIND=V_value
	FindValue/T=5/V=(tend) tbase
	Variable endIND=V_value
	WaveStats/Q/M=2/R=[strtIND,endIND] w1
	
	Print "AVG: "+num2str(V_avg) 
	Print "DEV: "+num2str(V_adev) 
End	
	