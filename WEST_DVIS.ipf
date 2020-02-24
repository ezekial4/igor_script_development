#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.


Function pfc_V_time(shotNUM, pfc, line) : Graph
   Variable shotNUM
   String pfc
   String line
	PauseUpdate; Silent 1		// `building window...
	
	String pfc_lineSTR = ":'_"+pfc+"_':'_calib_':data_0:'_"+line+"_':data_0:"
	String datFOLDER = "root:dat_"+num2istr(shotNUM)+pfc_lineSTR+"'_dat_':"
	String fldrSav0= GetDataFolder(1)
	SetDataFolder datFOLDER
	
	variable i=0
	string wavNAM
	
	wave tWAV = $"::::::"+pfc_lineSTR+"'_t_':data_0"
	wave datWAV = $datFOLDER+"data_0"
	wave errWAV = $"root:dat_"+num2istr(shotNUM)+pfc_lineSTR+"'_err_':data_0"
	wave rWAV = $"root:dat_"+num2istr(shotNUM)+pfc_lineSTR+"'_R_':data_0"
	
	wavestats/Q/M=1 rWAV
	
	Make/FREE/N=(16,3) colors = {{39321,1,15729}, {39321,1,31457}, {19729,1,39321}, {1,3,39321}, {1,9611,39321}, {1,26221,39321}, {1,39321,39321}, {1,39321,19939}, {1,65535,33232}, {19675,39321,1}, {39321,39319,1}, {39321,26208,1}, {39321,13101,1}, {0,0,0}, {43690,43690,43690}, {65535,0,0}}
	
	sprintf wavNAM, "R=%.3f", rWAV[0]
	Display /W=(731,22,1594,640) datWAV[*][0]/TN=$wavNam vs tWAV
	ErrorBars $wavNam SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(errWAV[*][0],errWAV[*][0])
	ModifyGraph tick=2,mirror=1,standoff=0,axisOnTop=1,fSize=14,font="Helvetica Neue Condensed Bold"
	ModifyGraph margin(left)=40,margin(bottom)=40,margin(right)=10,margin(top)=10
	ModifyGraph manTick(bottom)={0,2,0,0},manMinor(bottom)={3,2}

	for(i=0; i<(V_npnts-1);i+=1)
		sprintf wavNAM, "R=%.3f", rWAV[i+1]
		AppendtoGraph datWAV[*][i+1]/TN=$wavNAM  vs tWAV
		ModifyGraph rgb($wavNAM)=(colors[0][i],colors[1][i],colors[2][i])
		ErrorBars $wavNAM SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(errWAV[*][i+1],errWAV[*][i+1])
	endfor
	SetAxis left -1e+14,*
	ModifyGraph lsize=2
	String graphTITLE="Shot:"+num2istr(shotNUM)+"; PFC:"+pfc+"; Line:"+line
	TextBox/C/N=text0/X=0.00/Y=45.00/F=0/A=MC "\\F'Helvetica Neue Condensed Bold'"+graphTITLE
	Label bottom "time [sec]"
	Legend/C/N=text1/F=0/A=MC/X=-35.00/Y=15.00

	SetDataFolder fldrSav0
End