#pragma rtGlobals=1		// Use modern global access method.

Macro Pre_process_FS_mid(ishot,GA,Local)
	Variable ishot = 110000
	Variable  GA =0
	Variable Local =1
	
	Silent,1
	String fsname = "fsmid"
	String dum
	
	Variable i=1
	do
		Setdatafolder root:
		dum = fsname+num2str(i)
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

//	Move raw waves out of the working directory	
	i=1
	do
		dum =  fsname+num2str(i)+"_"+num2istr(ishot)
		Duplicate/O ::$dum ::$fsname+num2str(i)
		Duplicate/O ::$dum $fsname+num2str(i)+"_raw"
		Killwaves ::$dum

		Duplicate/O ::$"t_"+dum ::$"t_"+fsname+num2str(i)
		Duplicate/O ::$"t_"+dum $"t_"+fsname+num2str(i)+"_raw"
		Killwaves ::$"t_"+dum
		
		dum = fsname
		i+=1
	while(i<9)
	
	Setdatafolder root:$setname	
	
//	Truncate fsmid waves to match EFIT times
	String trunc_basewav = "rmidout"
	dum= "t_"+trunc_basewav+"_"+num2istr(ishot)
	print 
	Variable/G sm_pnt
	trunc_n_interp(ishot,$dum,fsname)
	
	// now need to make the approximate seperatrix location wav
	Make/O/N=234 rout_fsmid 
	Interpolate2/T=1/N=234/I=3/Y=fs_z_diff_L/X=t_fs_z_diff_L root:t_fs_z_diff, root:fs_z_diff
	rout_fsmid = trunc_basewav+"_"+num2istr(ishot) - fs_z_diff_L
	Setdatafolder ::
End
