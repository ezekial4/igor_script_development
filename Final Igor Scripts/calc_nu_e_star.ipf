#pragma rtGlobals=1		// Use modern global access method.

Macro Calc_nu_e(ishot,athome)
	variable ishot
	variable athome =0
	
	Silent 1
	SetDataFolder root:
	
	String dfolder = "s" + num2istr(ishot)
	If (DataFolderExists(dfolder) == 0)
			NewDataFolder $dfolder
	endif
	SetDataFolder "root:" + dfolder
	
	String dum = "teped_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	dum = "t_teped_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	
	dum="neped_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	
	dum="r0_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	dum="t_r0_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	
	dum="q95_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	dum="t_q95_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	
	dum="r_minor_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	dum="t_r_minor_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	
	dum="nev2_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	dum="t_nev2_"+num2istr(ishot)+".ibw"
	if (athome == 1)
		LoadWave/Q/O/H/P=GET_data dum
	else
		GA_Download(dum)
	endif
	
	Duplicate/O $"nev2_"+num2istr(ishot) nev2
	Duplicate/O $"t_nev2_"+num2istr(ishot) t_nev2
	Killwaves $"nev2_"+num2istr(ishot), $"t_nev2_"+num2istr(ishot)
	
	WaveStats/Q/Z $"teped_"+num2istr(ishot)
	Interpolate2/T=1/N=(V_npnts)/Y=q95_L/X=t_q95_L $"t_q95_"+num2istr(ishot), $"q95_"+num2istr(ishot)
	Duplicate/O $"q95_"+num2istr(ishot) q95
	Duplicate/O $"t_q95_"+num2istr(ishot) t_q95
	KillWaves $"q95_"+num2istr(ishot), $"t_q95_"+num2istr(ishot),t_q95_L
	Interpolate2/T=1/N=(V_npnts)/Y=r0_L/X=t_r0_L $"t_r0_"+num2istr(ishot), $"r0_"+num2istr(ishot)
	Duplicate/O $"r0_"+num2istr(ishot) r0
	Duplicate/O $"t_r0_"+num2istr(ishot) t_r0
	KillWaves $"r0_"+num2istr(ishot), $"t_r0_"+num2istr(ishot),t_r0_L
	Interpolate2/T=1/N=(V_npnts)/Y=r_minor_L/X=t_r_minor_L $"t_r_minor_"+num2istr(ishot), $"r_minor_"+num2istr(ishot)
	Duplicate/O $"r_minor_"+num2istr(ishot) r_minor
	Duplicate/O $"t_r_minor_"+num2istr(ishot) t_r_minor
	KillWaves $"r_minor_"+num2istr(ishot), $"t_r_minor_"+num2istr(ishot),t_r_minor_L
	
	Duplicate/O  $"teped_"+num2istr(ishot) teped
	KillWaves $"teped_"+num2istr(ishot)
	Duplicate/O  $"neped_"+num2istr(ishot) neped
	Killwaves $"neped_"+num2istr(ishot)
	Duplicate/O $"t_teped_"+num2istr(ishot) t_base
	Killwaves $"t_teped_"+num2istr(ishot)
	
	Duplicate/O neped nu_e_star, lambda_e
	// definition of pedestal collisionality taken from Loarte 2003
	// electron mean free path taken from Callen's plasmas physics book
	Variable z_i = 1; for dueterium
	lambda_e =  1.2e16*teped^2*(1/(neped*z_i) // also contains (17/ln_lambda) factor which is assumed 1; and Z
	nu_e_star = (r0_L^(5/2)*q95_L)/(r_minor_L^(3/2))*(1/lambda_e)((2*neped)/(1.2e16*teped^2))
//	Smooth 50, nu_e_star
	
	Display/N=nu_e nu_e_star vs t_base
	AppendToGraph/R nev2 vs t_nev2
	Silent 1
	ModifyGraph log(left)=1,rgb(nu_e_star)=(0,0,0),tick=2,mirror(bottom)=1,prescaleExp(right)=-13,standoff(bottom)=0
	ModifyGraph  standoff(right)=0,grid(bottom)=1,minor(bottom)=1,sep(bottom)=10
	SetAxis left 0.01,100
	ShowInfo
//	PauseforUser nu_e
//	print pcsr(A)
//	Wavestats/r=[pcsr(A),pcsr(B)]/q nu_e_star; print v_avg


//	Mean(nu_e_star,pcsr(A:nu_e_star),pnt2x(nu_e_star,pointNumber2)
	
	
EndMacro