#pragma rtGlobals=1		// Use modern global access method.

Function Build_fsarray(fswav)
	WAVE fswav
	
	Wavestats/q/z fswav
	Make/o/n=(V_endrow+1,8) fsarray,fsarray_err
	
	String ext
	NVAR gRadioVal2 =root:gRadioVal2
	If(gRadioVal2 == 1)
		ext="_da"
	elseif(gRadioVal2 == 2)
		ext="_c3"
	Endif
	
	String fname,fname2
	String fname_err,fname_err2
	
	Variable i
	for(i =0;i < 8;i +=1)
		fname= "fsmid"+num2str(i+1)+ext+"_avg"
		fname2="fsmid"+num2str(i+1)+ext+"_avg_corr"
		fname_err= "fsmid"+num2str(i+1)+ext+"_stdev"
		fname_err2= "fsmid"+num2str(i+1)+ext+"_stdev_corr"
		
		if (waveexists($fname2)==1)
			WAVE dummy =$fname2
		else
			WAVE dummy =$fname
		endif
		if (waveexists($fname_err2)==1)
			WAVE dummy2=$fname_err2
             else
             		WAVE dummy2=$fname_err
             	endif
              fsarray[][i] = dummy[p]
              fsarray_err[][i]=dummy2[p]
        endfor
End

