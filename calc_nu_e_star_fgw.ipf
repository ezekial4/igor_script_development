#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method.

Macro Calc_nu_e(ishot)
	variable ishot
	
	string DFpath="paramDB_"+num2istr(ishot)
	variable loadIT =0
	variable athome =0
	variable plotIT =0
	variable smIT =1
	Variable z_i =3 //for dueterium
	Silent 1
	SetDataFolder root:
	
	If (DataFolderExists(DFpath) == 0)
			NewDataFolder $DFpath
	endif
	SetDataFolder "root:" + DFpath
	
	if(loadIT == 1)
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
	endif
	
	//Interpolate2/T=1/N=(V_npnts)/Y=q95_L/X=t_q95_L $"t_q95_"+num2istr(ishot), $"q95_"+num2istr(ishot)
	Interpolate2/T=1/I=3/Y=Q95_L/X=t_NEPED t_Q95, Q95
		
	//Duplicate/O $"q95_"+num2istr(ishot) q95
	//Duplicate/O $"t_q95_"+num2istr(ishot) t_q95
	
	//Interpolate2/T=1/N=(V_npnts)/Y=r0_L/X=t_r0_L $"t_r0_"+num2istr(ishot), $"r0_"+num2istr(ishot)
	Interpolate2/T=1/I=3/Y=R0_L/X=t_NEPED t_R0, R0
	
	//Duplicate/O $"r0_"+num2istr(ishot) r0
	//Duplicate/O $"t_r0_"+num2istr(ishot) t_r0
	
	Interpolate2/T=1/I=3/Y=r_minor_L/X=t_NEPED t_AMINOR, AMINOR
	
//	Duplicate/O $"r_minor_"+num2istr(ishot) r_minor
//	Duplicate/O $"t_r_minor_"+num2istr(ishot) t_r_minor
	
	Interpolate2/T=1/I=3/Y=IP_L/X=t_NEPED t_IP, IP
	Interpolate2/T=1/I=3/Y=DENSR0_L/X=t_NEPED t_DENSR0, DENSR0
	
//	Duplicate/O  $"teped_"+num2istr(ishot) teped
//	KillWaves $"teped_"+num2istr(ishot)
//	Duplicate/O  $"neped_"+num2istr(ishot) neped
//	Killwaves $"neped_"+num2istr(ishot)
//	Duplicate/O $"t_teped_"+num2istr(ishot) t_base
//	Killwaves $"t_teped_"+num2istr(ishot)
	
	Duplicate/O NEPED NU_E_STAR, LAMBDA_E, f_GW_PED, f_GW, LNG_A, LNG_B, LN_LAMBDA
	// definition of pedestal collisionality taken from Loarte 2003
	// electron mean free path taken from Callen's plasmas physics book, appendix Z
	LNG_A = 5e-10*(z_i/teped)
	LNG_B = 1.1e-10*(1/teped)
	LN_LAMBDA = LN((7.4e3*sqrt(teped/neped))/max(LNG_A,LNG_B))
	LAMBDA_E =  1.2e16*teped^2*(1/(neped*z_i))*(17/LN_LAMBDA) 
	NU_E_STAR = (r0_L^(5/2)*q95_L)/(r_minor_L^(3/2))*(1/LAMBDA_E) 
	
	f_GW_PED = (NEPED/1e20)/((1e-6*abs(IP_L))/(pi*r_minor_L^2))
	f_GW = (DENSR0_l/1e20)*(pi*r_minor_L^2)/(1e-6*abs(IP_L))
	
	KillWaves R0_L,Q95_L,r_minor_L,IP_L,LNG_B,LNG_A,LN_LAMBDA
	
	if(smIT ==1)
		Smooth 11, nu_e_star
		Smooth 11, f_GW_PED
	endif
	
	if(plotIT == 1)
		Duplicate/O $"nev2_"+num2istr(ishot) nev2
		Duplicate/O $"t_nev2_"+num2istr(ishot) t_nev2
		Killwaves $"nev2_"+num2istr(ishot), $"t_nev2_"+num2istr(ishot)
	
		Display/N=nu_e nu_e_star vs t_base
		AppendToGraph/R nev2 vs t_nev2
		Silent 1
		ModifyGraph log(left)=1,rgb(nu_e_star)=(0,0,0),tick=2,mirror(bottom)=1,prescaleExp(right)=-13,standoff(bottom)=0
		ModifyGraph  standoff(right)=0,grid(bottom)=1,minor(bottom)=1,sep(bottom)=10
		SetAxis left 0.01,100
		ShowInfo
	endif
	
	SetDataFolder ::
EndMacro