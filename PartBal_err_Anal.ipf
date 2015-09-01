#pragma rtGlobals=1		// Use modern global access method.


Macro Run_err_anal(ishot,smoo,cleanup,noNBI)
	variable ishot
	variable smoo
	variable cleanup
	variable noNBI
	Silent 1; DelayUpdate
	
//---First get average signals and stdev
	//for S_NBI need P_INJ
	if (noNBI == 0)
		trunc_n_interp_v2("timeW","pinj_"+num2istr(ishot))
		match_uneven_timebase(timeW,"pinj_"+num2istr(ishot)+"_trunc_L")
		Duplicate/O/D $"pinj_"+num2istr(ishot)+"_trunc_L_valu" $"pinj_"+num2istr(ishot)+"_trunc_L"
		KillWaves/Z $"pinj_"+num2istr(ishot)+"_trunc_L_valu"
		pntname_sm_n_sdev(smoo,"pinj_"+num2istr(ishot)+"_trunc_L" ,1)
	endif
	
//for S_GAS need gasA (or equivalant)
	trunc_n_interp_v2("timeW","v_gas_"+num2istr(ishot))
	match_uneven_timebase(timeW,"v_gas_"+num2istr(ishot)+"_trunc_L")
	Duplicate/O/D $"v_gas_"+num2istr(ishot)+"_trunc_L_valu" $"v_gas_"+num2istr(ishot)+"_trunc_L"
	KillWaves/Z $"v_gas_"+num2istr(ishot)+"_trunc_L_valu"
	pntname_sm_n_sdev(smoo,"v_gas_"+num2istr(ishot)+"_trunc_L",2)
	
//for Q_cryo need asdex gauge measurements
	trunc_n_interp_v2("timeW","lobaf_"+num2istr(ishot))
	match_uneven_timebase(timeW,"lobaf_"+num2istr(ishot)+"_trunc_L")
	Duplicate/O/D $"lobaf_"+num2istr(ishot)+"_trunc_L_valu" $"lobaf_"+num2istr(ishot)+"_trunc_L"
	KillWaves/Z $"lobaf_"+num2istr(ishot)+"_trunc_L_valu"
	pntname_sm_n_sdev(smoo,"lobaf_"+num2istr(ishot)+"_trunc_L",2)
	trunc_n_interp_v2("timeW","upbaf_"+num2istr(ishot))
	match_uneven_timebase(timeW,"upbaf_"+num2istr(ishot)+"_trunc_L")
	Duplicate/O/D $"upbaf_"+num2istr(ishot)+"_trunc_L_valu" $"upbaf_"+num2istr(ishot)+"_trunc_L"
	KillWaves/Z $"upbaf_"+num2istr(ishot)+"_trunc_L_valu"
	pntname_sm_n_sdev(smoo,"upbaf_"+num2istr(ishot)+"_trunc_L",2)
	trunc_n_interp_v2("timeW","rdp_"+num2istr(ishot))
	match_uneven_timebase(timeW,"rdp_"+num2istr(ishot)+"_trunc_L")
	Duplicate/O/D $"rdp_"+num2istr(ishot)+"_trunc_L_valu" $"rdp_"+num2istr(ishot)+"_trunc_L"
	KillWaves/Z $"rdp_"+num2istr(ishot)+"_trunc_L_valu"
	pntname_sm_n_sdev(smoo,"rdp_"+num2istr(ishot)+"_trunc_L",2)
	
//Need dirivative of pressure for the dNeu/dt calculation
	Redimension/D $"lobaf_"+num2istr(ishot)+"_trunc_L"
	Redimension/D $"upbaf_"+num2istr(ishot)+"_trunc_L"
	Redimension/D $"rdp_"+num2istr(ishot)+"_trunc_L"
	Loess/N=1001/DEST= $"lobaf_"+num2istr(ishot)+"_trunc_L"/PASS=4/ORD=1 srcWAVE= $"lobaf_"+num2istr(ishot)+"_trunc_L"
	Differentiate/METH=1 $"lobaf_"+num2istr(ishot)+"_trunc_L"/X=$"timew_int"/D=$"lobaf_"+num2istr(ishot)+"_DIF"
	pntname_sm_n_sdev(smoo,"lobaf_"+num2istr(ishot)+"_DIF",2)
	Loess/N=11/DEST= $"upbaf_"+num2istr(ishot)+"_trunc_L"/PASS=4/ORD=1/R=1 srcWAVE= $"upbaf_"+num2istr(ishot)+"_trunc_L"
	Differentiate/METH=1 $"upbaf_"+num2istr(ishot)+"_trunc_L"/X=$"timew_int"/D=$"upbaf_"+num2istr(ishot)+"_DIF"
	pntname_sm_n_sdev(smoo,"upbaf_"+num2istr(ishot)+"_DIF",2)
	Loess/N=11/DEST= $"rdp_"+num2istr(ishot)+"_trunc_L"/PASS=4/ORD=0/R=1 srcWAVE= $"rdp_"+num2istr(ishot)+"_trunc_L"
	Differentiate/METH=1 $"rdp_"+num2istr(ishot)+"_trunc_L"/X=$"timew_int"/D=$"rdp_"+num2istr(ishot)+"_DIF"
	pntname_sm_n_sdev(smoo,"rdp_"+num2istr(ishot)+"_DIF",2)

 //Finally for the DN_core measurement
//	Loess/N=101/DEST=ne_tot_sm/PASS=4/ORD=1 srcWAVE=ne_tot
	Differentiate/METH=2 ne_tot_sm/X=timew_int/D=ne_tot_sm_DIF
	Duplicate/O ne_tot_sm_DIF, dne_dt
	pntname_sm_n_sdev(smoo,"dne_dt",1)
	dne_dt_sdev = abs(dne_dt_sdev)

//----Now get all the stdev.'s for each term
	//for the S_NBI
	// we have the hot nuetral contribution of 1.7 Torr-L/s/MW from Maingi 1996 and 25% of that for the cold nuetral contribution
		if (noNBI ==0) 
			Duplicate/O s_nbi stdev_nbi_hot, stdev_nbi_cold, sdev_nbi
			stdev_nbi_hot =  s_nbi*sqrt((0.1/1.7)^2 +($"pinj_"+num2istr(ishot)+"_trunc_L_sdev"/$"pinj_"+num2istr(ishot)+"_trunc_L_sm")^2)
			stdev_nbi_cold =  s_nbi*sqrt((0.25^2*(0.1/1.7)^2) +($"pinj_"+num2istr(ishot)+"_trunc_L_sdev"/$"pinj_"+num2istr(ishot)+"_trunc_L_sm")^2)
			sdev_nbi = stdev_nbi_hot+stdev_nbi_cold
	
			sdev_nbi=(numtype(sdev_nbi)== 2) ? 0 :sdev_nbi
			sdev_nbi=(numtype(sdev_nbi)== 1) ? 0 :sdev_nbi
		endif
	
	//for the S_gas
		Wavestats/Q s_gas
		String basewave = "v_gas_"+num2istr(ishot)+"_trunc_L"
		Duplicate/O $"v_gas_"+num2istr(ishot)+"_trunc_L" sdev_gas,cali_gas_flow
		Wavestats/Q $"v_gas_"+num2istr(ishot)+"_trunc_L" 
		Variable endpnt=V_endrow
		gas_cal_script(s_gas,endpnt,ishot,$basewave,cali_gas_flow)
		sdev_gas=s_gas*sqrt((0.1/cali_gas_flow)^2 +($"v_gas_"+num2istr(ishot)+"_trunc_L_sdev")^2)
	
	//for q_cryo
		Duplicate/O $"lobaf_"+num2istr(ishot)+"_trunc_L_sm", sdev_exh_adp,sdev_exh_rdpIN,sdev_exh_rdpout
		Duplicate/O exh_adp exh_tot
		exh_tot =exh_adp+exh_rdpin+exh_rdpout
	
		// Canstant values are for relative error in pumping speed
			sdev_exh_adp = exh_adp*sqrt((0.08^2+($"lobaf_"+num2istr(ishot)+"_trunc_L_sdev"/$"lobaf_"+num2istr(ishot)+"_trunc_L_sm")^2))
			sdev_exh_rdpin = exh_rdpin*sqrt((0.08^2+($"rdp_"+num2istr(ishot)+"_trunc_L_sdev"/$"rdp_"+num2istr(ishot)+"_trunc_L_sm")^2))
			sdev_exh_rdpout = exh_rdpout*sqrt((0.08^2+($"upbaf_"+num2istr(ishot)+"_trunc_L_sdev"/$"upbaf_"+num2istr(ishot)+"_trunc_L_sm")^2))

	//for dneu/dt
		Duplicate/O $"lobaf_"+num2istr(ishot)+"_DIF_sm", relerr_dn0dt_adp,relerr_dn0dt_rdpin,relerr_dn0dt_rdpout,relerr_dn0dt_tot
		relerr_dn0dt_adp=sqrt((.01/1.02)^2+(abs($"lobaf_"+num2istr(ishot)+"_DIF_sdev")/abs($"lobaf_"+num2istr(ishot)+"_DIF_sm"))^2)
		relerr_dn0dt_rdpout=sqrt((.01/1.02)^2+(abs($"upbaf_"+num2istr(ishot)+"_DIF_sdev")/abs($"upbaf_"+num2istr(ishot)+"_DIF_sm"))^2)
		relerr_dn0dt_rdpin=sqrt((.01/1.02)^2+(abs($"rdp_"+num2istr(ishot)+"_DIF_sdev")/abs($"rdp_"+num2istr(ishot)+"_DIF_sm"))^2)
	
		relerr_dn0dt_adp =0
	
		relerr_dn0dt_tot =0
		relerr_dn0dt_tot=relerr_dn0dt_adp+relerr_dn0dt_rdpin+relerr_dn0dt_rdpout
		relerr_dn0dt_tot=(numtype(relerr_dn0dt_tot[p])== 1) ? 0 : relerr_dn0dt_tot[p]
		relerr_dn0dt_tot=relerr_dn0dt_tot[p] > 100 ? 0 : relerr_dn0dt_tot[p]

		relerr_dn0dt_tot /=100

	//---calculating the relative error for swall
	duplicate/o swall sdev_swall_rel, relerr_gas,relerr_nbi,relerr_exh,relerr_dn0dt,relerr_dnedt

	relerr_gas= sdev_gas/S_gas
	relerr_gas=(numtype(relerr_gas)== 2) ? 0 :relerr_gas

	if (noNBI ==0) 
		relerr_nbi=s_nbi_sdev/s_nbi_sm
		relerr_nbi=(numtype(relerr_nbi)== 2) ? 0 :relerr_nbi
	endif

	relerr_exh=(sdev_exh_adp+sdev_exh_rdpin+sdev_exh_rdpout)/exh_tot
	relerr_exh=(numtype(relerr_exh)== 2) ? 0 :relerr_exh
	relerr_dnedt=dne_dt_sdev/abs(dne_dt_sm)
	relerr_dnedt=(numtype(relerr_dnedt)== 2) ? 0 :relerr_dnedt
	
	KillWaves/Z nom1,nom2,nom3
	
	if (noNBI ==1) 
		sdev_swall_rel = sqrt((relerr_gas)^2+(relerr_exh)^2+(relerr_dn0dt)^2+(relerr_dnedt)^2)
	else
		sdev_swall_rel = sqrt((relerr_gas)^2+(relerr_nbi)^2+(relerr_exh)^2+(relerr_dnedt)^2+(relerr_dn0dt)^2)
	endif
	
	//-- now get the error bands for swall
	Duplicate/o swall swall_plus, swall_minus, swall_plot
	smooth/m=0 15, sdev_swall_rel
	smooth/m=0 15, swall_plot
	swall_plus = swall_plot+(swall_plot*sdev_swall_rel)
	swall_minus = swall_plot -(swall_plot*sdev_swall_rel)
	
	// now calculating the relative error for nwall
	Duplicate/o nwall relerr_nwall, nwall_plus, nwall_minus, relerr_nwall2
	relerr_nwall = sqrt((timew_int[p+1]-timew_int[p])^2*(((swall[p+1]*sdev_swall_rel[p+1])+(swall[p]*sdev_swall_rel[p]))/2)^2)
	smooth/m=0 15, relerr_nwall
	nwall_plus=nwall+(nwall*relerr_nwall);
	nwall_minus=nwall-(nwall*relerr_nwall)
	
	//-- Get the other wave_plus; wave_minus waves
	S_gas_plus = s_gas+(s_gas*relerr_gas)
	s_gas_minus=s_gas-(s_gas*relerr_gas)
	
	S_nbi_plus = s_nbi+(S_nbi*relerr_nbi)
	s_nbi_minus= s_nbi-(s_nbi*relerr_nbi)
	
	Duplicate/O exh_tot exh_tot_plus, exh_tot_minus
	exh_tot_plus=exh_tot+(exh_tot*relerr_exh)
	exh_tot_minus=exh_tot-(exh_tot*relerr_exh)
	
	//Clean up waves
	If (cleanup ==1)
	Killwaves/Z cali_gas_flow,relerr_gas,relerr_nbi,relerr_exh,relerr_dn0dt,relerr_dnedt,sdev_swall_rel,$"lobaf_"+num2istr(ishot)+"_DIF_plus",$"lobaf_"+num2istr(ishot)+"_DIF_minus"
	endif
End