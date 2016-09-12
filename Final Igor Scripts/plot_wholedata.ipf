#pragma rtGlobals=1		// Use modern global access method.

function plot_wholedata_n_2(endpnt)
	Variable endpnt
	
	setdatafolder root:plots
	
	wave alpha = root:alpha2_fin
	wave aminor = root:aminor_fin
	wave basetime = root:time_fin
	Wave bdotevampl=root:bdotevampl_fin
	Wave bdotodampl=root:bdotodampl_fin
	Wave beams=root:beams_fin
	wave betan = root:betan_fin
	wave betap = root:betap_fin
	wave bt0 = root:bt0_fin
	Wave cerqrott23 = root:cerqrott23_fin
	wave densr0 = root:densr0_fin
	wave gapout = root:gapout_fin
	Wave h_thh98y2=root:h_thh98y2_fin
	Wave h_l89=root:h_l89_fin
	wave ip = root:ip_fin
	wave iu30 = root:iu30_fin
	wave iu90 = root:iu90_fin
	wave li = root:li_fin
	wave neped = root:neped_fin
	wave newid = root:newid_fin
	Wave n1rms=root:n1rms_fin 
	Wave n2rms=root:n2rms_fin
	Wave n3rms=root:n3rms_fin
	wave parit = root:parity_fin	
	wave peped = root:peped_fin
	wave pewid = root:pewid_fin
	wave phase = root:phase_fin
	Wave pinjf=root:pinjf_fin
	Wave prad_tot=root:prad_tot_fin
	Wave prad_divl=root:prad_divl_fin
	Wave prad_divu=root:prad_divu_fin
	wave q95 = root:q95_fin
	wave r0 = root:r0_fin
	Wave rvsout=root:rvsout_fin
	wave shot = root:shot_fin	
	Wave taue=root:taue_fin
	wave teped = root:teped_fin
	wave tewid = root:tewid_fin
//	wave tor = root:tormode_fin
	wave tor = root:tormode_byhand_fin
	Wave tribot = root:tribot_fin
	Wave tste_70=root:tste_70_fin
	Wave volume=root:volume_fin
	Wave wmhd=root:wmhd_fin
	
	
	wave alf_plot=root:plots:alpha2_plot
	Wave bdotevampl_pl=root:plots:bdotevampl_pl
	Wave bdotodampl_pl=root:plots:bdotodampl_pl
	Wave beams_pl=root:plots:beams_pl
	wave betan_pl = root:plots:betan_plot
	Wave betap_pl =root:plots:betap_pl
	Wave bt0_pl = root:plots:bt0_pl
	Wave cerqrott23_pl=root:plots:cerqrott23_pl
	Wave gapout_pl=root:plots:gapout_pl
	wave liplot = root:plots:li_plot
	Wave h_thh98y2_pl=root:plots:h_thh98y2_pl
	Wave h_l89_pl=root:plots:h_l89_pl
	Wave ip_pl = root:plots:ip_pl		
	wave iu30_pl = root:plots:iu30_pl
	wave iu90_pl = root:plots:iu90_pl
	Wave n1rms_pl=root:plots:n1rms_pl
	Wave n2rms_pl=root:plots:n2rms_pl
	Wave n3rms_pl=root:plots:n3rms_pl
	wave parit_pl = root:plots:parity_pl
	wave phase_pl = root:plots:phase_pl
	Wave pinjf_pl=root:plots:pinjf_pl
	Wave prad_tot_pl=root:plots:prad_tot_pl
	Wave prad_divl_pl=root:plots:prad_divl_pl
	Wave prad_divu_pl=root:plots:prad_divu_pl
	wave q95_pl = root:plots:q95_plot	
	Wave rvsout_pl = root:plots:rvsout_pl
	Wave taue_pl=root:plots:taue_pl
	Wave tewid_pl = root:plots:tewid_pl
	wave tor_plot = root:plots:tormode_plot
	Wave tribot_pl = root:plots:tribot_pl
	Wave tste_70_pl=root:plots:tste_70_pl
	Wave wmhd_pl = root:plots:wmhd
	Wave volume_pl =root:plots:volume_pl
	
	
	duplicate/o alpha alf_plot
	duplicate/o aminor aminor_pl


	duplicate/o basetime time_pl
	duplicate/o beams beams_pl
	duplicate/o betan betan_pl
	duplicate/o betap betap_pl
	duplicate/o bdotodampl bdotodampl_pl
	duplicate/o bdotevampl bdotevampl_pl
	duplicate/o bt0 bt0_pl
	duplicate/o cerqrott23 cerqrott23_pl
	duplicate/o densr0 densr0_pl
	duplicate/o gapout gapout_pl
	duplicate/o li liplot
	duplicate/o h_thh98y2 h_thh98y2_pl
	duplicate/o h_l89 h_l89_pl
	duplicate/o ip ip_pl
	duplicate/o iu30 iu30_pl
	duplicate/o n1rms n1rms_pl
	duplicate/o n2rms n2rms_pl
	duplicate/o n3rms n3rms_pl
	duplicate/o neped neped_pl
	duplicate/o newid newid_pl
	duplicate/o parit parit_pl
	duplicate/o phase phase_pl
	duplicate/o peped peped_pl
	duplicate/o pewid pewid_pl
	duplicate/o pinjf pinjf_pl
	duplicate/o prad_tot prad_tot_pl
	duplicate/o prad_divl prad_divl_pl
	duplicate/o prad_divu prad_divu_pl
	duplicate/o q95 q95_pl
	duplicate/o rvsout rvsout_pl
	duplicate/o taue taue_pl
	duplicate/o teped teped_pl
	duplicate/o tewid tewid_pl
	duplicate/o tor tor_plot
	duplicate/o tribot tribot_pl
	duplicate/o tste_70 tste_70_pl
	duplicate/o wmhd wmhd_pl
	duplicate/o volume volume_pl
	
	iu30_pl = abs(iu30)
	
	variable i, lmodechk
	for(i=0;i<(endpnt);i+=1)
		lmodechk = teped[i]
		if((lmodechk < 350) || (lmodechk > 2500))
			betan_pl[i] = nan
			teped_pl[i] = nan
			q95_pl[i] = nan
			liplot[i] = nan
			densr0_pl[i] = nan
			neped_pl[i] = nan
		endif 
	endfor
	
     	variable betatest
     	for(i=0;i<(endpnt);i+=1)
     		betatest = betan[i]
     		if((betatest < 0) || (betatest > 10))
     			betan_pl[i] = nan
     		endif
     	endfor
	
	variable q95test
	for(i=0;i<(endpnt);i+=1)
		q95test = q95_pl[i]
		if((q95test < 0) || (q95test > 10))
			q95_pl[i] = nan
		endif
	endfor
	
	variable denstest
	for(i=0;i<(endpnt);i+=1)
		denstest = densr0_pl[i]
		if((denstest < 0) || (denstest > 1e21))
			densr0_pl[i] = nan
		endif
	endfor
	
	variable pinjtest
	for(i=0;i<(endpnt);i+=1)
		pinjtest = pinjf_pl[i]
		if((pinjtest <= 0))
			pinjf_pl[i] = nan
		endif
	endfor
	
//	variable litest
//	for(i=0;i<(endpnt);i+=1)
//		litest = li[i]
//		if((litest < 0) || (litest > 10))
//			liplot[i] = nan
//		endif
//	endfor

	Variable timebase, torvar 
	for(i=0;i<(endpnt);i+=1)
		timebase = basetime[i]
		torvar = tor[i]
		if((timebase<1470)&&(torvar == 2))
			tor[i] = 0
		endif
	endfor 

	variable count_coil, count_marg, alphavar, shotvar, i30var,i90var,paritvar,cervar
	duplicate/o q95_pl q95_sup_pl q95_marg_pl q95_nosup_pl
	duplicate/o betan_pl betan_sup_pl betan_marg_pl betan_nosup_pl
	duplicate/o densr0_pl densr0_sup_pl, densr0_nosup_pl
	count_coil = 0
	count_marg = 0
	for(i=0;i<(endpnt);i+=1)
		torvar = tor[i]
		alphavar = alpha[i]
		shotvar = shot[i]
		i30var = abs(iu30[i])
		i90var = abs(iu90[i])
		paritvar = parit[i]
		cervar= cerqrott23[i]
		
		if(alphavar == -1)
			q95_sup_pl[i] = nan
			q95_nosup_pl[i] = nan
			q95_marg_pl[i] = nan
			betan_sup_pl[i] = nan
			betan_nosup_pl[i] = nan
			betan_marg_pl[i] = nan
			densr0_sup_pl[i] = nan
			densr0_nosup_pl[i] =nan
			 densr0_pl[i] = nan
			 neped_pl[i] = nan
		endif
		if(torvar != 2)
			q95_sup_pl[i] = nan
			q95_nosup_pl[i] = nan
			q95_marg_pl[i] = nan
			betan_sup_pl[i] = nan
			betan_nosup_pl[i] = nan
			betan_marg_pl[i] = nan
			densr0_sup_pl[i] = nan
			densr0_nosup_pl[i] =nan
			densr0_pl[i] = nan
			neped_pl[i] = nan
		endif
		if(torvar == 0)
			q95_sup_pl[i] = nan
			q95_nosup_pl[i] = nan
			q95_marg_pl[i] = nan
			betan_marg_pl[i] = nan
			betan_nosup_pl[i] = nan
			betan_sup_pl[i] = nan
			densr0_sup_pl[i] = nan
			densr0_nosup_pl[i] =nan
			densr0_pl[i] = nan
			neped_pl[i] = nan
		endif	
		if((torvar == 2) && (alphavar > 0.2))
			q95_sup_pl[i] = nan
			betan_sup_pl[i] = nan
			densr0_sup_pl[i] = nan
		endif
		if((torvar == 2) && (alphavar < 0.7))
			q95_nosup_pl[i] = nan
			betan_nosup_pl[i] = nan
			densr0_nosup_pl[i] =nan
		endif
		if((torvar == 2) && (alphavar < 0.7))
			q95_nosup_pl[i] = nan
			betan_nosup_pl[i] = nan
			densr0_nosup_pl[i] =nan
		endif
		
		if(i30var < 100)
			iu30_pl[i] = nan
		endif
		
		if(cervar ==0)
			cerqrott23_pl[i] = nan
		endif
	
//---Remove QH-mode shots---
		if((shotvar >137200)&&(shotvar<137235))
			q95_sup_pl[i] = nan
			q95_nosup_pl[i] = nan
			q95_marg_pl[i] = nan
			betan_marg_pl[i] = nan
			betan_nosup_pl[i] = nan
			betan_sup_pl[i] = nan
			densr0_sup_pl[i] = nan
			densr0_nosup_pl[i] =nan
			densr0_pl[i] = nan
			neped_pl[i] = nan
		endif
		if((shotvar >138578)&&(shotvar<138613))
			q95_sup_pl[i] = nan
			q95_nosup_pl[i] = nan
			q95_marg_pl[i] = nan
			betan_marg_pl[i] = nan
			betan_nosup_pl[i] = nan
			betan_sup_pl[i] = nan
			densr0_sup_pl[i] = nan
			densr0_nosup_pl[i] =nan
			densr0_pl[i] = nan
			neped_pl[i] = nan
		endif
		if((shotvar >141351)&&(shotvar<141444))
			q95_sup_pl[i] = nan
			q95_nosup_pl[i] = nan
			q95_marg_pl[i] = nan
			betan_marg_pl[i] = nan
			betan_nosup_pl[i] = nan
			betan_sup_pl[i] = nan
			densr0_sup_pl[i] = nan
			densr0_nosup_pl[i] =nan
			densr0_pl[i] = nan
			neped_pl[i] = nan
		endif
//---End QH-mode remove---
	endfor

	Duplicate/O q95_sup_pl q95_sup_ev_pl,q95_sup_od_pl
	Duplicate/O betan_sup_pl betan_sup_ev_pl,betan_sup_od_pl
	Duplicate/O densr0_pl densr0_sup_ev_pl,densr0_sup_od_pl
	for(i=0;i<(endpnt);i+=1)
		torvar = tor[i]
		alphavar = alpha[i]
		shotvar = shot[i]
		i30var = abs(iu30[i])
		i90var = abs(iu90[i])
		paritvar = parit[i]
		
		if((torvar == 2) && (paritvar==222))
			q95_sup_od_pl[i] = nan
			betan_sup_od_pl[i] = nan
			densr0_sup_od_pl[i] = nan
		endif
		if((torvar == 2) && (alphavar > 0.2))
			q95_sup_od_pl[i] = nan
			betan_sup_od_pl[i] = nan
			densr0_sup_od_pl[i] = nan
		endif
		if((torvar == 2) && (paritvar==111))
			q95_sup_ev_pl[i] = nan
			betan_sup_ev_pl[i] = nan
			densr0_sup_ev_pl[i] = nan
		endif
		if((torvar == 2) && (alphavar > 0.2))
			q95_sup_ev_pl[i] = nan
			betan_sup_ev_pl[i] = nan
			densr0_sup_ev_pl[i] = nan
		endif
	endfor

	Duplicate/O q95_pl nu_star
	nu_star =  q95_pl*(r0)^(5/2)*(aminor)^(-3/2)*(1/8.5e21)*(neped)*(teped/1000)^-2
	
	Duplicate/O densr0_pl f_gw
	f_gw = (densr0_pl/1e20)*pi*aminor_pl^2/abs(ip_pl/1e6)
	
	Duplicate/O betap_pl betap_ped
	betap_ped = 3000*peped_pl*volume_pl/wmhd_pl
	
	Duplicate/O aminor_pl rho_star_s_ped
	rho_star_s_ped = 4.57e-3*sqrt(teped_pl)/aminor_pl/abs(bt0_pl)
	
	Duplicate/O betan_pl bet_li_pl
	bet_li_pl = betan_pl/liplot
	
	Duplicate/O n1rms_pl nrms_tot
	Duplicate/O densr0_pl del_densr0_hi, del_densr0_lo
	Duplicate/O neped_pl del_neped_hi,del_neped_lo
	nrms_tot = n1rms_pl+n2rms_pl+n3rms_pl
	
	variable tribottest
	for(i=0;i<(endpnt);i+=1)
		i30var = abs(iu30[i])	
		betatest = betan[i]
		q95test = q95_pl[i]
		tribottest = tribot[i]
		del_densr0_hi[i] = (densr0_pl[i]-densr0_pl[i-1])/densr0_pl[i]
		del_densr0_lo[i] = (densr0_pl[i]-densr0_pl[i-1])/densr0_pl[i]
		del_neped_hi[i] = (neped_pl[i]-neped_pl[i-1])/neped_pl[i]
		del_neped_lo[i] = (neped_pl[i]-neped_pl[i-1])/neped_pl[i]
		if(i30var >=2500)
			del_densr0_lo[i] = nan
			del_neped_lo[i] =nan
		elseif(i30var < 2500)
			del_densr0_hi[i] = nan
			del_neped_hi[i] =nan
		endif
		if((betatest < 2.0) && (betatest > 2.2))
			del_densr0_lo[i] = nan
			del_neped_lo[i] =nan
			del_densr0_hi[i] = nan
			del_neped_hi[i] =nan
		endif
		if((q95test < 3.45) && (q95test > 3.55))
			del_densr0_lo[i] = nan
			del_neped_lo[i] =nan
			del_densr0_hi[i] = nan
			del_neped_hi[i] =nan
		endif
		if((tribottest < 0.6) && (tribottest > 0.7))
			del_densr0_lo[i] = nan
			del_neped_lo[i] =nan
			del_densr0_hi[i] = nan
			del_neped_hi[i] =nan
		endif
	endfor

	//	for(i=0;i<(endpnt);i+=1)
//		torvar = tor[i]
//		alphavar = alpha[i]	
//		if((torvar == 0) && (alphavar < 0.8))
//			alf_plot[i] = nan
//			tor_plot[i] = nan
//			betan_pl[i] = nan
//			liplot[i] = nan
//			q95_pl[i] = nan
//			bet_li_pl[i] = nan
//		endif
//	endfor
	setdatafolder root:
end