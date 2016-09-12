#pragma rtGlobals=1		// Use modern global access method.
Function TallyUP_4raffi(endpnt,do_base,do_big,killwav)
	Variable endpnt
	Variable do_base
	Variable do_big
	Variable killwav
	
	Variable timerrefnum = startMSTimer
	
	SetDataFolder root:
	Wave wave1 = root:good_shot_num_9
	
	if(do_base ==1)
		KillWaves/Z EFITshot_fin
		KillWaves/Z aminor_fin,betan_fin,betap_fin,bt0_fin,densr0_fin,gapout_fin,il30_fin,il90_fin
		KillWaves/Z iu30_fin,iu90_fin,li_fin,neped_fin,newid_fin,parity_fin,peped_fin,pewid_fin
		KillWaves/Z phase_fin,q95_fin, r0_fin,rvsout_fin,teped_fin,tewid_fin
		KillWaves/Z  tormode_fin,tribot_fin,densv3_fin
		KillWaves/Z volume_fin,wmhd_fin ,h_l89_fin,prad_divl_fin
	endif 
	
	if(do_big == 1)
		KillWaves/Z n1rms_fin,n2rms_fin,n3rms_fin,n4rms_fin
	endif
	
	Duplicate/O root:alpha:alpha2_clean root:alpha2_fin
	Duplicate/O root:alpha:alpha_clean root:alpha_fin
	Duplicate/O root:alpha:shotnum_alpha_clean root:shot_fin
	Duplicate/O root:alpha:t_alpha_clean root:time_fin
	
	Wave shot_alpha = root:alpha:shotnum_alpha_clean
	Wave t_alpha = root:alpha:t_alpha_clean
	Wave alpha = root:alpha:alpha_clean
	Wave alpha2 = root:alpha:alpha2_clean
	
	Wave shot_coils = root:Coils:shotnum_tot
	Wave t_coils = root:Coils:tst_tot
	Wave parity = root:Coils:parity_tot
	Wave phase = root:Coils:phase_tot
	Wave tormode = root:Coils:tormode_tot
	Wave iu30 = root:Coils:iu30_tot
	Wave iu90  = root:Coils:iu90_tot
	Wave il30 = root:Coils:il30_tot
	Wave il90 = root:Coils:il90_tot
	
	Wave shot_EFIT = root:Dataparams:shotnum_EFIT
	Wave t_EFIT = root:Dataparams:tbetan_tot
	Wave aminor_tot = root:Dataparams:aminor_tot
	Wave betan_tot = root:Dataparams:betan_tot
	Wave betap_tot = root:Dataparams:betap_tot
	Wave bt0_tot = root:Dataparams:bt0_tot
	Wave densr0_tot = root:Dataparams:densr0_tot
	Wave densv3_tot = root:Dataparams:densv3_tot
	Wave gapout_tot = root:Dataparams:gapout_tot
	Wave li_tot = root:Dataparams:li_tot
	Wave q95_tot = root:Dataparams:q95_tot
	Wave r0_tot = root:Dataparams:r0_tot
	Wave tribot_tot = root:Dataparams:tribot_tot
	Wave wmhd_tot = root:Dataparams:wmhd_tot
	
	Wave shot_NRMS = root:Dataparams:shotnum_NRMS
	Wave t_NRMS = root:Dataparams:tn1rms_tot
	Wave n1rms_tot= root:Dataparams:n1rms_tot
	Wave n2rms_tot= root:Dataparams:n2rms_tot
	Wave n3rms_tot= root:Dataparams:n3rms_tot
	Wave n4rms_tot= root:Dataparams:n4rms_tot
	
	Wave shot_electron = root:Dataparams:shotnum_electron
	Wave t_electron =  root:Dataparams:tteped_tot
	Wave neped_tot =  root:Dataparams:neped_tot
	Wave newid_tot = root:Dataparams:newid_tot
	Wave peped_tot = root:Dataparams:peped_tot
	Wave pewid_tot = root:Dataparams:pewid_tot
	Wave teped_tot =  root:Dataparams:teped_tot
	Wave tewid_tot = root:Dataparams:tewid_tot
	
	variable i
	string shotnum, folder, filename
	for(i=0;i<endpnt;i+=1)
		if(wave1[i] > 0)
			print i, wave1[i]
	//====== First we get all the time points for each sub-data base =========
			Variable compare = wave1[i]

			variable loc = numpnts(shot_alpha)
			variable count =0
			Variable s= 0
			Variable j
				for(j=0;j<(loc);j+=1)
					if(shot_alpha[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) alftime = 0 
				s =0
				for(j=0;j<(loc);j+=1)
					if(shot_alpha[j] == compare)
						alftime[s] = t_alpha[j]
						s +=1
					endif
					 if(shot_alpha[j] > (compare+1))
						break
					endif
				endfor
				
			if(do_base ==1)
				loc = numpnts(shot_coils)
				count =0
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_coils[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) coshot = 0
				Duplicate/O coshot cotime,parity_sh,phase_sh,tormode_sh
				Duplicate/O coshot iu30_sh,il30_sh,iu90_sh,il90_sh
				for(j=0;j<(loc);j+=1)
					if(shot_coils[j] == compare)
						coshot[s] =  shot_coils[j]
						cotime[s] = t_coils[j]
						parity_sh[s] = parity[j]
						phase_sh[s] = phase[j]
						tormode_sh[s] = tormode[j]
						iu30_sh[s] = iu30[j]
						il30_sh[s] = il30[j]
						iu90_sh[s] = iu90[j]
						il90_sh[s] = il90[j]
						s+=1
					endif
				endfor
				
				loc = numpnts(shot_electron)
				count =0
				for(j=0;j<(loc);j+=1)
					if(shot_electron[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) elecshot
				Duplicate/O elecshot electime,neped_sh,newid_sh,teped_sh
				Duplicate/O elecshot peped_sh,pewid_sh,tewid_sh
				s = 0
				for(j=0;j<(loc);j+=1)
					if(shot_electron[j] == compare)
						elecshot[s] =  shot_electron[j]
						electime[s] = t_electron[j]
						neped_sh[s] = neped_tot[j]
						newid_sh[s] = newid_tot[j]
						peped_sh[s] = peped_tot[j]
						pewid_sh[s] = pewid_tot[j]
						teped_sh[s] = teped_tot[j]
						tewid_sh[s] = tewid_tot[j]
						s +=1
					endif
				 	if(shot_electron[j] > (compare+1))
						break
					endif
				 endfor
			
				loc = numpnts(shot_EFIT)
				count =0
				for(j=0;j<(loc);j+=1)
					if(shot_EFIT[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) EFITshot = 0
				Duplicate/O EFITshot EFITtime,betan_sh,li_sh,q95_sh,aminor_sh, densr0_sh,betap_sh
				Duplicate/O EFITshot r0_sh,bt0_sh,tribot_sh,wmhd_sh,gapout_sh, densv3_sh
				s =0
				for(j=0;j<(loc);j+=1)
					if(shot_EFIT[j] == compare)
						EFITshot[s] = shot_EFIT[j]
						EFITtime[s] = t_EFIT[j]
						aminor_sh[s] = aminor_tot[j]
						betan_sh[s] = betan_tot[j]
						betap_sh[s] = betap_tot[j]
						bt0_sh[s] = bt0_tot[j]
						densr0_sh[s] = densr0_tot[j]
						densv3_sh[s] = densv3_tot[j]
						gapout_sh[s] = gapout_tot[j]
						li_sh[s] = li_tot[j]
						q95_sh[s] = q95_tot[j]
						r0_sh[s] = r0_tot[j]
						tribot_sh[s] = tribot_tot[j]
						wmhd_sh[s] = wmhd_tot[j]
						s +=1
					endif
					if(shot_EFIT[j] > (compare+1))
						break
					endif
				endfor
			endif

			if(do_big ==1)		
				loc=numpnts(shot_NRMS)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_NRMS[j] == compare)
						count +=1
					endif
					if(count > 3)
						break
					endif
				endfor
				Make/O/N=(count) NRMSshot = 0
				Duplicate/O NRMSshot NRMStime,n1rms_sh,n2rms_sh,n3rms_sh,n4rms_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_NRMS[j] == compare)
						NRMSshot[s]=shot_NRMS[j]
						NRMStime[s]=t_NRMS[j]
						n1rms_sh[s]=	n1rms_tot[j]
						n2rms_sh[s]=n2rms_tot[j]
						n3rms_sh[s]=n3rms_tot[j]
						n4rms_sh[s]=n4rms_tot[j]
						s +=1
					endif
					if(shot_NRMS[j] > (compare+1))
						break
					endif
				endfor
			endif

		//========= We got all the sub-data ================

		//========= Truncates all the waves to the alftime timebase ===
		Wavestats/Q alftime
		Variable endtime = alftime[V_endrow]
		
		if(do_base ==1)
			FindValue/T=1/V=(endtime) cotime
			if(V_value == -1)
				FindValue/T=2/V=(endtime) cotime
			endif
			if(V_value == -1)
				FindValue/T=5/V=(endtime) cotime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, cotime
				Deletepoints (V_Value+1),inf, coshot
				Deletepoints (V_Value+1),inf, parity_sh
				Deletepoints (V_Value+1),inf, phase_sh
				Deletepoints (V_Value+1),inf, tormode_sh
				Deletepoints (V_Value+1),inf, iu30_sh
				Deletepoints (V_Value+1),inf, il30_sh
				Deletepoints (V_Value+1),inf, iu90_sh
				Deletepoints (V_Value+1),inf, il90_sh
			endif
			
			FindValue/T=10/V=(endtime) electime
			if(V_value == -1)
				FindValue/T=30/V=(endtime) electime
			endif
			if(V_value == -1)
				FindValue/T=50/V=(endtime) electime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, electime
				Deletepoints (V_Value+1),inf, neped_sh
				Deletepoints (V_Value+1),inf, newid_sh
				Deletepoints (V_Value+1),inf, teped_sh
				Deletepoints (V_Value+1),inf, tewid_sh
				Deletepoints (V_Value+1),inf, peped_sh
				Deletepoints (V_Value+1),inf, pewid_sh
			endif
		
			FindValue/T=10/V=(endtime) EFITtime
			if(V_value == -1)
				FindValue/T=30/V=(endtime) EFITtime
			endif
			if(V_value == -1)
				FindValue/T=50/V=(endtime) EFITtime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, EFITtime
				Deletepoints (V_Value+1),inf, aminor_sh
				Deletepoints (V_Value+1),inf, betan_sh
				Deletepoints (V_Value+1),inf, betap_sh
				Deletepoints (V_Value+1),inf, bt0_sh
				Deletepoints (V_Value+1),inf, densr0_sh
				Deletepoints (V_Value+1),inf, densv3_sh
				Deletepoints (V_Value+1),inf, li_sh
				Deletepoints (V_Value+1),inf, q95_sh
				Deletepoints (V_Value+1),inf, r0_sh
				Deletepoints (V_Value+1),inf, tribot_sh
				Deletepoints (V_Value+1),inf, wmhd_sh
			endif	
		endif

		if(do_big==1)			
			FindValue/T=2/V=(endtime) NRMStime
			if(V_value == -1)
				FindValue/T=5/V=(endtime) NRMStime
			endif
			if(V_value == -1)
				FindValue/T=10/V=(endtime) NRMStime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, NRMStime
				Deletepoints (V_Value+1),inf, n1rms_sh
				Deletepoints (V_Value+1),inf, n2rms_sh
				Deletepoints (V_Value+1),inf, n3rms_sh
				Deletepoints (V_Value+1),inf, n4rms_sh
			endif
		endif
		//========= Get everything on the same timebase =======
			
		Variable basepnt
		basepnt = numpnts(alftime)
		
		if(do_base ==1)
			Interpolate2/T=1/I=3/Y=parity_temp/X=alftime cotime, parity_sh
			Interpolate2/T=1/I=3/Y=phase_temp/X=alftime cotime, phase_sh
			Interpolate2/T=1/I=3/Y=tormode_temp/X=alftime cotime, tormode_sh
			Interpolate2/T=1/I=3/Y=iu30_temp/X=alftime cotime, iu30_sh
			Interpolate2/T=1/I=3/Y=iu90_temp/X=alftime cotime, iu90_sh
			Interpolate2/T=1/I=3/Y=il30_temp/X=alftime cotime, il30_sh
			Interpolate2/T=1/I=3/Y=il90_temp/X=alftime cotime, il90_sh
			
//			Interpolate2/T=1/I=3/N=(basepnt)/Y=parity_temp/X=alftime cotime, parity_sh
//			Interpolate2/T=1/I=3/N=(basepnt)/Y=phase_temp/X=alftime cotime, phase_sh
//			Interpolate2/T=1/I=3/N=(basepnt)/Y=tormode_temp/X=alftime cotime, tormode_sh
//			Interpolate2/T=1/I=3/N=(basepnt)/Y=iu30_temp/X=alftime cotime, iu30_sh
//			Interpolate2/T=1/I=3/N=(basepnt)/Y=iu90_temp/X=alftime cotime, iu90_sh
//			Interpolate2/T=1/I=3/N=(basepnt)/Y=il30_temp/X=alftime cotime, il30_sh
//			Interpolate2/T=1/I=3/N=(basepnt)/Y=il90_temp/X=alftime cotime, il90_sh
			
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=neped_temp/X=alftime electime, neped_sh 
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=newid_temp/X=alftime electime, newid_sh 
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=teped_temp/X=alftime electime, teped_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=tewid_temp/X=alftime electime, tewid_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=peped_temp/X=alftime electime, peped_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=pewid_temp/X=alftime electime, pewid_sh
					
			
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=q95_temp/X=alftime EFITtime, q95_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=aminor_temp/X=alftime EFITtime, aminor_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=betan_temp/X=alftime EFITtime, betan_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=betap_temp/X=alftime EFITtime, betap_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=bt0_temp/X=alftime EFITtime, bt0_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=densr0_temp/X=alftime EFITtime, densr0_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=densv3_temp/X=alftime EFITtime, densv3_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=li_temp/X=alftime EFITtime, li_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=r0_temp/X=alftime EFITtime, r0_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=tribot_temp/X=alftime EFITtime, tribot_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=wmhd_temp/X=alftime EFITtime, wmhd_sh	
		endif

		if(do_big==1)			
			Interpolate2/T=1/I=3/Y=n1rms_temp/X=alftime NRMStime, n1rms_sh
			Interpolate2/T=1/I=3/Y=n2rms_temp/X=alftime NRMStime, n2rms_sh
			Interpolate2/T=1/I=3/Y=n3rms_temp/X=alftime NRMStime, n3rms_sh
			Interpolate2/T=1/I=3/Y=n4rms_temp/X=alftime NRMStime, n4rms_sh
		endif

		if(do_base ==1)
			Concatenate/NP {neped_temp}, root:neped_fin
			Concatenate/NP {newid_temp}, root:newid_fin
			Concatenate/NP {teped_temp}, root:teped_fin
			Concatenate/NP {tewid_temp}, root:tewid_fin
			Concatenate/NP {peped_temp}, root:peped_fin
			Concatenate/NP {pewid_temp}, root:pewid_fin
			Redimension/S root:neped_fin,root:newid_fin,root:peped_fin,root:pewid_fin,root:teped_fin,root:tewid_fin
			
			Concatenate/NP {parity_temp}, root:parity_fin
			Concatenate/NP {phase_temp}, root:phase_fin
			Concatenate/NP {tormode_temp}, root:tormode_fin
			Concatenate/NP {iu30_temp}, root:iu30_fin
			Concatenate/NP {il30_temp}, root:il30_fin
			Concatenate/NP {iu90_temp}, root:iu90_fin
			Concatenate/NP {il90_temp}, root:il90_fin
			Redimension/S root:iu30_fin,root:il30_fin,root:il90_fin
			REdimension/S root:iu90_fin,root:parity_fin,root:phase_fin,root:tormode_fin
			
			Concatenate/NP {q95_temp}, root:q95_fin
			Concatenate/NP {aminor_temp}, root:aminor_fin
			Concatenate/NP {betan_temp}, root:betan_fin
			Concatenate/NP {betap_temp}, root:betap_fin
			Concatenate/NP {bt0_temp}, root:bt0_fin
			Concatenate/NP {li_temp}, root:li_fin
			Concatenate/NP {r0_temp}, root:r0_fin
			Concatenate/NP {tribot_temp}, root:tribot_fin
			Concatenate/NP {wmhd_temp}, root:wmhd_fin
			Concatenate/NP {densr0_temp}, root:densr0_fin
			Concatenate/NP {densv3_temp}, root:densv3_fin
			Redimension/S  root:aminor_fin,root:q95_fin,root:betan_fin,root:betap_fin,root:bt0_fin
			Redimension/S  root:li_fin,root:r0_fin,root:tribot_fin,root:wmhd_fin,root:densr0_fin,root:densv3_fin
		endif 
		
		if(do_big==1)
			Concatenate/NP {n1rms_temp}, root:n1rms_fin
			Concatenate/NP {n2rms_temp}, root:n2rms_fin
			Concatenate/NP {n3rms_temp}, root:n3rms_fin
			Concatenate/NP {n3rms_temp}, root:n4rms_fin
			Redimension/S root:n1rms_fin,root:n2rms_fin,root:n3rms_fin,root:n4rms_fin
		endif	
		endif
	endfor
	
	if(killwav == 1)
		KillWaves/Z coshot, cotime, parity_sh,parity_temp,phase_sh,phase_temp,beams_sh,beams_temp
		KillWaves/Z tormode_sh, tormode_temp, aminor_sh, aminor_temp, r0_sh, r0_temp
		KillWaves/Z neped_temp, electime, elecshot, teped_sh, neped_sh, teped_temp,gapout_sh
		KillWaves/Z alftime, EFITshot, EFITtime, betan_sh, li_sh, q95_sh, newid_sh,newid_temp
		KillWaves/Z q95_temp, betan_temp, li_temp, tewid_sh, tewid_temp, peped_sh,peped_temp
		KillWaves/Z pewid_temp,pewid_sh, bt0_sh,bt0_temp,iu30_sh,iu30_temp, il30_sh,il30_temp
		KillWaves/Z iu90_sh,iu90_temp,il90_sh,il90_temp,rvsout_sh,rvsout_temp,tribot_sh,tribot_temp
		KillWaves/Z wmhd_sh,wmhd_temp, ip_sh,ip_temp, densr0_sh, densr0_temp,RVSOUTshot,RVSOUTtime
		KillWaves/Z betap_sh,betap_temp,bdotevampl_sh,bdotevampl_temp,bdotodampl_sh,bdotodampl_temp
		KillWaves/Z cerqrott23_sh,cerqrott23_temp,h_l89_sh,h_l89_temp,h_thh98y2_sh,h_thh98y2_temp
		KillWaves/Z n1rms_sh,n1rms_temp,n2rms_sh,n2rms_temp,n3rms_sh,n3rms_temp,pinjf_sh,pinjf_temp
		KillWaves/Z prad_divl_sh,prad_divl_temp,prad_divu_sh,prad_divu_temp,prad_tot_sh,prad_tot_temp
		KillWaves/Z taue_sh,taue_temp,tste_70_sh,tste_70_temp,IPshot,IPtime,TAUEshot,TAUEtime,VOLUMEtime
		KillWaves/Z cerqrott23_temp2, H98shot,H98time,h_l89_temp2,taue_temp2,TSTE70shot,TSTE70time
		KillWaves/Z volume_sh,volume_temp,BDOTshot,BDOTtime,BEAMStime,BEAMSshot,NRMSshot,NRMStime
		KillWaves/Z PRADtime,PRADshot,CERshot,CERtime,h_thh98y2_temp2,PINJshot,PINJtime,VOLUMEshot
		KillWaves/Z densv3_sh, densv3_temp,n4rms_sh,n4rms_temp
	endif
	
	SetDataFolder root:
	
	Variable microsec = stopMSTimer(timerrefnum)
	microsec =round(microsec)
	Print microsec/1e6, "Seconds Elapsed" 
End