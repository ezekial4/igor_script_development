#pragma rtGlobals=1		// Use modern global access method.

Function trunc_n_interp(ishot,basewav,interpnam,ext)
	Variable ishot
	Wave basewav
	String interpnam
	String ext
	
	Wavestats/M=1/Q basewav
	Variable truncstart = basewav[V_startrow+1]
	Variable truncend = basewav[V_endrow-2]
	Variable wavpnt = (V_endrow+1-3)
	
	Variable i,j
	for (i=1;i<9;i +=1)
		Wave dum2 = $"t_"+interpnam+num2str(i)+ext
		FindValue/T=2/V=(truncstart) dum2
		DeletePoints 0, (V_value+1), dum2
		DeletePoints 0, (V_value+1), $interpnam+num2str(i)+ext
		
		FindValue/T=2/V=(truncend) dum2
		DeletePoints (V_Value+1-2), 1e6, dum2
		DeletePoints (V_Value+1-2), 1e6, $interpnam+num2str(i)+ext

		Interpolate2/T=1/N=(wavpnt)/Y=$interpnam+num2str(i)+ext+"_L"/X=$"t_"+interpnam+num2str(i)+ext+"_L" dum2, $interpnam+num2str(i)+ext

		KillWaves $interpnam+num2str(i)+ext+"_L"
	endfor
End