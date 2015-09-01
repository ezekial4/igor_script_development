#pragma rtGlobals=1		// Use modern global access method.

Macro make_gener_layout(gname1, gname2)
	String gname1="nev3"
	String gname2="nebar"

//Make some dummy waves after checking if they are already there or not.	
	variable tester1= exists("fit_"+gname1)
	variable tester2= exists("fit_"+gname2)
	if (tester1 == 0)
		Make/O/N=1 $"fit_"+gname1
	endif
	if (tester2 == 0)
		Make/O/N=1 $"fit_"+gname2
	endif
	
	String plot1=gname1+"_plus"
	Display /W=(276,44,1423,723) $plot1 vs $"time_"+gname1
	DoWindow/C $gname1+"_graph"
	AppendToGraph $gname1+"_minus",$gname1,$gname1+"_sm" vs $"time_"+gname1
	AppendToGraph/R iu30 vs time_iu30
	AppendToGraph $"fit_"+gname1
	ModifyGraph marker($gname1+"_sm")=18,marker($"fit_"+gname1)=18,rgb($plot1)=(32768,65535,65535),rgb($gname1)=(1,26221,39321),rgb($gname1+"_minus")=(32768,65535,65535)
	ModifyGraph rgb(iu30)=(0,0,65535),rgb($gname1+"_sm")=(65535,49157,16385),rgb($"fit_"+gname1)=(44253,29492,58982),toMode($plot1)=1,font="Century Gothic"
	ModifyGraph prescaleExp(left)=-13,prescaleExp(bottom)=-3,prescaleExp(right)=-3,manTick(left)={0,2,0,0},manMinor(left)={1,0},lsize($gname1+"_sm")=2
	ModifyGraph grid(left)=1,grid(bottom)=1,tick=2,zero(right)=1,mirror(bottom)=1,standoff=0,mode($gname1)=2,lsize($gname1)=1,lsize($"fit_"+gname1)=2
	Label left "ne_bar (x10\\S-13\\Mcm\\S-3\\M)"
	Label bottom "Time (sec)"
	Label right "coil current (kA)"
	SetAxis left 0,100000000000000
	SetAxis bottom 1500,4000
	SetAxis right -5000,5000
	Cursor/P A $gname1 1232;Cursor/P B $gname1 1560
	ShowInfo


////   Extra for comparison
	String plot2=gname2+"_plus"
	AppendToGraph $plot2 vs $"time_"+gname2
	AppendToGraph $gname2+"_minus",$gname2,$gname2+"_sm" vs $"time_"+gname2
	AppendToGraph $"fit_"+gname2
	ModifyGraph marker($gname2+"_sm")=18,marker($"fit_"+gname2)=18,rgb($plot2)=(43690,43690,43690),rgb($gname2)=(0,0,0),rgb($gname2+"_minus")=(43690,43690,43690)
	ModifyGraph rgb($gname2+"_sm")=(65535,16385,16385),rgb($"fit_"+gname2)=(16386,65535,16385),toMode($plot2)=1,font="Century Gothic"
	ModifyGraph prescaleExp(left)=-13,prescaleExp(bottom)=-3,prescaleExp(right)=-3,manTick(left)={0,2,0,0},manMinor(left)={1,0},lsize($gname2+"_sm")=2
	ModifyGraph grid(left)=1,grid(bottom)=1,tick=2,zero(right)=1,mirror(bottom)=1,standoff=0,mode($gname2)=2,lsize($gname2)=1,lsize($"fit_"+gname2)=2
EndMacro	