#pragma rtGlobals=1		// Use modern global access method.
Window GetProfDB_Panel() : Panel
	PauseUpdate; Silent 1		// building window...
	//Prep Work
	FindHome()
	Homepath +=":"
	if(Exists("shot")!=2)
		Variable/G shot = 149712
	endif
	if(Exists("Neupath")!=2)
		String/G Neupath = "Users:"
	endif
	NewPanel /W=(567,76,1027,448)
	ModifyPanel cbRGB=(48059,48059,48059)
	SetDrawLayer UserBack
	SetDrawEnv linethick= 2
	DrawRRect 122,7,330,40
	SetDrawEnv fname= "Arial Narrow Bold",fsize= 24
	DrawText 128,37,"DIII-D ProfDB Loader"
	SetDrawEnv linefgc= (61166,61166,61166)
	DrawLine 4,57,186,57
	SetDrawEnv linefgc= (61166,61166,61166)
	DrawLine 248,58,452,58
	SetDrawEnv fsize= 18,textrgb= (61166,61166,61166)
	DrawText 197,66,"Setup"
	SetDrawEnv linefgc= (61166,61166,61166)
	DrawLine 6,144,180,144
	SetDrawEnv fsize= 18,textrgb= (61166,61166,61166)
	DrawText 187,153,"Get Data"
	SetDrawEnv linefgc= (61166,61166,61166)
	DrawLine 257,145,454,145
	SetDrawEnv linefgc= (61166,61166,61166)
	DrawLine 8,243,182,243
	SetDrawEnv fsize= 18,textrgb= (61166,61166,61166)
	DrawText 185,252,"Make Plots"
	SetDrawEnv linefgc= (61166,61166,61166)
	DrawLine 272,244,456,244
	SetVariable ShotNum,pos={28,159},size={110,26},title="Shot:"
	SetVariable ShotNum,font="Arial Narrow Bold",fSize=20
	SetVariable ShotNum,valueBackColor=(65535,65535,65535)
	SetVariable ShotNum,limits={100000,999999,0},value= shot
	SetVariable pathDSPL,pos={21,68},size={200,24},title="Save Path?"
	SetVariable pathDSPL,font="Arial Narrow Bold",fSize=18,frame=0
	SetVariable pathDSPL,limits={-inf,inf,0},value= Homepath,noedit= 1
	SetVariable pathDSPL1,pos={192,69},size={200,24},title=" "
	SetVariable pathDSPL1,font="Arial Narrow Bold",fSize=18
	SetVariable pathDSPL1,limits={-inf,inf,0},value= Neupath
	SetVariable Def_timeid,pos={150,159},size={105,24},title="Time ID:"
	SetVariable Def_timeid,font="Arial Narrow Bold",fSize=18
	SetVariable Def_timeid,limits={0,10000,0},value= timeid
	SetVariable Def_runid,pos={275,159},size={115,24},title="Run ID:"
	SetVariable Def_runid,font="Arial Narrow Bold",fSize=18
	SetVariable Def_runid,limits={0,10000,0},value= runid
	Button GetDATA,pos={172,189},size={105,30},proc=ButtonProc,title="GetPROFdat"
	Button GetDATA,font="Arial Narrow Bold",fSize=20,fStyle=0,fColor=(0,13107,0)
	Button GetDATA1,pos={329,308},size={75,30},proc=ButtonProc_1,title="Plot?"
	Button GetDATA1,font="Arial Narrow Bold",fSize=20,fStyle=0,fColor=(0,13107,0)
	Button MakePATH,pos={215,97},size={140,30},proc=ButtonProc_2,title="Make New Path?"
	Button MakePATH,font="Arial Narrow Bold",fSize=20,fStyle=0,fColor=(0,13107,0)
	SetVariable plot_pntname,pos={52,310},size={255,24},title="PLTdat: PointName?"
	SetVariable plot_pntname,font="Arial Narrow Bold",fSize=18
	SetVariable plot_pntname,limits={100000,999999,1},value= plot_pntnam
	Button GetDATA2,pos={149,263},size={150,30},proc=ButtonProc_3,title="Plot Summary?"
	Button GetDATA2,font="Arial Narrow Bold",fSize=20,fStyle=0,fColor=(0,13107,0)
EndMacro

Function ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR shot
			NVAR timeid
			SVAR runid
			getPROFDAT(shot,timeid,runid)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "PLTdat_graph()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_2(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			MakeNeuIGORPath()
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_3(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "SumPlot()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function FindHome()
	
	PathInfo home
	Variable machstart= strsearch(S_path,":",0)
	String/G Homepath
	Homepath= S_path[0,machstart-1]
	
	return 0
End

Function MakeNeuIGORPath()
	
	String/G Homepath 
	String/G Neupath
	String totpath = HomePath+Neupath
	NewPath/Q/O DataDump totpath
	
	return 0
End

Window PLTdat_graph() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	String/G plot_pntnam
	Variable/G shot
	Variable/G timeid
	String/G runid
	String FoldNAM = "profdb_out_"+num2istr(shot)+"_"+num2istr(timeid)+"_"+runid
	SetDataFolder root:$FoldNAM
	Display /W=(657,44,1052,252) sig_Z vs sig_X
	String z_dim 
	If(Exists("sig_dimz")==1)
		z_dim = "["+sig_dimz[0]+"]"
	else
		z_dim = "dim?"
	endif
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=45,margin(bottom)=35,margin(top)=10,margin(right)=10
	ModifyGraph lSize=2,tick=2,zero(left)=1,mirror=1,standoff=0,axisOnTop=1
	ModifyGraph font="Helvetica Neue Bold Condensed"
	ModifyGraph fSize=12,fStyle=1,notation(left)=1 
	Label left z_dim
	Label bottom "Time [msec]"
	Legend/C/N=text0/J/A=MC/X=(-35)/Y=(35) "\\F'Arial Narrow'\\f01\\Z14\\s(sig_Z) "+plot_pntnam
EndMacro

Window SumPlot() : Graph
	PauseUpdate; Silent 1		// building window...
	Variable/G shot
	Variable/G timeid
	String/G runid
	String FoldNAM = "profdb_out_"+num2istr(shot)+"_"+num2istr(timeid)+"_"+runid
	Display /W=(1172,91,2443,855)
	TextBox/C/N=text0/A=MB/X=0.00/Y=1.90 "\\Z18\F'Arial Narrow'\f01ProfDB Tags:: Shot: "+num2istr(shot)+" Time: "+num2istr(timeid)+" Run: "+runid
	String fldrSav0= GetDataFolder(1)
	SetDataFolder FoldNAM
	Display/W=(0,0,0.498,0.301)/HOST=#  NEP vs PNE
	ErrorBars/L=3/X=1/Y=1 NEP XY,wave=(EPNE,EPNE),wave=(ENEP,ENEP)
	AppendToGraph/C=(57054,30326,11565) NETHP vs PNETH
	AppendToGraph/C=(0,0,0) NET0P vs PNET0
	AppendToGraph/C=(41120,10794,7453) NISPLPSIWAV vs PNWAV
	APPENDToGraph/C=(6682,40349,38550) NBSPLPSIWAV vs PNWAV
	WaveStats/M=1/Q/Z NEP
	SetAxis left 0,1.1*V_max
	SetAxis bottom 0,1.1
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,2.7}
	ModifyGraph height=220,standoff=0,axisOnTop=1,tick=2, mirror=1, noLabel(bottom)=2
	ModifyGraph mode(NEP)=3,marker(NEP)=19,msize(NEP)=4
	ModifyGraph lSize=3
	ModifyGraph rgb(NEP)=(34181,50372,17990,6554),useMrkStrokeRGB(NEP)=1,mrkStrokeRGB(NEP)=(0,31097,13364,26214)
	ModifyGraph fSize=14, font="Arial Narrow", fStyle=1
	Legend/C/N=text0/J/A=MC/H=9/X=30/Y=35 "\\M\\Z13\\F'Arial Narrow'\\f01\\s(NEP) NEP [x10\\S20 \\M\Z13m\\S-3\\M]\\Z13\r\\s(NETHP)NETHP            \\s(NET0P)NET0P"
	AppendText "\\s(nisplpsiWAV)nisplpsiWAV  \\s(NBSPLPSIWAV)NBSPLPSIWAV"
	RenameWindow #,G0
	SetActiveSubwindow ##

	SetDataFolder FoldNAM
	Display/W=(0,0.302,0.498,0.602)/HOST=#  TEP vs PTE
	AppendToGraph/C=(57054,30326,11565) TETHP vs PTETH
	AppendToGraph/C=(0,0,0) TET0P vs PTET0
	AppendToGraph/C=(6682,40349,38550) TISPLPSIWAV vs PNWAV
	ErrorBars/L=3/X=1/Y=1 TEP XY,wave=(EPTE,EPTE),wave=(ETEP,ETEP)
	SetAxis bottom 0,1.1
	WaveStats/M=1/Q/Z TEP
	SetAxis left 0,1.1*V_max
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,2.7}
	ModifyGraph height=220, standoff=0, axisOnTop=1, lSize=3, tick=2, mirror=1, noLabel(bottom)=2
	ModifyGraph mode(TEP)=3,marker(TEP)=19,msize(TEP)=4
	ModifyGraph rgb(TEP)=(34181,50372,17990,6554),useMrkStrokeRGB(TEP)=1,mrkStrokeRGB(TEP)=(0,31097,13364,26214)
	ModifyGraph fSize=14,font="Arial Narrow", fStyle=1
	Legend/C/N=text0/J/A=MC/H=9/X=32.32/Y=30.00 "\\M\\Z13\\F'Arial Narrow'\\f01\\s(TEP)TEP [keV]\r\\s(TETHP)TETHP\r\\s(TET0P)TET0P\r\\s(TISPLPSIWAV)TISPLPSIWAV"
	RenameWindow #,G1
	SetActiveSubwindow ##
	
	SetDataFolder FoldNAM
	Display/W=(0,0.603,0.498,0.942)/HOST=#  PTOTSPLPSIWAV vs PNWAV
	AppendToGraph/C=(34181,50372,17990,6554) PEP vs PPE
	AppendToGraph/C=(57054,30326,11565) PETHP vs PPETH
	AppendToGraph PTTHP vs PPTTH
	AppendToGraph/C=(41120,10794,7453) PTT0P vs PPTT0
	AppendToGraph/C=(0,0,0) PBSPLPSIWAV vs PNWAV
	ErrorBars/L=3/X=1/Y=1 PEP XY,wave=(EPPE,EPPE),wave=(EPEP,EPEP)
	WaveStats/M=1/Q/Z PEP
	SetAxis left 0,1.1*V_max
	SetAxis bottom 0,1.1
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,2.7}
	ModifyGraph height=220, lSize=3,axisOnTop=1,standoff=0,tick=2,mirror=1,fSize=14,font="Arial Narrow",fStyle=1
	ModifyGraph mode(PEP)=3
	ModifyGraph marker(PEP)=19
	ModifyGraph rgb(PTOTSPLPSIWAV)=(6682,40349,38550),rgb(PETHP)=(34952,13107,11822)
	ModifyGraph rgb(PTTHP)=(58339,51400,0),rgb(PTT0P)=(57054,30326,11565)
	ModifyGraph msize(PEP)=4
	ModifyGraph useMrkStrokeRGB(PEP)=1,mrkStrokeRGB(PEP)=(0,31097,13364,26214)
	ModifyGraph muloffset(PTOTSPLPSIWAV)={0,0.5},muloffset(PTTHP)={0,0.5},muloffset(PTT0P)={0,0.5}
	Legend/C/N=text0/J/A=MC/H=9/X=15/Y=25.45 "\\M\\Z13\\F'Arial Narrow'\\f01\\s(PEP)PEP [kPa]\r\\s(PETHP)PETHP\r\\s(PTTHP)0.5xP_TOT_TANH   \\s(PTT0P)0.5xP_TOT_TANH0   \\s(PTOTSPLPSIWAV)0.5xP_TOT_SPL\r\\s(PBSPLPSIWAV)PBSPLPSIWAV"
	RenameWindow #,G2
	SetActiveSubwindow ##
	
	SetDataFolder FoldNAM
	Display/W=(0.494,0,0.992,0.301)/HOST=#  FZP vs PFZ
	If(Exists("FZSPLPSIWAV"))
		AppendToGraph/C=(20560,37265,52685) FZSPLPSIWAV vs PNWAV
	endif
	AppendToGraph/C=(57054,30326,11565) FZTHP vs PFZTH
	AppendToGraph/C=(34952,13107,11822) FZT0P vs PFZT0
	ErrorBars/Y=1/L=3 FZP Y,wave=(EFZP,EFZP)
	WaveStats/M=1/Q/Z FZP
	SetAxis left 0,1.1*V_max
	SetAxis bottom 0,1.1
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,2.7}
	ModifyGraph height=220,lSize=3,mirror=1,standoff=0,axisOnTop=1,tick=2,noLabel(bottom)=2,fSize=14,font="Arial Narrow",fStyle=1
	ModifyGraph mode(FZP)=3,marker(FZP)=19,msize(FZP)=4
	ModifyGraph rgb(FZP)=(34181,50372,17990,6554)
	ModifyGraph useMrkStrokeRGB(FZP)=1
	ModifyGraph mrkStrokeRGB(FZP)=(0,31097,13364,26214)
	Legend/C/N=text0/J/A=MC/H=9/X=-35/Y=30 "\\M\\Z13\\F'Arial Narrow'\\f01\\s(FZP)FZP = 6n\\Bc\\M\Z13/n\\Be\\M\\Z13 [%]\r\\Z13\\s(FZSPLPSIWAV)FZSPLPSIWAV\r\\s(FZTHP)FZTHP\r\\s(FZT0P)FZT0P"
	RenameWindow #,G3
	SetActiveSubwindow ##
	
	SetDataFolder FoldNAM
	Display/W=(0.494,0.302,0.992,0.602)/HOST=#  TIP vs PTI
	AppendToGraph/C=(34952,13107,11822) TITHP vs PTITH
	AppendToGraph/C=(57054,30326,11565) TIT0P vs PTIT0
	AppendToGraph/C=(6682,40349,38550) TISPLPSIWAV vs PNWAV
	ErrorBars/Y=1/L=3 TIP Y,wave=(ETIP,ETIP)
	WaveStats/M=1/Q/Z TIP
	SetAxis left 0,1.1*V_max
	SetAxis bottom 0,1.1
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,2.7}
	ModifyGraph height=220,lSize=3,tick=2,mirror=1,noLabel(bottom)=2,standoff=0,axisOnTop=1,fSize=14,font="Arial Narrow",fStyle=1
	ModifyGraph mode(TIP)=3,marker(TIP)=19,msize(TIP)=4
	ModifyGraph rgb(TIP)=(34181,50372,17990,6554)
	ModifyGraph useMrkStrokeRGB(TIP)=1,mrkStrokeRGB(TIP)=(0,31097,13364,26214)
	Legend/C/N=text0/J/A=MC/H=9/X=29.29/Y=30.00 "\\M\\Z13\\F'Arial Narrow'\\f01\\s(TIP) TIP [keV]\r\\s(TITHP) TITHP\r\\s(TIT0P) TIT0P\r\\s(TISPLPSIWAV) TISPLPSIWAV"
	RenameWindow #,G4
	SetActiveSubwindow ##
	
	SetDataFolder FoldNAM
	Display/W=(0.494,0.603,0.992,0.942)/HOST=#  OMEVBSPLPSIWAV vs PNWAV
	AppendToGraph/C=(57054,30326,11565) OMGHBSPLPSIWAV vs PNWAV
	AppendToGraph/C=(41120,10794,7453) OMMPPSPLPSIWAV vs PNWAV
	AppendToGraph/C=(0,31097,13364) OMGPPSPLPSIWAV vs PNWAV
	SetAxis left -120,55
	SetAxis bottom 0,1.1
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,2.7}
	ModifyGraph height=220,zero(left)=1,tick=2,mirror=1,standoff=0,axisOnTop=1
	ModifyGraph lSize=3,fSize=14,font="Arial Narrow",fStyle=1
	ModifyGraph rgb(OMEVBSPLPSIWAV)=(6682,40349,38550)
	ModifyGraph muloffset(OMEVBSPLPSIWAV)={0,0.5}
	Legend/C/N=text0/J/A=MC/H=9/X=-4.38/Y=-25.91 "\\M\Z13\\F'Arial Narrow'\\f01\\s(OMEVBSPLPSIWAV) OMEG_VxB [krad/s]\r\\s(OMGHBSPLPSIWAV) OMEG_HAHM-BURREL\r\\s(OMGPPSPLPSIWAV) OMEG_DIAG_E"
	AppendText "\\s(OMMPPSPLPSIWAV) OMEG_DIAG_ION"
	RenameWindow #,G5
	SetActiveSubwindow ##
EndMacro
