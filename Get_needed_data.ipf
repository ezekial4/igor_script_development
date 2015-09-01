#pragma rtGlobals=1		// Use modern global access method.

// This macro looks for time history data from 2 places. Eother via FTP and the GA server 
//or my local HD.

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
	
	String fnamelong = fname+"_"+num2istr(ishot)+".ibw"
	String fname_t_long = "t_"+fname+"_"+num2istr(ishot)+".ibw"
	
	if (GAdlwav ==1)
		GA_Download(fnamelong)
		GA_Download(fname_t_long)
	endif
	
	if(LocalDLWav ==1)
		String Unt_path = "unterbee_hd:Users:unterbee:Desktop:GA_igor_downloads:"
		LoadWave /H/O/Q Unt_path+fnamelong
		LoadWave /H/O/Q unt_path+fname_t_long
	endif
	
	Setdatafolder root:
End