#pragma rtGlobals=1		// Use modern global access method.

Macro Pre_process_FS_mid(ishot,GA,Local)
	Variable ishot = 110000
	Variable  GA = 0
	Variable Local = 1
	
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

	Variable i=1
	do
		Setdatafolder root:
		dum = fsname+num2str(i)+ext
		GA_load_wav_time_his(ishot,dum,GA,Local)
		dum = fsname
		i +=1
	while(i<9)

	String setname = "s"+num2istr(ishot)
	Setdatafolder root:$setname
	If(DataFolderExists("Raw_FS_data"))
		Setdatafolder "Raw_FS_data"
	else
		NewDataFolder/S Raw_FS_data
	endif

//Make a noise wav to store error from digitizer noise 
	Make/O/N=8 fsnoise_err
	Variable ierr = 40    //This is the stopping point of the offset analysis 
	
//	Move raw waves out of the working directory and correct for offsets
	i=1
	do
		dum =  fsname+num2str(i)+ext+"_"+num2istr(ishot)
		
		Wavestats/Q/R=[0,ierr] ::$dum
		fsnoise_err[i-1]=V_sdev
		Duplicate/O ::$dum ::$fsname+num2str(i)+ext
		
		::$fsname+num2str(i)+ext -=V_avg
		
		Duplicate/O ::$dum $fsname+num2str(i)+ext+"_raw"
		Killwaves ::$dum

		Duplicate/O ::$"t_"+dum ::$"t_"+fsname+num2str(i)+ext
		Duplicate/O ::$"t_"+dum $"t_"+fsname+num2str(i)+ext+"_raw"
		Killwaves ::$"t_"+dum
		
		dum = fsname
		i+=1
	while(i<9)

//Load in other needed waves
	If (local == 1)
		PathInfo Unt_path
		If (V_flag == 0)
			NewPath/C/O/M="Find Ye Path to the Data" Unt_path
		Endif
		
		Make/T/O/N=3 fname
		fname[0]="rmidout"
		fname[1]="fsmid_psi"
		fname[2]="fsmid_rho"
		
		String fnamelong, fname_t_long
		
		i=0
		do
			fnamelong = fname[i]+"_"+num2istr(ishot)+".ibw"
			fname_t_long = "t_"+fname[i]+"_"+num2istr(ishot)+".ibw"
			LoadWave /H/O/Q/P=Unt_path fnamelong
			LoadWave /H/O/Q/P= unt_path fname_t_long
			
			dum = fname[i]+"_"+num2istr(ishot)
	
			Duplicate/O $dum ::$fname[i]
		
			Duplicate/O $dum $fname[i]+"_raw"
			KillWaves $dum
			Duplicate/O $"t_"+dum ::$"t_"+fname[i]
			Duplicate/O $"t_"+dum $"t_"+fname[i]+"_raw"
			Killwaves $"t_"+dum
		i+=1	
		while(i <=0)
	endif
//---end---

	KillWaves/Z fname
//	Setdatafolder root:$setname	

//---load all the space waves ---	
	Variable j=0
	String fnamerho, fnamepsi,fnamermaj
	String timewav="timepoints"
	Wavestats/Q/M=1 ::$timewav
	do
			fnamerho="fsmid_rho_"+num2istr(ishot)+"_"+num2istr(::timepoints[j])+".ibw"
			LoadWave /H/O/Q/P=Unt_path fnamerho
			dum = "fsmid_rho_"+num2istr(ishot)+"_"+num2istr(::timepoints[j])
			Duplicate/O $dum $"fsmid_rho_"+num2istr(::timepoints[j])+"_raw"
			Duplicate/O $dum ::$"fsmid_rho_"+num2istr(::timepoints[j])
			Killwaves $dum 
			
			fnamepsi="fsmid_psi_"+num2istr(ishot)+"_"+num2istr(::timepoints[j])+".ibw"
			LoadWave /H/O/Q/P=Unt_path fnamepsi
			dum = "fsmid_psi_"+num2istr(ishot)+"_"+num2istr(::timepoints[j])
			Duplicate/O $dum $"fsmid_psi_"+num2istr(::timepoints[j])+"_raw"
			Duplicate/O $dum ::$"fsmid_psi_"+num2istr(::timepoints[j])
			Killwaves $dum 
	j+=1
	while(j<(V_npnts))
	
	fnamermaj="fsmid_rmaj_"+num2istr(ishot)+".ibw"
	LoadWave /H/O/Q/P=Unt_path fnamermaj
	dum="fsmid_rmaj_"+num2istr(ishot)
	Duplicate/O $dum fsmid_rmaj_raw
	Duplicate/O $dum ::fsmid_rmaj
	Killwaves $dum	
//---end---	

	Setdatafolder root:
	print "Completed loading and pre-procesing"
End
