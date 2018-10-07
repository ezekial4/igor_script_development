#pragma rtGlobals=1		// Use modern global access method.
//*********************************************
//Purpose: Takes the average of a given wave.
//
//Couples to UberKontrol Panel
//*********************************************
Function Wave_avg()
	
	NVAR ishot = root:ishot
	Setdatafolder root:
	String setname = "s"+num2istr(ishot)
	Setdatafolder root:$setname
	
	NVAR gRadioVal2 = root:gRadioVal2
	String ext
	If(gRadioVal2 == 1)
		ext="_da"
	elseif(gRadioVal2 == 2)
		ext="_c3"
	Endif
	
	NVAR numpnt=root:numpnt 
	
	//	Truncate fsmid waves to match EFIT times
	String trunc_basewav = "rmidout"
	String dum= "t_"+trunc_basewav
	
	String fsname = "fsmid"
	trunc_n_interp(ishot,$dum,fsname,ext)
		
	Variable j
	String inwav 
	For (j=1;j<9;j+=1)
		
		inwav = "fs"+num2str(j)+"mid"+ext[1,2]
		Wave dummy = $"t_"+inwav
		Wave dummy2 = $"t_"+inwav+"_L"
		
		Wavestats/Q/M=2 dummy2
		Duplicate/O dummy2 $inwav+"_avg",$inwav+"_stdev"
		Variable stoppnt = V_endrow
		
		Wave dummy3 = $inwav+"_avg"
		Wave dummy4 = $inwav+"_stdev"
		
		Variable i
		for (i=0;i<(stoppnt+1);i+=1)
			FindValue/T=2/V=(dummy2[i]) dummy
			Variable startpnt = V_value
			FindValue/T=2/V=(dummy2[i+1]) dummy
			Variable endpnt = V_value
			
			Variable Spnt = startpnt-(numpnt/2)
			Variable Epnt = startpnt+(numpnt/2)
			
			NVAR Time_avg_num = root:Time_avg_num
			Time_avg_num = dummy[Epnt]-dummy[Spnt]
			
			Wavestats/Q/M=2/R=[Spnt,Epnt] $inwav
			
			dummy3[i] = V_avg
			dummy4[i] = V_sdev
			
			dummy2[i]=trunc(dummy2[i])
		endfor
		
		if(j==1)
			print dummy4[129]
		endif
		Duplicate/O dummy2 $"t_"+inwav+"_shrt"
		KillWaves dummy2
	endfor
	
	Setdatafolder root:
End