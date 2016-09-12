#pragma rtGlobals=1		// Use modern global access method.

Function pullout_tstimes(endpnt, killwav)
	Variable endpnt
	Variable Killwav
	
	SetDataFolder root:
	Wave wave1 = root:good_shot_num_7
	NewPath/O/Q NetCDF_location "MainSSD:Users:unterbee:Desktop:tstimedata:"
	
	Make/O/N=1839 root:first_trunc_tst = 0
	Wave wave2 = root:first_trunc_tst
	variable i
	string shotnum, folder, filename
	for(i=0;i<endpnt;i+=1)
		if(wave1[i] > 0)
			SetDataFolder root:
			shotnum = num2istr(wave1[i])
			print i,shotnum
			folder = "s"+shotnum
			
			if(DataFolderExists(folder) ==1)
				SetDataFolder folder
			else
				NewDataFolder/S $folder
			endif
			
			String cmdstr
			cmdstr =  "Load_NetCDF/D/Q/P=NetCDF_location \"tstime_"+shotnum+".nc\""
			Execute cmdstr	

			
			Wave tst_core = nc_time_core
			Wave tst_tan = nc_time_tan
			Concatenate/O/NP {tst_core,tst_tan}, tst_trunc
			Sort tst_trunc,tst_trunc
			
			FindValue/T=3/V=4500 tst_trunc		
			if(V_Value != -1)
					DeletePoints (V_Value), 1e6, tst_trunc
			endif
			FindValue/T=3/V=1450 tst_trunc		
			if(V_Value != -1)
					DeletePoints 0,(V_Value), tst_trunc
			endif
			
			Variable holder = tst_trunc[0]
			wave2[i]=holder
			
			variable j
			if (Killwav == 1)
				KillWaves/Z nc_varnames
				string units
				string longname
				for(j=0;j<3;j+=1)
					units = "nc_var"+num2str(j)+"_units"
					longname = "nc_var"+num2str(j)+"_long_name"
					Killwaves/Z $units
					Killwaves/Z $longname
				endfor
			endif
			
		endif
		
	endfor
	KillPath NETCDF_location
	SetDataFolder root:
End