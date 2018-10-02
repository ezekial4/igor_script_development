#pragma rtGlobals=1		// Use modern global access method.

Function get_zipfit(ishot,fname_dens,fname_temp,GA_DL,LocalDL)
	Variable ishot
	String fname_dens
	String fname_temp
	Variable GA_DL
	Variable LocalDL
		
	SetDataFolder root:
	String setname = "s"+num2istr(ishot)
	
	String fnamelong = fname_temp+"_"+num2istr(ishot)+".ibw"
	String fnamelong2 = fname_dens+"_"+num2istr(ishot)+".ibw"
	
	String fnamelong3 = "rho_"+fname_temp+"_"+num2istr(ishot)+".ibw"
	String fnamelong4 = "rho_"+fname_dens+"_"+num2istr(ishot)+".ibw"
	
	String fnamelong5 = "time_"+fname_temp+"_"+num2istr(ishot)+".ibw"
	String fnamelong6 = "time_"+fname_dens+"_"+num2istr(ishot)+".ibw"

	if (GA_DL==1)
		NVAR local=root:local
		NVAR ga=root:ga
		if(local==1)
			getGADAT(ishot,fname_dens+"fit","localhost")
			getGADAT(ishot,fname_temp+"fit","localhost")
		elseif (ga == 1)
			getGADAT(ishot,fname_dens+"fit","atlas.gat.com")
			getGADAT(ishot,fname_temp+"fit","atlas.gat.com")
		endif

		MoveWave root:$"pyd3dat_"+fname_dens+"fit_"+num2istr(ishot):sig_Z, root:$"s"+num2istr(ishot):$fname_dens+"_"+num2istr(ishot)
		MoveWave root:$"pyd3dat_"+fname_dens+"fit_"+num2istr(ishot):sig_X, root:$"s"+num2istr(ishot):$"rho_"+fname_dens+"_"+num2istr(ishot)
		MoveWave root:$"pyd3dat_"+fname_dens+"fit_"+num2istr(ishot):sig_Y, root:$"s"+num2istr(ishot):$"time_"+fname_dens+"_"+num2istr(ishot)
	
		MoveWave root:$"pyd3dat_"+fname_temp+"fit_"+num2istr(ishot):sig_Z, root:$"s"+num2istr(ishot):$fname_temp+"_"+num2istr(ishot)
		MoveWave root:$"pyd3dat_"+fname_temp+"fit_"+num2istr(ishot):sig_X, root:$"s"+num2istr(ishot):$"rho_"+fname_temp+"_"+num2istr(ishot)
		MoveWave root:$"pyd3dat_"+fname_temp+"fit_"+num2istr(ishot):sig_Y, root:$"s"+num2istr(ishot):$"time_"+fname_temp+"_"+num2istr(ishot)

		KillDataFolder root:$"pyd3dat_"+fname_dens+"fit_"+num2istr(ishot)
		KillDataFolder root:$"pyd3dat_"+fname_temp+"fit_"+num2istr(ishot)
	endif
	
	if(LocalDL==1)
		PathInfo Unt_path
		If (V_flag == 0)
			NewPath/C/O/M="Find Ye Path to the Data" Unt_path
		Endif
		LoadWave /H/O/Q/P=Unt_path fnamelong
		LoadWave /H/O/Q/P=Unt_path fnamelong2
		LoadWave /H/O/Q/P=Unt_path fnamelong3
		LoadWave /H/O/Q/P=Unt_path fnamelong4
		LoadWave /H/O/Q/P=Unt_path fnamelong5
		LoadWave /H/O/Q/P=Unt_path fnamelong6
	endif
	
	if(DataFolderExists(setname) ==1)
		Setdatafolder root:$setname
	else
		NewDataFolder/S $setname
	endif
	//transpose density and temp. waves to make pretty graphs
	String saveloca="root:"+setname+":Raw_FS_data"
		
	String fnamelong_pl=fnamelong[0,4] 
	Duplicate/O $fnamelong_pl+"_"+num2istr(ishot) $fnamelong_pl+"_plot"
	string save1=saveloca+":"+fnamelong_pl+"_raw"
	Duplicate/O $fnamelong_pl+"_"+num2istr(ishot) $save1
	
	String fnamelong2_pl=fnamelong2[0,4]
	Duplicate/O $fnamelong2_pl+"_"+num2istr(ishot) $fnamelong2_pl+"_plot"
	string save2=saveloca+":"+fnamelong2_pl+"_raw"
	Duplicate/O $fnamelong2_pl+"_"+num2istr(ishot) $save2
	matrixtranspose $fnamelong_pl+"_plot"
	matrixtranspose $fnamelong2_pl+"_plot"
	KillWaves $fnamelong_pl+"_"+num2istr(ishot),$fnamelong2_pl+"_"+num2istr(ishot)
	
	//Now need to make plot-able time and rho waves
	String fnamelong3_pl = fnamelong3[0,8]
	Duplicate/O $ fnamelong3_pl+"_"+num2istr(ishot) $ fnamelong3_pl+"_plot"
	string save3=saveloca+":"+fnamelong3_pl+"_raw"
	Duplicate/O $fnamelong3_pl+"_"+num2istr(ishot) $save3
	KillWaves $fnamelong3_pl+"_"+num2istr(ishot)

	String fnamelong4_pl = fnamelong4[0,8]
	Duplicate/O $ fnamelong4_pl+"_"+num2istr(ishot) $ fnamelong4_pl+"_plot"
	string save4=saveloca+":"+fnamelong4_pl+"_raw"
	Duplicate/O $fnamelong4_pl+"_"+num2istr(ishot) $save4
	KillWaves $fnamelong4_pl+"_"+num2istr(ishot)

	String fnamelong5_pl = fnamelong5[0,9]
	Duplicate/O $ fnamelong5_pl+"_"+num2istr(ishot) $ fnamelong5_pl+"_plot"
	string save5=saveloca+":"+fnamelong5_pl+"_raw"
	Duplicate/O $fnamelong5_pl+"_"+num2istr(ishot) $save5
	KillWaves $fnamelong5_pl+"_"+num2istr(ishot)

	String fnamelong6_pl = fnamelong6[0,9]
	Duplicate/O $ fnamelong6_pl+"_"+num2istr(ishot) $ fnamelong6_pl+"_plot"
	string save6=saveloca+":"+fnamelong6_pl+"_raw"
	Duplicate/O $fnamelong6_pl+"_"+num2istr(ishot) $save6
	KillWaves $fnamelong6_pl+"_"+num2istr(ishot)

	Wavestats/Q/M=1  $fnamelong3_pl+"_plot"
	InsertPoints V_endrow+1,1, $fnamelong3_pl+"_plot"
	Wave dum1 =$fnamelong3_pl+"_plot"
	dum1[V_endrow+1]=dum1[V_endrow]+1
	InsertPoints V_endrow+1,1, $fnamelong4_pl+"_plot"
	Wave dum2=$fnamelong4_pl+"_plot"
	dum2[V_endrow+1] =dum2[V_endrow]+1
	
	Wavestats/Q/M=1  $fnamelong5_pl+"_plot"
	wave dum3=$fnamelong5_pl+"_plot"
	InsertPoints V_endrow+1,1, $fnamelong5_pl+"_plot"
	dum3[V_endrow+1]=dum3[V_endrow]+1
	InsertPoints V_endrow+1,1,$fnamelong6_pl+"_plot"
	wave dum4=$fnamelong6_pl+"_plot"
	dum4[V_endrow+1]=dum4[V_endrow]+1
	
//	Variable drho =1.21
	
	Setdatafolder root:
	print "done getting zipfit profiles"
End
