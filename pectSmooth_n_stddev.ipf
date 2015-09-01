#pragma rtGlobals=1		// Use modern global access method.

Function/D PerctSmooth(frac,w, x1, x2)	// Returns median value of wave w
	Variable frac 	// fraction of distribustion to take
	Wave w
	Variable x1, x2	// range of interest

	Variable/G root:result,root:stddev,root:result2

	Duplicate/O/R=[x1,x2] w, tempWave	// Make a clone of wave
	Sort tempWave, tempWave	// Sort clone
	SetScale/P x 0,1,tempWave
	NVAR/SDFR=root: result 
	result = tempWave((numpnts(tempWave)-1)*frac)
	
	WaveStats/Q/R=[(numpnts(tempWave)-1)*frac] tempWave
	NVAR/SDFR=root: stddev 
	stddev = V_sdev
	NVAR/SDFR=root: result2
	result2 = V_avg
	
	Print V_avg, V_sdev,V_sem
	KillWaves tempWave
End