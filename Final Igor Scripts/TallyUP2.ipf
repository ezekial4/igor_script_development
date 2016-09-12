#pragma rtGlobals=1		// Use modern global access method.
Function TallyUP2(endpnt, killwav)
	Variable endpnt
	Variable killwav
	
	SetDataFolder root:
	Wave wave1 = root:good_shot_num_8
	
	KillWaves/Z aminor_fin,betan_fin,betap_fin,bt0_fin,densr0_fin,gapout_fin,il30_fin,il90_fin
	KillWaves/Z ip_fin,iu30_fin,iu90_fin,li_fin,neped_fin,newid_fin,parity_fin,peped_fin,pewid_fin
	KillWaves/Z phase_fin,q95_fin, r0_fin,rvsout_fin,teped_fin,tewid_fin, beams_fin
	KillWaves/Z  tormode_fin,tribot_fin,bdotevampl_fin,bdotodampl_fin,cerqrott23_fin
	KillWaves/Z volume_fin,wmhd_fin ,h_l89_fin,h_thh98y2_fin,n1rms_fin,n2rms_fin,n3rms_fin
	KillWaves/Z pinjf_fin,prad_divl_fin,prad_divu_fin,prad_tot_fin,taue_fin,tste_70_fin
	
	KillWaves/Z EFITshot_fin
	
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
			endfor

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
				if(count > 3)
					break
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
			 endfor
			 			
			loc = numpnts(shot_EFIT)
			count =0
			for(j=0;j<(loc);j+=1)
				if(shot_EFIT[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
				endif
			endfor
			Make/O/N=(count) EFITshot = 0
			Duplicate/O EFITshot EFITtime,betan_sh,li_sh,q95_sh,aminor_sh, densr0_sh,betap_sh
			Duplicate/O EFITshot r0_sh,bt0_sh,tribot_sh,wmhd_sh
			s =0
			for(j=0;j<(loc);j+=1)
				if(shot_EFIT[j] == compare)
					EFITshot[s] =  shot_EFIT[j]
					EFITtime[s] = t_EFIT[j]
					aminor_sh[s] = aminor_tot[j]
					betan_sh[s] = betan_tot[j]
					betap_sh[s] = betap_tot[j]
					bt0_sh[s] = bt0_tot[j]
					densr0_sh[s] = densr0_tot[j]
					li_sh[s] = li_tot[j]
					q95_sh[s] = q95_tot[j]
					r0_sh[s] = r0_tot[j]
					tribot_sh[s] = tribot_tot[j]
					wmhd_sh[s] = wmhd_tot[j]
					s +=1
				endif
			endfor
			
			loc=numpnts(shot_BDOT)
			count=0
			for(j=0;j<(loc);j+=1)
				if(shot_BDOT[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
			endfor

			loc=numpnts(shot_BEAMS)
			count=0
			for(j=0;j<(loc);j+=1)
				if(shot_BEAMS[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
			endfor
			
			loc=numpnts(shot_PRAD)
			count=0
			for(j=0;j<(loc);j+=1)
				if(shot_PRAD[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
			endfor
			
			loc=numpnts(shot_CER)
			count=0
			Variable CERtag
			for(j=0;j<(loc);j+=1)
				if(shot_CER[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
				endfor
			endif
			
			loc=numpnts(shot_H98)
			count=0
			Variable H98Tag
			for(j=0;j<(loc);j+=1)
				if(shot_H98[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
					if(shot_h98[j] == compare)
						H98shot[s] = shot_H98[j]
						H98time[s] = t_H98[j]
						h_thh98y2_sh[s]=h_thh98y2_tot[j]
						s +=1
					endif
				endfor
			endif
			
			loc=numpnts(shot_IP)
			count=0
			for(j=0;j<(loc);j+=1)
				if(shot_IP[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
			endfor
			
			loc=numpnts(shot_TAUE)
			count=0
			Variable TAUEtag
			for(j=0;j<(loc);j+=1)
				if(shot_TAUE[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
				endfor
			endif
			
			loc=numpnts(shot_PINJ)
			count=0
			for(j=0;j<(loc);j+=1)
				if(shot_PINJ[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
			endfor
			
			loc=numpnts(shot_RVSOUT)
			count=0
			for(j=0;j<(loc);j+=1)
				if(shot_RVSOUT[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
			endfor
			
			loc=numpnts(shot_VOLUME)
			count=0
			for(j=0;j<(loc);j+=1)
				if(shot_VOLUME[j] == compare)
					count +=1
				endif
				if(count > 3)
					break
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
			endfor
	endfor
	
	if(killwav == 1)
		KillWaves/Z coshot, cotime, parity_sh,parity_temp,phase_sh,phase_temp,beams_sh,beams_temp
		KillWaves/Z tormode_sh, tormode_temp, aminor_sh, aminor_temp, r0_sh, r0_temp
		KillWaves/Z neped_temp, electime, elecshot, teped_sh, neped_sh, teped_temp
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
End