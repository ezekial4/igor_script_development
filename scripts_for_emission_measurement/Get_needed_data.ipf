#pragma rtGlobals=1		// Use modern global access method.

Function GA_load_wav_time_his(ishot,fname,GAdlwav,LocalDLWav)
	Variable ishot 
	String fname
	Variable GAdlwav
	Variable LocalDLWav
	
	String setname = "s"+num2istr(ishot)
	If(DataFolderExists(setname))
		Setdatafolder root:$setname
	else
		NewDataFolder/S $setname
	endif
	
	String server
	if (GAdlwav == 1)
		server="atlas.gat.com"
		getGADAT(ishot,fname,server)
	endif
	
	if(LocalDLWav == 1)
		server="localhost"
		getGADAT(ishot,fname,server)
	endif
	
	MoveWave root:$"s"+num2istr(ishot):$"pyd3dat_"+fname+"_"+num2istr(ishot):sig_Z, root:$"s"+num2istr(ishot):$fname
	MoveWave root:$"s"+num2istr(ishot):$"pyd3dat_"+fname+"_"+num2istr(ishot):sig_X, root:$"s"+num2istr(ishot):$"t_"+fname

	KillDataFolder $"pyd3dat_"+fname+"_"+num2istr(ishot)
	
	Setdatafolder root:
End