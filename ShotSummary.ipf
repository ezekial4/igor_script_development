#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Window loadPanel() : Panel
	PauseUpdate; Silent 1		// building window...
	
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
	if(Exists("mds") !=2)
		Variable/G mds=0
	endif
	if(Exists("icoil_type") !=2)
		Variable/G icoil_type=0
	endif
	//End Prep

	NewPanel /W=(161,45,533,334)
	ModifyPanel cbRGB=(34181,50372,17990)
	TitleBox title0,pos={70,15},size={265,40},title="Load: Shot Summary"
	TitleBox title0,labelBack=(0,26214,13293),font="Myriad Pro Condensed",fSize=36,frame=5
	TitleBox title0,fStyle=1,fColor=(65535,65535,65535),anchor= MC,fixedSize=1
	CheckBox usePython,pos={80,160},size={106.00,16.00},title="from MDSplus"
	CheckBox usePython,labelBack=(0,0,0),font="Myriad Pro Condensed",fSize=14,variable= mds,fStyle=1
	CheckBox whicIC,pos={190,160},size={106.00,16.00},title="use PCS Icoil"
	CheckBox whicIC,labelBack=(0,0,0),font="Myriad Pro Condensed",fSize=14,variable= icoil_type,fStyle=1
	SetVariable setvar0,pos={125.00,57},size={137.00,24.00},title="Shot #:"
	SetVariable setvar0,labelBack=(0,26214,13293),font="Myriad Pro Condensed",fSize=24,fStyle=1
	SetVariable setvar0,fColor=(65535,65535,65535),valueColor=(65535,65535,65535)
	SetVariable setvar0,valueBackColor=(34952,13107,11822)
	SetVariable setvar0,limits={10000,inf,0},value= shotNum,styledText= 1
	SetVariable setvar1,pos={111.00,191.00},size={165,22.00},title="Plot Start Time:"
	SetVariable setvar1,labelBack=(0,26214,13293),font="Myriad Pro Condensed",fSize=20,fStyle=1
	SetVariable setvar1,fColor=(65535,65535,65535),valueColor=(65535,65535,65535)
	SetVariable setvar1,valueBackColor=(34952,13107,11822)
	SetVariable setvar1,limits={-inf,inf,0},value= tstart,styledText= 1
	SetVariable setvar2,pos={111.00,217.00},size={165,22.00},title="Plot End Time:   "
	SetVariable setvar2,labelBack=(0,26214,13293),font="Myriad Pro Condensed",fSize=20,fStyle=1
	SetVariable setvar2,fColor=(65535,65535,65535),valueColor=(65535,65535,65535)
	SetVariable setvar2,valueBackColor=(34952,13107,11822)
	SetVariable setvar2,limits={-inf,inf,0},value= tend,styledText= 1
	Button button0,pos={50,243.00},size={50.00,35},proc=ButtonProc,title="Plot"
	Button button0,fSize=28,fStyle=1,fColor=(1,39321,19939),font="Myriad Pro Condensed"
	SetVariable pathDSPL,pos={5.00,100.00},size={121,22},title="Path "
	SetVariable pathDSPL,labelBack=(0,26214,13293),font="Myriad Pro Condensed",fSize=18
	SetVariable pathDSPL,frame=0,fColor=(65535,65535,65535),fStyle=1
	SetVariable pathDSPL,valueColor=(65535,65535,65535),valueBackColor=(34952,13107,11822)
	SetVariable pathDSPL,limits={-inf,inf,0},value= Homepath,noedit= 1
	SetVariable pathDSPL1,pos={125,100},size={235,20.00},title=" "
	SetVariable pathDSPL1,labelBack=(39321,1,1),font="Myriad Pro Condensed",fSize=14
	SetVariable pathDSPL1,fStyle=2,valueColor=(65535,65535,65535)
	SetVariable pathDSPL1,valueBackColor=(34952,13107,11822)
	SetVariable pathDSPL1,limits={-inf,inf,0},value= Neupath
	Button MakePATH,pos={120.00,130.00},size={120.00,30.00},proc=ButtonProc_2,title="Make New Path?"
	Button MakePATH,font="Myriad Pro Condensed",fSize=18,fStyle=1,fColor=(1,39321,19939)
	Button button1,pos={150,244.00},size={50.00,35},proc=ButtonProc_3,title="Save"
	Button button1,fSize=28,fStyle=1,fColor=(1,39321,19939),font="Myriad Pro Condensed"
	Button button2,pos={240,244.00},size={85,35},proc=ButtonProc_4,title="CloseAll"
	Button button2,fSize=28,fStyle=1,fColor=(1,39321,19939),font="Myriad Pro Condensed"
EndMacro

Function ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR shotNum
			NVAR mds
			NVAR icoil_type
			print shotNum
			if(mds == 1)
			   print "here"
				getGAdataDUMP(shotNum, icoil_type)
			endif
			
			String fname = "paramDB_"+num2istr(shotNum)+".h5"
			print fname
			Variable fileID
			HDF5OpenFile/P=DataDump/R/Z fileID as fname
			HDF5LoadGroup/T/O/Z/IGOR=-1 :, fileID,"/"
			HDF5CloseFile/A/Z fileID
			Execute "Calc_nu_e(shotNum)"
			Execute "Calc_psep_pthres(shotNum)"
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

Function ButtonProc_3(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "sav2PDF()"
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_4(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "KillOverviews()"
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
	TextBox/C/N=text0/A=MB/X=-5.86/Y=1.90 "\\Z18\\f01\\F'Myriad Pro Condensed'Shot: \\{shotNum}"
	String savDF="root:paramDB_"+num2istr(shotNum)+":"
	String fldrSav0= GetDataFolder(1)
		
	// Graph 1,1
	SetDataFolder savDF
	Display/W=(0,0,0.334,0.295)/HOST=# DENSV3 vs t_DENSV3
	AppendToGraph/C=(1,39321,19939) DENSV2 vs t_DENSV2
	AppendToGraph/C=(1,34817,52428) DENSR0 vs t_DENSR0
	AppendToGraph/C=(65535,49151,49151,32768) NEPED vs t_NEPED
	ErrorBars/L=3/Y=2 NEPED Y,wave=(NEPED_ERR,NEPED_ERR)
	WaveStats/Q/m=1 DENSR0
	SetAxis left 0,1.1*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph rgb(DENSV3)=(52428,34958,1),lSize(DENSV3)=3,lSize(DENSV2)=3,lSize(DENSR0)=3
	ModifyGraph mode(NEPED)=3,msize(NEPED)=3,marker(NEPED)=19,useMrkStrokeRGB(NEPED)=1,mrkStrokeRGB(NEPED)=(52428,1,1), rgb(NEPED)=(65535,49151,49151,16384)
	ModifyGraph grid(bottom)=1,noLabel(bottom)=2,fSize(left)=15,prescaleExp(left)=-19
	ModifyGraph tick=2,height=210,mirror=1,standoff=0,axisOnTop=1 
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph fStyle(left)=1,font(left)="Myriad Pro Condensed"
	Label left " "
	Legend/C/N=text0/J/A=MC/X=0/Y=-40/H=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(DENSR0) DENSR0 \\M\\Z16[ x10\\S19 \\M\\Z16m\\S-3\\M\\Z16 ]     \\Z16\\s(DENSV2) DENSV2"
	AppendText/N=text0 "\\s(DENSV3) DENSV3                              \\s(NEPED)  NEPED"
	RenameWindow #,G0
	SetActiveSubwindow ##
	
	//Graph 1,2
	SetDataFolder savDF
	Display/W=(0.334,0,0.668,0.295)/HOST=#  IP vs t_IP
	AppendToGraph/C=(1,34817,52428) BT0VAC vs t_BT0VAC
	AppendToGraph/C=(1,39321,19939) LI vs t_LI
	AppendToGraph/C=(52428,34958,1) KAPPA vs t_KAPPA
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210, standoff=0,mirror=1,tick=2,lSize=3,fSize(left)=15,axisOnTop(left)=1
	ModifyGraph rgb(IP)=(52428,1,1),muloffset(IP)={0,1e-06},muloffset(BT0VAC)={0,-1} 
	ModifyGraph grid(bottom)=1,noLabel(bottom)=2,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph fStyle(left)=1,font(left)="Myriad Pro Condensed"
	Label left " "
	SetAxis left 0,*
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=1.09/Y=-40/H=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(IP) IP [MA]  \\s(BT0VAC) BT0 [T]\r\\s(LI) LI              \\s(KAPPA) KAPPA"
	RenameWindow #,G1
	SetActiveSubwindow ##
	
	//Graph 1,3
	SetDataFolder savDF
	Display/W=(0.666,0.2,1,0.295)/FG=(,FT,,)/HOST=#  H_THH98Y2 vs t_H_THH98Y2
	AppendToGraph/C=(1,39321,19939) H_L89 vs t_H_L89
	AppendToGraph/C=(52428,1,1) TAUE vs t_TAUE
	AppendToGraph/C=(52428,34958,1) TAU_P_STAR vs t_TAU_P_STAR
	WaveStats/Q/M=1 TAU_P_STAR
	SetAxis left 0.01,1.1*V_max
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75},height=210
	ModifyGraph rgb(H_THH98Y2)=(1,34817,52428)
	ModifyGraph muloffset(TAUE)={0,10},log(left)=1
	ModifyGraph grid(bottom)=1,noLabel(bottom)=2,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph tick=2,mirror=1,fSize(left)=15,standoff=0,axisOnTop=1, lSize=3
	ModifyGraph fStyle(left)=1,font(left)="Myriad Pro Condensed"
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=0/Y=-40/H=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(H_THH98Y2) H_THH98Y2        \\s(H_L89) H_L89\r\\s(TAUE) TAUE [x0.1 sec]  \\s(TAU_P_STAR) TAU_P_STAR [sec]"
	RenameWindow #,G2
	SetActiveSubwindow ##
	
	//Graph 2,1
	SetDataFolder savDF
	Display/W=(0,0.293,0.334,0.587)/HOST=#  TEPED vs t_TEPED
	AppendToGraph/C=(1,39321,19939,16384) TSTE_70 vs t_TSTE_70
	AppendToGraph/C=(57054,30326,11565,16384) TSTE_43 vs t_TSTE_43
	AppendToGraph/C=(52428,1,1) ECE15 vs t_ECE15
	AppendToGraph/C=(34181,50372,17990) ECE29 vs t_ECE29
	if(Exists("cerqtit1"))
		AppendToGraph/C=(25443,0,16448) cerqtit1 vs t_cerqtit1
	else
		Make/O/N=1 cerqtit1,t_cerqtit1 = 0.0
		AppendToGraph/C=(25443,0,16448) cerqtit1 vs cerqtit1
	endif
	if(Exists("cerqtit23"))
		AppendToGraph/C=(0,48573,56797) cerqtit23 vs t_cerqtit23
	else
		Make/O/N=1 cerqtit23, t_cerqtit23 = 0.0
		AppendToGraph/C=(0,48573,56797) cerqtit23 vs t_cerqtit23
	endif
	WaveStats/Q/M=1 ECE29
	SetAxis/N=2 left 100,1100*V_max
	ErrorBars/Y=2/L=2 TEPED Y,wave=(TEPED_ERR,TEPED_ERR)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75},height=210,noLabel(bottom)=2
	ModifyGraph mode(TEPED)=3,mode(TSTE_70)=3,msize(TEPED)=2,msize(TSTE_70)=2, lSize(ECE15)=3,lSize(ECE29)=3,lSize(cerqtit1)=3,lSize(cerqtit23)=3
	ModifyGraph marker(TEPED)=29,marker(TSTE_70)=29,mode(TSTE_43)=3,marker(TSTE_43)=29,msize(TSTE_43)=2
	ModifyGraph rgb(TEPED)=(1,34817,52428,16384),useMrkStrokeRGB(TEPED)=1,useMrkStrokeRGB(TSTE_70)=1,useMrkStrokeRGB(TSTE_43)=1
	ModifyGraph mrkStrokeRGB(TSTE_70)=(0,31097,13364),mrkStrokeRGB(TEPED)=(20560,37265,52685),mrkStrokeRGB(TSTE_43)=(57054,30326,11565)
	ModifyGraph muloffset(ECE15)={0,1000},muloffset(ECE29)={0,1000}
	ModifyGraph grid(bottom)=1,tick=2,mirror=1,fSize=15, standoff=0,prescaleExp(left)=-3,axisOnTop=1,log(left)=1
	ModifyGraph fStyle(left)=1,font(left)="Myriad Pro Condensed"
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left " "
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-10/Y=-40/H={6,0,0}  "\\Z16\\f01\\F'Myriad Pro Condensed'T_E [keV]: \\s(TSTE_43)TS(0)   \\s(TEPED)TS(ped) \\s(TSTE_70)TS(a)\r                      \\s(ECE29)ECE(0) \\s(ECE15)ECE(0.5)\rT_I [keV]:  \\s(cerqtit1)CER(0) \\s(cerqtit23)CER(ped)"
	RenameWindow #,G3
	SetActiveSubwindow ##
	
	//Graph 2,2
	SetDataFolder savDF
	Display/W=(0.333,0.294,0.667,0.589)/HOST=#  WMHD vs t_WMHD
	AppendToGraph/C=(1,34817,52428) BETAP vs t_BETAP
	AppendToGraph/C=(1,39321,19939) BETAN vs t_BETAN
	AppendToGraph/C=(52428,34958,1) BETAT vs t_BETAT
	WaveStats/Q/M=1 BETAT
	SetAxis left 0,1.02*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,lSize=3,tick=2,mirror=1,standoff=0,axisOnTop=1
	ModifyGraph rgb(WMHD)=(52428,1,1),muloffset(WMHD)={0,1e-06}
	ModifyGraph grid(bottom)=1,fSize(left)=15,noLabel(bottom)=2, manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph fStyle(left)=1,font(left)="Myriad Pro Condensed"
	Legend/C/N=text0/J/A=MC/X=0/Y=-40/H=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(WMHD) WMHD [MJ]\\s(BETAP) BETAP\r\\s(BETAN) BETAN          \\s(BETAT) BETAT"
	RenameWindow #,G4
	SetActiveSubwindow ##
	
	//Graph 2,3
	SetDataFolder savDF
	Display/W=(0.665,0.294,0.8,0.589)/FG=(,,FR,)/HOST=#  PRAD_TOT vs t_PRAD_TOT
	AppendToGraph/C=(1,39321,19939) PRAD_DIVU vs t_PRAD_DIVU
	AppendToGraph/C=(1,34817,52428) PRAD_DIVL vs t_PRAD_DIVL
	AppendToGraph/C=(0,0,0) POH vs t_POH
	AppendToGraph/C=(34181,50372,17990) P_SEP vs t_POH
	AppendToGraph/C=(65535,34848,13326) P_THRES vs t_POH
	Duplicate/O PINJF, PINJF_smth
	//Smooth/MPCT=75/M=0 401, PINJF_smth
	Smooth/B 301, PINJF_smth
	AppendToGraph/C=(52428,34958,1) PINJF_smth vs t_PINJF
	PINJF_smth *=1000
	AppendToGraph/C=(26214,26214,26214) ECHPWRC vs t_ECHPWRC
	WaveStats/Q/M=1 PINJF_smth
	SetAxis/N=2 left 0,V_max
	SetAxis bottom root:tstart,root:tend
	ReorderTraces POH,{ECHPWRC,PINJF_smth,PRAD_TOT,PRAD_DIVU,PRAD_DIVL}
	SetDataFolder fldrSav0
	ModifyGraph rgb(PRAD_TOT)=(52428,1,1),prescaleExp(left)=-6
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,manTick(bottom)={0,1000,0,0}
	ModifyGraph height=210,width={Aspect,1.75}
	ModifyGraph lSize=3,fSize(left)=15,noLabel(bottom)=2,tick=2, standoff=0,mirror=1,axisOnTop=1,grid(bottom)=1,manMinor(bottom)={1,0}
	ModifyGraph mode(PRAD_TOT)=7,mode(PRAD_DIVU)=7,hbFill(PRAD_DIVU)=2,toMode(PRAD_DIVU)=3,mode(PRAD_DIVL)=7,hbFill(PRAD_DIVL)=2,hbFill(PRAD_TOT)=2
	ModifyGraph fStyle(left)=1,font(left)="Myriad Pro Condensed"
	Label left " "
	Legend/C/N=text0/J/A=MC/X=0/Y=31.90/H=9 "\\Z13\\f01\\F'Myriad Pro Condensed'\\s(PRAD_TOT) PRAD_TOT [MW]     \\s(PRAD_DIVU) PRAD_DIVU\r\\s(PRAD_DIVL) PRAD_DIVL                \\s(PINJF_smth) PINJ\r\\s(POH) POH                               \\s(ECHPWRC) PECH\r\Z13\\s(P_SEP) P_SEP                       \\s(P_THRES) P_THRES"
	RenameWindow #,G5
	SetActiveSubwindow ##
	
	//Graph 3,1
	SetDataFolder savDF
	Display/W=(0,0.588,0.334,0.923)/HOST=#  Q95 vs t_Q95
	AppendToGraph/C=(1,39321,19939) Q0 vs t_Q0
	AppendToGraph/C=(52428,34958,1) QMIN vs t_QMIN
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210, lSize=3,tick=2,mirror=1,fSize=15,standoff=0, axisOnTop=1,rgb(Q95)=(52428,1,1),grid(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0},lblMargin(bottom)=-40,lstyle(QMIN)=3
	ModifyGraph fStyle=1,font="Myriad Pro Condensed"
	Label bottom "\\Z15time [ms]"
	SetAxis left 0.5,6
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=-0.2/Y=-5/H=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(Q95) Q95\r\\s(Q0) Q0\r\\s(QMIN) QMIN"
	RenameWindow #,G6
	SetActiveSubwindow ##
	
	//Graph 3,2
	SetDataFolder savDF
	Display/W=(0.333,0.588,0.666,0.923)/HOST=# /R FS03 vs t_FS03
	AppendToGraph/R/C=(52428,34958,1) FS01 vs t_FS01
	Duplicate/O ELM_freq,ELM_freq_smth
	if(numpnts(ELM_freq) > 5)
		Smooth/MPCT=25/M=0 11, ELM_freq_smth
	else
		ELM_freq_smth = 0.1
	endif
	AppendToGraph/C=(56797,56797,56797,16384) ELM_freq_smth vs t_ELM_freq
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=4
	ModifyGraph height=210,width={Aspect,1.75}
	ModifyGraph mode(ELM_freq_smth)=3,msize(ELM_freq_smth)=5,marker(ELM_freq_smth)=19,useMrkStrokeRGB(ELM_freq_smth)=1
	ModifyGraph rgb(FS03)=(1,39321,19939)
	ModifyGraph grid(bottom)=1
	ModifyGraph log(left)=1
	ModifyGraph tick=2
	ModifyGraph mirror(bottom)=1
	ModifyGraph noLabel(right)=2
	ModifyGraph fSize=15,standoff=0,axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph fStyle=1,font="Myriad Pro Condensed"
	Label bottom "\\Z15time [ms]"
	SetAxis right 0,100000000000000000
	SetAxis bottom root:tstart,root:tend
	SetAxis left 1,1000
	Legend/C/N=text0/J/A=MC/X=6.54/Y=34.76/H=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(FS01) FS01\r\\s(FS03) FS03\r\\s(ELM_freq_smth) ELM_freq_smth"
	RenameWindow #,G7
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
	ModifyGraph muloffset(DRSEP)={0,10000},axisOnTop=1,prescaleExp(left)=-3,standoff=0,fSize=15,mirror=1,zero(left)=2,tick=2
	ModifyGraph grid(bottom)=1,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	ModifyGraph fStyle=1,font="Myriad Pro Condensed"
	Label left "[kA] "
	Label bottom "\\Z15time [ms]"
	SetAxis bottom root:tstart,root:tend
	Legend/C/N=text0/J/A=MC/X=35/Y=3 "\\Z13\\f01\\F'Myriad Pro Condensed'\\s(IL30) IL30\r\\s(IL90) IL90\r\\s(IL150) IL150\r\\s(IL210) IL210\r\\s(IL270) IL270\r\\s(IL330) IL330\r\\s(IU30) IU30"
	AppendText "\\s(IU90) IU90\r\\s(IU150) IU150\r\\s(IU210) IU210\r\\s(IU270) IU270\r\\s(IU330) IU330\r\\s(DRSEP) DRSEP"
	RenameWindow #,G8
	SetActiveSubwindow ##
EndMacro

Window Overview_p2() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(1279,45,2501,789)
	TextBox/C/N=text0/A=MB/X=-5.86/Y=1.90 "\\Z18\\f01\\F'Myriad Pro Condensed'Shot: \\{shotNum}"
	String savDF="root:paramDB_"+num2istr(shotNum)+":"
	String fldrSav0= GetDataFolder(1)
	
	//Graph 1,1
	SetDataFolder savDF
	Display/W=(0,0,0.333,0.295)/HOST=#  BDOTEVAMPL vs t_BDOTEVAMPL
	AppendToGraph BDOTODAMPL vs t_BDOTODAMPL
	WaveStats/Q/M=1 BDOTODAMPL
	SetAxis left 0,1.02*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,mode=7,lSize=3
	ModifyGraph rgb(BDOTEVAMPL)=(52428,1,1),rgb(BDOTODAMPL)=(1,34817,52428)
	ModifyGraph hbFill=2,toMode=3
	ModifyGraph grid(bottom)=1,tick=2,mirror=1
	ModifyGraph font="Myriad Pro Condensed"
	ModifyGraph noLabel(bottom)=2,fSize=15,fStyle=1,standoff=0,axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Legend/C/N=text0/J/A=MC/X=3.00/Y=35.24 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(BDOTEVAMPL) BDOTEVAMPL\r\\s(BDOTODAMPL) BDOTODAMPL"
	RenameWindow #,G0
	SetActiveSubwindow ##
		
	// Graph 1,2
	SetDataFolder savDF
	Display/W=(0.333,0,0.666,0.295)/HOST=#  PEPED vs t_PEPED
	ErrorBars/L=3/Y=2 PEPED Y,wave=(PEPED_ERR,PEPED_ERR)
	WaveStats/Q/M=1 PEPED
	SetAxis left 0,1.02*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,mode=3,marker=19,rgb=(65535,49151,49151,32768),msize=4,useMrkStrokeRGB=1
	ModifyGraph mrkStrokeRGB=(52428,1,1),grid(bottom)=1,tick=2,mirror=1,font="Myriad Pro Condensed",noLabel(bottom)=2
	ModifyGraph fSize=15,fStyle=1,standoff=0,axisOnTop=1,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Legend/C/N=text0/J/A=MC/X=0/Y=-40 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(PEPED) PEPED [kPa]"
	RenameWindow #,G1
	SetActiveSubwindow ##
	
	// Graph 1,3
	SetDataFolder savDF
	Display/W=(0.666,0,0.999,0.295)/HOST=#  NEWID vs t_NEWID
	AppendToGraph PEWID vs t_PEWID
	AppendToGraph TEWID vs t_TEWID
	ErrorBars/L=2/Y=2 NEWID Y,wave=(NEWID_ERR,NEWID_ERR)
	ErrorBars/L=2/Y=2 PEWID Y,wave=(PEWID_ERR,PEWID_ERR)
	ErrorBars/L=2/Y=2 TEWID Y,wave=(TEWID_ERR,TEWID_ERR)
	WaveStats/Q/M=1 TEWID
	SetAxis left 0.01,1.02*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,mode=3,marker=19,lSize=3
	ModifyGraph rgb(NEWID)=(65535,49151,49151,32768),rgb(PEWID)=(49151,65535,49151,32768)
	ModifyGraph rgb(TEWID)=(49151,60031,65535,32768),msize=2
	ModifyGraph useMrkStrokeRGB=1,mrkStrokeRGB(NEWID)=(52428,1,1),mrkStrokeRGB(PEWID)=(1,39321,19939)
	ModifyGraph mrkStrokeRGB(TEWID)=(1,34817,52428),grid(bottom)=1,log(left)=1,tick=2,mirror=1,font="Myriad Pro Condensed"
	ModifyGraph noLabel(bottom)=2,fSize=15,fStyle=1,standoff=0,axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Legend/C/N=text0/J/A=MC/X=3.27/Y=41.90 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(NEWID) NEWID   \\s(PEWID) PEWID   \\s(TEWID) TEWID"
	RenameWindow #,G2
	SetActiveSubwindow ##
	
	// Graph 2,1
	SetDataFolder savDF
	Display/W=(0,0.302,0.333,0.596)/HOST=#  N1RMS vs t_N1RMS
	AppendToGraph N2RMS vs t_N2RMS
	AppendToGraph N3RMS vs t_N3RMS
	AppendToGraph N4RMS vs t_N4RMS
	WaveStats/Q/M=1 N1RMS
	SetAxis left 0.0,1.2*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,mode=7,lSize=3
	ModifyGraph rgb(N1RMS)=(65535,43690,0),rgb(N2RMS)=(52428,1,1),rgb(N3RMS)=(1,34817,52428)
	ModifyGraph rgb(N4RMS)=(1,39321,19939)
	ModifyGraph hbFill=2,toMode=3,grid(bottom)=1,tick=2,mirror=1,font="Myriad Pro Condensed"
	ModifyGraph noLabel(bottom)=2,fSize=15,fStyle=1,standoff=0,axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Legend/C/N=text0/J/A=MC/X=0/Y=30.00 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(N1RMS) N1RMS\r\\s(N2RMS) N2RMS\r\\s(N3RMS) N3RMS\r\\s(N4RMS) N4RMS"
	RenameWindow #,G5
	SetActiveSubwindow ##
	
	// Graph 2,2
	SetDataFolder savDF
	Display/W=(0.333,0.305,0.665,0.599)/HOST=#  cerqrotct23 vs t_cerqrotct23
	AppendToGraph cerqrotct1 vs t_cerqrotct1
	WaveStats/Q/M=1 cerqrotct1
	SetAxis left 0.0,1.2*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210
	ModifyGraph lSize=3
	ModifyGraph rgb(cerqrotct23)=(52428,1,1),rgb(cerqrotct1)=(0,31097,13364)
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font="Myriad Pro Condensed"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize=15
	ModifyGraph fStyle=1
	ModifyGraph standoff=0
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Legend/C/N=text0/J/A=MC/X=0/Y=-40/H=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(cerqrotct23) Edge Rotation [krad/s]\r\\s(cerqrotct1) Core Rotation"
	RenameWindow #,G3
	SetActiveSubwindow ##
	
	// Graph 2,3
	SetDataFolder savDF
	Display/W=(0.666,0.305,0.999,0.599)/HOST=#  RVSOUT vs t_RVSOUT
	SetAxis left 1.3,1.4
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=5,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210,lSize=3,rgb=(52428,1,1)
	ModifyGraph grid(bottom)=1,tick=2,mirror=1,font="Myriad Pro Condensed",noLabel(bottom)=2,fSize=15
	ModifyGraph fStyle=1,standoff=0,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Legend/C/N=text0/J/A=MC/X=0.00/Y=2.86/h=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(RVSOUT) RVSOUT"
	RenameWindow #,G4
	SetActiveSubwindow ##
	
	// Graph 3,1
	SetDataFolder savDF
	Display/W=(0,0.6,0.333,0.935)/HOST=#  NU_E_STAR vs t_NEPED
	AppendToGraph f_GW vs t_NEPED
	AppendToGraph f_GW_PED vs t_NEPED
	WaveStats/Q/M=1 NU_E_STAR
	SetAxis left 0.1,1.2*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210
	ModifyGraph lSize=3
	ModifyGraph rgb(NU_E_STAR)=(52428,1,1),rgb(f_GW)=(1,34817,52428),rgb(f_GW_PED)=(1,39321,19939)
	ModifyGraph grid(bottom)=1
	ModifyGraph log(left)=1
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font="Myriad Pro Condensed"
	ModifyGraph fSize=15
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(bottom)=-40
	ModifyGraph standoff=0
	ModifyGraph axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label bottom "\\Z15time [ms]"
	Legend/C/N=text0/J/A=MC/X=-1.09/Y=46.67/H=9 "\\Z16\\f01\\F'Myriad Pro Condensed'\\s(NU_E_STAR) NU_E_STAR   \\s(F_GW) F_GW    \\s(F_GW_PED) F_GW_PED"
	RenameWindow #,G7
	SetActiveSubwindow ##
	
	// Grpah 3,2
	SetDataFolder savDF
	Display/W=(0.333,0.6,0.665,0.935)/HOST=#  VIOW vs t_VIOW
	Duplicate/O TINJ, TINJ_smth
	//Smooth/MPCT=75/M=0 301, TINJ_smth
	Smooth/B 301, TINJ_smth
	AppendToGraph/C=(20560,37265,52685) TINJ_smth vs t_TINJ
	WaveStats/Q/M=1 TINJ_smth
	AppendToGraph fzns vs t_fzns
	SetAxis left 0.0,1.2*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210
	ModifyGraph lSize=3
	ModifyGraph rgb(VIOW)=(1,39321,19939),rgb(fzns)=(52428,1,1)
	ModifyGraph grid(bottom)=1,tick=2,mirror=1
	ModifyGraph font="Myriad Pro Condensed"
	ModifyGraph fSize=15,fStyle=1
	ModifyGraph lblMargin(bottom)=-40
	ModifyGraph standoff=0
	ModifyGraph axisOnTop=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label bottom "\\Z15time [ms]"
	Legend/C/N=text0/J/A=MC/X=3.81/Y=34.29/H=9"\\Z16\\f01\\F'Myriad Pro Condensed'\\s(VIOW) VIOW\r\\s(FZNS) FZNS\r\\s(TINJ_smth) NBI NET TORQUE"
	RenameWindow #,G8
	SetActiveSubwindow ##
	
	// Graph 3,3
	SetDataFolder savDF
	Display/W=(0.666,0.6,0.998,0.935)/HOST=#  AMINOR vs t_AMINOR
	AppendToGraph VOLUME vs t_VOLUME
	AppendToGraph GAPOUT vs t_GAPOUT
	AppendToGraph TRIBOT vs t_TRIBOT
	AppendToGraph TRITOP vs t_TRITOP
	WaveStats/Q/M=1 AMINOR
	SetAxis left 0.01,120*V_max
	SetAxis bottom root:tstart,root:tend
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=35,margin(bottom)=35,margin(top)=5,margin(right)=5,width={Aspect,1.75}
	ModifyGraph height=210
	ModifyGraph lSize=3
	ModifyGraph rgb(AMINOR)=(1,39321,19939),rgb(VOLUME)=(52428,1,1),rgb(GAPOUT)=(65535,43690,0)
	ModifyGraph rgb(TRIBOT)=(26214,26214,26214),rgb(TRITOP)=(20560,37265,52685)
	ModifyGraph muloffset(AMINOR)={0,100}
	ModifyGraph grid(bottom)=1
	ModifyGraph log(left)=1
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font="Myriad Pro Condensed"
	ModifyGraph fSize=15
	ModifyGraph fStyle=1
	ModifyGraph lblMargin(bottom)=-40
	ModifyGraph standoff=0,axisOnTop=1,manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label bottom "\\Z15time [ms]"
	Legend/C/N=text0/J/A=MC/X=3.27/Y=22.38 "\\Z13\\f01\\F'Myriad Pro Condensed'\\s(VOLUME) VOLUME [m**3]\r\\s(AMINOR) AMINOR [cm] \r\\s(GAPOUT) GAPOUT [cm]\r\\s(TRIBOT) TRIBOT  "
	AppendText "\\s(TRITOP) TRITOP"
	RenameWindow #,G6
	SetActiveSubwindow ##
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
	Variable/G shotNum 
	String totpath = HomePath+Neupath+":"+num2istr(shotNum)
	NewPath/Q/O DataDump totpath
	
	return 0
End

Function sav2PDF()

	SavePICT/O/P=DataDump/E=1/EF=2/WIN=Overview_p1
	SavePICT/O/P=DataDump/E=1/EF=2/WIN=Overview_p2
	return 0
End

Function KillOverviews()
	KillWindow/Z Overview_p1
	KillWindow/Z Overview_p2
	return 0
End