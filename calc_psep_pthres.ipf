#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Macro Calc_psep_pthres(ishot)
	variable ishot
	
	string DFpath="paramDB_"+num2istr(ishot)
	variable plotIT = 0
	variable smIT = 1
	variable smPNTS = 1001
	
	Silent 1
	SetDataFolder root:
	if (DataFolderExists(DFpath) == 0)
			NewDataFolder $DFpath
	endif
	SetDataFolder "root:" + DFpath
	
	Duplicate/O POH P_THRES, P_SEP
	
	Duplicate/O PINJF PINJFsm
	if(smIT ==1)
		Smooth/B/F smPNTS, PINJFsm
		Interpolate2/T=1/I=3/Y=PINJF_L/X=t_POH t_PINJF, PINJFsm
		KillWaves PINJFsm
	else
		Interpolate2/T=1/I=3/Y=PINJ_L/X=t_POH t_PINJF, PINJF
	endif
	
	Duplicate/O PRAD_TOT PRAD_TOTsm
	if(smIT ==1)
		Smooth/B/F smPNTS, PRAD_TOTsm
		Interpolate2/T=1/I=3/Y=PRAD_TOT_L/X=t_POH t_PRAD_TOT, PRAD_TOTsm
		KillWaves PRAD_TOTsm
	else
		Interpolate2/T=1/I=3/Y=PRAD_TOT_L/X=t_POH t_PRAD_TOT, PRAD_TOT
	endif
	
	Duplicate/O ECHPWRC ECHPWRCsm
	if (numpnts(ECHPWRCsm) > 1)
		if(smIT ==1)
			Smooth/B/F smPNTS, ECHPWRCsm
			Interpolate2/T=1/I=3/Y=ECHPWRC_L/X=t_POH t_ECHPWRC, ECHPWRCsm
			KillWaves ECHPWRCsm
		else
			Interpolate2/T=1/I=3/Y=ECHPWRC_L/X=t_POH t_ECHPWRC, ECHPWRC
		endif
	else 
		Duplicate/O POH ECHPWRC_L
		ECHPWRC_L = 0.0
	endif
	
	P_SEP = PINJF_L*1000. + POH + ECHPWRC_L - PRAD_TOT_L
	
	P_THRES = 0.0488 * (DENSV2/1e20)^0.712 * (sqrt(BT0*BT0))^0.8 * PSURFA^0.94 * 1e6
	
	if(plotIT == 1)
			Display/N=PSEP_PTHRES P_SEP vs t_POH
		AppendToGraph P_THRES vs t_POH
		Silent 1
//		ModifyGraph log(left)=1,rgb(nu_e_star)=(0,0,0),tick=2,mirror(bottom)=1,prescaleExp(right)=-13,standoff(bottom)=0
//		ModifyGraph  standoff(right)=0,grid(bottom)=1,minor(bottom)=1,sep(bottom)=10
		ShowInfo
	endif
	
	SetDataFolder ::
EndMacro	