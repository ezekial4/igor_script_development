#pragma rtGlobals=1		// Use modern global access method.

Function go_MDSPlus(endpnt,killwav)
	Variable endpnt
	Variable killwav
	
	SetDataFolder root:
	Wave wave1 = root:good_shot_num_8
	KillWaves/Z aminor_tot, taminor_tot,bdotevampl_tot,tbdotevampl_tot,bdotodampl_tot
	KillWaves/Z tbdotodampl_tot,beams_tot,tbeams_tot,betan_tot,tbetan_tot, betap_tot,tbetap_tot
	KillWaves/Z bt0_tot,tbt0_tot,cerqrott23_tot,tcerqrott23_tot,densr0_tot,tdensr0_tot
	KillWaves/Z densv2_tot,tdensv2_tot,densv3_tot,tdensv3_tot
	KillWaves/Z gapout_tot,tgapout_tot,h_l89_tot,th_l89_tot,h_thh98y2_tot,th_thh98y2_tot
	KillWaves/Z ip_tot,tip_tot,kappa_tot,tkappa_tot,li_tot,tli_tot,n1rms_tot,tn1rms_tot
	KillWaves/Z n2rms_tot,tn2rms_tot,n3rms_tot,tn3rms_tot,n4rms_tot,tn4rms_tot
	KillWaves/Z pinjf_tot,tpinjf_tot
	KillWaves/Z neped_tot,tneped_tot,newid_tot,tnewid_tot,peped_tot,tpeped_tot,pewid_tot,tpewid_tot
	KillWaves/Z prad_divl_tot,tprad_divl_tot,prad_divu_tot,tprad_divu_tot,prad_tot_tot,tprad_tot_tot
	KillWaves/Z q95_tot,tq95_tot,r0_tot, tr0_tot,rmidout_tot,trmidout_tot,rvsout_tot,trvsout_tot
	KillWaves/Z taue_tot,ttaue_tot,teped_tot,tteped_tot,tewid_tot,ttewid_tot
	KillWaves/Z tribot_tot,ttribot_tot,tste_70_tot,ttste_70_tot
	KillWaves/Z volume_tot,tvolume_tot,wmhd_tot,twmhd_tot
	KillWaves/Z shotnum_EFIT,shotnum_electron, shotnum_BDOT,shotnum_BEAMS,shotnum_CER
	KillWaves/Z shotnum_TAUE, shotnum_H98, shotnum_IP, shotnum_NRMS,shotnum_PINJF
	KillWaves/Z shotnum_PRAD,shotnum_RVSOUT,shotnum_TSTE70, shotnum_VOL

	NewPath/O/Q MDSParam "MainSSD:Users:unterbee:Desktop:databaseparams:"
//       NewPath/O/Q MDSParam "TravelTronSSD:Users:unterbee:Desktop:databaseparams:"
	
	variable i
	string shotnum,folder
	for(i=0;i<endpnt;i+=1)
		SetDataFolder root:
		if(wave1[i] > 0)
			shotnum = num2istr(wave1[i])
			print i,shotnum
			folder = "s"+shotnum
			
			if(DataFolderExists(folder) ==1)
				SetDataFolder folder
			else
				NewDataFolder/S $folder
			endif
			
			String cmdstr
			cmdstr =  "Load_NetCDF/D/Q/P=MDSParam \"paramDB_"+shotnum+".nc\""
			Execute cmdstr
			cmdstr =  "Load_NetCDF/D/Q/P=MDSParam \"paramDB_2_"+shotnum+".nc\""
			Execute cmdstr
			
			Wave aminor =nc_aminor
			Wave taminor = nc_t_aminor
			FindValue/T=4/V=1450.0 taminor
			Deletepoints 0, V_Value, aminor
			Deletepoints 0, V_Value, taminor
			FindValue/T=4/V=4500.0 taminor
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, aminor
				Deletepoints (V_Value+1),inf, taminor
			endif
			Concatenate/S/NP {aminor}, root:aminor_tot
			Concatenate/S/NP {taminor}, root:taminor_tot
			Redimension/S root:aminor_tot
			Redimension/S root:taminor_tot
			
			Wave bdotevampl =nc_bdotevampl
			Wave tbdotevampl = nc_t_bdotevampl
			FindValue/T=4/V=1450.0 tbdotevampl
			Deletepoints 0, V_Value, bdotevampl
			Deletepoints 0, V_Value, tbdotevampl
			FindValue/T=4/V=4500.0 tbdotevampl
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, bdotevampl
				Deletepoints (V_Value+1),inf, tbdotevampl
			endif
			Concatenate/NP {bdotevampl}, root:bdotevampl_tot
			Concatenate/NP {tbdotevampl}, root:tbdotevampl_tot
			Redimension/S root:bdotevampl_tot
			Redimension/S root:tbdotevampl_tot
			
			Wave bdotodampl =nc_bdotodampl
			Wave tbdotodampl = nc_t_bdotodampl
			FindValue/T=4/V=1450.0 tbdotodampl
			Deletepoints 0, V_Value, bdotodampl
			Deletepoints 0, V_Value, tbdotodampl
			FindValue/T=4/V=4500.0 tbdotodampl
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, bdotodampl
				Deletepoints (V_Value+1),inf, tbdotodampl
			endif
			Concatenate/NP {bdotodampl}, root:bdotodampl_tot
			Concatenate/NP {tbdotodampl}, root:tbdotodampl_tot
			Redimension/S root:bdotodampl_tot
			Redimension/S root:tbdotodampl_tot
			
			Wave beams =nc_beams
			Wave tbeams = nc_t_beams
			FindValue/T=4/V=1450.0 tbeams
			Deletepoints 0, V_Value, beams
			Deletepoints 0, V_Value, tbeams
			FindValue/T=4/V=4500.0 tbeams
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, beams
				Deletepoints (V_Value+1),inf, tbeams
			endif
			Concatenate/NP {beams}, root:beams_tot
			Concatenate/NP {tbeams}, root:tbeams_tot
			Redimension/S root:beams_tot
			Redimension/S root:tbeams_tot
			
			Wave betan =nc_betan
			Wave tbetan = nc_t_betan
			FindValue/T=4/V=1450.0 tbetan
			Deletepoints 0, V_Value, betan
			Deletepoints 0, V_Value, tbetan
			FindValue/T=4/V=4500.0 tbetan
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, betan
				Deletepoints (V_Value+1),inf, tbetan
			endif
			Concatenate/NP {betan}, root:betan_tot
			Concatenate/NP {tbetan}, root:tbetan_tot
			Redimension/S root:betan_tot
			Redimension/S root:tbetan_tot
			
			Wave betap =nc_betap
			Wave tbetap = nc_t_betap
			FindValue/T=4/V=1450.0 tbetap
			Deletepoints 0, V_Value, betap
			Deletepoints 0, V_Value, tbetap
			FindValue/T=4/V=4500.0 tbetap
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, betap
				Deletepoints (V_Value+1),inf, tbetap
			endif
			Concatenate/NP {betap}, root:betap_tot
			Concatenate/NP {tbetap}, root:tbetap_tot
			Redimension/S root:betap_tot
			Redimension/S root:tbetap_tot
			
			Wave bt0 =nc_bt0
			Wave tbt0 = nc_t_bt0
			FindValue/T=4/V=1450.0 tbt0
			Deletepoints 0, V_Value, bt0
			Deletepoints 0, V_Value, tbt0
			FindValue/T=4/V=4500.0 tbt0
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, bt0
				Deletepoints (V_Value+1),inf, tbt0
			endif
			Concatenate/NP {bt0}, root:bt0_tot
			Concatenate/NP {tbt0}, root:tbt0_tot
			Redimension/S root:bt0_tot
			Redimension/S root:tbt0_tot
			
			Wave cerqrott23 =nc_cerqrott23
			Wave tcerqrott23 = nc_t_cerqrott23
			FindValue/T=4/V=1450.0 tcerqrott23
			Deletepoints 0, V_Value, cerqrott23
			Deletepoints 0, V_Value, tcerqrott23
			FindValue/T=4/V=4500.0 tcerqrott23
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, cerqrott23
				Deletepoints (V_Value+1),inf, tcerqrott23
			endif
			Concatenate/NP {cerqrott23}, root:cerqrott23_tot
			Concatenate/NP {tcerqrott23}, root:tcerqrott23_tot
			Redimension/S root:cerqrott23_tot
			Redimension/S root:tcerqrott23_tot
			
			Wave densr0 =nc_densr0
			Wave tdensr0 = nc_t_densr0
			FindValue/T=4/V=1450.0 tdensr0
			Deletepoints 0, V_Value, densr0
			Deletepoints 0, V_Value, tdensr0
			FindValue/T=4/V=4500.0 tdensr0
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, densr0
				Deletepoints (V_Value+1),inf, tdensr0
			endif
			Concatenate/NP {densr0}, root:densr0_tot
			Concatenate/NP {tdensr0}, root:tdensr0_tot
			Redimension/S root:densr0_tot
			Redimension/S root:tdensr0_tot
			
			Wave densv2 =nc_densv2
			Wave tdensv2 = nc_t_densv2
			FindValue/T=4/V=1450.0 tdensv2
			Deletepoints 0, V_Value, densv2
			Deletepoints 0, V_Value, tdensv2
			FindValue/T=4/V=4500.0 tdensv2
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, densv2
				Deletepoints (V_Value+1),inf, tdensv2
			endif
			Concatenate/NP {densv2}, root:densv2_tot
			Concatenate/NP {tdensv2}, root:tdensv2_tot
			Redimension/S root:densv2_tot
			Redimension/S root:tdensv2_tot
			
			Wave densv3 =nc_densv3
			Wave tdensv3 = nc_t_densv3
			FindValue/T=4/V=1450.0 tdensv3
			Deletepoints 0, V_Value, densv3
			Deletepoints 0, V_Value, tdensv3
			FindValue/T=4/V=4500.0 tdensv3
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, densv3
				Deletepoints (V_Value+1),inf, tdensv3
			endif
			Concatenate/NP {densv3}, root:densv3_tot
			Concatenate/NP {tdensv3}, root:tdensv3_tot
			Redimension/S root:densv3_tot
			Redimension/S root:tdensv3_tot
			
			Wave gapout =nc_gapout
			Wave tgapout = nc_t_gapout
			FindValue/T=4/V=1450.0 tgapout
			Deletepoints 0, V_Value, gapout
			Deletepoints 0, V_Value, tgapout
			FindValue/T=4/V=4500.0 tgapout
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, gapout
				Deletepoints (V_Value+1),inf, tgapout
			endif
			Concatenate/NP {gapout}, root:gapout_tot
			Concatenate/NP {tgapout}, root:tgapout_tot
			Redimension/S root:gapout_tot
			Redimension/S root:tgapout_tot
			
			Wave h_l89 =nc_h_l89
			Wave th_l89 = nc_t_h_l89
			FindValue/T=4/V=1450.0 th_l89
			Deletepoints 0, V_Value, h_l89
			Deletepoints 0, V_Value, th_l89
			FindValue/T=4/V=4500.0 th_l89
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, h_l89
				Deletepoints (V_Value+1),inf, th_l89
			endif
			Concatenate/NP {h_l89}, root:h_l89_tot
			Concatenate/NP {th_l89}, root:th_l89_tot
			Redimension/S root:h_l89_tot
			Redimension/S root:th_l89_tot
			
			Wave h_thh98y2 =nc_h_thh98y2
			Wave th_thh98y2 = nc_t_h_thh98y2
			FindValue/T=4/V=1450.0 th_thh98y2
			Deletepoints 0, V_Value, h_thh98y2
			Deletepoints 0, V_Value, th_thh98y2
			FindValue/T=4/V=4500.0 th_thh98y2
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, h_thh98y2
				Deletepoints (V_Value+1),inf, th_thh98y2
			endif
			Concatenate/NP {h_thh98y2}, root:h_thh98y2_tot
			Concatenate/NP {th_thh98y2}, root:th_thh98y2_tot
			Redimension/S root:h_thh98y2_tot
			Redimension/S root:th_thh98y2_tot
			
			Wave ip =nc_ip
			Wave tip = nc_t_ip
			FindValue/T=4/V=1450.0 tip
			Deletepoints 0, V_Value, ip
			Deletepoints 0, V_Value, tip
			FindValue/T=4/V=4500.0 tip
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, ip
				Deletepoints (V_Value+1),inf, tip
			endif
			Concatenate/NP {ip}, root:ip_tot
			Concatenate/NP {tip}, root:tip_tot
			Redimension/S root:ip_tot
			Redimension/S root:tip_tot
			
			Wave kappa =nc_kappa
			Wave tkappa = nc_t_kappa
			FindValue/T=4/V=1450.0 tkappa
			Deletepoints 0, V_Value, kappa
			Deletepoints 0, V_Value, tkappa
			FindValue/T=4/V=4500.0 tkappa
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, kappa
				Deletepoints (V_Value+1),inf, tkappa
			endif
			Concatenate/NP {kappa}, root:kappa_tot
			Concatenate/NP {tkappa}, root:tkappa_tot
			Redimension/S root:kappa_tot
			Redimension/S root:tkappa_tot
			
			Wave li =nc_li
			Wave tli = nc_t_li
			FindValue/T=4/V=1450.0 tli
			Deletepoints 0, V_Value, li
			Deletepoints 0, V_Value, tli
			FindValue/T=4/V=4500.0 tli
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, li
				Deletepoints (V_Value+1),inf, tli
			endif
			Concatenate/NP {li}, root:li_tot
			Concatenate/NP {tli}, root:tli_tot
			Redimension/S root:li_tot
			Redimension/S root:tli_tot
			
			Wave n1rms =nc_n1rms
			Wave tn1rms = nc_t_n1rms
			FindValue/T=4/V=1450.0 tn1rms
			Deletepoints 0, V_Value, n1rms
			Deletepoints 0, V_Value, tn1rms
			FindValue/T=4/V=4500.0 tn1rms
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, n1rms
				Deletepoints (V_Value+1),inf, tn1rms
			endif
			Concatenate/NP {n1rms}, root:n1rms_tot
			Concatenate/NP {tn1rms}, root:tn1rms_tot
			Redimension/S root:n1rms_tot
			Redimension/S root:tn1rms_tot
			
			Wave n2rms =nc_n2rms
			Wave tn2rms = nc_t_n2rms
			FindValue/T=4/V=1450.0 tn2rms
			Deletepoints 0, V_Value, n2rms
			Deletepoints 0, V_Value, tn2rms
			FindValue/T=4/V=4500.0 tn2rms
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, n2rms
				Deletepoints (V_Value+1),inf, tn2rms
			endif
			Concatenate/NP {n2rms}, root:n2rms_tot
			Concatenate/NP {tn2rms}, root:tn2rms_tot
			Redimension/S root:n2rms_tot
			Redimension/S root:tn2rms_tot
			
			Wave n3rms =nc_n3rms
			Wave tn3rms = nc_t_n3rms
			FindValue/T=4/V=1450.0 tn3rms
			Deletepoints 0, V_Value, n3rms
			Deletepoints 0, V_Value, tn3rms
			FindValue/T=4/V=4500.0 tn3rms
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, n3rms
				Deletepoints (V_Value+1),inf, tn3rms
			endif
			Concatenate/NP {n3rms}, root:n3rms_tot
			Concatenate/NP {tn3rms}, root:tn3rms_tot
			Redimension/S root:n3rms_tot
			Redimension/S root:tn3rms_tot
			
			Wave n4rms =nc_N4RMS
			Wave tn4rms = nc_t_N4RMS
			FindValue/T=4/V=1450.0 tn4rms
			Deletepoints 0, V_Value, n4rms
			Deletepoints 0, V_Value, tn4rms
			FindValue/T=4/V=4500.0 tn4rms
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, n4rms
				Deletepoints (V_Value+1),inf, tn4rms
			endif
			Concatenate/NP {n4rms}, root:n4rms_tot
			Concatenate/NP {tn4rms}, root:tn4rms_tot
			Redimension/S root:n4rms_tot
			Redimension/S root:tn4rms_tot
			
			Wave neped = nc_neped
			Wave tneped = nc_t_neped
			FindValue/T=4/V=1450.0 tneped
			Deletepoints 0, V_Value,neped
			Deletepoints 0, V_Value,tneped
			FindValue/T=4/V=4500.0 tneped
			if(V_value != -1)
				Deletepoints (V_Value+1),inf,neped
				Deletepoints (V_Value+1),inf,tneped
			endif
			Concatenate/NP {neped}, root:neped_tot
			Concatenate/NP {tneped}, root:tneped_tot
			Redimension/S root:neped_tot
			Redimension/S root:tneped_tot
			
			Wave newid = nc_newid
			Wave tnewid = nc_t_newid
			FindValue/T=4/V=1450.0 tnewid
			Deletepoints 0, V_Value,newid
			Deletepoints 0, V_Value,tnewid
			FindValue/T=4/V=4500.0 tnewid
			if(V_value != -1)
				Deletepoints (V_Value+1),inf,newid
				Deletepoints (V_Value+1),inf,tnewid
			endif
			Concatenate/NP {newid}, root:newid_tot
			Concatenate/NP {tnewid}, root:tnewid_tot
			Redimension/S root:newid_tot
			Redimension/S root:tnewid_tot
			
			Wave peped = nc_peped
			Wave tpeped = nc_t_peped
			FindValue/T=4/V=1450.0 tpeped
			Deletepoints 0, V_Value,peped
			Deletepoints 0, V_Value,tpeped
			FindValue/T=4/V=4500.0 tpeped
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,peped
				Deletepoints (V_Value+1),inf,tpeped
			endif
			Concatenate/NP {peped}, root:peped_tot
			Concatenate/NP {tpeped}, root:tpeped_tot
			Redimension/S root:peped_tot
			Redimension/S root:tpeped_tot	
			
			Wave pewid = nc_pewid
			Wave tpewid = nc_t_pewid
			FindValue/T=4/V=1450.0 tpewid
			Deletepoints 0, V_Value,pewid
			Deletepoints 0, V_Value,tpewid
			FindValue/T=4/V=4500.0 tpewid
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,pewid
				Deletepoints (V_Value+1),inf,tpewid
			endif
			Concatenate/NP {pewid}, root:pewid_tot
			Concatenate/NP {tpewid}, root:tpewid_tot
			Redimension/S root:pewid_tot
			Redimension/S root:tpewid_tot	
			
			Wave pinjf = nc_pinjf
			Wave tpinjf = nc_t_pinjf
			FindValue/T=4/V=1450.0 tpinjf
			Deletepoints 0, V_Value,pinjf
			Deletepoints 0, V_Value,tpinjf
			FindValue/T=4/V=4500.0 tpinjf
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,pinjf
				Deletepoints (V_Value+1),inf,tpinjf
			endif
			Concatenate/NP {pinjf}, root:pinjf_tot
			Concatenate/NP {tpinjf}, root:tpinjf_tot	
			Redimension/S root:pinjf_tot
			Redimension/S root:tpinjf_tot	
			
			Wave prad_divl = nc_prad_divl
			Wave tprad_divl = nc_t_prad_divl
			FindValue/T=4/V=1450.0 tprad_divl
			Deletepoints 0, V_Value,prad_divl
			Deletepoints 0, V_Value,tprad_divl
			FindValue/T=4/V=4500.0 tprad_divl
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,prad_divl
				Deletepoints (V_Value+1),inf,tprad_divl
			endif
			Concatenate/NP {prad_divl}, root:prad_divl_tot
			Concatenate/NP {tprad_divl}, root:tprad_divl_tot
			Redimension/S root:prad_divl_tot
			Redimension/S root:tprad_divl_tot	
			
			Wave prad_divu = nc_prad_divu
			Wave tprad_divu = nc_t_prad_divu
			FindValue/T=4/V=1450.0 tprad_divu
			Deletepoints 0, V_Value,prad_divu
			Deletepoints 0, V_Value,tprad_divu
			FindValue/T=4/V=4500.0 tprad_divu
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,prad_divu
				Deletepoints (V_Value+1),inf,tprad_divu
			endif
			Concatenate/NP {prad_divu}, root:prad_divu_tot
			Concatenate/NP {tprad_divu}, root:tprad_divu_tot
			Redimension/S root:prad_divu_tot
			Redimension/S root:tprad_divu_tot	
			
			Wave prad_tot = nc_prad_tot
			Wave tprad_tot = nc_t_prad_tot
			FindValue/T=4/V=1450.0 tprad_tot
			Deletepoints 0, V_Value,prad_tot
			Deletepoints 0, V_Value,tprad_tot
			FindValue/T=4/V=4500.0 tprad_tot
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,prad_tot
				Deletepoints (V_Value+1),inf,tprad_tot
			endif
			Concatenate/NP {prad_tot}, root:prad_tot_tot
			Concatenate/NP {tprad_tot}, root:tprad_tot_tot
			Redimension/S root:prad_tot_tot
			Redimension/S root:tprad_tot_tot	
			
			Wave q95 =nc_q95
			Wave tq95 = nc_t_q95
			FindValue/T=4/V=1450.0 tq95
			Deletepoints 0, V_Value, q95
			Deletepoints 0, V_Value, tq95
			FindValue/T=4/V=4500.0 tq95
			if(v_value != -1)
				Deletepoints (V_Value+1),inf, q95
				Deletepoints (V_Value+1),inf, tq95
			endif
			Concatenate/NP {q95}, root:q95_tot
			Concatenate/NP {tq95}, root:tq95_tot
			Redimension/S root:q95_tot
			Redimension/S root:tq95_tot
			
			Wave r0 =nc_r0
			Wave tr0 = nc_t_r0
			FindValue/T=4/V=1450.0 tr0
			Deletepoints 0, V_Value, r0
			Deletepoints 0, V_Value, tr0
			FindValue/T=4/V=4500.0 tr0
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, r0
				Deletepoints (V_Value+1),inf, tr0
			endif
			Concatenate/NP {r0}, root:r0_tot
			Concatenate/NP {tr0}, root:tr0_tot
			Redimension/S root:r0_tot
			Redimension/S root:tr0_tot
			
			Wave rmidout =nc_rmidout
			Wave trmidout = nc_t_rmidout
			FindValue/T=4/V=1450.0 trmidout
			Deletepoints 0, V_Value, rmidout
			Deletepoints 0, V_Value, trmidout
			FindValue/T=4/V=4500.0 trmidout
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, rmidout
				Deletepoints (V_Value+1),inf, trmidout
			endif
			Concatenate/NP {rmidout}, root:rmidout_tot
			Concatenate/NP {trmidout}, root:trmidout_tot
			Redimension/S root:rmidout_tot
			Redimension/S root:trmidout_tot
			
			Wave rvsout =nc_rvsout
			Wave trvsout = nc_t_rvsout
			FindValue/T=4/V=1450.0 trvsout
			Deletepoints 0, V_Value, rvsout
			Deletepoints 0, V_Value, trvsout
			FindValue/T=4/V=4500.0 trvsout
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, rvsout
				Deletepoints (V_Value+1),inf, trvsout
			endif
			Concatenate/NP {rvsout}, root:rvsout_tot
			Concatenate/NP {trvsout}, root:trvsout_tot
			Redimension/S root:rvsout_tot
			Redimension/S root:trvsout_tot
			
			Wave taue =nc_taue
			Wave ttaue = nc_t_taue
			FindValue/T=4/V=1450.0 ttaue
			Deletepoints 0, V_Value, taue
			Deletepoints 0, V_Value, ttaue
			FindValue/T=4/V=4500.0 ttaue
			if(V_value != -1)
				Deletepoints (V_Value+1),inf, taue
				Deletepoints (V_Value+1),inf, ttaue
			endif
			Concatenate/NP {taue}, root:taue_tot
			Concatenate/NP {ttaue}, root:ttaue_tot
			Redimension/S root:taue_tot
			Redimension/S root:ttaue_tot
			
			Wave teped = nc_teped
			Wave tteped = nc_t_teped
			FindValue/T=4/V=1450.0 tteped
			Deletepoints 0, V_Value,teped
			Deletepoints 0, V_Value,tteped
			FindValue/T=4/V=4500.0 tteped
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,teped
				Deletepoints (V_Value+1),inf,tteped
			endif
			Concatenate/NP {teped}, root:teped_tot
			Concatenate/NP {tteped}, root:tteped_tot	
			Redimension/S root:teped_tot
			Redimension/S root:tteped_tot	
			
			Wave tewid = nc_tewid
			Wave ttewid = nc_t_tewid
			FindValue/T=4/V=1450.0 ttewid
			Deletepoints 0, V_Value,tewid
			Deletepoints 0, V_Value,ttewid
			FindValue/T=4/V=4500.0 ttewid
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,tewid
				Deletepoints (V_Value+1),inf,ttewid
			endif
			Concatenate/NP {tewid}, root:tewid_tot
			Concatenate/NP {ttewid}, root:ttewid_tot	
			Redimension/S root:tewid_tot
			Redimension/S root:ttewid_tot	
			
			Wave tribot = nc_tribot
			Wave ttribot = nc_t_tribot
			FindValue/T=4/V=1450.0 ttribot
			Deletepoints 0, V_Value,tribot
			Deletepoints 0, V_Value,ttribot
			FindValue/T=4/V=4500.0 ttribot
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,tribot
				Deletepoints (V_Value+1),inf,ttribot
			endif
			Concatenate/NP {tribot}, root:tribot_tot
			Concatenate/NP {ttribot}, root:ttribot_tot
			Redimension/S root:tribot_tot
			Redimension/S root:ttribot_tot
			
			Wave tste_70 = nc_tste_70
			Wave ttste_70 = nc_t_tste_70
			FindValue/T=4/V=1450.0 ttste_70
			Deletepoints 0, V_Value,tste_70
			Deletepoints 0, V_Value,ttste_70
			FindValue/T=4/V=4500.0 ttste_70
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,tste_70
				Deletepoints (V_Value+1),inf,ttste_70
			endif
			Concatenate/NP {tste_70}, root:tste_70_tot
			Concatenate/NP {ttste_70}, root:ttste_70_tot
			Redimension/S root:tste_70_tot
			Redimension/S root:ttste_70_tot	
			
			Wave volume = nc_volume
			Wave tvolume = nc_t_volume
			FindValue/T=4/V=1450.0 tvolume
			Deletepoints 0, V_Value,volume
			Deletepoints 0, V_Value,tvolume
			FindValue/T=4/V=4500.0 tvolume
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,volume
				Deletepoints (V_Value+1),inf,tvolume
			endif
			Concatenate/NP {volume}, root:volume_tot
			Concatenate/NP {tvolume}, root:tvolume_tot
			Redimension/S root:volume_tot
			Redimension/S root:tvolume_tot
			
			Wave wmhd = nc_wmhd
			Wave twmhd = nc_t_wmhd
			FindValue/T=4/V=1450.0 twmhd
			Deletepoints 0, V_Value,wmhd
			Deletepoints 0, V_Value,twmhd
			FindValue/T=4/V=4500.0 twmhd
			if(V_Value != -1)
				Deletepoints (V_Value+1),inf,wmhd
				Deletepoints (V_Value+1),inf,twmhd
			endif
			Concatenate/NP {wmhd}, root:wmhd_tot
			Concatenate/NP {twmhd}, root:twmhd_tot
			Redimension/S root:wmhd_tot
			Redimension/S root:twmhd_tot				
			
			Make/O/I/U/N=(numpnts(betan)) hold_EFIT
			Make/O/I/U/N=(numpnts(neped)) hold_electron
			Make/O/I/U/N=(numpnts(bdotevampl)) hold_BDOT
			Make/O/I/U/N=(numpnts(beams)) hold_BEAMS
			Make/O/I/U/N=(numpnts(cerqrott23)) hold_CER
			Make/O/I/U/N=(numpnts(taue)) hold_TAUE        //tbase for h_l89 & taue
			Make/O/I/U/N=(numpnts(h_thh98y2)) hold_H98
			Make/O/I/U/N=(numpnts(ip)) hold_IP
			Make/O/I/U/N=(numpnts(n1rms)) hold_NRMS
			Make/O/I/U/N=(numpnts(pinjf)) hold_PINJ
			Make/O/I/U/N=(numpnts(prad_tot)) hold_PRAD
			Make/O/N=(numpnts(rvsout)) hold_RVSOUT
			Make/O/N=(numpnts(tste_70)) hold_TSTE70
			Make/O/I/U/N=(numpnts(volume)) hold_VOL
			hold_EFIT = wave1[i]
			hold_electron = wave1[i]
			hold_BDOT = wave1[i]
			hold_BEAMS = wave1[i]
			hold_CER = wave1[i]
			hold_TAUE = wave1[i]
			hold_H98 = wave1[i]
			hold_IP = wave1[i]
			hold_NRMS = wave1[i]
			hold_PINJ = wave1[i]
			hold_PRAD = wave1[i]
			hold_RVSOUT = wave1[i]
			hold_TSTE70 = wave1[i]
			hold_VOL = wave1[i]
			Concatenate/NP {hold_EFIT}, root:shotnum_EFIT
			Concatenate/NP {hold_electron}, root:shotnum_electron
			Concatenate/NP {hold_BDOT}, root:shotnum_BDOT
			Concatenate/NP {hold_BEAMS}, root:shotnum_BEAMS
			Concatenate/NP {hold_CER}, root:shotnum_CER
			Concatenate/NP {hold_TAUE}, root:shotnum_TAUE
			Concatenate/NP {hold_H98}, root:shotnum_H98
			Concatenate/NP {hold_IP}, root:shotnum_IP
			Concatenate/NP {hold_NRMS}, root:shotnum_NRMS
			Concatenate/NP {hold_PINJ}, root:shotnum_PINJF
			Concatenate/NP {hold_PRAD}, root:shotnum_PRAD
			Concatenate/NP {hold_RVSOUT}, root:shotnum_RVSOUT
			Concatenate/NP {hold_TSTE70}, root:shotnum_TSTE70
			Concatenate/NP {hold_VOL}, root:shotnum_VOL
			
			if (Killwav == 1)
				KillWaves/Z parity,phase,tormode, nc_TSTIMECO
				KillWaves/Z nc_varnames, hold_electron, hold_EFIT
				KillWaves/Z hold_BDOT,hold_BEAMS,hold_CER,hold_TAUE,hold_H98
				KillWaves/Z hold_IP, hold_NRMS, hold_PINJ, hold_PRAD,hold_RVSOUT
				KillWaves/Z hold_TSTE70,hold_VOL
				KillWaves/Z nc_AMINOR,nc_t_AMINOR,nc_BDOTEVAMPL,nc_t_BDOTEVAMPL
				KillWaves/Z nc_BDOTODAMPL,nc_t_BDOTODAMPL,nc_beams,nc_t_beams
				KillWaves/Z nc_betan,nc_t_betan,nc_betap,nc_t_betap,nc_bt0,nc_t_bt0
				KillWaves/Z nc_cerqrott23,nc_t_cerqrott23,nc_densr0,nc_t_densr0
				KillWaves/Z nc_densv2,nc_t_densv2,nc_densv3,nc_t_densv3
				KillWaves/Z nc_gapout,nc_t_gapout,nc_h_l89,nc_t_h_l89,nc_ip,nc_t_ip
				KillWaves/Z nc_h_thh98y2,nc_t_h_thh98y2,nc_kappa,nc_t_kappa,nc_li,nc_t_li
				KillWaves/Z nc_n1rms,nc_t_n1rms,nc_n2rms,nc_t_n2rms,nc_n3rms,nc_t_n3rms
				KillWaves/Z nc_n4rms,nc_t_n4rms
				KillWaves/Z nc_neped,nc_t_neped,nc_newid,nc_t_newid,nc_peped,nc_t_peped
				KillWaves/Z nc_pewid,nc_t_pewid,nc_pinjf,nc_t_pinjf,nc_prad_divl,nc_t_prad_divl
				KillWaves/Z nc_prad_divu,nc_t_prad_divu,nc_prad_tot,nc_t_prad_tot,nc_q95,nc_t_q95
				KillWaves/Z nc_r0,nc_t_r0,nc_rmidout,nc_t_rmidout,nc_rvsout,nc_t_rvsout
				KillWaves/Z nc_taue,nc_t_taue,nc_teped,nc_t_teped,nc_tewid,nc_t_tewid
				KillWaves/Z nc_tribot,nc_t_tribot,nc_tste_70,nc_t_tste_70,nc_volume,nc_t_volume
				KillWaves/Z nc_wmhd,nc_t_wmhd
				KillWaves/Z nc_tbeams,nc_tcerqrott23,nc_th_l89,nc_th_thh98y2,nc_ttaue
				KillWaves/Z nc_tn1rms,nc_tn2rms,nc_tn3rms,nc_tpinjf,nc_ttste_70
				string units, longname
				Variable j
				for(j=0;j<80;j+=1)
					units = "nc_var"+num2str(j)+"_units"
					longname = "nc_var"+num2str(j)+"_long_name"
					Killwaves/Z $units
					Killwaves/Z $longname
				endfor
			endif
		endif
	endfor
	SetDataFolder root:
End