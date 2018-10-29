#pragma rtGlobals=1		// Use modern global access method.

Macro Pre_process_FS_mid(ishot,GA,Local)
	Variable ishot
	Variable  GA
	Variable Local
	
	PauseUpdate; Silent 1
	
	Silent,1
	String fsname = "fs"
	String dum
	
//Set if we are doing the d_alpha or c3 filtescopes
	String ext
	If(gRadioVal2 == 1)
		ext="midda"
	else(gRadioVal2 == 2)
		ext="midc3"
	Endif
	
	String setname = "s"+num2istr(ishot)
	If(DataFolderExists(setname))
		Setdatafolder root:$setname
	else
		NewDataFolder/S $setname
	endif
	
	Variable i=1
	Setdatafolder root:
	do
		dum = fsname+num2str(i)+ext
		GA_load_wav_time_his(ishot,dum,GA,Local)
		dum = fsname
		i +=1
	while(i<9)
	
	Setdatafolder root:$setname
	If(DataFolderExists("Raw_data"))
		Setdatafolder "Raw_data"
	else
		NewDataFolder/S Raw_data
	endif

//Make a noise wav to store error from digitizer noise 
	Make/O/N=8 fsnoise_err
	Variable ierr = 400    //This is the stopping point of the offset analysis 
	Variable stopper
//	Move raw waves out of the working directory and correct for offsets
	i=1
	do
		dum =  fsname+num2str(i)+ext
		print dum
		Wavestats/Q ::$dum
		stopper = V_endRow - ierr
		Wavestats/Q/R=[stopper,V_endRow] ::$dum
		fsnoise_err[i-1]=V_sdev
		Duplicate/O ::$"t_"+dum $"t_"+fsname+num2str(i)+ext+"_raw"
		Duplicate/O ::$dum $fsname+num2str(i)+ext+"_raw"
		::$fsname+num2str(i)+ext -=V_avg
		i+=1
	while(i<9)

//Load in other needed waves
	Setdatafolder root:$setname
	getOtherData(setname, ishot, GA, Local)
//---end---

	Setdatafolder root:
	print "Completed loading and pre-processing"
End
