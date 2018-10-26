#pragma rtGlobals=1		// Use modern global access method.

Function GA_load_wav_time_his(ishot,fname,GAdlwav,LocalDLWav)
	Variable ishot 
	String fname
	Variable GAdlwav
	Variable LocalDLWav
	
	String server
	if (GAdlwav == 1)
		getGADAT(ishot,fname,"atlas.gat.com")
	endif
	
	if(LocalDLWav == 1)
		getGADAT(ishot,fname,"localhost")
	endif
	
	Duplicate/O root:$"pyd3dat_"+fname+"_"+num2istr(ishot):sig_Z, root:$"s"+num2istr(ishot):$fname
	Duplicate/O root:$"pyd3dat_"+fname+"_"+num2istr(ishot):sig_X, root:$"s"+num2istr(ishot):$"t_"+fname

//	KillDataFolder $"pyd3dat_"+fname+"_"+num2istr(ishot)
	
	Setdatafolder root:
End