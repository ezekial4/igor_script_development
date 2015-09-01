#pragma rtGlobals=1		// Use modern global access method.

Macro Load_partbal(ish,icoiluse,layoutuse)
variable ish=132000
Variable icoiluse =0
Variable layoutuse =0

PauseUpdate;Silent 1
String/G root:Unt_path = "ORNLTron:Users:unterbee:Desktop:d2bal files"
String/G root:shotfold ="s"+num2istr(ish)
String fname = "d2bal_"+num2istr(ish)+".txt"

String Set_path="root:s"+num2istr(ish)
SetDataFolder Set_path

DoWindow/K lft_column
DoWindow/K rt_column
LoadWave/G/D/W/N/O/Q root:Unt_path+":"+fname

Display /W=(941,44,1392,916) as "Left Column"
	PauseUpdate
	ModifyGraph margin(bottom)=1,margin(top)=10
	Display/W=(0,0,1,0.333)/HOST=#  dne_dt vs timeW
	DoWindow/C lft_column
	if (icoiluse == 1)
		AppendToGraph/R iu30 vs t_iu30
		ModifyGraph rgb(iu30)=(56797,56797,56797),hbFill(iu30)=2,usePlusRGB(iu30)=1
		ModifyGraph plusRGB(iu30)=(56797,56797,56797)
		ModifyGraph mode(iu30)=7
		ModifyGraph noLabel(right)=2
		SetAxis right 0,55000
	endif
	
	ModifyGraph margin(left)=40,margin(bottom)=10,margin(top)=10,margin(right)=10
	ModifyGraph lSize=2,tick=2,zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2,fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop=1
	ModifyGraph manTick(left)={0,10,0,0},manMinor(left)={1,50}
	Label left "dN\\Be\\M/dt [torr-l/s]"
	TextBox/C/N=text0 "\\Z14Shot "+num2istr(ish)
	SetAxis/A/N=1 left
	RenameWindow #,G0
	SetActiveSubwindow ##
	Display/W=(0,0.333,1,0.667)/HOST=#  s_nbi vs timeW
	ModifyGraph margin(left)=40,margin(bottom)=10,margin(top)=10,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop(left)=1
	ModifyGraph manTick(left)={0,2,0,0},manMinor(left)={1,50}
	Label left "NBI feed Rate, S_NBI [torr-l/s]"
	SetAxis/N=1 left 0,*
	RenameWindow #,G1
	SetActiveSubwindow ##
	Display/W=(0,0.667,1,1)/HOST=#  dn0dt_adp,dn0dt_rdpin,dn0dt_rdpout vs timeW
	ModifyGraph margin(left)=40,margin(bottom)=30,margin(top)=10,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph lStyle(dn0dt_rdpin)=2,lStyle(dn0dt_rdpout)=4
	ModifyGraph rgb(dn0dt_rdpin)=(0,0,65535),rgb(dn0dt_rdpout)=(3,52428,1)
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror=1
	ModifyGraph font="Helvetica"
	ModifyGraph fSize=12
	ModifyGraph lblMargin(bottom)=3
	ModifyGraph standoff=0
	ModifyGraph axisOnTop(left)=1
	ModifyGraph manTick(left)={0,5,0,1},manMinor(left)={1,50}
	Label left "dN\\B0\\M/dt [torr-l/s]"
	Label bottom "Time [ms]"
	SetAxis/A/N=1 left
	Legend/C/N=text0/J/F=0/A=MC/X=28.18/Y=35.07 "\\F'Helvetica'\\Z14\\s(dn0dt_adp) ADP\r\\s(dn0dt_rdpin) RDPin\r\\s(dn0dt_rdpout) RDPout"
	RenameWindow #,G2
	SetActiveSubwindow ##


Display /W=(1396,44,1845,912) as "Right Column"
	Display/W=(0,0,1,0.333)/HOST=#  s_gas vs timeW
	ModifyGraph margin(left)=40,margin(bottom)=10,margin(top)=10,margin(right)=10
	DoWindow/C rt_column
	ModifyGraph lSize=2
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop(left)=1
	ModifyGraph manTick=0,minor(left)=1,manTick=0
	Label left "Total D2 Gas Input Rate, S_gas [torr-l/s]"
	SetAxis/A/N=1 left
	RenameWindow #,G0
	SetActiveSubwindow ##
	Display/W=(0,0.333,1,0.667)/HOST=#  exh_adp,exh_rdpin,exh_rdpout vs timeW
	ModifyGraph margin(left)=40,margin(bottom)=10,margin(top)=10,margin(right)=10
	ModifyGraph lSize=2
	ModifyGraph lStyle(exh_rdpin)=2,lStyle(exh_rdpout)=4
	ModifyGraph rgb(exh_rdpin)=(0,0,65535),rgb(exh_rdpout)=(3,52428,1)
	ModifyGraph tick=2
	ModifyGraph mirror=1
	ModifyGraph font(left)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop(left)=1
	ModifyGraph manTick(left)={0,5,0,0},manMinor(left)={1,50}
	Label left "Cryo Exhaust Rate, Q_cryo [torr-l/s]"
	SetAxis/A/N=1 left
	TextBox/C/N=text0/F=0/A=MC/X=38.00/Y=34.52 "\\F'Helvetica'\\Z14\\s(exh_adp) ADP\r\\s(exh_rdpin) RDPin\r\\s(exh_rdpout) RDPout"
	RenameWindow #,G1
	SetActiveSubwindow ##
	Display/W=(0,0.667,1,1)/HOST=#  swall,nwall vs timeW
	ModifyGraph margin(left)=40,margin(bottom)=30,margin(top)=10,margin(right)=10

	if (icoiluse == 1)
		AppendToGraph/R iu30 vs t_iu30
		ModifyGraph mode(iu30)=7,hbFill(iu30)=2,rgb(iu30)=(56797,56797,56797)
		ModifyGraph noLabel(right)=2,standoff=0
	endif
	
	ModifyGraph axisOnTop(bottom)=1
	ModifyGraph lSize=2
	ModifyGraph lStyle(nwall)=3
	ModifyGraph rgb(nwall)=(0,0,65535)
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph font="Helvetica"
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop(left)=1
	ModifyGraph mirror=1
	ModifyGraph manTick(left)={0,10,0,0},manMinor(left)={1,50}
	Label left "Wall Pump Rate and Load"
	Label bottom "Time [ms]"
	SetAxis/A/N=1 left
	TextBox/C/N=text0/F=0/A=MC/X=25.27/Y=35.00 "\\F'Helvetica'\\Z14\\s(swall) Load Rate\r\\s(nwall) Wall Load"
	RenameWindow #,G2
	SetActiveSubwindow ##
	
	if (layoutuse == 1)
		Layout/C=1/W=(605,263,1556,1184) right_column(310,21,591,749)/O=1/F=0/T,left_column(21,21,302,749)/O=1/F=0/T
		ModifyLayout mag=1, units=1
	endif
	
//Caluculate other things
	Duplicate/o timew timew_int
	timew_int /=1000
	
	Duplicate/O ne_tot tau_p_star
//	smooth/s=2 21,dne_dt  
	Loess/N=71/DEST=dne_dt_sm/PASS=4/ORD=1 srcWAVE=dne_dt 
	tau_p_star = ne_tot/(s_nbi+s_gas-dne_dt_sm)
	Duplicate/O tau_p_star tau_p
	tau_p = ne_tot/(s_nbi+s_gas-dne_dt+swall)
	
	Duplicate/o S_gas S_in_tot
	S_in_tot = S_gas+S_NBI
	Integrate/METH=1 S_in_tot/X=timeW_int/D=N_in_tot
	
	Duplicate/O exh_Adp S_exh_tot
	S_exh_tot = exh_adp+exh_rdpout+exh_rdpin
	Integrate/METH=1 S_exh_tot/X=timeW_int/D=N_exh_tot
	
	SetDataFolder ::
EndMacro
