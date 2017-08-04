#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function start(inwave,t_inwave,outwave,t_outwave,level,killem)
	Wave inwave,t_inwave,outwave,t_outwave
	Variable level
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
	Duplicate/O hold_x_shrt,newOUTx,newOUTy
	Variable i, pnt, stopitr
	stopitr = numpnts(hold_x_shrt)
	for (i=0;i<=stopitr;i+=1)
		pnt = BinarySearch(t_outwave, hold_x_shrt[i])
		newOUTx[i] = t_outwave[pnt]
		newOUTy[i] = outwave[pnt]
	endfor
	if (killem==1)
		KillWaves W_FindLevels,W_FindLevels_shrt,hold_x, hold_x_shrt
	endif
End

Function makeDELW(inwave,t_inwave,tstart,tend,WMHDwave,t_WMHDwave,level,shot,killem)
	Wave inwave,t_inwave,tstart,tend,WMHDwave,t_WMHDwave
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
	
	Duplicate/O hold_x_shrt,newOUTx,holdy_end,holdy_start
	Variable i, elmpnt, pnt_start, pnt_end, stopitr
	stopitr = numpnts(hold_x_shrt)
	for (i=0;i<=stopitr-1;i+=1)
		elmpnt = BinarySearch(tstart, hold_x_shrt[i])
		pnt_start = BinarySearch(t_WMHDwave, tstart[elmpnt])
		pnt_end = BinarySearch(t_WMHDwave, tend[elmpnt])
		newOUTx[i] = t_WMHDwave[pnt_start]
		holdy_start[i] = WMHDwave[pnt_start]
		holdy_end[i] = WMHDwave[pnt_end]
	endfor
	Duplicate/O holdy_start, newOUTy
	newOUTy = holdy_start - holdy_end
	
	Duplicate/O newOUTy $"dWmhd_neu_"+num2istr(shot)
	Duplicate/O newOUTx $"t_dWmhd_neu_"+num2istr(shot)
	Duplicate/O holdy_start $"Wmhd_neu_"+num2istr(shot)
	if (killem==1)
		KillWaves W_FindLevels,W_FindLevels_shrt,hold_x,hold_x_shrt,holdy_start,holdy_end
		KillWaves newOUTy,newOUTx
	endif
End