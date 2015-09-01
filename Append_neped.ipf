#pragma rtGlobals=1		// Use modern global access method.
	
Macro append_neped_layout()

	Duplicate/O neped neped_cm
	Duplicate/O neped_err neped_err_cm
	neped_cm /=1e6
	neped_err_cm /=1e6
	Make/O/N=1 fit_neped_cm
       AppendToGraph neped_cm vs time_neped
	AppendToGraph fit_neped_cm
	ModifyGraph rgb(neped_cm)=(1,52428,26586)
	ModifyGraph mode(neped_cm)=4
	ModifyGraph marker(neped_cm)=19
	ModifyGraph lSize(fit_neped_cm)=3
	ModifyGraph rgb(fit_neped_cm)=(0,0,0)
	ModifyGraph msize(neped_cm)=3
	ModifyGraph useMrkStrokeRGB(neped_cm)=1
	ErrorBars neped_cm Y,wave=(neped_err_cm,:neped_err_cm)
	
EndMacro