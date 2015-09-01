#pragma rtGlobals=1		// Use modern global access method.

Function Fudg_app(fudg_nam, wav_nam, err_wav)
	String fudg_nam
	String wav_nam
	String err_wav

	NVAR ishot=root:ishot
	String setname = "s"+num2istr(ishot)
	SetDataFolder root:$setname
	
	Wave Fudge=root:$fudg_nam
	Wave Wav_uncorr = $wav_nam
	Wave Err_uncorr = $err_wav
	
	Duplicate/O wav_uncorr $wav_nam+"_corr"
	Wave wav_corr = $wav_nam+"_corr"

	Duplicate/O Err_uncorr $err_wav+"_corr"
	Wave err_corr = $err_wav+"_corr"
	
	Variable hold =strsearch(wav_nam,"_",0)
	Variable i = str2num(wav_nam[hold-1])
	wav_corr= wav_uncorr+(fudge[8-i]*wav_uncorr)
	print i,fudge[8-i]
	err_corr= err_uncorr+(fudge[8-i]*err_uncorr)
	
	Setdatafolder root:	
End