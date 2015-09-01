#pragma rtGlobals=1		// Use modern global access method.

Function Build_length_matrix(imax,jmax,basewav_YN)
	Variable imax
	Variable jmax
	Variable basewav_YN

//Everything below is in cm

	if(basewav_YN==1)		
		Build_fs_radius_n_other()
	endif
	Wave out_radius = fs_outer_radi_l
	Wave tanj_radius = fs_tanj_radi_l
	
	Wavestats/M=0 out_radius
	
	Make/O/N=(imax,jmax) Length_matrix =0
	
	Variable i,j
	for (i=0;i<(imax);i+=1)
		for(j=0;j<(jmax);j+=1)	
			if (out_radius[j] > tanj_radius[i])
				if (i == j)
					Length_matrix[i][j] = 2*sqrt(out_radius[j]^2-tanj_radius[i]^2)
				elseif (i  != j )
					Length_matrix[i][j] = 2*sqrt(out_radius[j]^2-tanj_radius[i]^2)-2*sqrt(out_radius[j-1]^2-tanj_radius[i]^2)
				endif	
			elseif (out_radius[j] < tanj_radius[i])
				Length_matrix[i][j] = 0
			endif 
		endfor
	endfor
	
	//Killwaves fs_outer_radi,fs_tanj_radi
End	

Function Build_fs_radius_n_other()

	Nvar ishot = root:ishot
	Variable Z_fs = -0.205
	Variable sep_del = (4.3/100)
	Variable i
	
	//Here we are building the radius wavs for the length matrix
	Make/O/N=8 fs_outer_radi, fs_tanj_radi
	
	Variable start_radi = 221.6
	
	for (i=0;i<8; i+=1)
		fs_tanj_radi[i]=start_radi+(i)
		if (i == 2)
			fs_tanj_radi[i] +=0.1
		endif
		if (i==3)
		     fs_tanj_radi[i] +=0.08
		endif
		if (i==4)
		     fs_tanj_radi[i] +=0.11
		endif
		if (i==5)
		     fs_tanj_radi[i] +=0.07
		endif
		if (i==7)
		     fs_tanj_radi[i] +=0.08
		endif
		fs_outer_radi[i]= fs_tanj_radi[i]+0.5
	endfor
	
	//Now we are making the 'proper' geometry corrections for the radius and rho	
	
	String setname = "s"+num2istr(ishot)
	Setdatafolder root:$setname
	String aminor = "aminor_"+num2istr(ishot)
	String z0 =  "z0_"+num2istr(ishot)
	String rmid = "rmidout_"+num2istr(ishot)
	
	Wave dum2 = $aminor 
	Wave dum3 = $z0
	Wave dum4 = $rmid
	
	Duplicate/O $aminor root:aminor_new
	Wave aminor_new = root:aminor_new
	aminor_new = sqrt((dum3+Z_fs)^2+(dum2-sep_del)^2)
	
	for (i=0;i<8; i+=1)
		Duplicate/O $aminor root:$"radi_fsmid"+num2istr(i+1)
		Wave dum1 = root:$"radi_fsmid"+num2istr(i+1)
		dum1 = sqrt((dum3+Z_fs)^2+((fs_tanj_radi[i]/100)- (dum4-dum2))^2)

	endfor
	Setdatafolder root:	
	killwaves aminor_new
End
		