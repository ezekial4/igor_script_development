#pragma rtGlobals=1		// Use modern global access method.


Function Error_anal(y_emis,y_err,nam_base,length_matrix,invert, itermax, err_val)
	Wave y_emis
	Wave y_err
	String nam_base
	Wave length_matrix
	Variable invert
	Variable itermax
	Variable err_val // fractional amount to vary emission values 
	
	NVAR need_length =root:need_length
	if(need_length==1)
		Variable imax=8
		Variable jmax=8
		Variable YN =0
		Build_length_matrix(imax,jmax,YN)
	endif
	
	if (invert ==1)
		Variable i,fit_lgth
		
		WaveStats/Q/M=0 y_emis
		fit_lgth = V_npnts

		Variable j
		Make/O/N=(fit_lgth,itermax) mat_err_str = 0
		Make/O/N=(fit_lgth,itermax) mat_inv_str = 0
		Make/O/N=(fit_lgth)  y_random, temp

		For(i=1;i<(itermax+1);i+=1)
			y_random = y_emis +(y_err*enoise(err_val,2))
			j = i-1	
			mat_err_str[][j] = y_random[p]
			
			Matrixop/O temp= length_matrix x y_random
			mat_inv_str[][j] = temp[p]
		Endfor
		
		Make/O/N=(fit_lgth)  $nam_base+"_splavg",$nam_base+"_splplus",$nam_base+"_splminus", $nam_base+"_splsdev"
		Wave dummy3 = $nam_base+"_splavg"
		Wave dummy4 = $nam_base+"_splplus"
		Wave dummy5 = $nam_base+"_splminus"
		Wave dummy6 = $nam_base+"_splsdev"
	
		For(i=0;i<(fit_lgth);i+=1)
			ImageStats/G={i,i,0,(itermax-1)} mat_inv_str	
			dummy3[i] = V_avg
	       	dummy6[i] = V_adev
		Endfor
		
			dummy4 = dummy3 + dummy6
			dummy5 = dummy3 - dummy6
	Endif
		dummy3 *=4*pi
		dummy4 *=4*pi
		dummy5 *=4*pi
End	