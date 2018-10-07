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
	String holdSTR,t_holdSTR
	for (i=1;i<9;i +=1)
		t_holdSTR="t_"+interpnam[0,1]+num2str(i)+interpnam[2,4]+ext[1,2]
		holdSTR=interpnam[0,1]+num2str(i)+interpnam[2,4]+ext[1,2]
		Wave dum2 = $t_holdSTR
		FindValue/T=2/V=(truncstart) dum2
		DeletePoints 0, (V_value+1), dum2
		DeletePoints 0, (V_value+1), $holdSTR
		
		FindValue/T=2/V=(truncend) dum2
		DeletePoints (V_Value+1-2), 1e6, dum2
		DeletePoints (V_Value+1-2), 1e6, $holdSTR

		Interpolate2/T=1/N=(wavpnt)/Y=$holdSTR+"_L"/X=$t_holdSTR+"_L" dum2, $holdSTR
		KillWaves $holdSTR+"_L"
	endfor
End