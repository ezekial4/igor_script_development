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
	
	Wavestats/Q/M=0 $Timepnts
	For	(i =0;i < (V_endrow+1);i +=1)
		print Tmpnt[i]
		Make/N=8/O $"fsmid_"+num2istr(Tmpnt[i])+ext
		Make/N=8/O $"fsmid_"+num2istr(Tmpnt[i])+"_err"+ext
//		Make/N=8/O $"radi_fsmid_"+num2istr(Tmpnt[i])
	
		if(zipfit_YN ==1)
			Make/N=8/O $"edens_"+num2istr(Tmpnt[i])
        	Make/N=8/O $"etemp_"+num2istr(Tmpnt[i])
		endif
		
	   FindValue/T=13/V=(Tmpnt[i]) refwav
		Wave Dum1 = $"fsmid_"+num2istr(Tmpnt[i])+ext
		Wave Dum2 = fsarray
		
		Wave Dum3 = $"fsmid_"+num2istr(Tmpnt[i])+"_err"+ext
		Wave Dum4 =  fsarray_err
		
		Dum1[] = Dum2[V_value][p]
		Dum3[] = Dum4[V_value][p]
		
		FindValue/T=2/V=(Tmpnt[i]) $"t_rmidout"
	       
//		For(j=0;j<8;j+=1)
//		 	Wave dummy1 = root:$"s"+num2istr(ishot):$"radi_fsmid"+num2istr(j+1)			 	 
//		 	 Wave dummy3 =  $"radi_fsmid_"+num2istr(Tmpnt[i])
//		 	  dummy3[j]=  dummy1[V_value]*100	
//		Endfor
	Endfor
	KillWaves fsarray,fsarray_err
	
	Setdatafolder root:
End