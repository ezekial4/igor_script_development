#pragma rtGlobals=1		// Use modern global access method.

Function Build_profiles(Timepnts,zipfit_YN)
	String Timepnts
	Variable zipfit_YN

	Variable i
	Variable j

	String ext
	NVAR gRadioVal2 =root:gRadioVal2
	If(gRadioVal2 == 1)
		ext="_da"
	elseif(gRadioVal2 == 2)
		ext="_c3"
	Endif
	
	NVAR ishot = root:ishot
	
	String setname = "s"+num2istr(ishot)
	SetDataFolder root:$setname
	
	Wave Tmpnt = root:$Timepnts
	
	String hold = "t_fs1mid"+ext[1,2]+"_shrt"
	Wave refwav = $hold
	Build_fsarray(refwav)
	
	Wavestats/Q/Z/M=0 Tmpnt
	
	for (i=0;i<=V_endrow;i+=1)
		Make/N=8/O $"fsmid_"+num2istr(Tmpnt[i])+ext
		Make/N=8/O $"fsmid_"+num2istr(Tmpnt[i])+"_err"+ext
	
	   FindValue/T=13/V=(Tmpnt[i]) refwav
	   Variable tHOLD = V_value
		
		if(zipfit_YN ==1)
			Make/N=8/O $"edens_"+num2istr(Tmpnt[i])
        	Make/N=8/O $"etemp_"+num2istr(Tmpnt[i])
        	Wave edens_plot
        	Wave etemp_plot
        	Wave rho_etemp_plot
        	hold = "fsmid_rho_"+num2istr(Tmpnt[i])
        	Wave clocker = $hold
        	Wave dummy1 = $"edens_"+num2istr(Tmpnt[i])
        	Wave dummy2 = $"etemp_"+num2istr(Tmpnt[i])
        	for(j=0;j<=8;j+=1) 
        		FindValue/T=0.01/V=(clocker[j]) rho_etemp_plot
        		//print tHOLD,clocker[j],V_Value
        		if(V_Value ==-1)
	        		dummy1[j] = dummy1[j-1]
	        		dummy2[j] = dummy2[j-1]
        		else
	        		dummy1[j] = edens_plot[tHOLD][V_value]
	        		dummy2[j] = etemp_plot[tHOLD][V_value]
        		endif
        	endfor
		endif
		
		Wave Dum1 = $"fsmid_"+num2istr(Tmpnt[i])+ext
		Wave Dum2 = fsarray
		
		Wave Dum3 = $"fsmid_"+num2istr(Tmpnt[i])+"_err"+ext
		Wave Dum4 =  fsarray_err
		
		Dum1[] = Dum2[tHOLD][p]
		Dum3[] = Dum4[tHOLD][p]
	endfor
	KillWaves fsarray,fsarray_err
	
	Setdatafolder root:
End