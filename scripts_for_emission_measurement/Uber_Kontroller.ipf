#pragma rtGlobals=1		// Use modern global access method.


Window Uber_Kontroller() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(163,44,700,619) as "Uber_Kontrolle"
	ModifyPanel cbRGB=(43690,43690,43690), frameInset=3
	ShowTools/A
	SetDrawLayer UserBack
	SetDrawEnv fname= "Helvetica",fstyle= 1
	DrawText 19,136,"Where to get data?"
	SetDrawEnv linethick= 2,linefgc= (52428,52428,52428)
	DrawLine -0.0203442879499218,0.296875,0.995305164319249,0.296875
	DrawRect 50,50,60,60
	SetDrawEnv linethick= 0.1,linefgc= (65535,65535,65535)
	DrawRect 173,48,455,71
	TitleBox Uber_title,pos={5,5},size={521,34},title="UberKontrol for Midplane Filterscope to Neutral Density"
	TitleBox Uber_title,labelBack=(8738,8738,8738),font="Gill Sans",fSize=22,frame=4
	TitleBox Uber_title,fColor=(65535,65535,65535)
	GroupBox FSmid_group,pos={7,82},size={305,100},labelBack=(65535,65535,65535)
	GroupBox FSmid_group,font="Gill Sans",fSize=16
	SetVariable SetShot,pos={25,48},size={125,22},title="Shot #"
	SetVariable SetShot,labelBack=(65535,65535,65535),font="Gill Sans",fSize=16
	SetVariable SetShot,limits={0,135000,1},value= ishot
	Button Pre_process_FS_mid,pos={12,146},size={180,25},proc=PreProcess_button,title="Go and PreProcess FSmidData"
	Button Pre_process_FS_mid,font="Gill Sans",fColor=(0,17409,26214)
	CheckBox GA_data,pos={135,121},size={75,15},proc=Radio_Change,title="GA server"
	CheckBox GA_data,font="Helvetica Neue",fSize=12,fStyle=1,value= 0,mode=1
	CheckBox Local_data,pos={212,121},size={89,15},proc=Radio_Change,title="Local server"
	CheckBox Local_data,font="Helvetica Neue",fSize=12,fStyle=1,value= 1,mode=1
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
	GroupBox Timepnt_wave,pos={360,190},size={150,100},labelBack=(65535,65535,65535)
	GroupBox Timepnt_wave,font="Gill Sans",fSize=16,fStyle=0
	CheckBox make_zipfit_profile,pos={366,224},size={133,14},title="Make dens & temp profile?"
	CheckBox make_zipfit_profile,labelBack=(65535,65535,65535)
	CheckBox make_zipfit_profile,font="Helvetica Neue Light",fSize=9,fStyle=1
	CheckBox make_zipfit_profile,variable= zipfit_YN
	SetVariable TIME_WAVE,pos={370,243},size={125,14},title="Time Pnt Waves"
	SetVariable TIME_WAVE,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable TIME_WAVE,fStyle=1,limits={-inf,inf,0},value= Timepnts
	Button Prof_build,pos={407,262},size={50,20},proc=Build_prof_button,title="Make"
	Button Prof_build,font="Gill Sans",fColor=(0,17409,26214)
	TitleBox Pre_process,pos={59,86},size={202,27},title="(1) Setup & Pre-process"
	TitleBox Pre_process,labelBack=(21845,21845,21845),font="Gill Sans",fSize=16
	TitleBox Pre_process,frame=4,fStyle=1,fColor=(65535,65535,65535),anchor= MC
	TitleBox fs_chnl,pos={175,50},size={135,19},title="Filterscope Channel?"
	TitleBox fs_chnl,font="Gill Sans",fSize=16,frame=0
	CheckBox FS_Dalf,pos={315,50},size={72,19},proc=Radio_Change2,title="D_alpha"
	CheckBox FS_Dalf,labelBack=(0,0,0),font="Gill Sans",fSize=16,fStyle=0
	CheckBox FS_Dalf,value= 1,mode=1
	CheckBox FS_C3,pos={398,50},size={42,19},proc=Radio_Change2,title="CIII"
	CheckBox FS_C3,font="Gill Sans",fSize=16,fStyle=0,value= 0,mode=1
	TitleBox grab_profs,pos={341,82},size={156,27},title="(1a) Grab Profiles?"
	TitleBox grab_profs,labelBack=(21845,21845,21845),font="Gill Sans",fSize=16
	TitleBox grab_profs,frame=4,fStyle=1,fColor=(65535,65535,65535),anchor= MC
	TitleBox time_avg,pos={39,192},size={115,25},title="(2) Time Avg. Wave"
	TitleBox time_avg,labelBack=(21845,21845,21845),font="Gill Sans",fSize=14
	TitleBox time_avg,frame=4,fStyle=0,fColor=(65535,65535,65535),anchor= MC
	TitleBox create_profs,pos={377,192},size={114,25},title="(3) Create Profiles"
	TitleBox create_profs,labelBack=(21845,21845,21845),font="Gill Sans",fSize=14
	TitleBox create_profs,frame=4,fStyle=0,fColor=(65535,65535,65535),anchor= MC
	GroupBox Timepnt_wave1,pos={16,316},size={156,235},labelBack=(65535,65535,65535)
	GroupBox Timepnt_wave1,font="Gill Sans",fSize=16,fStyle=0
	TitleBox create_profs1,pos={38,322},size={111,25},title="(4) Spline Fit Data"
	TitleBox create_profs1,labelBack=(21845,21845,21845),font="Gill Sans",fSize=14
	TitleBox create_profs1,frame=4,fStyle=0,fColor=(65535,65535,65535),anchor= MC
	GroupBox Timepnt_wave2,pos={176,188},size={171,117}
	GroupBox Timepnt_wave2,labelBack=(65535,65535,65535),font="Gill Sans",fSize=16
	GroupBox Timepnt_wave2,fStyle=0
	SetVariable fudg_wav,pos={185,228},size={152,14},title=" Fudge Wavname"
	SetVariable fudg_wav,labelBack=(65535,65535,65535),font="Helvetica Neue",fSize=9
	SetVariable fudg_wav,fStyle=1,limits={-inf,inf,0},value= fudg_nam
	Button Fdug_go,pos={223,285},size={75,16},proc=Build_prof_button,title="Fudge 'em!"
	Button Fdug_go,font="Gill Sans",fColor=(0,17409,26214)
	TitleBox do_fudg_corr,pos={190,195},size={141,25},title="(2a) 'Fudge' Correction"
	TitleBox do_fudg_corr,labelBack=(21845,21845,21845),font="Gill Sans",fSize=14
	TitleBox do_fudg_corr,frame=4,fStyle=0,fColor=(65535,65535,65535),anchor= MC
	SetVariable fudg_wav1,pos={180,249},size={162,14},title="To-apply Wavname"
	SetVariable fudg_wav1,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable fudg_wav1,fSize=9,fStyle=1,limits={-inf,inf,0},value= wav_nam
	SetVariable fudg_wav2,pos={182,265},size={162,14},title="To-apply Err wave"
	SetVariable fudg_wav2,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable fudg_wav2,fSize=9,fStyle=1,limits={-inf,inf,0},value= err_wav
	SetVariable splinxwav,pos={22,351},size={145,14},title="X Wavname"
	SetVariable splinxwav,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable splinxwav,fSize=9,fStyle=1,limits={-inf,inf,0},value= x_data
	SetVariable splinywav,pos={22,371},size={145,14},title="Y Wavname"
	SetVariable splinywav,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable splinywav,fSize=9,fStyle=1,limits={-inf,inf,0},value= y_data
	SetVariable spline_start_knots,pos={28,408},size={125,14},title="Initial Spline Knots"
	SetVariable spline_start_knots,labelBack=(65535,65535,65535)
	SetVariable spline_start_knots,font="Helvetica Neue",fSize=9,fStyle=1
	SetVariable spline_start_knots,limits={-inf,inf,0},value= int_knots
	SetVariable splinyerr,pos={23,390},size={145,14},title="Y Error Wave"
	SetVariable splinyerr,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable splinyerr,fSize=9,fStyle=1,limits={-inf,inf,0},value= y_err_str
	SetVariable spline_tolerance,pos={27,427},size={125,14},title="Chi**2 Error tol"
	SetVariable spline_tolerance,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable spline_tolerance,fSize=9,fStyle=1,limits={-inf,inf,0},value= tol
	SetVariable spline_itermax,pos={19,446},size={150,14},title="Max. Iter's on MC error"
	SetVariable spline_itermax,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable spline_itermax,fSize=9,fStyle=1,limits={-inf,inf,0},value= itermax
	GroupBox Timepnt_wave3,pos={360,190},size={150,100}
	GroupBox Timepnt_wave3,labelBack=(65535,65535,65535),font="Gill Sans",fSize=16
	GroupBox Timepnt_wave3,fStyle=0
	CheckBox make_zipfit_profile1,pos={366,224},size={133,14},title="Make dens & temp profile?"
	CheckBox make_zipfit_profile1,labelBack=(65535,65535,65535)
	CheckBox make_zipfit_profile1,font="Helvetica Neue Light",fSize=9,fStyle=1
	CheckBox make_zipfit_profile1,variable= zipfit_YN
	SetVariable TIME_WAVE1,pos={370,243},size={125,14},title="Time Pnt Waves"
	SetVariable TIME_WAVE1,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable TIME_WAVE1,fStyle=1,limits={-inf,inf,0},value= Timepnts
	Button Prof_build1,pos={407,262},size={50,20},proc=Build_prof_button,title="Make"
	Button Prof_build1,font="Gill Sans",fColor=(0,17409,26214)
	TitleBox create_profs2,pos={377,192},size={114,25},title="(3) Create Profiles"
	TitleBox create_profs2,labelBack=(21845,21845,21845),font="Gill Sans",fSize=14
	TitleBox create_profs2,frame=4,fStyle=0,fColor=(65535,65535,65535),anchor= MC
	GroupBox Timepnt_wave4,pos={196,320},size={313,108}
	GroupBox Timepnt_wave4,labelBack=(65535,65535,65535),font="Gill Sans",fSize=16
	GroupBox Timepnt_wave4,frame=0,fStyle=0
	CheckBox Build_length_matrix,pos={267,347},size={157,14},title="Make Geometric Length Matrix?"
	CheckBox Build_length_matrix,labelBack=(65535,65535,65535)
	CheckBox Build_length_matrix,font="Helvetica Neue Light",fSize=9,fStyle=1
	CheckBox Build_length_matrix,variable= zipfit_YN
	SetVariable emiss_WAV,pos={210,368},size={125,14},title="Wave to Invert?"
	SetVariable emiss_WAV,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable emiss_WAV,fStyle=1,limits={-inf,inf,0},value= Timepnts
	Button Prof_build2,pos={389,367},size={50,20},proc=Build_prof_button,title="Make"
	Button Prof_build2,font="Gill Sans",fColor=(0,17409,26214)
	TitleBox create_profs3,pos={227,323},size={239,25},title="(5) Calculate Emissivity & Error Analysis "
	TitleBox create_profs3,labelBack=(21845,21845,21845),font="Gill Sans",fSize=14
	TitleBox create_profs3,frame=5,fStyle=0,fColor=(65535,65535,65535),anchor= MC
	Button Prof_build3,pos={69,522},size={50,23},proc=Splineer,title="Spline't!"
	Button Prof_build3,font="Gill Sans",fColor=(0,17409,26214)
	SetVariable end_chi_sq,pos={39,463},size={100,15},disable=2,title="End Chi_sq ="
	SetVariable end_chi_sq,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable end_chi_sq,fSize=10,frame=0,fStyle=0
	SetVariable end_chi_sq,limits={0,200,0},value= error_wave[0]
	SetVariable end_chi_sq1,pos={28,477},size={125,15},disable=2,title="Reduced Chi_sq ="
	SetVariable end_chi_sq1,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable end_chi_sq1,fSize=10,frame=0,fStyle=0
	SetVariable end_chi_sq1,limits={0,200,0},value= error_wave[1]
	SetVariable end_chi_sq2,pos={39,491},size={100,15},disable=2,title="Deg. of Freedom="
	SetVariable end_chi_sq2,labelBack=(65535,65535,65535),font="Helvetica Neue"
	SetVariable end_chi_sq2,fSize=10,frame=0,fStyle=0
	SetVariable end_chi_sq2,limits={0,200,0},value= error_wave[2]
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
	
	if (checkname("ga",3)==0)
		variable/g ga
	endif
	
	if (checkname("local",3)==0)
		variable/g local
		
	endif
	
	NVAR gRadioVal= root:gRadioVal
	NVAR ga=root:ga
	NVAR local=root:local
	
	strswitch (name)
		case "GA_data":
			gRadioVal= 1
			ga =1
			local=0
			break
		case "Local_data":
			gRadioVal= 2
			ga=0
			local=1
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
		case "FS_Dalf":
			gRadioVal2= 1
			break
		case "FS_C3":
			gRadioVal2= 2
			break
	endswitch
	CheckBox FS_Dalf,value= gRadioVal2==1
	CheckBox FS_C3,value= gRadioVal2==2
End

Window Plot_fs_data() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	String dataset = "root:s"+num2istr(ishot)
	string septrix = "rmidout"
	SetDataFolder dataset
	if(checkname("fs1midda",1)!=0)
		Display /W=(7,44,559,465) fs1midda vs t_fs1midda
		AppendToGraph fs2midda vs t_fs2midda
		AppendToGraph fs3midda vs t_fs3midda
		AppendToGraph fs4midda vs t_fs4midda
		AppendToGraph fs5midda vs t_fs5midda
		AppendToGraph fs6midda vs t_fs6midda
		AppendToGraph fs7midda vs t_fs7midda
		AppendToGraph fs8midda vs t_fs8midda
		AppendToGraph/R $septrix vs $"t_"+septrix
		SetDataFolder fldrSav0
		ModifyGraph margin(bottom)=35,margin(top)=10,margin(left)=45
		ModifyGraph log(left)=1
		ModifyGraph mode(fs1midda)=3,mode(fs2midda)=3,mode(fs3midda)=3,mode(fs4midda)=3
		ModifyGraph mode(fs5midda)=3,mode(fs6midda)=3,mode(fs7midda)=3,mode(fs8midda)=3
		ModifyGraph mode($septrix)=4
		ModifyGraph marker(fs1midda)=19,marker(fs2midda)=19,marker(fs3midda)=19,marker(fs4midda)=19
		ModifyGraph marker(fs5midda)=19,marker(fs6midda)=19,marker(fs7midda)=19,marker(fs8midda)=19
		ModifyGraph marker($septrix)=19
		ModifyGraph rgb(fs1midda)=(0,0,65535,32767),rgb(fs2midda)=(3,52428,1,32767),rgb(fs4midda)=(52428,52425,1,32767)
		ModifyGraph rgb(fs5midda)=(65535,16385,55749,32767),rgb(fs6midda)=(0,0,0,32767),rgb(fs7midda)=(26214,26214,26214,32767)
		ModifyGraph rgb(fs8midda)=(1,52428,52428,32767),rgb(fs3midda)=(65535,0,0,32767)
		ModifyGraph msize(fs1midda)=1,msize(fs2midda)=1,msize(fs3midda)=1,msize(fs4midda)=1
		ModifyGraph msize(fs5midda)=1,msize(fs6midda)=1,msize(fs7midda)=1,msize(fs8midda)=1
		ModifyGraph msize($septrix)=4
		ModifyGraph useMrkStrokeRGB($septrix)=1,standoff=0,tick=2,mirror(bottom)=1
		ModifyGraph manTick(bottom)={0,500,0,0},manMinor(bottom)={0,0}
		ModifyGraph axisOnTop=1,font="Helvetica Neue Condensed Bold"
		SetAxis bottom 0,6000
		SetAxis left 1e+12,1e+16
		Label bottom "Time [msec]"
		Label right "[meters]"
		Label left "[ph/s/cm\\S2\\M/str]"
		Legend/C/N=text0/J/F=0/A=MC/X=-30.28/Y=31.68 "\\Z10\\F'Helvetica Neue Condensed Bold'\\s(fs1midda) fsmid1_da\r\\s(fs2midda) fsmid2_da\r\\s(fs3midda) fsmid3_da\r\\s(fs4midda) fsmid4_da\r\\s(fs5midda) fsmid5_da"
		AppendText "\\s(fs6midda) fsmid6_da\r\\s(fs7midda) fsmid7_da\r\\s(fs8midda) fsmid8_da\r\\s("+septrix+") rout_fsmid"
	else
		print "*************"
		print "No D_alpha Waves!!!"
		print "*************"
	endif
	SetDataFolder dataset
	if(checkname("fsmid1_c3",1) !=0)
		Display /W=(565,44,1117,465) fsmid1_c3 vs t_fsmid1_c3
		AppendToGraph fsmid2_c3 vs t_fsmid2_c3
		AppendToGraph fsmid3_c3 vs t_fsmid3_c3
		AppendToGraph fsmid4_c3 vs t_fsmid4_c3
		AppendToGraph fsmid5_c3 vs t_fsmid5_c3
		AppendToGraph fsmid6_c3 vs t_fsmid6_c3
		AppendToGraph fsmid7_c3 vs t_fsmid7_c3
		AppendToGraph fsmid8_c3 vs t_fsmid8_c3
		AppendToGraph/R $septrix vs $"t_"+septrix
		SetDataFolder fldrSav0
		ModifyGraph mode(fsmid1_c3)=3,mode(fsmid2_c3)=3,mode(fsmid3_c3)=3,mode(fsmid4_c3)=3
		ModifyGraph mode(fsmid5_c3)=3,mode(fsmid6_c3)=3,mode(fsmid7_c3)=3,mode(fsmid8_c3)=3
		ModifyGraph mode($septrix)=4
		ModifyGraph marker(fsmid1_c3)=16,marker(fsmid2_c3)=16,marker(fsmid3_c3)=16,marker(fsmid4_c3)=16
		ModifyGraph marker(fsmid5_c3)=16,marker(fsmid6_c3)=16,marker(fsmid7_c3)=16,marker(fsmid8_c3)=16
		ModifyGraph marker($septrix)=19
		ModifyGraph rgb(fsmid1_c3)=(0,0,65535),rgb(fsmid2_c3)=(3,52428,1),rgb(fsmid4_c3)=(52428,52425,1)
		ModifyGraph rgb(fsmid5_c3)=(65535,16385,55749),rgb(fsmid6_c3)=(0,0,0),rgb(fsmid7_c3)=(26214,26214,26214)
		ModifyGraph rgb(fsmid8_c3)=(1,52428,52428)
		ModifyGraph msize(fsmid1_c3)=2,msize(fsmid2_c3)=2,msize(fsmid3_c3)=2,msize(fsmid4_c3)=2
		ModifyGraph msize(fsmid5_c3)=2,msize(fsmid6_c3)=2,msize(fsmid7_c3)=2,msize(fsmid8_c3)=2
		ModifyGraph msize($septrix)=4
		ModifyGraph useMrkStrokeRGB($septrix)=1,standoff=0,tick=2,mirror(bottom)=1
		ModifyGraph manTick(bottom)={0,500,0,0},manMinor(bottom)={0,0}
		SetAxis bottom 0,6000
		Legend/C/N=text0/J/F=0/A=MC/X=-30.28/Y=31.68 "\\s(fsmid1_c3) fsmid1_c3\r\\s(fsmid2_c3) fsmid2_c3\r\\s(fsmid3_c3) fsmid3_c3\r\\s(fsmid4_c3) fsmid4_c3\r\\s(fsmid5_c3) fsmid5_c3"
		AppendText "\\s(fsmid6_c3) fsmid6_c3\r\\s(fsmid7_c3) fsmid7_c3\r\\s(fsmid8_c3) fsmid8_c3\r\\s(rout_fsmid) rout_fsmid"
	else(checkname("fsmid1_c3",1) ==0)
		print "*************"
		print "No Carbon III Waves!!!"
		print "*************"
	endif
EndMacro

Window Plot_zipfit_data() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	String dataset = "root:s"+num2istr(ishot)
	Display /W=(79,171,1409,660)
	ShowInfo
	Display/W=(0,0,0.5,1)/HOST=# 
	SetDataFolder dataset
	AppendMatrixContour edens_plot vs {time_edens_plot,rho_edens_plot}
	ModifyContour edens_plot autoLevels={0,9,10}, rgbLines=(65535,65535,65535), labels=0
	AppendImage edens_plot vs {time_edens_plot,rho_edens_plot}
	ModifyImage edens_plot ctab={0,9,root:Packages:ColorTables:Matplotlib:viridis,0}
	ModifyGraph margin(bottom)=30,margin(top)=75,margin(right)=10,margin(left)=45
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph mirror(left)=1,mirror(bottom)=2
	ModifyGraph font="Helvetica Neue Condensed Bold"
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph gridRGB(bottom)=(43690,43690,43690)
	ModifyGraph prescaleExp(bottom)=-3
	ModifyGraph manTick(bottom)={0,0.5,0,1},manMinor(bottom)={0,0}
	Label bottom "Time [s]"
	Label left "\\Z16\\Z18ρ"
	SetAxis left 0.5,1.21
	SetAxis bottom 0,6000
	Cursor/P/I A edens_plot 146,96
	ColorScale/C/N=text0/F=0/A=MC/X=-0.50/Y=60.32 image=edens_plot, vert=0
	ColorScale/C/N=text0 side=2, tickLen=0.5,font="Helvetica Neue Condensed Bold",nticks=10
	AppendText "Electron Density [X10\\S19 \\Mm\\S-3\\M ]"
	SetDrawLayer UserFront
	DrawLine 2.1,0.296875,1.05,0.296875
	SetDrawEnv linethick= 2,linefgc= (52428,52428,52428)
	DrawLine 0.005,0.296875,1.01833333333333,0.296875
	RenameWindow #,G0
	SetActiveSubwindow ##
	Display/W=(0.501,0,1,1)/FG=(,,,FB)/HOST=# 
	AppendMatrixContour etemp_plot vs {time_etemp_plot,:rho_etemp_plot}
	ModifyContour etemp_plot autoLevels={0,3,6}, rgbLines=(65535,65535,65535)
	ModifyContour etemp_plot labels=0
	AppendImage etemp_plot vs {time_etemp_plot,rho_etemp_plot}
	ModifyImage etemp_plot ctab= {0,3,root:Packages:ColorTables:Matplotlib:inferno,0}
	ModifyGraph margin(left)=15,margin(bottom)=30,margin(top)=75,margin(right)=10
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font="Helvetica Neue Condensed Bold"
	ModifyGraph noLabel(left)=2
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph gridRGB(bottom)=(43690,43690,43690)
	ModifyGraph prescaleExp(bottom)=-3
	ModifyGraph manTick(bottom)={0,0.5,0,1},manMinor(bottom)={0,0}
	Label bottom "Time [s]"
	SetAxis left 0.5,1.21
	SetAxis bottom 0,6000
	ColorScale/C/N=text0/F=0/A=MC/X=1.25/Y=61.20 image=etemp_plot, vert=0
	ColorScale/C/N=text0 side=2, tickLen=0.5,font="Helvetica Neue Condensed Bold"
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
	String dataset = "root:s"+num2istr(ishot)
	SetDataFolder dataset
	Display/W=(0,0,1,0.125)/HOST=#  fs1midda_avg vs t_fs1midda_shrt
	ErrorBars fs1midda_avg SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(fs1midda_stdev,fs1midda_stdev)
	SetDataFolder fldrSav0
	ModifyGraph gaps=0,margin(left)=40,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph marker(fs1midda_avg)=8,lSize(fs1midda_avg)=1,rgb(fs1midda_avg)=(0,0,65535)
	ModifyGraph msize(fs1midda_avg)=1,mode=4,opaque=1
	ModifyGraph plusRGB(fs1midda_avg)=(49151,53155,65535)
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica Neue Condensed Bold"
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
	SetDataFolder dataset
	Display/W=(0,0.125,1,0.25)/HOST=#  fs2midda_avg vs t_fs2midda_shrt
	ErrorBars fs2midda_avg SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(fs2midda_stdev,fs2midda_stdev)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=40,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph marker(fs2midda_avg)=8,lSize(fs2midda_avg)=1
	ModifyGraph rgb(fs2midda_avg)=(1,26214,0)
	ModifyGraph msize(fs2midda_avg)=1,mode=4,opaque=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica Neue Condensed Bold"
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
	SetDataFolder dataset
	Display/W=(0,0.25,1,0.375)/HOST=#  fs3midda_avg vs t_fs3midda_shrt
	ErrorBars fs3midda_avg SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(fs3midda_stdev,fs3midda_stdev)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=40,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph marker(fs3midda_avg)=8,lSize(fs3midda_avg)=1
	ModifyGraph msize(fs3midda_avg)=1,mode=4,opaque=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica Neue Condensed Bold"
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
	SetDataFolder dataset
	Display/W=(0,0.375,1,0.5)/HOST=#  fs4midda_avg vs t_fs4midda_shrt
	ErrorBars fs4midda_avg SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(fs4midda_stdev,fs4midda_stdev)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=40,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph marker(fs4midda_avg)=8,lSize(fs4midda_avg)=1
	ModifyGraph rgb(fs4midda_avg)=(65535,43690,0)
	ModifyGraph msize(fs4midda_avg)=1,mode=4,opaque=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica Neue Condensed Bold"
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
	SetDataFolder dataset
	Display/W=(0,0.5,1,0.625)/HOST=#  fs5midda_avg vs t_fs5midda_shrt
	ErrorBars fs5midda_avg SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(fs5midda_stdev,fs5midda_stdev)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=40,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph marker(fs5midda_avg)=8
	ModifyGraph lSize(fs5midda_avg)=1
	ModifyGraph rgb(fs5midda_avg)=(26214,26214,26214)
	ModifyGraph msize(fs5midda_avg)=1,mode=4,opaque=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica Neue Condensed Bold"
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
	SetDataFolder dataset
	Display/W=(0,0.625,1,0.75)/HOST=#  fs6midda_avg vs t_fs6midda_shrt
	ErrorBars fs6midda_avg SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(fs6midda_stdev,fs6midda_stdev)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=40,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph marker(fs6midda_avg)=8
	ModifyGraph lSize(fs6midda_avg)=1
	ModifyGraph rgb(fs6midda_avg)=(39321,1,15729)
	ModifyGraph msize(fs6midda_avg)=1,mode=4,opaque=1
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica Neue Condensed Bold"
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
	SetDataFolder dataset
	Display/W=(0,0.75,1,0.875)/HOST=#  fs7midda_avg vs t_fs7midda_shrt
	ErrorBars fs7midda_avg SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(fs7midda_stdev,fs7midda_stdev)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=40,margin(bottom)=5,margin(top)=5,margin(right)=5
	ModifyGraph marker(fs7midda_avg)=8
	ModifyGraph lSize(fs7midda_avg)=1
	ModifyGraph rgb(fs7midda_avg)=(26214,26212,0)
	ModifyGraph msize(fs7midda_avg)=1,mode=4,opaque=1  
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica Neue Condensed Bold"
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
	SetDataFolder dataset
	Display/W=(0,0.875,1,1)/HOST=# fs8midda_avg vs t_fs8midda_shrt
	ErrorBars fs8midda_avg SHADE= {0,0,(0,0,0,0),(0,0,0,0)},wave=(fs8midda_stdev,fs8midda_stdev)
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=40,margin(bottom)=10,margin(top)=5,margin(right)=5
	ModifyGraph marker(fs8midda_avg)=8
	ModifyGraph lSize(fs8midda_avg)=1
	ModifyGraph rgb(fs8midda_avg)=(1,26221,39321)
	ModifyGraph msize(fs8midda_avg)=1,mode=4,opaque=1  
	ModifyGraph grid(bottom)=1
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font="Helvetica Neue Condensed Bold"
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13,prescaleExp(bottom)=-3
	ModifyGraph axisOnTop(bottom)=1
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
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


Function Kill_fs_data(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			KillWindow Plot_fs_data
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

Function Splineer(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Splineopt(y_data,x_data,y_err_str,int_knots,tol,itermax)"
			break
	endswitch

	return 0
End

Function Avg_waves(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	if(checkname("numpnt",3)==0)
		Variable numpnt=50
	endif
	
	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Wave_avg()"
			break
	endswitch

	return 0
End

Function Button_App_FUDG(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Fudg_app(fudg_nam,wav_nam,err_wav)"
			break
	endswitch

	return 0
End

Function Button_inver(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			Execute "Invert_data(inwav)"
			break
	endswitch

	return 0
End
