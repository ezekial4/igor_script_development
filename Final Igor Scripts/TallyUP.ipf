#pragma rtGlobals=1		// Use modern global access method.
Function TallyUP(endpnt,do_base,do_big,killwav)
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
	KillWaves/Z  tormode_fin,tribot_fin,bdotevampl_fin,bdotodampl_fin,cerqrott23_fin
	KillWaves/Z volume_fin,wmhd_fin ,h_l89_fin,prad_divl_fin,prad_divu_fin,prad_tot_fin,taue_fin,tste_70_fin
	endif 
	
	if(do_big == 1)
		KillWaves/Z pinjf_fin,,h_thh98y2_fin,n1rms_fin,n2rms_fin,n3rms_fin,ip_fin,beams_fin
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
	Wave gapout_tot = root:Dataparams:gapout_tot
	Wave li_tot = root:Dataparams:li_tot
	Wave q95_tot = root:Dataparams:q95_tot
	Wave r0_tot = root:Dataparams:r0_tot
	Wave tribot_tot = root:Dataparams:tribot_tot
	Wave wmhd_tot = root:Dataparams:wmhd_tot
	
	Wave shot_BDOT = root:Dataparams:shotnum_BDOT
	Wave t_BDOT = root:Dataparams:tbdotevampl_tot
	Wave bdotevampl_tot = root:Dataparams:bdotevampl_tot
	Wave bdotodampl_tot=root:Dataparams:bdotodampl_tot
	
	Wave shot_BEAMS = root:Dataparams:shotnum_BEAMS
	Wave t_BEAMS = root:Dataparams:tbeams_tot
	Wave beams_tot = root:Dataparams:beams_tot
	
	Wave shot_PRAD = root:Dataparams:shotnum_PRAD
	Wave  t_PRAD = root:Dataparams:tprad_tot_tot
	Wave prad_divu_tot= root:Dataparams:prad_divu_tot
	Wave prad_divl_tot= root:Dataparams:prad_divl_tot
	Wave prad_tot_tot= root:Dataparams:prad_tot_tot
	
	Wave shot_CER = root:Dataparams:shotnum_CER
	Wave t_CER = root:Dataparams:tcerqrott23_tot
	Wave cerqrott23_tot = root:Dataparams:cerqrott23_tot
	
	Wave shot_H98 = root:Dataparams:shotnum_H98
	Wave t_H98 = root:Dataparams:th_thh98y2_tot
	Wave h_thh98y2_tot=root:Dataparams:h_thh98y2_tot
	
	Wave shot_IP = root:Dataparams:shotnum_IP
	Wave t_IP = root:Dataparams:tip_tot
	Wave ip_tot = root:Dataparams:ip_tot
	
	Wave shot_NRMS = root:Dataparams:shotnum_NRMS
	Wave t_NRMS = root:Dataparams:tn1rms_tot
	Wave n1rms_tot= root:Dataparams:n1rms_tot
	Wave n2rms_tot= root:Dataparams:n2rms_tot
	Wave n3rms_tot= root:Dataparams:n3rms_tot
	
	Wave shot_TAUE = root:Dataparams:shotnum_TAUE
	Wave t_TAUE = root:Dataparams:ttaue_tot
	Wave taue_tot = root:Dataparams:taue_tot
	Wave h_l89_tot = root:Dataparams:h_l89_tot
	
	Wave shot_PINJ = root:Dataparams:shotnum_PINJF
	Wave t_PINJ = root:Dataparams:tpinjf_tot
	Wave pinjf_tot= root:Dataparams:pinjf_tot
	
	Wave shot_TSTE70 = root:Dataparams:shotnum_TSTE70
	Wave t_TSTE70 = root:Dataparams:ttste_70_tot
	Wave tste_70_tot = root:Dataparams:tste_70_tot
	
	Wave shot_VOLUME = root:Dataparams:shotnum_VOL
	Wave shot_RVSOUT = root:Dataparams:shotnum_RVSOUT
	Wave t_VOLUME = root:Dataparams:tvolume_tot
	Wave t_RVSOUT= root:Dataparams:trvsout_tot
	Wave rvsout_tot = root:Dataparams:rvsout_tot
	Wave volume_tot = root:Dataparams:volume_tot
	
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
					if(shot_coils[j] > (compare+1))
						break
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
				Duplicate/O EFITshot r0_sh,bt0_sh,tribot_sh,wmhd_sh,gapout_sh
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
				
				loc=numpnts(shot_BDOT)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_BDOT[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) BDOTshot = 0
				Duplicate/O BDOTshot BDOTtime,bdotevampl_sh,bdotodampl_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_BDOT[j] == compare)
						BDOTshot[s] = shot_BDOT[j]
						BDOTtime[s] = t_BDOT[j]
						bdotevampl_sh[s]=bdotevampl_tot[j]
						bdotodampl_sh[s]=bdotodampl_tot[j]
						s +=1
					endif
					if(shot_BDOT[j] > (compare+1))
						break
					endif
				endfor
				
				loc=numpnts(shot_TSTE70)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_TSTE70[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) TSTE70shot = 0
				Duplicate/O TSTE70shot TSTE70time,tste_70_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_TSTE70[j] == compare)
						TSTE70shot[s]=shot_TSTE70[j]
						TSTE70time[s]=t_TSTE70[j]
						tste_70_sh[s]=tste_70_tot[j]
						s +=1
					endif
					if(shot_TSTE70[j] > (compare+1))
						break
					endif
				endfor
				
				loc=numpnts(shot_RVSOUT)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_RVSOUT[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) RVSOUTshot = 0
				Duplicate/O RVSOUTshot RVSOUTtime,rvsout_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_RVSOUT[j] == compare)
						RVSOUTshot[s]=shot_RVSOUT[j]
						RVSOUTtime[s]=t_RVSOUT[j]
						rvsout_sh[s] = rvsout_tot[j]
						s +=1
					endif
					if(shot_RVSOUT[j] > (compare+1))
						break
					endif
				endfor
						
				loc=numpnts(shot_VOLUME)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_VOLUME[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) VOLUMEshot = 0
				Duplicate/O VOLUMEshot VOLUMEtime,volume_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_VOLUME[j] == compare)
						VOLUMEshot[s]=shot_VOLUME[j]
						VOLUMEtime[s]=t_VOLUME[j]
						volume_sh[s] = volume_tot[j]
						s +=1
					endif
					if(shot_VOLUME[j] > (compare+1))
						break
					endif
				endfor
				
				loc=numpnts(shot_PRAD)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_PRAD[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) PRADshot = 0
				Duplicate/O PRADshot PRADtime,prad_divl_sh,prad_divu_sh,prad_tot_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_PRAD[j] == compare)
						PRADshot[s]=shot_PRAD[j]
						PRADtime[s]=t_PRAD[j]
						prad_divl_sh[s]=prad_divl_tot[j]
						prad_divu_sh[s]=prad_divu_tot[j]
						prad_tot_sh[s]=prad_tot_tot[j]
						s +=1
					endif
					if(shot_PRAD[j] > (compare+1))
						break
					endif
				endfor
				
				loc=numpnts(shot_CER)
				count=0
				Variable CERtag
				for(j=0;j<(loc);j+=1)
					if(shot_CER[j] == compare)
						count +=1
					endif
				endfor
				if(count < 2)
					CERtag =1
				else
					CERtag = 0
				endif
				if(CERtag == 0) 
					Make/O/N=(count) CERshot = 0
					Duplicate/O CERshot CERtime,cerqrott23_sh
					s=0
					for(j=0;j<(loc);j+=1)
						if(shot_CER[j] == compare)
							CERshot[s] = shot_CER[j]
							CERtime[s] = t_CER[j]
							cerqrott23_sh[s]=cerqrott23_tot[j]
							s +=1
						endif
						if(shot_CER[j] > (compare+1))
							break
						endif
					endfor
				endif
				
				loc=numpnts(shot_TAUE)
				count=0
				Variable TAUEtag
				for(j=0;j<(loc);j+=1)
					if(shot_TAUE[j] == compare)
						count +=1
					endif
				endfor
				if(count < 2)
					TAUEtag =1
				else
					TAUEtag = 0
				endif
				if(TAUEtag == 0) 
					Make/O/N=(count) TAUEshot = 0
					Duplicate/O TAUEshot TAUEtime,h_l89_sh,taue_sh
					s=0
					for(j=0;j<(loc);j+=1)
						if(shot_TAUE[j] == compare)
							TAUEshot[s]=shot_TAUE[j]
							TAUEtime[s]=t_TAUE[j]
							taue_sh[s]=taue_tot[j]
							h_l89_sh[s]=h_l89_tot[j]
							s +=1
						endif
						if(shot_TAUE[j] > (compare+1))
							break
						endif
					endfor
				endif				
			endif

			if(do_big ==1)			
				loc=numpnts(shot_H98)
				count=0
				Variable H98Tag
				for(j=0;j<(loc);j+=1)
					if(shot_H98[j] == compare)
						count +=1
					endif
				endfor
				if(count < 2)
					H98tag =1
				else
					H98tag = 0
				endif
				if(H98tag == 0) 
					Make/O/N=(count) H98shot = 0
					Duplicate/O H98shot H98time,h_thh98y2_sh
					s=0
					for(j=0;j<(loc);j+=1)
						if(shot_H98[j] == compare)
							H98shot[s] = shot_H98[j]
							H98time[s] = t_H98[j]
							h_thh98y2_sh[s]=h_thh98y2_tot[j]
							s +=1
						endif
						if(shot_H98[j] > (compare+1))
							break
						endif
					endfor
				endif
				
				loc=numpnts(shot_IP)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_IP[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) IPshot = 0
				Duplicate/O IPshot IPtime,ip_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_IP[j] == compare)
						IPshot[s]=shot_IP[j]
						IPtime[s]=t_IP[j]
						ip_sh[s] = ip_tot[j]
						s +=1
					endif
					if(shot_IP[j] > (compare+1))
						break
					endif
				endfor
				
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
				Duplicate/O NRMSshot NRMStime,n1rms_sh,n2rms_sh,n3rms_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_NRMS[j] == compare)
						NRMSshot[s]=shot_NRMS[j]
						NRMStime[s]=t_NRMS[j]
						n1rms_sh[s]=	n1rms_tot[j]
						n2rms_sh[s]=n2rms_tot[j]
						n3rms_sh[s]=n3rms_tot[j]
						s +=1
					endif
					if(shot_NRMS[j] > (compare+1))
						break
					endif
				endfor
				
				loc=numpnts(shot_BEAMS)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_BEAMS[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) BEAMSshot = 0
				Duplicate/O BEAMSshot beams_sh,BEAMStime
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_BEAMS[j] == compare)
						BEAMSshot[s] = shot_BEAMS[j]
						BEAMStime[s] = t_BEAMS[j]
						beams_sh[s]=beams_tot[j]
						s +=1
					endif
					if(shot_BEAMS[j] > (compare+1))
						break
					endif
				endfor
				
				loc=numpnts(shot_PINJ)
				count=0
				for(j=0;j<(loc);j+=1)
					if(shot_PINJ[j] == compare)
						count +=1
					endif
				endfor
				Make/O/N=(count) PINJshot = 0
				Duplicate/O PINJshot PINJtime,pinjf_sh
				s=0
				for(j=0;j<(loc);j+=1)
					if(shot_PINJ[j] == compare)
						PINJshot[s]=shot_PINJ[j]
						PINJtime[s]=t_PINJ[j]
						pinjf_sh[s]=pinjf_tot[j]
						s +=1
					endif
					if(shot_PINJ[j] > (compare+1))
						break
					endif
				endfor
			endif

		//========= We got all the sub-data ================

		//========= Truncates all the waves to the alftime timebase ===
		Wavestats/Q alftime
		Variable endtime = alftime[V_endrow]
		
		if(do_base ==1)
			FindValue/T=10/V=(endtime) cotime
			if(V_value == -1)
				FindValue/T=30/V=(endtime) cotime
			endif
			if(V_value == -1)
				FindValue/T=50/V=(endtime) cotime
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
				Deletepoints (V_Value+1),inf, gapout_sh
				Deletepoints (V_Value+1),inf, li_sh
				Deletepoints (V_Value+1),inf, q95_sh
				Deletepoints (V_Value+1),inf, r0_sh
				Deletepoints (V_Value+1),inf, tribot_sh
				Deletepoints (V_Value+1),inf, wmhd_sh
			endif
			
			FindValue/T=2/V=(endtime) BDOTtime
			if(V_value == -1)
				FindValue/T=5/V=(endtime) BDOTtime
			endif
			if(V_value == -1)
				FindValue/T=10/V=(endtime) BDOTtime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, BDOTtime
				Deletepoints (V_Value+1),inf, bdotevampl_sh
				Deletepoints (V_Value+1),inf, bdotodampl_sh
			endif
		
			FindValue/T=2/V=(endtime) PRADtime
			if(V_value == -1)
				FindValue/T=5/V=(endtime) PRADtime
			endif
			if(V_value == -1)
				FindValue/T=10/V=(endtime) PRADtime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, PRADtime
				Deletepoints (V_Value+1),inf, prad_divl_sh
				Deletepoints (V_Value+1),inf, prad_divu_sh
				Deletepoints (V_Value+1),inf, prad_tot_sh
			endif
			
			if(CERtag == 0)
				FindValue/T=2/V=(endtime) CERtime
				if(V_value == -1)
					FindValue/T=5/V=(endtime) CERtime
				endif
				if(V_value == -1)
					FindValue/T=10/V=(endtime) CERtime
				endif
				if(V_value != -1)
					Deletepoints (V_Value+1),inf, CERtime
					Deletepoints (V_Value+1),inf, cerqrott23_sh
				endif
			endif
			
			if(TAUEtag == 0)
				FindValue/T=10/V=(endtime) TAUEtime
				if(V_value == -1)
					FindValue/T=20/V=(endtime) TAUEtime
				endif
				if(V_value == -1)
					FindValue/T=50/V=(endtime) TAUEtime
				endif
				if(V_value != -1)
					Deletepoints (V_Value+1),inf, TAUEtime
					Deletepoints (V_Value+1),inf, h_l89_sh
					Deletepoints (V_Value+1),inf, taue_sh
				endif
			endif		
			
			FindValue/T=10/V=(endtime) TSTE70time
			if(V_value == -1)
				FindValue/T=30/V=(endtime) TSTE70time
			endif
			if(V_value == -1)
				FindValue/T=50/V=(endtime) TSTE70time
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, TSTE70time
				Deletepoints (V_Value+1),inf, tste_70_sh
			endif
			
			FindValue/T=10/V=(endtime) RVSOUTtime
			if(V_value == -1)
				FindValue/T=30/V=(endtime) RVSOUTtime
			endif
			if(V_value == -1)
				FindValue/T=50/V=(endtime) RVSOUTtime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, RVSOUTtime
				Deletepoints (V_Value+1),inf, rvsout_sh
			endif
			
			FindValue/T=10/V=(endtime) VOLUMEtime
			if(V_value == -1)
				FindValue/T=30/V=(endtime) VOLUMEtime
			endif
			if(V_value == -1)
				FindValue/T=50/V=(endtime) VOLUMEtime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, VOLUMEtime
				Deletepoints (V_Value+1),inf, volume_sh
			endif
		endif

		if(do_big==1)		
			if(H98tag == 0)
				FindValue/T=5/V=(endtime) H98time
				if(V_value == -1)
					FindValue/T=10/V=(endtime) H98time
				endif
				if(V_value == -1)
					FindValue/T=20/V=(endtime) H98time
				endif
				if(V_value != -1)
					Deletepoints (V_Value+1),inf, H98time
					Deletepoints (V_Value+1),inf, h_thh98y2_sh
				endif
			endif
			
			FindValue/T=2/V=(endtime) IPtime
			if(V_value == -1)
				FindValue/T=5/V=(endtime) IPtime
			endif
			if(V_value == -1)
				FindValue/T=10/V=(endtime) IPtime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, IPtime
				DeletePoints (V_Value+1),inf, ip_sh
			endif
			
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
			endif
			
			FindValue/T=2/V=(endtime) BEAMStime
			if(V_value == -1)
				FindValue/T=5/V=(endtime) BEAMStime
			endif
			if(V_value == -1)
				FindValue/T=10/V=(endtime) BEAMStime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, BEAMStime
				Deletepoints (V_Value+1),inf, beams_sh
			endif
			
			FindValue/T=2/V=(endtime) PINJtime
			if(V_value == -1)
				FindValue/T=5/V=(endtime) PINJtime
			endif
			if(V_value == -1)
				FindValue/T=10/V=(endtime) PINJtime
			endif
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, PINJtime
				Deletepoints (V_Value+1),inf, pinjf_sh
			endif
		endif
		//========= Get everything on the same timebase =======
			
		Variable basepnt
		basepnt = numpnts(alftime)
		
		if(do_base ==1)
			Interpolate2/T=1/I=3/N=(basepnt)/Y=parity_temp/X=alftime cotime, parity_sh
			Interpolate2/T=1/I=3/N=(basepnt)/Y=phase_temp/X=alftime cotime, phase_sh
			Interpolate2/T=1/I=3/N=(basepnt)/Y=tormode_temp/X=alftime cotime, tormode_sh
			Interpolate2/T=1/I=3/N=(basepnt)/Y=iu30_temp/X=alftime cotime, iu30_sh
			Interpolate2/T=1/I=3/N=(basepnt)/Y=iu90_temp/X=alftime cotime, iu90_sh
			Interpolate2/T=1/I=3/N=(basepnt)/Y=il30_temp/X=alftime cotime, il30_sh
			Interpolate2/T=1/I=3/N=(basepnt)/Y=il90_temp/X=alftime cotime, il90_sh
			
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
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=gapout_temp/X=alftime EFITtime, gapout_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=li_temp/X=alftime EFITtime, li_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=r0_temp/X=alftime EFITtime, r0_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=tribot_temp/X=alftime EFITtime, tribot_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=wmhd_temp/X=alftime EFITtime, wmhd_sh
	
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=rvsout_temp/X=alftime RVSOUTtime, rvsout_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=tste_70_temp/X=alftime TSTE70time, tste_70_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=volume_temp/X=alftime VOLUMEtime, volume_sh
			
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=bdotevampl_temp/X=alftime BDOTtime, bdotevampl_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=bdotodampl_temp/X=alftime BDOTtime, bdotodampl_sh
			
			If(TAUEtag == 0)
				Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=h_l89_temp/X=alftime TAUEtime, h_l89_sh
				Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=taue_temp/X=alftime TAUEtime, taue_sh
			elseif(TAUEtag == 1)
				Make/O/N=(basepnt) h_l89_temp2
				Make/O/N=(basepnt) taue_temp2
				taue_temp2 =0
				h_l89_temp2 =0
			endif
			
			If(CERtag == 0)
				Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=cerqrott23_temp/X=alftime CERtime, cerqrott23_sh
			elseif(CERtag == 1)
				Make/O/N=(basepnt) cerqrott23_temp2
				cerqrott23_temp2 =0
			endif
			
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=prad_divl_temp/X=alftime PRADtime, prad_divl_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=prad_divu_temp/X=alftime PRADtime, prad_divu_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=prad_tot_temp/X=alftime PRADtime, prad_tot_sh
		endif

		if(do_big==1)			
			If(H98tag == 0)
				Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=h_thh98y2_temp/X=alftime H98time, h_thh98y2_sh
			elseif(H98tag == 1)
				Make/O/N=(basepnt) h_thh98y2_temp2
				h_thh98y2_temp2 =0
			endif
			
			Interpolate2/T=1/I=3/N=(basepnt)/J=2/Y=beams_temp/X=alftime BEAMStime, beams_sh	
			
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=ip_temp/X=alftime IPtime, ip_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=n1rms_temp/X=alftime NRMStime, n1rms_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=n2rms_temp/X=alftime NRMStime, n2rms_sh
			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=n3rms_temp/X=alftime NRMStime, n3rms_sh

			Interpolate2/T=1/I=3/A=(basepnt)/J=2/Y=pinjf_temp/X=alftime PINJtime, pinjf_sh
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
			Concatenate/NP {gapout_temp}, root:gapout_fin
			Concatenate/NP {li_temp}, root:li_fin
			Concatenate/NP {r0_temp}, root:r0_fin
			Concatenate/NP {tribot_temp}, root:tribot_fin
			Concatenate/NP {wmhd_temp}, root:wmhd_fin
			Concatenate/NP {densr0_temp}, root:densr0_fin
			Redimension/S  root:aminor_fin,root:q95_fin,root:betan_fin,root:betap_fin,root:bt0_fin
			Redimension/S  root:li_fin,root:r0_fin,root:tribot_fin,root:wmhd_fin,root:densr0_fin, root:gapout_fin
			
			Concatenate/NP {bdotevampl_temp}, root:bdotevampl_fin
			Concatenate/NP {bdotodampl_temp}, root:bdotodampl_fin
			Redimension/S  root:bdotevampl_fin,root:bdotodampl_fin
	
			Concatenate/NP {prad_divl_temp}, root:prad_divl_fin
			Concatenate/NP {prad_divu_temp}, root:prad_divu_fin
			Concatenate/NP {prad_tot_temp}, root:prad_tot_fin
			Redimension/S root:prad_divl_fin,root:prad_divu_fin,root:prad_tot_fin
			
			Concatenate/NP {volume_temp}, root:volume_fin
			Concatenate/NP {rvsout_temp}, root:rvsout_fin
			Redimension/S  root:rvsout_fin,root:volume_fin
			
			Concatenate/NP {tste_70_temp}, root:tste_70_fin
			Redimension/S  root:tste_70_fin
			
			If(CERtag == 0)
				Concatenate/NP {cerqrott23_temp}, root:cerqrott23_fin
			elseif(CERtag == 1)
				Concatenate/NP {cerqrott23_temp2}, root:cerqrott23_fin
			endif
			Redimension/S root:cerqrott23_fin
	
			If(TAUEtag == 0)
				Concatenate/NP {h_l89_temp}, root:h_l89_fin
				Concatenate/NP {taue_temp}, root:taue_fin	
			elseif(TAUEtag ==1)
				Concatenate/NP {h_l89_temp2}, root:h_l89_fin
				Concatenate/NP {taue_temp2}, root:taue_fin	
			endif
			Redimension/S root:taue_fin,root:h_l89_fin
		endif 
		
		if(do_big==1)
			Concatenate/NP {ip_temp}, root:ip_fin
			Concatenate/NP {n1rms_temp}, root:n1rms_fin
			Concatenate/NP {n2rms_temp}, root:n2rms_fin
			Concatenate/NP {n3rms_temp}, root:n3rms_fin
			Concatenate/NP {pinjf_temp}, root:pinjf_fin
			Redimension/S root:n1rms_fin,root:n2rms_fin,root:n3rms_fin,root:ip_fin,root:pinjf_fin

			Concatenate/NP {beams_temp}, root:beams_fin
			Redimension/S  root:beams_fin
						
			If(H98tag == 0)
				Concatenate/NP {h_thh98y2_temp}, root:h_thh98y2_fin
			elseif(H98tag == 1)
				Concatenate/NP {h_thh98y2_temp2}, root:h_thh98y2_fin
			endif
			Redimension/S root:h_thh98y2_fin
		endif	
		
		endif	
	endfor
	
	if(killwav == 1)
		KillWaves/Z coshot, cotime, parity_sh,parity_temp,phase_sh,phase_temp,beams_sh,beams_temp
		KillWaves/Z tormode_sh, tormode_temp, aminor_sh, aminor_temp, r0_sh, r0_temp
		KillWaves/Z neped_temp, electime, elecshot, teped_sh, neped_sh, teped_temp,gapout_sh,gapout_temp
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
	endif
	
	SetDataFolder root:
	
	Variable microsec = stopMSTimer(timerrefnum)
	microsec =round(microsec)
	Print microsec/1e6, "Seconds Elapsed" 
End