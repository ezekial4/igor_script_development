#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.


Function findELMWI(inwave,t_inwave,tstart,tend,FSCOPEwave,t_FSCOPEwave,level,shot,killem)
	Wave inwave,t_inwave,tstart,tend,FSCOPEwave,t_FSCOPEwave
	Variable level
	Variable shot
	Variable killem
	
	Make/O/N=0 W_FindLevels
	Variable V_LevelsFound
	Findlevels/P/Q/D=W_FindLevels inwave, level
	Redimension/I W_FindLevels
	
	Print "number of events: "+num2str(V_LevelsFound)
	FindDuplicates/RN=W_FindLevels_shrt W_FindLevels
	Duplicate/O W_FindLevels_shrt,hold_x
	Redimension/D hold_x
	hold_x = t_inwave[W_FindLevels_shrt]
	FindDuplicates/RN=hold_x_shrt hold_x
	
	Duplicate/O hold_x_shrt,newOUTx,holdy_end,holdy_start, newOUTy
	Variable i, elmpnt, pnt_start, pnt_end, stopitr
	Make/O/N=0 M_WaveStats
	stopitr = numpnts(hold_x_shrt)
	for (i=0;i<=stopitr-1;i+=1)
		elmpnt = BinarySearch(tstart, hold_x_shrt[i])
		pnt_start = BinarySearch(t_FSCOPEwave, tstart[elmpnt]-0.25)
		pnt_end = BinarySearch(t_FSCOPEwave, tend[elmpnt])
		newOUTx[i] = t_FSCOPEwave[pnt_start] + (t_FSCOPEwave[pnt_end] - t_FSCOPEwave[pnt_start])/2
		WaveStats/Q/W/R=[pnt_start,pnt_end] FSCOPEwave
		//newOUTy[i] = M_WaveStats[12]              // element 12 is max value
		newOUTy[i] = M_WaveStats[5]               // element 5 is rms value
		//newOUTy[i] = mean(FSCOPEwave,pnt_start,pnt_end)
	endfor
	
	
	Duplicate/O newOUTy $"FSCOPE_WI_ELM_"+num2istr(shot)
	Duplicate/O newOUTx $"t_FSCOPE_WI_ELM_"+num2istr(shot)
	if (killem==1)
		KillWaves W_FindLevels,W_FindLevels_shrt,hold_x,hold_x_shrt,holdy_start,holdy_end
		KillWaves newOUTy,newOUTx, M_WaveStats
	endif
End