#pragma rtGlobals=1		// Use modern global access method.
Window GetDAT_Panel() : Panel
	PauseUpdate; Silent 1		// building window...
	// Prep work
	FindHome()
	Homepath +=":"
	if(Exists("shot")!=2)
		Variable/G shot = 149712
	endif
	if(Exists("pntname")!=2)
		String/G pntname = "density"
	endif
	if(Exists("server")!=2)
		String/G server = "atlas.gat.com"
	endif
	if(Exists("plot_pntnam")!=2)
		String/G plot_pntnam = "density"
	endif
	if(Exists("Neupath")!=2)
		String/G Neupath = "Users:"
	endif
	//End Prep
	NewPanel /W=(494,342,949,639)
	ModifyPanel cbRGB=(48059,48059,48059)
	SetDrawLayer UserBack
	SetDrawEnv linethick= 2
	DrawRRect 82,7,357,40
	SetDrawEnv fname= "Arial Narrow Bold",fsize= 24
	DrawText 97,39,"DIII-D Data Archive Loader"
	SetVariable ShotNum,pos={151,51},size={130,26},title="Shot:"
	SetVariable ShotNum,font="Arial Narrow Bold",fSize=20
	SetVariable ShotNum,valueBackColor=(65535,65535,65535)
	SetVariable ShotNum,limits={100000,999999,1},value= shot
	SetVariable pathDSPL,pos={21,84},size={200,24},title="Save Path?"
	SetVariable pathDSPL,font="Arial Narrow Bold",fSize=18,frame=0
	SetVariable pathDSPL,limits={-inf,inf,0},value= Homepath,noedit= 1
	SetVariable pathDSPL1,pos={223,84},size={200,24},title=" "
	SetVariable pathDSPL1,font="Arial Narrow Bold",fSize=18
	SetVariable pathDSPL1,limits={-inf,inf,0},value= Neupath
	SetVariable Def_pntname,pos={88,151},size={255,24},title="GetDAT: PointName?"
	SetVariable Def_pntname,font="Arial Narrow Bold",fSize=18
	SetVariable Def_pntname,limits={100000,999999,1},value= pntname
	Button GetDATA,pos={176,179},size={75,30},proc=ButtonProc,title="GetDAT"
	Button GetDATA,font="Arial Narrow Bold",fSize=20,fStyle=0,fColor=(0,13107,0)
	Button GetDATA1,pos={175,248},size={75,30},proc=ButtonProc_1,title="Plot?"
	Button GetDATA1,font="Arial Narrow Bold",fSize=20,fStyle=0,fColor=(0,13107,0)
	Button MakePATH,pos={262,110},size={140,30},proc=ButtonProc_2,title="Make New Path?"
	Button MakePATH,font="Arial Narrow Bold",fSize=20,fStyle=0,fColor=(0,13107,0)
	SetVariable plot_pntname,pos={90,219},size={255,24},title="PLTdat: PointName?"
	SetVariable plot_pntname,font="Arial Narrow Bold",fSize=18
	SetVariable plot_pntname,limits={100000,999999,1},value= plot_pntnam
	SetVariable setServer title="Server",size={100,20},value=server
	SetVariable setServer size={200,16},font="Arial Narrow",fSize=20
EndMacro

Function ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR shot
			SVAR pntname
			SVAR server
			getGADAT(shot,pntname,server)
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Window PLTdat_graph() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	String/G plot_pntnam
	Variable/G shot
	String FoldNAM = "pyd3dat_"+plot_pntnam+"_"+num2istr(shot)
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
	ModifyGraph rgb=(52428,1,1)
	Label left z_dim
	Label bottom "Time [msec]"
	Legend/C/N=text0/J/A=LT/Z=0 "\\F'Helvetica Neue Bold Condensed'\\Z14\\s(sig_Z) "+plot_pntnam
	TextBox/C/N=text1/Z=1/A=RT/X=1.00/Y=1.00 "\\F'Helvetica Neue Bold Condensed'\\Z14"+num2istr(shot)
EndMacro

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
			FindHome()
			MakeNeuIGORPath()
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
	String totpath = HomePath+":"+Neupath
	NewPath/Q/O DataDump totpath
	
	return 0
End