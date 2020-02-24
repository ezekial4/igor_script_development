#pragma rtGlobals=1		// Use modern global access method.

Function pfc_pnts_stdev_XY(shotNUM, pfc, line, tstart, tend, errcalc)
	Variable shotNUM
   String pfc
   String line
   Variable tstart
   Variable tend
   Variable errcalc
   
	String pfc_lineSTR = ":'_"+pfc+"_':'_calib_':data_0:'_"+line+"_':data_0:"
	String datFOLDER = "root:dat_"+num2istr(shotNUM)+pfc_lineSTR+"'_dat_':"
	String fldrSav0= GetDataFolder(1)
	SetDataFolder datFOLDER
	
	wave tWAV = $"::::::"+pfc_lineSTR+"'_t_':data_0"
	wave datWAV = $datFOLDER+"data_0"
	wave errWAV = $"root:dat_"+num2istr(shotNUM)+pfc_lineSTR+"'_err_':data_0"
	wave rWAV = $"root:dat_"+num2istr(shotNUM)+pfc_lineSTR+"'_R_':data_0"
	
	Wave/T units = $"root:dat_"+num2istr(shotNUM)+":'_"+pfc+"_':'_calib_':data_0:'_unit_':data_0"
	
	FindValue/T=0.001/V=(tstart) tWAV
	Variable pstart = V_value
	FindValue/T=0.001/V=(tend) tWAV
	Variable pend = V_value
	
	duplicate/O tWAV hold
	duplicate/O rWAV specProf, specPROF_err
	
	wavestats/Q/M=1 rWAV
	Variable i,lgth
	lgth=V_npnts
	for(i=0; i<(lgth);i+=1)
		hold = datWAV[p][i]
		specProf[i] = mean(hold,pstart,pend)
		if(errcalc==1)
			hold = errWAV[p][i]
			Wavestats/Q/R=[pstart,pend] hold
			specProf_err[i] = V_rms
		endif
	endfor
	
	Display specProf vs rWAV
	ErrorBars/T=0/Y=1/L=2 specProf Y,wave=(specPROF_err,specPROF_err)
	ModifyGraph marker=8,rgb=(65535,0,0),mode=4,opaque=1,mrkThick=1,mrkThick=2,lsize=2,msize=3
	ModifyGraph margin(left)=40,margin(bottom)=40,margin(right)=15,margin(top)=10
	ModifyGraph tick=2,mirror=1,fSize=14,axisOnTop=1,standoff=0,font="Helvetica Neue Condensed Bold"
	
	SetAxis left 0,*
	String graphTITLE="Shot:"+num2istr(shotNUM)+"; PFC:"+pfc+"; Line:"+line
	TextBox/C/N=text0/X=0.00/Y=45.00/F=0/A=MC "\\F'Helvetica Neue Condensed Bold'"+graphTITLE
	Label bottom "R [m]"
	Label left 	"["+units[0]+"]"
	ModifyGraph fStyle(bottom)=1
	
	SetDataFolder fldrSav0
End