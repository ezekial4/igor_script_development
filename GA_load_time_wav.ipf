#pragma rtGlobals=1		// Use modern global access method.

Macro Load_time_Wave(wavname,ishot)
	String wavname = "time_ne"
	Variable ishot = 122000
	
	
	PathInfo Get_data
	
	If (v_flag == 0)
		NewPath Get_data "unterbee_hd:Users:unterbee:Desktop:GA_igor_downloads:"
	Endif
	
	String loadwav = wavname+"_"+num2istr(ishot)+".ibw"
	String loadtwav ="t_"+wavname+"_"+num2istr(ishot)+".ibw"
	
	GA_Download(loadwav)
	GA_Download(loadtwav)

EndMacro