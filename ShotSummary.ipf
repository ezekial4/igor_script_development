#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Window loadPanel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(478,44,850,400)
	ModifyPanel cbRGB=(65535,60076,49151)
	
	//Prep Work
	FindHome()
	Homepath +=":"
	if (exists("shotNum") != 2)
		Variable/G shotNum = 126006
	endif
	if (exists("tstart") != 2)
		Variable/G tstart = -50. 
	endif
	if (exists("tend") != 2)
		Variable/G/O tend = 5500. 
	endif
	if(Exists("Neupath")!=2)
		String/G Neupath = "Users:"
	endif
	//End Prep
	
	TitleBox title0,pos={90,15},size={199,35},title="Load Shot Summary",labelBack=(0,26214,13293),font="Arial Narrow Bold",fSize=28,frame=4,fStyle=1,fColor=(65535,65535,65535),anchor= MT
	CheckBox usePython,pos={116,166},size={113,16},title="from MDSplus"
	CheckBox usePython,labelBack=(0,0,0),font="Arial Bold",fSize=14,value= 1,mode=1
	SetVariable setvar0,pos={125,68},size={115,24},title="Shot #:",valueBackColor=(39321,1,1),limits={10000,inf,0},value= shotNum,styledText= 1
	SetVariable setvar0,labelBack=(0,26214,13293),font="Arial Narrow Bold",fSize=18,fColor=(65535,65535,65535),valueColor=(65535,65535,65535)
	SetVariable setvar1,pos={111,191},size={140,17},title="Plot Start Time:",fColor=(65535,65535,65535),valueColor=(65535,65535,65535)
	SetVariable setvar1,labelBack=(0,26214,13293),font="Arial Narrow Bold",fSize=16,valueBackColor=(39321,1,1),limits={-inf,inf,0},value= tstart,styledText= 1
	SetVariable setvar2,pos={111,217},size={140,17},title="Plot End Time:",labelBack=(0,26214,13293),font="Arial Narrow Bold",fSize=16
	SetVariable setvar2,fColor=(65535,65535,65535),valueColor=(65535,65535,65535)
	SetVariable setvar2,valueBackColor=(39321,1,1),limits={-inf,inf,0},value= tend,styledText= 1
	Button button0,pos={150,249},size={50,30},proc=ButtonProc,title="Plot",fSize=18,fStyle=1,fColor=(1,39321,19939)
	
	SetVariable pathDSPL,pos={5,100},size={160,24},title="Data Path:",labelBack=(0,26214,13293),fColor=(65535,65535,65535),valueColor=(65535,65535,65535),valueBackColor=(39321,1,1)
	SetVariable pathDSPL,font="Arial Narrow Bold",fSize=18,frame=0
	SetVariable pathDSPL,limits={-inf,inf,0},value= Homepath,noedit= 1
	SetVariable pathDSPL1,pos={160,100},size={200,24},title=" "
	SetVariable pathDSPL1,font="Arial Narrow Bold",fSize=14,fstyle=2,valueColor=(65535,65535,65535), valueBackColor=(39321,1,1), labelBack=(39321,1,1)
	SetVariable pathDSPL1,limits={-inf,inf,0},value= Neupath
	Button MakePATH,pos={120,130},size={120,30},proc=ButtonProc_2,title="Make New Path?"
	Button MakePATH,font="Arial Narrow Bold",fSize=18,fStyle=0,fColor=(1,39321,19939)
	
EndMacro

Function ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR shotNum
			String fname = "paramDB_"+num2istr(shotNum)+".h5"
			print fname
			Variable fileID
			HDF5OpenFile/P=DataDump/R/Z fileID as fname
			HDF5LoadGroup/T/O/Z/IGOR=-1 :, fileID,"/"
			HDF5CloseFile/A/Z fileID
			Execute "Calc_nu_e(shotNum)"
			Execute "Overview_p1()"
			Execute "Overview_p2()"
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

Window Overview_p1() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(836,44,2053,789)
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5
	TextBox/C/N=text0/A=MB/X=-5.86/Y=1.90 "\\Z18Shot: \\{shotNum}"
	String savDF="root:paramDB_"+num2istr(shotNum)+":"
	String fldrSav0= GetDataFolder(1)
		
	// Graph 1,1
	SetDataFolder savDF
	Display/W=(0,0,0.334,0.295)/HOST=# DENSV3 vs t_DENSV3
	AppendToGraph/C=(1,39321,19939) DENSV2 vs t_DENSV2
	AppendToGraph/C=(1,34817,52428) DENSR0 vs t_DENSR0
	AppendToGraph/C=(65535,49151,49151) NEPED vs t_NEPED
	ErrorBars/Y=2 NEPED Y,wave=(NEPED_ERR,NEPED_ERR)
	WaveStats/Q/m=1 DENSR0
	SetAxis left 0,1.1*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph rgb(DENSV3)=(52428,34958,1),lSize(DENSV3)=3,lSize(DENSV2)=3,lSize(DENSR0)=3
	ModifyGraph mode(NEPED)=3,msize(NEPED)=3,marker(NEPED)=19,useMrkStrokeRGB(NEPED)=1,mrkStrokeRGB(NEPED)=(52428,1,1)
	ModifyGraph grid(bottom)=1,noLabel(bottom)=2,fSize(left)=12,prescaleExp(left)=-19
	ModifyGraph tick=2,height=210,mirror=1,standoff=0,axisOnTop=1 
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left " "
	Legend/C/N=text0/J/A=MC/X=1.63/Y=-31.90 "\\Z11\\s(DENSR0) DENSR0 \\M[ x10\\S19 \\Mm\\S-3\\M ] \r\\s(DENSV2) DENSV2\r\\s(DENSV3) DENSV3\r\\s(NEPED) NEPED"
	RenameWindow #,G0
	SetActiveSubwindow ##
	
	//Graph 1,2
	SetDataFolder savDF
	Display/W=(0.334,0,0.668,0.295)/HOST=#  IP vs t_IP
	AppendToGraph/C=(1,34817,52428) BT0 vs t_BT0
	AppendToGraph/C=(1,39321,19939) LI vs t_LI
	AppendToGraph/C=(52428,34958,1) KAPPA vs t_KAPPA
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210, standoff=0,mirror=1,tick=2,lSize=3,fSize(left)=12,axisOnTop(left)=1
	ModifyGraph rgb(IP)=(52428,1,1),muloffset(IP)={0,1e-06},muloffset(BT0)={0,-1} 
	ModifyGraph grid(bottom)=1,noLabel(bottom)=2,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left " "
	SetAxis left 0,*
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=1.09/Y=-31.90 "\\Z11\\s(IP) IP [MA]\r\\s(BT0) BT0 [T]\r\\s(LI) LI\r\\s(KAPPA) KAPPA"
	RenameWindow #,G1
	SetActiveSubwindow ##
	
	//Graph 1,3
	SetDataFolder savDF
	Display/W=(0.666,0.2,1,0.295)/FG=(,FT,,)/HOST=#  H_THH98Y2 vs t_H_THH98Y2
	AppendToGraph/C=(1,39321,19939) H_L89 vs t_H_L89
	AppendToGraph/C=(52428,1,1) TAUE vs t_TAUE
	WaveStats/Q/M=1 H_L89
	SetAxis left 0,1.1*V_max
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75},height=210
	ModifyGraph rgb(H_THH98Y2)=(1,34817,52428)
	ModifyGraph muloffset(TAUE)={0,10}
	ModifyGraph grid(bottom)=1,noLabel(bottom)=2,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph tick=2,mirror=1,fSize(left)=12,standoff=0,axisOnTop=1, lSize=3
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-5.45/Y=-36.67 "\\Z11\\s(H_THH98Y2) H_THH98Y2\r\\s(H_L89) H_L89\r\\s(TAUE) TAUE [x0.1 sec]"
	RenameWindow #,G8
	SetActiveSubwindow ##
	
	//Graph 2,1
	SetDataFolder savDF
	Display/W=(0,0.293,0.334,0.587)/HOST=#  TEPED vs t_TEPED
	AppendToGraph/C=(49151,65535,49151) TSTE70 vs t_TSTE70
	AppendToGraph/C=(52428,1,1) ECE_MID vs t_ECE_MID
	AppendToGraph/C=(52428,34958,1) ECE_CEN vs t_ECE_CEN
	WaveStats/Q/M=1 ECE_CEN
	SetAxis/N=2 left 0,1250*V_max
	ErrorBars/Y=2 TEPED Y,wave=(TEPED_ERR,TEPED_ERR)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75},height=210,noLabel(bottom)=2
	ModifyGraph mode(TEPED)=3,mode(TSTE70)=3,msize(TEPED)=2,msize(TSTE70)=2, lSize(ECE_MID)=3,lSize(ECE_CEN)=3
	ModifyGraph marker(TEPED)=29,marker(TSTE70)=29,rgb(TEPED)=(49151,60031,65535)
	ModifyGraph useMrkStrokeRGB(TEPED)=1,useMrkStrokeRGB(TSTE70)=1
	ModifyGraph mrkStrokeRGB(TEPED)=(1,34817,52428),mrkStrokeRGB(TSTE70)=(1,39321,19939)
	ModifyGraph muloffset(ECE_MID)={0,1000},muloffset(ECE_CEN)={0,1000}
	ModifyGraph grid(bottom)=1,tick=2,mirror=1,fSize=12, standoff=0,prescaleExp(left)=-3,axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left " "
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-37.33/Y=34.76 "\\Z11\\s(TEPED) TEPED [keV]\r\\s(TSTE70) TSTE70\r\\s(ECE_MID) ECE_MID\r\\s(ECE_CEN) ECE_CEN"
	RenameWindow #,G5
	SetActiveSubwindow ##
	
	//Graph 2,2
	SetDataFolder savDF
	Display/W=(0.333,0.294,0.667,0.589)/HOST=#  WMHD vs t_WMHD
	AppendToGraph/C=(1,34817,52428) BETAP vs t_BETAP
	AppendToGraph/C=(1,39321,19939) BETAN vs t_BETAN
	WaveStats/Q/M=1 BETAN
	SetAxis left 0,1.1*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,lSize=3,tick=2,mirror=1,standoff=0,axisOnTop=1
	ModifyGraph rgb(WMHD)=(52428,1,1),muloffset(WMHD)={0,1e-06}
	ModifyGraph grid(bottom)=1,fSize(left)=12,noLabel(bottom)=2, manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Legend/C/N=text0/J/A=MC/X=3.54/Y=-37.62 "\\Z11\\s(WMHD) WMHD [MJ]\r\\s(BETAP) BETAP\r\\s(BETAN) BETAN"
	RenameWindow #,G2
	SetActiveSubwindow ##
	
	//Graph 2,3
	SetDataFolder savDF
	Display/W=(0.665,0.294,0.8,0.589)/FG=(,,FR,)/HOST=#  PRAD_TOT vs t_PRAD_TOT
	AppendToGraph/C=(1,39321,19939) PRAD_DIVU vs t_PRAD_DIVU
	AppendToGraph/C=(1,34817,52428) PRAD_DIVL vs t_PRAD_DIVL
	AppendToGraph/C=(52428,34958,1) PINJ vs t_PINJ
	AppendToGraph/C=(26214,26214,26214) POH vs t_POH
	WaveStats/Q/M=1 PINJ
	SetAxis/N=2 left 0,1100*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph rgb(PRAD_TOT)=(52428,1,1),muloffset(PINJ)={0,1000},prescaleExp(left)=-6
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75},manTick(bottom)={0,1000,0,0}
	ModifyGraph height=210,lSize=3,fSize(left)=12,noLabel(bottom)=2,tick=2, standoff=0,mirror=1,axisOnTop=1,grid(bottom)=1,manMinor(bottom)={1,0}
	Label left " "
	Legend/C/N=text0/J/A=MC/X=-25/Y=31.90 "\\Z11\\s(PRAD_TOT) PRAD_TOT [MW]\r\\s(PRAD_DIVU) PRAD_DIVU\r\\s(PRAD_DIVL) PRAD_DIVL\r\\s(PINJ) PINJ\r\\s(POH) POH"
	RenameWindow #,G3
	SetActiveSubwindow ##
	
	//Graph 3,1
	SetDataFolder savDF
	Display/W=(0,0.588,0.334,0.923)/HOST=#  Q95 vs t_Q95
	AppendToGraph/C=(1,39321,19939) Q0 vs t_Q0
	AppendToGraph/C=(52428,34958,1) QMIN vs t_QMIN
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210, lSize=3,tick=2,mirror=1,fSize=12,standoff=0, axisOnTop=1,rgb(Q95)=(52428,1,1),grid(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0},lblMargin(bottom)=-40,lstyle(QMIN)=3
	Label bottom "\\Z12time [ms]"
	SetAxis left 0.5,6
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-1.63/Y=38.57 "\\Z11\\s(Q95) Q95\r\\s(Q0) Q0\r\\s(QMIN) QMIN"
	RenameWindow #,G4
	SetActiveSubwindow ##
	
	//Graph 3,2
	SetDataFolder savDF
	Display/W=(0.333,0.588,0.666,0.923)/HOST=# /R FS03 vs t_FS03
	AppendToGraph/R/C=(52428,34958,1) FS01 vs t_FS01
	Duplicate/O ELM_freq,ELM_freq_smth
	Smooth/MPCT=25/M=0 11, ELM_freq_smth
	AppendToGraph/C=(56797,56797,56797) ELM_freq_smth vs t_ELM_freq
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=4,width={Aspect,1.75}
	ModifyGraph height=210
	ModifyGraph mode(ELM_freq_smth)=3
	ModifyGraph marker(ELM_freq_smth)=19
	ModifyGraph rgb(FS03)=(1,39321,19939)
	ModifyGraph useMrkStrokeRGB(ELM_freq_smth)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph log(left)=1
	ModifyGraph tick=2
	ModifyGraph mirror(bottom)=1
	ModifyGraph noLabel(right)=2
	ModifyGraph fSize(bottom)=12,fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label bottom "\\Z12time [ms]"
	SetAxis right 0,100000000000000
	SetAxis bottom root:tstart,root:tend
	SetAxis left 10,9000
	Legend/C/N=text0/J/A=MC/X=6.54/Y=34.76 "\\Z11\\s(FS01) FS01\r\\s(FS03) FS03\r\\s(ELM_freq_smth) ELM_freq_smth"
	RenameWindow #,G6
	SetActiveSubwindow ##
	
	
	//Graph 3,3
	SetDataFolder savDF
	Display/W=(0.667,0.589,1,0.923)/HOST=#  IL30 vs t_IL30
	AppendToGraph IL90 vs t_IL90[0,32749]
	AppendToGraph IL150 vs t_IL150[0,32749]
	AppendToGraph IL210 vs t_IL210[0,32749]
	AppendToGraph IL270 vs t_IL270[0,32749]
	AppendToGraph IL330 vs t_IL330[0,32749]
	AppendToGraph IU30 vs t_IU30[0,32749]
	AppendToGraph IU90 vs t_IU90[0,32749]
	AppendToGraph IU150 vs t_IU150[0,32749]
	AppendToGraph IU210 vs t_IU210[0,32749]
	AppendToGraph IU270 vs t_IU270[0,32749]
	AppendToGraph IU330 vs t_IU330[0,32749]
	AppendToGraph DRSEP vs t_DRSEP
	SetAxis/N=2 left -4250,4250
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210
	ModifyGraph lSize(IL30)=3,lSize(IL90)=3,lSize(IL150)=3,lSize(IL210)=3,lSize(IL270)=3
	ModifyGraph lSize(IL330)=3,lSize(IU30)=2,lSize(IU90)=2,lSize(IU150)=2,lSize(IU210)=2
	ModifyGraph lSize(IU270)=2,lSize(IU330)=2,lSize(DRSEP)=3
	ModifyGraph lStyle(IU30)=2,lStyle(IU90)=2,lStyle(IU150)=2,lStyle(IU210)=2,lStyle(IU270)=2
	ModifyGraph lStyle(IU330)=2
	ModifyGraph rgb(IL30)=(52428,1,1),rgb(IL90)=(1,52428,26586),rgb(IL150)=(1,34817,52428)
	ModifyGraph rgb(IL210)=(52428,34958,1),rgb(IL270)=(26214,26214,26214),rgb(IL330)=(24576,24576,65535)
	ModifyGraph rgb(IU30)=(52428,1,1),rgb(IU90)=(1,52428,26586),rgb(IU150)=(1,34817,52428)
	ModifyGraph rgb(IU210)=(52428,34958,1),rgb(IU270)=(26214,26214,26214),rgb(IU330)=(24576,24576,65535)
	ModifyGraph rgb(DRSEP)=(21845,21845,21845)
	ModifyGraph muloffset(DRSEP)={0,10000},axisOnTop=1,prescaleExp(left)=-3,standoff=0,fSize=12,mirror=1,zero(left)=2,tick=2
	ModifyGraph grid(bottom)=1,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left "[kA] "
	Label bottom "\\Z12time [ms]"
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-0.54/Y=0.48 "\\Z11\\s(IL30) IL30\r\\s(IL90) IL90\r\\s(IL150) IL150\r\\s(IL210) IL210\r\\s(IL270) IL270\r\\s(IL330) IL330\r\\s(IU30) IU30"
	AppendText "\\s(IU90) IU90\r\\s(IU150) IU150\r\\s(IU210) IU210\r\\s(IU270) IU270\r\\s(IU330) IU330\r\\s(DRSEP) DRSEP"
	RenameWindow #,G7
	SetActiveSubwindow ##
EndMacro

Window Overview_p2() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(1279,44,2501,788)
	TextBox/C/N=text0/A=MB/X=-5.86/Y=1.90 "\\Z18Shot: \\{shotNum}"
	String savDF="root:paramDB_"+num2istr(shotNum)+":"
	String fldrSav0= GetDataFolder(1)
	
	//Graph 1,1
	SetDataFolder savDF
	Display/W=(0,0,0.333,0.295)/HOST=#  BDOTEVAMPL vs t_BDOTEVAMPL
	AppendToGraph/C=(1,34817,52428) BDOTODAMPL vs t_BDOTODAMPL
	WaveStats/Q/M=1 BDOTODAMPL
	SetAxis left 0,1.1*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210
	ModifyGraph lSize=3
	ModifyGraph rgb(BDOTEVAMPL)=(52428,1,1)
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Legend/C/N=text0/J/A=MC/X=-8.17/Y=33.33 "\\Z11\\s(BDOTEVAMPL) BDOTEVAMPL\r\\s(BDOTODAMPL) BDOTODAMPL"
	RenameWindow #,G0
	SetActiveSubwindow ##
	
	//Grpah 1,2
	SetDataFolder savDF
	Display/W=(0.333,0,0.666,0.295)/HOST=#  PEPED vs t_PEPED
	ErrorBars/Y=2 PEPED Y,wave=(PEPED_ERR,PEPED_ERR)
	WaveStats/Q/M=1 PEPED
	SetAxis/N=2 left 0,1.1*V_max
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210, mirror=1,mode=3,marker=19,rgb=(65535,49151,49151),useMrkStrokeRGB=1
	ModifyGraph mrkStrokeRGB=(52428,1,1),grid(bottom)=1, tick=2, standoff=0,axisOnTop=1,fSize=12
	ModifyGraph noLabel(bottom)=2,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=4.90/Y=36.67 "\\Z11\\s(PEPED) PEPED"
	RenameWindow #,G1
	SetActiveSubwindow ##
	
	//Graph 1,3
	SetDataFolder savDF
	Display/W=(0.666,0,0.999,0.295)/HOST=#  NEWID vs t_NEWID
	AppendToGraph/C=(49151,65535,49151) PEWID vs t_PEWID
	AppendToGraph/C=(49151,60031,65535) TEWID vs t_TEWID
	AppendToGraph/C=(26214,26214,26214) TRIBOT vs t_TRIBOT
	AppendToGraph/C=(52428,1,1) TRITOP vs t_TRITOP
	AppendToGraph/C=(65535,43690,0) GAPOUT vs t_GAPOUT
	ErrorBars/Y=2 NEWID Y,wave=(NEWID_ERR,NEWID_ERR)
	ErrorBars/Y=2 PEWID Y,wave=(PEWID_ERR,PEWID_ERR)
	ErrorBars/Y=2 TEWID Y,wave=(TEWID_ERR,TEWID_ERR)
	WaveStats/Q/M=1 TRIBOT
	SetAxis/N=2 left 0.007,1.1*V_max
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75} 
	ModifyGraph mode(NEWID)=3,mode(PEWID)=3,mode(TEWID)=3
	ModifyGraph marker(NEWID)=19,marker(PEWID)=19,marker(TEWID)=19
	ModifyGraph lSize(TRIBOT)=3,lSize(TRITOP)=3,lSize(GAPOUT)=3
	ModifyGraph rgb(NEWID)=(65535,49151,49151)
	ModifyGraph msize(NEWID)=2,msize(PEWID)=2,msize(TEWID)=2
	ModifyGraph useMrkStrokeRGB(NEWID)=1,useMrkStrokeRGB(PEWID)=1,useMrkStrokeRGB(TEWID)=1
	ModifyGraph mrkStrokeRGB(NEWID)=(52428,1,1),mrkStrokeRGB(PEWID)=(1,39321,19939)
	ModifyGraph mrkStrokeRGB(TEWID)=(1,34817,52428)
	ModifyGraph grid(bottom)=1,height=210
	ModifyGraph log(left)=1
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=41.69/Y=-27.14 "\\Z11\\s(NEWID) NEWID\r\\s(PEWID) PEWID\r\\s(TEWID) TEWID\r\\s(TRIBOT) TRIBOT\r\\s(TRITOP) TRITOP\r\\s(GAPOUT) GAPOUT"
	RenameWindow #,G2
	SetActiveSubwindow ##
	
	//Graph 2,1
	SetDataFolder savDF
	Display/W=(0,0.302,0.333,0.596)/HOST=#  N4RMS vs t_N4RMS
	AppendToGraph/C=(52428,1,1) N1RMS vs t_N1RMS
	AppendToGraph/C=(1,34817,52428) N2RMS vs t_N2RMS
	AppendToGraph/C=(1,39321,19939) N3RMS vs t_N3RMS
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,axisOnTop=1,standoff=0,fSize=12,mirror=1,tick=2,grid(bottom)=1,noLabel(bottom)=2
	ModifyGraph lSize=3,rgb(N4RMS)=(65535,43690,0),manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-8.45/Y=30.00 "\\Z11\\s(N4RMS) N4RMS\r\\s(N1RMS) N1RMS\r\\s(N2RMS) N2RMS\r\\s(N3RMS) N3RMS"
	RenameWindow #,G5
	SetActiveSubwindow ##
	
	//Graph 2,2
	SetDataFolder savDF
	Display/W=(0.333,0.305,0.665,0.599)/HOST=#  ROTT23 vs t_ROTT23
	WaveStats/Q/M=1 ROTT23
	SetAxis left 0,1.25*V_max
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,rgb=(52428,1,1),lSize=3,noLabel(bottom)=2
	ModifyGraph grid(bottom)=1,tick=2,mirror=1,fSize=12,standoff=0 
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-3.54/Y=34.29 "\\Z11\\s(ROTT23) ROTT23"
	RenameWindow #,G3
	SetActiveSubwindow ##
	
	//Graph 2,3
	SetDataFolder savDF
	Display/W=(0.666,0.305,0.999,0.598)/HOST=#  RVSOUT vs t_RVSOUT
	WaveStats/Q/M=1 RVSOUT
	SetAxis left 0.9*V_max,1.05*V_max
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210
	ModifyGraph lSize=3,tick=2
	ModifyGraph rgb=(52428,1,1)
	ModifyGraph grid(bottom)=1,noLabel(bottom)=2
	ModifyGraph mirror=1, fSize=12, standoff=0
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-3.54/Y=34.29 "\\Z11\\s(RVSOUT) RVSOUT"
	RenameWindow #,G4
	SetActiveSubwindow ##
	
	//Graph 3,1
	Display/W=(0,0.6,0.334,0.923)/HOST=# NU_E_STAR vs t_NEPED
	AppendToGraph/C=(1,34817,52428) F_GW vs t_NEPED
	AppendToGraph/C=(1,39321,19939) F_GW_PED vs t_NEPED
	WaveStats/Q/M=1 NU_E_STAR
	SetAxis left 2*V_min,6
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210, lSize=3,tick=2,mirror=1,fSize=12,standoff=0, axisOnTop=1,rgb(NU_E_STAR)=(52428,1,1),grid(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0},lblMargin(bottom)=-40,log(left)=1
	Label bottom "\\Z12time [ms]"
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-1.63/Y=38.57 "\\Z11\\s(NU_E_STAR) NU_E_STAR\r\\s(F_GW) F_GW\r\\s(F_GW_PED) F_GW_PED"
	RenameWindow #,G7
	SetActiveSubwindow ##
	
	//Graph 3,2
	Display/W=(0.333,0.6,0.334,0.923)/HOST=# VIOW vs t_VIOW
	WaveStats/Q/M=1 VIOW
	SetAxis left 0.0,1.2*V_max
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5
	ModifyGraph height=210,width={Aspect,1.75},fsize=12,lblMargin(bottom)=-40
	ModifyGraph grid(bottom)=1, tick=2, standoff=0,axisOnTop=1,mirror=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph lsize=3,rgb(VIOW)=(1,39321,19939)
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-3.54/Y=45 "\\Z11\\s(VIOW) VIOW"
	Label bottom "\\Z12time [ms]"
	RenameWindow #,G8
	SetActiveSubwindow ##
	
	//Graph 3,3
	Display/W=(0.666,0.6,1,0.923)/HOST=# AMINOR vs t_AMINOR
	AppendToGraph/C=(52428,1,1) VOLUME vs t_VOLUME
	WaveStats/Q/M=1 AMINOR
	SetAxis left 0,110*V_max
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5
	ModifyGraph height=210,width={Aspect,1.75},fsize=12,lblMargin(bottom)=-40
	ModifyGraph grid(bottom)=1, tick=2, standoff=0,axisOnTop=1,mirror=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph lsize=3,rgb(AMINOR)=(1,39321,19939),muloffset(AMINOR)={0,100}
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-3.54/Y=34.29 "\\Z11\\s(VOLUME) VOLUME [m**3]\r\\s(AMINOR) AMINOR [cm]"
	Label bottom "\\Z12time [ms]"
	RenameWindow #,G6
	SetActiveSubwindow ##
	
	SetDataFolder ::
EndMacro

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