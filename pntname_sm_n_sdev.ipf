#pragma rtGlobals=1		// Use modern global access method.

//---This FUNCTION is meant to get a smoothed (true) signal from a noisey signal and then calculate a standard
//---deviation of the signal from this true signal. 
//---Taken from BEvington eq. 1.8
//---var^2 = (1/N)*SUM(datapoint-truepoint)^2

	
Function pntname_sm_n_sdev(i_sm,foldnam,fname,sm_type)
	Variable i_sm 
	String foldnam
	String fname 
	Variable sm_type              //use 1 for boxcar; 2 for median
	
	Silent 1;DelayUpdate
	SetDataFolder foldnam
// Now my crude way of getting an average signal
	Duplicate/O $fname $fname+"_sm"

//---Using a boxcar smoothing technique
	If (sm_type == 1)
		Smooth/B i_sm,$fname+"_sm"
	Endif
//---Using a median value smoothing technique
	If (sm_type == 2)
		Smooth/M=0 i_sm,$fname+"_sm"
	Endif
	
//Another crude way to sum square signals
	Duplicate/O $fname+"_sm" $"sm_"+fname+"_sqd"
	Wave dum = $"sm_"+fname+"_sqd" 
	Wave dum1 = $fname
	Wave dum2 = $fname+"_sm"
	dum = (dum1  - dum2)*(dum1 - dum2)
	Smooth/b i_sm, dum

	Duplicate/O $"sm_"+fname+"_sqd" $fname+"_var"
	Wave dum3 = $fname+"_var" 
	dum3 = dum

	Duplicate/O $fname+"_var" $fname+"_sdev"
	Wave dum4 = $fname+"_sdev"
	dum4 = sqrt(dum3)

	Duplicate/O $fname $fname+"_plus" $fname+"_minus"
	Wave dum5 =$fname+"_plus"
	Wave dum6 =$fname+"_minus" 
	dum5 = (dum2) + (dum4)
	dum6 = (dum2) -(dum4)

	KillWaves/Z $fname+"_var", $fname+"_sqd",$fname+"_sm_sqd",$"sm_"+fname+"_sqd"
	SetDataFolder root:
End