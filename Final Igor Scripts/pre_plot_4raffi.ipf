#pragma rtGlobals=1		// Use modern global access method.

function pre_plot_4Raffi(endpnt)
	Variable endpnt
	
	setdatafolder root:plots
	
	wave basetime = root:time_fin
	wave teped = root:teped_fin
//	wave tor = root:tormode_fin
	wave tor = root:tormode_byhand_fin
	wave alpha = root:alpha2_fin
	wave aminor = root:aminor_fin
	wave betan = root:betan_fin
	wave densr0 = root:densr0_fin
	wave densv3 = root:densv3_fin
	wave q95 = root:q95_fin
	wave li = root:li_fin
	wave r0 = root:r0_fin
	wave parit = root:parity_fin
	wave phase = root:phase_fin
	wave neped = root:neped_fin
	wave newid = root:newid_fin
	wave peped = root:peped_fin
	wave pewid = root:pewid_fin
	wave shot = root:shot_fin
	wave iu30 = root:iu30_fin
	wave iu90 = root:iu90_fin
	Wave n1rms=root:n1rms_fin 
	Wave n2rms=root:n2rms_fin
	Wave n3rms=root:n3rms_fin
	Wave n4rms=root:n4rms_fin
	Wave tribot = root:tribot_fin
	
	wave alf_plot=root:plots:alpha2_plot
	wave q95_pl = root:plots:q95_plot
	wave betan_pl = root:plots:betan_plot
	wave tor_plot = root:plots:tormode_plot
	wave liplot = root:plots:li_plot
	wave bet_li_pl = root:plots:betan_li_plot
	wave parit_pl = root:plots:parity_pl
	wave phase_pl = root:plots:phase_pl
	wave iu30_pl = root:plots:iu30_pl
	wave iu90_pl = root:plots:iu90_pl
	Wave n1rms_pl=root:plots:n1rms_pl
	Wave n2rms_pl=root:plots:n2rms_pl
	Wave n3rms_pl=root:plots:n3rms_pl
	Wave n4rms_pl=root:plots:n4rms_pl
	Wave tribot_pl = root:plots:tribot_pl
	
	duplicate/o alpha alf_plot
	duplicate/o tor tor_plot
	duplicate/o aminor aminor_pl
	duplicate/o betan betan_pl
	duplicate/o densr0 densr0_pl
	duplicate/o densv3 densv3_pl
	duplicate/o q95 q95_pl
	duplicate/o li liplot
	duplicate/o parit parit_pl
	duplicate/o phase phase_pl
	duplicate/o teped teped_pl
	duplicate/o neped neped_pl
	duplicate/o newid newid_pl
	duplicate/o peped peped_pl
	duplicate/o pewid pewid_pl
	duplicate/o basetime time_pl
	duplicate/o n1rms n1rms_pl
	duplicate/o n2rms n2rms_pl
	duplicate/o n3rms n3rms_pl
	duplicate/o n4rms n4rms_pl
	duplicate/o iu30 iu30_pl
	
	
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
			densv3_pl[i] = nan
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
		denstest = densv3_pl[i]
		if((denstest < 0) || (denstest > 1e21))
			densv3_pl[i] = nan
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
		if((timebase<1470)&&(torvar == 3))
			tor[i] = 0
		endif
	endfor 

	variable count_coil, count_marg, alphavar, shotvar, i30var,i90var,paritvar
	duplicate/o q95_pl q95_sup_pl q95_marg_pl q95_nosup_pl
	duplicate/o betan_pl betan_sup_pl betan_marg_pl betan_nosup_pl
	duplicate/o densr0_pl densr0_sup_pl, densr0_nosup_pl
	duplicate/o densv3_pl densv3_sup_pl, densv3_nosup_pl
	count_coil = 0
	count_marg = 0
	for(i=0;i<(endpnt);i+=1)
		torvar = tor[i]
		alphavar = alpha[i]
		shotvar = shot[i]
		i30var = abs(iu30[i])
		i90var = abs(iu90[i])
		paritvar = parit[i]
		
		if(paritvar == 111)
			densr0_pl[i] = nan
			neped_pl[i] = nan
			densv3_pl[i]=nan
		endif
//		if(alphavar == -1)
//			q95_sup_pl[i] = nan
//			q95_nosup_pl[i] = nan
//			q95_marg_pl[i] = nan
//			betan_sup_pl[i] = nan
//			betan_nosup_pl[i] = nan
//			betan_marg_pl[i] = nan
//			densr0_sup_pl[i] = nan
//			densr0_nosup_pl[i] =nan
//			 densr0_pl[i] = nan
//			 neped_pl[i] = nan
//			 densv3_pl[i] = nan
//			 densv3_sup_pl[i] = nan
//			 densv3_nosup_pl[i] =nan
//		endif

		if(torvar != 3)
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
			 densv3_sup_pl[i] = nan
			 densv3_nosup_pl[i] =nan
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
			 densv3_pl[i-1]=nan
			 densv3_sup_pl[i] = nan
			 densv3_nosup_pl[i] =nan
		endif
		if((torvar == 1)||(torvar == 2))
		 	densv3_pl[i]=nan
		endif
//		if((torvar == 3) && (alphavar > 0.2))
//			q95_sup_pl[i] = nan
//			betan_sup_pl[i] = nan
//			densr0_sup_pl[i] = nan
//			densv3_sup_pl[i] = nan
//		endif
//		if((torvar == 3) && (alphavar < 0.7))
//			q95_nosup_pl[i] = nan
//			betan_nosup_pl[i] = nan
//			densr0_nosup_pl[i] =nan
//			densv3_nosup_pl[i] =nan
//		endif

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
		
		if(i30var < 100)
			iu30_pl[i] = nan
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
			densv3_pl[i] = nan
			 densv3_sup_pl[i] = nan
			 densv3_nosup_pl[i] =nan
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
			densv3_pl[i] = nan
			 densv3_sup_pl[i] = nan
			 densv3_nosup_pl[i] =nan
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
			densv3_pl[i] = nan
			 densv3_sup_pl[i] = nan
			 densv3_nosup_pl[i] =nan
		endif
//---End QH-mode remove---
	endfor
	
	Duplicate/O n2rms_pl nrms_tot_2,nrms_tot_1
	
	Duplicate/O densr0_pl del_densr0_hi, del_densr0_lo
	Duplicate/O densv3_pl del_densv3_hi, del_densv3_lo
	
	Duplicate/O neped_pl del_neped_hi,del_neped_lo
	
	nrms_tot_1 = n1rms_pl+n2rms_pl+n3rms_pl+n4rms_pl
	nrms_tot_2 = n2rms_pl+n3rms_pl+n4rms_pl
	
	variable tribottest
	for(i=0;i<(endpnt);i+=1)
		i30var = abs(iu30[i])
		betatest = betan[i]
		q95test = q95_pl[i]
		tribottest = tribot[i]	
		del_densr0_hi[i] = (densr0_pl[i+3]-densr0_pl[i-1])/densr0_pl[i]
		del_densr0_lo[i] = (densr0_pl[i+3]-densr0_pl[i-1])/densr0_pl[i]
		del_densv3_hi[i] = (densv3_pl[i+3]-densv3_pl[i-1])/densv3_pl[i]
		del_densv3_lo[i] = (densv3_pl[i+3]-densv3_pl[i-1])/densv3_pl[i]
		del_neped_hi[i] = (neped_pl[i+3]-neped_pl[i-1])/neped_pl[i]
		del_neped_lo[i] = (neped_pl[i+3]-neped_pl[i-1])/neped_pl[i]
		if(i30var >=2000)
			del_densr0_lo[i] = nan
			del_neped_lo[i] =nan
			del_densv3_lo[i]=nan
		endif
		if(i30var <= 4000)
			del_densr0_hi[i] = nan
			del_neped_hi[i] =nan
			del_densv3_hi[i]=nan
		endif
		if((betatest < 2.0) && (betatest > 2.2))
			del_densr0_lo[i] = nan
			del_neped_lo[i] =nan
			del_densv3_lo[i]=nan
			del_densr0_hi[i] = nan
			del_neped_hi[i] =nan
			del_densv3_hi[i]=nan
		endif
		if((q95test < 3.45) && (q95test > 3.55))
			del_densr0_lo[i] = nan
			del_neped_lo[i] =nan
			del_densv3_lo[i]=nan
			del_densr0_hi[i] = nan
			del_neped_hi[i] =nan
			del_densv3_hi[i]=nan
		endif
		if((tribottest < 0.6) && (tribottest > 0.7))
			del_densr0_lo[i] = nan
			del_neped_lo[i] =nan
			del_densv3_lo[i]=nan
			del_densr0_hi[i] = nan
			del_neped_hi[i] =nan
			del_densv3_hi[i]=nan
		endif
	endfor

	setdatafolder root:
end