#pragma rtGlobals=1		// Use modern global access method.


Window Uber_Kontroller() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(374,109,908,522) as "Uber_Kontrolle"
	ModifyPanel cbRGB=(43690,43690,43690), frameInset=3
	ShowTools/A
	SetDrawLayer UserBack
	SetDrawEnv fname= "Helvetica",fstyle= 1
	DrawText 19,136,"Where to get data?"
	SetDrawEnv linethick= 2,linefgc= (52428,52428,52428)
	DrawLine -0.0203442879499218,0.296875,0.995305164319249,0.296875
	TitleBox Uber_title,pos={5,5},size={521,34},title="UberKontrol for Midplane Filterscope to Neutral Density"
	TitleBox Uber_title,labelBack=(8738,8738,8738),font="Gill Sans",fSize=22,frame=4
	TitleBox Uber_title,fColor=(65535,65535,65535)
	GroupBox FSmid_group,pos={7,82},size={305,100},labelBack=(65535,65535,65535)
	GroupBox FSmid_group,font="Gill Sans",fSize=16
	SetVariable SetShot,pos={25,48},size={125,22},title="Shot #"
	SetVariable SetShot,labelBack=(34952,34952,34952),font="Gill Sans",fSize=16
	SetVariable SetShot,limits={0,135000,1},value= ishot
	Button Pre_process_FS_mid,pos={12,146},size={180,25},proc=PreProcess_button,title="Go and PreProcess FSmidData"
	Button Pre_process_FS_mid,font="Gill Sans",fColor=(0,17409,26214)
	CheckBox GA_data,pos={135,121},size={75,15},proc=Radio_Change,title="GA server"
	CheckBox GA_data,font="Helvetica Neue",fSize=12,fStyle=1,value= 1,mode=1
	CheckBox Local_data,pos={212,121},size={89,15},proc=Radio_Change,title="Local server"
	CheckBox Local_data,font="Helvetica Neue",fSize=12,fStyle=1,value= 0,mode=1
	GroupBox Get_Zipfit_data,pos={320,81},size={200,100}
	GroupBox Get_Zipfit_data,labelBack=(65535,65535,65535),font="Gill Sans",fSize=16
	Button Plot_fs_data,pos={198,146},size={50,25},proc=FS_plot,title="Plot It!"
	Button Plot_fs_data,font="Gill Sans",fSize=14,fColor=(0,13107,0)
	SetVariable Etemp_nam,pos={367,113},size={106,15},title="Temp. Name"
	SetVariable Etemp_nam,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable Etemp_nam,fSize=10,fStyle=1,limits={-inf,inf,0},value= fname_temp
	SetVariable dens_nam,pos={367,130},size={106,15},title="Density Name"
	SetVariable dens_nam,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable dens_nam,fSize=10,fStyle=1,limits={-inf,inf,0},value= fname_dens
	Button zipfit_get,pos={333,151},size={60,25},proc=Zipfit_get,title="Get 'em!"
	Button zipfit_get,font="Gill Sans",fSize=14,fColor=(0,17409,26214)
	Button Plot_zipfit_data,pos={400,151},size={50,25},proc=Zipfit_plot,title="Plot It!"
	Button Plot_zipfit_data,font="Gill Sans",fSize=14,fColor=(0,13107,0)
	GroupBox Average_wave,pos={21,190},size={150,100},labelBack=(65535,65535,65535)
	GroupBox Average_wave,font="Gill Sans",fSize=16,fStyle=0
	SetVariable Numpnts_avg,pos={40,220},size={115,13},bodyWidth=35,title="Smooth Pnts. = "
	SetVariable Numpnts_avg,font="Helvetica",fSize=10,fStyle=1
	SetVariable Numpnts_avg,limits={-inf,inf,0},value= root:s132463:numpnt
	Button Avg_wav,pos={49,262},size={55,20},proc=Avg_waves,title="Do AVG"
	Button Avg_wav,font="Gill Sans",fColor=(0,17409,26214)
	SetVariable time_display,pos={62,236},size={78,18},disable=2,title="time  ="
	SetVariable time_display,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable time_display,fSize=12,frame=0,fStyle=1
	SetVariable time_display,limits={0,200,0},value= root:s132463:Time_avg_num
	Button Kill_fs_data_1,pos={254,146},size={50,25},proc=Kill_fs_data_1,title="Kill It!"
	Button Kill_fs_data_1,font="Gill Sans",fSize=14,fColor=(13107,0,0)
	Button Kill_zipfit_data,pos={456,151},size={50,25},proc=Kill_zipfit_data,title="Kill It!"
	Button Kill_zipfit_data,font="Gill Sans",fSize=14,fColor=(13107,0,0)
	Button Plot_fs_data_1,pos={121,259},size={30,25},proc=FS_plot,title="Plot"
	Button Plot_fs_data_1,font="Gill Sans",fSize=14,fColor=(0,13107,0)
	GroupBox Timepnt_wave,pos={184,191},size={150,100},labelBack=(65535,65535,65535)
	GroupBox Timepnt_wave,font="Gill Sans",fSize=16,fStyle=0
	CheckBox make_zipfit_profile,pos={190,225},size={133,14},title="Make dens & temp profile?"
	CheckBox make_zipfit_profile,labelBack=(65535,65535,65535)
	CheckBox make_zipfit_profile,font="Helvetica Neue Light",fSize=9,fStyle=1
	CheckBox make_zipfit_profile,variable= zipfit_YN
	SetVariable TIME_WAVE,pos={194,244},size={125,14},title="Time Pnt Waves"
	SetVariable TIME_WAVE,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable TIME_WAVE,fStyle=1,limits={-inf,inf,0},value= Timepnts
	Button Prof_build,pos={231,263},size={50,20},proc=Build_prof_button,title="Make"
	Button Prof_build,font="Gill Sans",fColor=(0,17409,26214)
	TitleBox Pre_process,pos={59,86},size={202,27},title="(1) Setup & Pre-process"
	TitleBox Pre_process,labelBack=(21845,21845,21845),font="Gill Sans",fSize=16
	TitleBox Pre_process,frame=4,fStyle=1,fColor=(65535,65535,65535),anchor= MC
	TitleBox fs_chnl,pos={172,50},size={135,19},title="Filterscope Channel?"
	TitleBox fs_chnl,labelBack=(34952,34952,34952),font="Gill Sans",fSize=16,frame=0
	CheckBox FS_chan1,pos={315,51},size={72,19},proc=Radio_Change2,title="D_alpha"
	CheckBox FS_chan1,labelBack=(0,0,0),font="Gill Sans",fSize=16,fStyle=0
	CheckBox FS_chan1,value= 1,mode=1
	CheckBox FS_Chan2,pos={397,51},size={42,19},proc=Radio_Change2,title="CIII"
	CheckBox FS_Chan2,font="Gill Sans",fSize=16,fStyle=0,value= 1,mode=1
	TitleBox grab_profs,pos={341,82},size={156,27},title="(1a) Grab Profiles?"
	TitleBox grab_profs,labelBack=(21845,21845,21845),font="Gill Sans",fSize=16
	TitleBox grab_profs,frame=4,fStyle=1,fColor=(65535,65535,65535),anchor= MC
	TitleBox time_avg,pos={39,192},size={115,25},title="(2) Time Avg. Wave"
	TitleBox time_avg,labelBack=(21845,21845,21845),font="Gill Sans",fSize=14
	TitleBox time_avg,frame=4,fStyle=0,fColor=(65535,65535,65535),anchor= MC
	TitleBox create_profs,pos={201,193},size={114,25},title="(3) Create Profiles"
	TitleBox create_profs,labelBack=(21845,21845,21845),font="Gill Sans",fSize=14
	TitleBox create_profs,frame=4,fStyle=0,fColor=(65535,65535,65535),anchor= MC
	ToolsGrid grid=(0,28.35,5)
EndMacro


Function PreProcess_button(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Pre_process_FS_mid(ishot,ga,local)"
			break
	endswitch

	return 0
End

Function Radio_Change(name,value)
	String name
	Variable value
	
	NVAR gRadioVal= root:gRadioVal
	
	strswitch (name)
		case "GA_data":
			gRadioVal= 1
			break
		case "Local_data":
			gRadioVal= 2
			break
	endswitch
	CheckBox GA_data,value= gRadioVal==1
	CheckBox Local_data,value= gRadioVal==2
End

Function Radio_Change2(name2,value2)
	String name2
	Variable value2
	
	NVAR gRadioVal2= root:gRadioVal2
	
	strswitch (name2)
		case "D_alpha":
			gRadioVal2= 1
			break
		case "CIII":
			gRadioVal2= 2
			break
	endswitch
	CheckBox GA_data,value= gRadioVal2==1
	CheckBox Local_data,value= gRadioVal2==2
End

Window Plot_fs_data() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	String dataset = "root:s"+num2istr(ishot)
	string septrix = "rmidout_"+num2istr(ishot)
	SetDataFolder dataset
	Display /W=(7,44,559,465) fsmid1_L vs t_fsmid1_L
	AppendToGraph fsmid2_L vs t_fsmid2_L
	AppendToGraph fsmid3_L vs t_fsmid3_L
	AppendToGraph fsmid4_L vs t_fsmid4_L
	AppendToGraph fsmid5_L vs t_fsmid5_L
	AppendToGraph fsmid6_L vs t_fsmid6_L
	AppendToGraph fsmid7_L vs t_fsmid7_L
	AppendToGraph fsmid8_L vs t_fsmid8_L
	AppendToGraph/R $septrix vs $"t_"+septrix
	SetDataFolder fldrSav0
	ModifyGraph mode(fsmid1_L)=3,mode(fsmid2_L)=3,mode(fsmid3_L)=3,mode(fsmid4_L)=3
	ModifyGraph mode(fsmid5_L)=3,mode(fsmid6_L)=3,mode(fsmid7_L)=3,mode(fsmid8_L)=3
	ModifyGraph mode($septrix)=4
	ModifyGraph marker(fsmid1_L)=16,marker(fsmid2_L)=16,marker(fsmid3_L)=16,marker(fsmid4_L)=16
	ModifyGraph marker(fsmid5_L)=16,marker(fsmid6_L)=16,marker(fsmid7_L)=16,marker(fsmid8_L)=16
	ModifyGraph marker($septrix)=19
	ModifyGraph rgb(fsmid1_L)=(0,0,65535),rgb(fsmid2_L)=(3,52428,1),rgb(fsmid4_L)=(52428,52425,1)
	ModifyGraph rgb(fsmid5_L)=(65535,16385,55749),rgb(fsmid6_L)=(0,0,0),rgb(fsmid7_L)=(26214,26214,26214)
	ModifyGraph rgb(fsmid8_L)=(1,52428,52428)
	ModifyGraph msize(fsmid1_L)=2,msize(fsmid2_L)=2,msize(fsmid3_L)=2,msize(fsmid4_L)=2
	ModifyGraph msize(fsmid5_L)=2,msize(fsmid6_L)=2,msize(fsmid7_L)=2,msize(fsmid8_L)=2
	ModifyGraph msize($septrix)=4
	ModifyGraph useMrkStrokeRGB($septrix)=1,standoff=0,tick=2,mirror(bottom)=1
	ModifyGraph manTick(bottom)={0,500,0,0},manMinor(bottom)={0,0}
	SetAxis bottom 0,6000
	Legend/C/N=text0/J/F=0/A=MC/X=-30.28/Y=31.68 "\\s(fsmid1_L) fsmid1_L\r\\s(fsmid2_L) fsmid2_L\r\\s(fsmid3_L) fsmid3_L\r\\s(fsmid4_L) fsmid4_L\r\\s(fsmid5_L) fsmid5_L"
	AppendText "\\s(fsmid6_L) fsmid6_L\r\\s(fsmid7_L) fsmid7_L\r\\s(fsmid8_L) fsmid8_L\r\\s(rout_fsmid) rout_fsmid"
EndMacro

Window Plot_zipfit_data() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(79,171,1409,660)
	ShowInfo
	Display/W=(0,0,0.5,1)/HOST=# 
	AppendMatrixContour :s132463:dens_132463_plot vs {:s132463:time_132463_plot,:s132463:rho_132463_plot}
	ModifyContour dens_132463_plot autoLevels={0,9,16}, rgbLines=(65535,0,0), labels=0
	AppendImage :s132463:dens_132463_plot vs {:s132463:time_132463_plot,:s132463:rho_132463_plot}
	ModifyImage dens_132463_plot ctab= {0,9,PlanetEarth256,0}
	ModifyGraph margin(bottom)=30,margin(top)=75,margin(right)=10
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph mirror(left)=1,mirror(bottom)=2
	ModifyGraph font="Helvetica"
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph gridRGB(bottom)=(43690,43690,43690)
	ModifyGraph prescaleExp(bottom)=-3
	ModifyGraph manTick(bottom)={0,0.5,0,1},manMinor(bottom)={0,0}
	Label bottom "Time [s]"
	SetAxis left 0.5,1.21
	SetAxis bottom 0,6000
	Cursor/P/I A dens_132463_plot 146,96
	ColorScale/C/N=text0/F=0/A=MC/X=-0.50/Y=60.32 image=dens_132463_plot, vert=0
	ColorScale/C/N=text0 side=2, tickLen=0.5
	AppendText "Electron Density [X10^19 m^-3]"
	SetDrawLayer UserFront
	DrawLine 2.1,0.296875,1.05,0.296875
	SetDrawEnv linethick= 2,linefgc= (52428,52428,52428)
	DrawLine 0.005,0.296875,1.01833333333333,0.296875
	RenameWindow #,G0
	SetActiveSubwindow ##
	Display/W=(0.501,0,1,1)/FG=(,,,FB)/HOST=# 
	AppendMatrixContour :s132463:etemp_132463_plot vs {:s132463:time_etemp_132463,:s132463:rho_etemp_132463}
	ModifyContour etemp_132463_plot autoLevels={0,6,16}, rgbLines=(65535,65535,65535)
	ModifyContour etemp_132463_plot labels=0
	AppendImage :s132463:etemp_132463_plot vs {:s132463:time_etemp_132463_plot,:s132463:rho_etemp_132463_plot}
	ModifyImage etemp_132463_plot ctab= {0,6,BlueHot256,0}
	ModifyGraph margin(left)=15,margin(bottom)=30,margin(top)=75,margin(right)=10
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font="Helvetica"
	ModifyGraph noLabel(left)=2
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph gridRGB(bottom)=(43690,43690,43690)
	ModifyGraph prescaleExp(bottom)=-3
	ModifyGraph manTick(bottom)={0,0.5,0,1},manMinor(bottom)={0,0}
	Label bottom "Time [s]"
	SetAxis left 0.5,1.21
	SetAxis bottom 0,6000
	ColorScale/C/N=text0/F=0/A=MC/X=1.25/Y=61.20 image=etemp_132463_plot, vert=0
	ColorScale/C/N=text0 side=2, tickLen=0.5
	AppendText "Electron Temperature (keV)"
	SetDrawLayer UserFront
	SetDrawEnv linethick= 2,linefgc= (52428,52428,52428)
	DrawLine -0.0203442879499218,0.296875,0.995305164319249,0.296875
	RenameWindow #,G1
	SetActiveSubwindow ##
EndMacro

Window avg_fsmid_signal_layout() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(163,66,852,1098)
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0,1,0.125)/HOST=#  fsmid1_plus,fsmid1_minus vs t_fsmid1_L
	AppendToGraph fsmid1_L_avg vs t_fsmid1_L
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph mode(fsmid1_plus)=7
	ModifyGraph marker(fsmid1_L_avg)=19
	ModifyGraph lSize(fsmid1_L_avg)=2
	ModifyGraph rgb(fsmid1_plus)=(49151,53155,65535),rgb(fsmid1_minus)=(49151,53155,65535)
	ModifyGraph rgb(fsmid1_L_avg)=(0,0,65535)
	ModifyGraph msize(fsmid1_L_avg)=1
	ModifyGraph hbFill(fsmid1_plus)=2
	ModifyGraph usePlusRGB(fsmid1_plus)=1
	ModifyGraph plusRGB(fsmid1_plus)=(49151,53155,65535)
	ModifyGraph toMode(fsmid1_plus)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left "[X10\\S13\\M  cm\\S-2\\Mstr\\S-1\\Ms\\S-1\\M]"
	SetAxis left 0,100000000000000
	SetAxis bottom 0,6000
	RenameWindow #,G0
	SetActiveSubwindow ##
	String fldrSav1= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.125,1,0.25)/HOST=#  fsmid2_plus,fsmid2_minus vs t_fsmid2_L
	AppendToGraph fsmid2_L_avg vs t_fsmid2_L
	SetDataFolder fldrSav1
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph mode(fsmid2_plus)=7
	ModifyGraph lSize(fsmid2_L_avg)=2
	ModifyGraph rgb(fsmid2_plus)=(49151,65535,49151),rgb(fsmid2_minus)=(49151,65535,49151)
	ModifyGraph rgb(fsmid2_L_avg)=(1,26214,0)
	ModifyGraph msize(fsmid2_L_avg)=2
	ModifyGraph hbFill(fsmid2_plus)=2
	ModifyGraph usePlusRGB(fsmid2_plus)=1
	ModifyGraph plusRGB(fsmid2_plus)=(49151,65535,49151)
	ModifyGraph toMode(fsmid2_plus)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13
	ModifyGraph axisOnTop(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left "[X10\\S13\\M  cm\\S-2\\Mstr\\S-1\\Ms\\S-1\\M]"
	SetAxis left 0,100000000000000
	SetAxis bottom 0,6000
	RenameWindow #,G1
	SetActiveSubwindow ##
	String fldrSav2= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.25,1,0.375)/HOST=#  fsmid3_plus,fsmid3_minus vs t_fsmid3_L
	AppendToGraph fsmid3_L_avg vs t_fsmid3_L
	SetDataFolder fldrSav2
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph mode(fsmid3_plus)=7
	ModifyGraph lSize(fsmid3_L_avg)=2
	ModifyGraph rgb(fsmid3_plus)=(65535,49151,49151),rgb(fsmid3_minus)=(65535,49151,49151)
	ModifyGraph msize(fsmid3_L_avg)=1
	ModifyGraph hbFill(fsmid3_plus)=2
	ModifyGraph usePlusRGB(fsmid3_plus)=1
	ModifyGraph plusRGB(fsmid3_plus)=(65535,49151,49151)
	ModifyGraph toMode(fsmid3_plus)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left "[X10\\S13\\M  cm\\S-2\\Mstr\\S-1\\Ms\\S-1\\M]"
	SetAxis left 0,100000000000000
	SetAxis bottom 0,6000
	RenameWindow #,G2
	SetActiveSubwindow ##
	String fldrSav3= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.375,1,0.5)/HOST=#  fsmid4_plus,fsmid4_minus vs t_fsmid4_L
	AppendToGraph fsmid4_L_avg vs t_fsmid4_L
	SetDataFolder fldrSav3
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph mode(fsmid4_plus)=7
	ModifyGraph marker(fsmid4_L_avg)=19
	ModifyGraph lSize(fsmid4_L_avg)=2
	ModifyGraph rgb(fsmid4_plus)=(65535,60076,49151),rgb(fsmid4_minus)=(65535,60076,49151)
	ModifyGraph rgb(fsmid4_L_avg)=(65535,43690,0)
	ModifyGraph msize(fsmid4_L_avg)=1
	ModifyGraph hbFill(fsmid4_plus)=2,hbFill(fsmid4_L_avg)=2
	ModifyGraph usePlusRGB(fsmid4_plus)=1
	ModifyGraph plusRGB(fsmid4_plus)=(65535,60076,49151)
	ModifyGraph toMode(fsmid4_plus)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13
	ModifyGraph axisOnTop(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left "[X10\\S13\\M  cm\\S-2\\Mstr\\S-1\\Ms\\S-1\\M]"
	SetAxis left 0,100000000000000
	SetAxis bottom 0,6000
	RenameWindow #,G3
	SetActiveSubwindow ##
	String fldrSav4= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.5,1,0.625)/HOST=#  fsmid5_plus,fsmid5_minus vs t_fsmid5_L
	AppendToGraph fsmid5_L_avg vs t_fsmid5_L
	SetDataFolder fldrSav4
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph mode(fsmid5_plus)=7
	ModifyGraph marker(fsmid5_L_avg)=19
	ModifyGraph lSize(fsmid5_L_avg)=2
	ModifyGraph rgb(fsmid5_plus)=(56797,56797,56797),rgb(fsmid5_minus)=(56797,56797,56797)
	ModifyGraph rgb(fsmid5_L_avg)=(26214,26214,26214)
	ModifyGraph msize(fsmid5_L_avg)=1
	ModifyGraph hbFill(fsmid5_plus)=2
	ModifyGraph usePlusRGB(fsmid5_plus)=1
	ModifyGraph plusRGB(fsmid5_plus)=(56797,56797,56797)
	ModifyGraph toMode(fsmid5_plus)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13
	ModifyGraph axisOnTop(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left "[X10\\S13\\M  cm\\S-2\\Mstr\\S-1\\Ms\\S-1\\M]"
	SetAxis left 0,100000000000000
	SetAxis bottom 0,6000
	RenameWindow #,G4
	SetActiveSubwindow ##
	String fldrSav5= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.625,1,0.75)/HOST=#  fsmid6_plus,fsmid6_minus vs t_fsmid6_L
	AppendToGraph fsmid6_L_avg vs t_fsmid6_L
	SetDataFolder fldrSav5
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph mode(fsmid6_plus)=7
	ModifyGraph marker(fsmid6_L_avg)=19
	ModifyGraph lSize(fsmid6_L_avg)=2
	ModifyGraph rgb(fsmid6_plus)=(65535,49151,55704),rgb(fsmid6_minus)=(65535,49151,55704)
	ModifyGraph rgb(fsmid6_L_avg)=(39321,1,15729)
	ModifyGraph msize(fsmid6_L_avg)=1
	ModifyGraph hbFill(fsmid6_plus)=2
	ModifyGraph toMode(fsmid6_plus)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13
	ModifyGraph axisOnTop(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left "[X10\\S13\\M  cm\\S-2\\Mstr\\S-1\\Ms\\S-1\\M]"
	SetAxis left 0,100000000000000
	SetAxis bottom 0,6000
	RenameWindow #,G5
	SetActiveSubwindow ##
	String fldrSav6= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.75,1,0.875)/HOST=#  fsmid7_plus,fsmid7_minus vs t_fsmid7_L
	AppendToGraph fsmid7_L_avg vs t_fsmid7_L
	SetDataFolder fldrSav6
	ModifyGraph margin(left)=30,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph mode(fsmid7_plus)=7 marker(fsmid7_L_avg)=19
	ModifyGraph lSize(fsmid7_L_avg)=2
	ModifyGraph rgb(fsmid7_plus)=(52428,52425,1),rgb(fsmid7_minus)=(52428,52425,1),rgb(fsmid7_L_avg)=(26214,26212,0)
	ModifyGraph msize(fsmid7_L_avg)=1  hbFill(fsmid7_plus)=2
	ModifyGraph toMode(fsmid7_plus)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13
	ModifyGraph axisOnTop(bottom)=1
	ModifyGraph manTick(bottom)={0,1000,0,0},manMinor(bottom)={1,0}
	Label left "[X10\\S13\\M  cm\\S-2\\Mstr\\S-1\\Ms\\S-1\\M]"
	SetAxis left 0,100000000000000
	SetAxis bottom 0,6000
	RenameWindow #,G6
	SetActiveSubwindow ##
	String fldrSav7= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.875,1,1)/HOST=#  fsmid8_plus,fsmid8_minus vs t_fsmid8_L
	AppendToGraph fsmid8_L_avg vs t_fsmid8_L
	SetDataFolder fldrSav7
	ModifyGraph margin(left)=30,margin(bottom)=10,margin(top)=5,margin(right)=5
	ModifyGraph mode(fsmid8_plus)=7
	ModifyGraph marker(fsmid8_L_avg)=19
	ModifyGraph lSize(fsmid8_L_avg)=2
	ModifyGraph rgb(fsmid8_plus)=(32768,54615,65535),rgb(fsmid8_minus)=(32768,54615,65535)
	ModifyGraph rgb(fsmid8_L_avg)=(1,26221,39321)
	ModifyGraph msize(fsmid8_L_avg)=1
	ModifyGraph hbFill(fsmid8_plus)=2
	ModifyGraph toMode(fsmid8_plus)=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font="Helvetica"
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13,prescaleExp(bottom)=-3
	ModifyGraph axisOnTop(bottom)=1
	Label left "[X10\\S13\\M  cm\\S-2\\Mstr\\S-1\\Ms\\S-1\\M]"
	Label bottom " "
	SetAxis left 0,100000000000000
	SetAxis bottom 0,6000
	RenameWindow #,G7
	SetActiveSubwindow ##
EndMacro

Function FS_plot(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Plot_fs_data()"
			break
	endswitch

	return 0
End

Function Zipfit_get(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Get_zipfit(ishot,fname_dens,fname_temp,ga,local)"
			break
	endswitch

	return 0
	

End

Function Zipfit_plot(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Plot_zipfit_data()"
			break
	endswitch

	return 0
End

Function Avg_waves(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Wave_avg()"
			break
	endswitch

	return 0
End

Function Kill_fs_data_1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			KillWindow Plot_fs_data_1
			break
	endswitch

	return 0
End

Function Kill_zipfit_data(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			KillWindow Plot_zipfit_data
			break
	endswitch

	return 0
End

Function FS_Avg_plot(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "avg_fsmid_signal_layout()"
			break
	endswitch

	return 0
End

Function Build_prof_button(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Build_profiles(Timepnts,zipfit_YN)"
			break
	endswitch

	return 0
End