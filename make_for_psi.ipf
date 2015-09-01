#pragma rtGlobals=1		// Use modern global access method.

Window make_for_psi() : Graph
	PauseUpdate; Silent 1		// building window...
	Display /W=(514,44,1114,944) as "PSI_graph"
	ModifyGraph margin(bottom)=1,margin(top)=10
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0,1,0.24)/HOST=#  dne_dt vs timeW
	AppendToGraph/R ne_tot vs timeW
	SetDataFolder fldrSav0
	ModifyGraph margin(left)=40,margin(bottom)=30,margin(top)=10,margin(right)=40
	ModifyGraph lSize(dne_dt)=3,lSize(ne_tot)=2
	ModifyGraph lStyle(dne_dt)=3
	ModifyGraph rgb(ne_tot)=(0,0,0)
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font(left)="Helvetica",font(right)="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12,fSize(right)=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop=1
	ModifyGraph manTick(left)={0,20,0,0},manMinor(left)={1,50}
	Label left "\\Z14dN\\B\\Z12e\\M\\Z14/dt [Torr-L/s]"
	Label right "\\Z14Total N\\B\\Z12e\\M\\Z14 Inventory  [Torr-L]"
	SetAxis/N=1 left -80,80
	SetAxis bottom 0,4700
	SetAxis right 0,100
	TextBox/C/N=text0/X=42.73/Y=4.30 "\\Z14Shot 132463"
	TextBox/C/N=text1/F=0/B=1/A=MC/X=-39.23/Y=36.36 "\\Z14Plasma, N\\B\\Z14e"
	RenameWindow #,G0
	SetActiveSubwindow ##
	String fldrSav1= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.25,1,0.49)/HOST=#  s_nbi vs timeW
	AppendToGraph s_gas vs timeW
	AppendToGraph/R N_in_tot vs timeW
	SetDataFolder fldrSav1
	ModifyGraph margin(left)=40,margin(bottom)=30,margin(top)=10,margin(right)=40
	ModifyGraph lSize(s_nbi)=2,lSize(N_in_tot)=2
	ModifyGraph lStyle(s_nbi)=3
	ModifyGraph rgb(N_in_tot)=(0,0,0)
	ModifyGraph tick=2
	ModifyGraph mirror(bottom)=1
	ModifyGraph font(left)="Helvetica",font(right)="Helvetica"
	ModifyGraph minor(left)=1
	ModifyGraph sep(left)=2
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize(left)=12,fSize(right)=12
	ModifyGraph standoff=0
	ModifyGraph axisOnTop(left)=1,axisOnTop(bottom)=1
	ModifyGraph manTick(left)={0,10,0,0},manMinor(left)={1,50}
	Label left "\\Z14Feed Rate, S\\Z14\\BIN\\M\\Z14 [Torr-L/s]"
	Label right "\\Z14Total Feed  [Torr-L]"
	SetAxis/N=1 left 0,80
	SetAxis bottom 0,4700
	SetAxis right 0,100
	TextBox/C/N=text0/F=0/B=1/A=MC/X=-38.27/Y=29.55 "\\F'Helvetica'\\Z14Gas Puff"
	TextBox/C/N=text1/F=0/B=1/A=MC/X=18.85/Y=-22.73 "\\F'Helvetica'\\Z14NBI"
	RenameWindow #,G1
	SetActiveSubwindow ##
	String fldrSav2= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.5,1,0.74)/HOST=#  exh_tot vs timeW
	AppendToGraph/R N_exh_tot vs timeW
	SetDataFolder fldrSav2
	ModifyGraph margin(left)=40,margin(bottom)=30,margin(top)=5,margin(right)=40
	ModifyGraph lSize=2
	ModifyGraph lStyle(exh_tot)=3
	ModifyGraph rgb(N_exh_tot)=(0,0,0)
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica"
	ModifyGraph noLabel(bottom)=2
	ModifyGraph fSize=12
	ModifyGraph lblMargin(bottom)=3
	ModifyGraph standoff(left)=0,standoff(bottom)=0
	ModifyGraph axisOnTop(left)=1,axisOnTop(bottom)=1
	ModifyGraph manTick(left)={0,10,0,0},manMinor(left)={1,50}
	Label left "\\Z14Exhuast Rate, Q\\Z14\\BCRYO\\M\\Z14 [Torr-L/s]"
	Label bottom "Time [ms]"
	Label right "\\Z14Total Exhaust  [Torr-L]"
	SetAxis/N=1 left 0,60
	SetAxis bottom 0,4700
	SetAxis right 0,100
	Legend/C/N=text0/J/F=0/A=MC/X=-38.27/Y=34.81 "\\F'Helvetica'\\Z14All Cryo Pumps"
	RenameWindow #,G2
	SetActiveSubwindow ##
	String fldrSav3= GetDataFolder(1)
	SetDataFolder root:s132463:
	Display/W=(0,0.75,1,1)/HOST=#  swall vs timeW
	AppendToGraph/R nwall vs timeW
	SetDataFolder fldrSav3
	ModifyGraph margin(left)=40,margin(bottom)=30,margin(top)=10,margin(right)=40
	ModifyGraph lSize=2
	ModifyGraph lStyle(swall)=3
	ModifyGraph rgb(nwall)=(0,0,0)
	ModifyGraph tick=2
	ModifyGraph zero(left)=1
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Helvetica"
	ModifyGraph fSize=12
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(bottom)=-3
	ModifyGraph axisOnTop(left)=1,axisOnTop(bottom)=1
	ModifyGraph manTick(left)={0,20,0,0},manMinor(left)={1,0}
	ModifyGraph manTick(bottom)={0,1,0,0},manMinor(bottom)={1,0}
	Label left "\\Z14Wall Load Rate, S\\Z14\\BWall\\M\\Z14 [Torr-L/s]"
	Label bottom "time [sec]"
	Label right "\\Z14Total Wall Load  [Torr-L]"
	SetAxis/N=1 left -80,80
	SetAxis bottom 0,4700
	SetAxis right 0,100
	RenameWindow #,G3
	SetActiveSubwindow ##
EndMacro
