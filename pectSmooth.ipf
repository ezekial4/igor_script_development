#pragma rtGlobals=1		// Use modern global access method.

Function Takeoff_bac(pntsm,interppnt,wav)
	Variable pntsm
	Variable interppnt
	String wav
	
	Variable frac =0.3
	Get_back(wav,pntsm,frac)
	
	String neuwav = wav+"_bac"
	Wave wav1 = $wav
	Wave wav2 = $neuwav
	
	String finalwav = wav[0,11]+"fin"
	String tempwav =  wav[0,11]+"temp"
	
	Duplicate/O wav1 $finalwav, $tempwav
	Wave wav3 = $finalwav
	Wave wav4 = $tempwav
	
	Wave twav = timebase_l
	Variable Nums = 1000
	Interpolate2/T=1/N=(Nums)/A=(interppnt)/J=0/Y=wav4 twav, wav2

	wav3 = wav1 - wav4
	
	KillWaves wav2,wav4
end

Function Get_back(wav,pntsm,frac)
	String wav
	Variable pntsm
	Variable frac
	
	Wave wav1 = $wav
	Wavestats/Q wav1
	Variable wavpnts = V_npnts
	
	String neuwav = wav+"_bac"
	Duplicate/O wav1 $neuwav
	Wave wav2 = $neuwav
	Variable i,result
	For(i=0;i< wavpnts; i +=pntsm)
		result = PerctSmooth(frac,wav1,i,(i+pntsm))
		wav2[i,(i+pntsm)] = result
	endfor
End

Function/D PerctSmooth(frac,w, x1, x2)	// Returns median value of wave w
	Variable frac 	// fraction of distribustion to take
	Wave w
	Variable x1, x2	// range of interest

	Variable result

	Duplicate/O/R=[x1,x2] w, tempWave	// Make a clone of wave
	Sort tempWave, tempWave	// Sort clone
	SetScale/P x 0,1,tempWave
	result = tempWave((numpnts(tempWave)-1)*frac)
	WaveStats/Q/R=[(numpnts(tempWave)-1)*frac] tempWave
	KillWaves tempWave
	return result
End