#pragma rtGlobals=1		// Use modern global access method.

Macro make_rot_layout(gname2)
	String gname2="cert23q"
	
	String gname1="nev3"
	String plot1=gname1+"_plus"
	Display /W=(276,44,1423,723) $plot1 vs $"time_"+gname1
	DoWindow/C $gname2+"_graph"
	AppendToGraph $gname1+"_minus",$gname1,$gname1+"_sm" vs $"time_"+gname1
	AppendToGraph/R iu30 vs time_iu
	AppendToGraph $"fit_"+gname1
	ModifyGraph marker($gname1+"_sm")=18,marker($"fit_"+gname1)=18,rgb($plot1)=(32768,65535,65535),rgb($gname1)=(1,26221,39321),rgb($gname1+"_minus")=(32768,65535,65535)
	ModifyGraph rgb(iu30)=(0,0,65535),rgb($gname1+"_sm")=(65535,49157,16385),rgb($"fit_"+gname1)=(44253,29492,58982),toMode($plot1)=1,font="Century Gothic"
	ModifyGraph prescaleExp(left)=-13,prescaleExp(bottom)=-3,prescaleExp(right)=-3,manTick(left)={0,2,0,0},manMinor(left)={1,0},lsize($gname1+"_sm")=2
	ModifyGraph grid(left)=1,grid(bottom)=1,tick=2,zero(right)=1,mirror(bottom)=1,standoff=0,mode($gname1)=2,lsize($gname1)=1,lsize($"fit_"+gname1)=2, lblPos(right)=50
	Label left "ne_bar (x10\\S-13\\Mcm\\S-3\\M)"
	Label bottom "Time (sec)"
	Label right "coil current (kA)"
	SetAxis left 0,100000000000000
	SetAxis bottom 1500,4000
	SetAxis right -5000,5000
	Cursor/P A $gname1 1232;Cursor/P B $gname1 1560
	ShowInfo


////   Extra for comparison	
	Duplicate/O $gname2 $gname2+"_plus", $gname2+"_minus"
	$gname2+"_plus" = ($gname2) + ($gname2+"u")
	$gname2+"_minus" = ($gname2) - ($gname2+"u")
	
	AppendToGraph/R=Rot $gname2+"_plus",$gname2,$gname2+"_minus" vs $"time_"+gname2
	
	ModifyGraph font="Century Gothic", grid(left)=1,grid(bottom)=1,tick=2,zero(right)=1,mirror(bottom)=1,standoff=0
	ModifyGraph lblPos(Rot)=70,freePos(Rot)=75,margin(right)=144,mode( $gname2+"_plus")=7,hbFill( $gname2+"_plus")=2,toMode( $gname2+"_plus")=1
	ModifyGraph rgb($gname2+"_plus")=(65535,49151,49151),plusRGB($gname2+"_plus")=(65535,49151,49151),negRGB($gname2+"_plus")=(65535,49151,49151)
	ModifyGraph mode($gname2)=7,hbFill($gname2)=2,toMode($gname2)=1,lsize($gname2)=2,usePlusRGB($gname2)=1,plusRGB($gname2)=(65535,49151,49151)
	ModifyGraph useNegRGB($gname2)=1,negRGB($gname2)=(65535,49151,49151),rgb($gname2+"_minus")=(65535,49151,49151)
	Label Rot "Rotation (m/s)"
	
EndMacro	