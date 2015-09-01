#pragma rtGlobals=1		// Use modern global access method.

Macro nebar_neped() : Graph
	PauseUpdate; Silent 1		// building window..

	Display /W=(900,516,1754,1109) neped_sm vs time_neped
	AppendToGraph nebar_sm vs time_ne
	AppendToGraph/R iu30 vs time_iu
	AppendToGraph fit_nebar_sm
	ModifyGraph marker(neped_sm)=19,marker(nebar_sm)=18,mode=0
	ModifyGraph lSize(fit_nebar_sm)=2
	ModifyGraph rgb(neped_sm)=(0,0,0),rgb(nebar_sm)=(3,52428,1),rgb(iu30)=(0,0,65535)
	ModifyGraph msize(neped_sm)=7
	ModifyGraph useMrkStrokeRGB(neped_sm)=1,useMrkStrokeRGB(nebar_sm)=1
	ModifyGraph tick=2
	ModifyGraph mirror(bottom)=1
	ModifyGraph font="Century Gothic"
	ModifyGraph fSize=12
	ModifyGraph lblMargin(left)=5
	ModifyGraph standoff=0
	ModifyGraph prescaleExp(left)=-13
	Label left "electron density (cm^-3)"
	Label bottom "time (msec)"
	SetAxis left 0,80000000000000
	SetAxis bottom 0,5500
	SetAxis right 0,5000
//	ErrorBars neped_sm Y,wave=(neped_sdev,neped_sdev)
EndMacro