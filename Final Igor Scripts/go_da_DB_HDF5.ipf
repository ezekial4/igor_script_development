#pragma rtGlobals=1		// Use modern global access method.

Function go_DALPHA2(endpnt,tspnts,killwav)
	Variable endpnt					// number of points to iterate through (usually from a shot list, eg good_shot_num_6
	Variable killwav				// clean up temp waves -- yes (1) or no (0)
	Variable tspnts					// number of thomson spoints to use in analysis
	
	SetDataFolder root:
	Wave wave1 = root:good_shot_num_9
	
	KillWaves/Z alpha1, alpha3,alpha1_tot,alpha3_tot
	KillWaves/Z shotnum_alpha,shotnum_alpha_tot,t_alpha,t_alpha_tot
	
	NewPath/O/Q DALPHParam "MainSSD:Users:unterbee:Desktop:DALPH_DB:"	
//	NewPath/O/Q DALPHParam "TravelTronSSD:Users:unterbee:Desktop:DALPH_DB:"
	
	variable i
	string shotnum,folder
	Variable t0
	t0=ticks
	for(i=0;i<endpnt;i+=1)
		if(i == 0)
			print "Start"
		endif
		if(i == (round(0.25*endpnt)))
			print "25%"
		endif
		if(i==(round(endpnt/2)))
			print "50%"
		endif
		if(i== (round(0.75*endpnt)))
			print "75%"
		endif
		if(i == (endpnt-1))
			print "End"
		endif
		SetDataFolder root:
		if(wave1[i] > 0)
			shotnum = num2istr(wave1[i])
			folder = "s"+shotnum
			
			if(DataFolderExists(folder) ==1)
				SetDataFolder folder
			else
				NewDataFolder/S $folder
			endif
				
			KillWaves/Z dalp_min, t_dalp_min
			
			Variable fileID
			HDF5OpenFile/P=DALPHParam/R/Z fileID as "dalphaDB_"+shotnum+".hdf5"
			HDF5LoadGroup/O/Z :, fileID, "."			
			HDF5CloseFile/A/Z fileID	
		
			Wave tstime = TSTIMECO
			Wave tFS03 = t_FS03
			Wave FS03 = FS03
			Wave FS01 = FS01
			Wave tFS01 = t_FS01
			
			FindValue/T=4/V=1450.0 tstime
			Deletepoints 0, V_Value, tstime
			FindValue/T=4/V=4500.0 tstime
			if (V_Value != -1)
				Deletepoints (V_Value+1),inf, tstime
			endif
			
			FindValue/T=1/V=1450.0 tFS03
			Deletepoints 0, V_Value,FS03
			Deletepoints 0, V_Value,tFS03
			FindValue/T=1/V=4500.0 tFS03
			if (V_Value != -1)
				Deletepoints (V_Value+1),inf,FS03
				Deletepoints (V_Value+1),inf,tFS03
			endif 
			
			FindValue/T=1/V=1450.0 tFS01
			Deletepoints 0, V_Value,FS01
			Deletepoints 0, V_Value,tFS01
			FindValue/T=1/V=4500.0 tFS01
			if (V_Value != -1)
				Deletepoints (V_Value+1),inf,FS01
				Deletepoints (V_Value+1),inf,tFS01
			endif 
			
			Variable test_fs03 = mean(FS03,0,25)
			Variable test_fs01 = mean(FS01,0,25)
			
			Variable points = numpnts(tstime)
			Make/O/n=(round(points/tspnts)) alpha1,alpha3, t_alpha
			alpha1 = 0
			alpha3 = 0
			t_alpha = 0
			variable j, spot, other
			for(j=0;j<(points);j+=(tspnts))
				other = round(j/tspnts)
				t_alpha[other] = tstime[j]
				
				spot=tstime[j]
					
				duplicate/O FS01, $"truncdalp1"
				wave truncdalp1
				duplicate/O tFS01,$"t_truncdalp1"
				wave t_truncdalp1
				FindValue/T=2/V=(spot) tFS01
				if (V_Value != -1)
					Deletepoints 0, V_Value, truncdalp1
					Deletepoints 0, V_Value, t_truncdalp1
				else
					truncdalp1 = nan
					t_truncdalp1 = nan
				endif
				spot=tstime[j+tspnts]
				FindValue/T=2/V=(spot) t_truncdalp1
				if (V_Value != -1)
					Deletepoints (V_Value+1),inf, truncdalp1
					Deletepoints (V_Value+1),inf, t_truncdalp1
				else
					truncdalp1 = nan
					t_truncdalp1 = nan
				endif 
				
				duplicate/O FS03, $"truncdalp3"
				wave truncdalp3
				duplicate/O tFS03,$"t_truncdalp3"
				wave t_truncdalp3		
				spot=tstime[j]
				FindValue/T=2/V=(spot) tFS03
				if (V_Value != -1)
					Deletepoints 0, V_Value, truncdalp3
					Deletepoints 0, V_Value, t_truncdalp3
				else
					truncdalp3 = nan
					t_truncdalp3 = nan
				endif
				spot=tstime[j+tspnts]
				FindValue/T=2/V=(spot) t_truncdalp3
				if (V_Value != -1)
					Deletepoints (V_Value+1),inf, truncdalp3
					Deletepoints (V_Value+1),inf, t_truncdalp3
				else
					truncdalp3 = nan
					t_truncdalp3 = nan
				endif 
				
				variable results
				results = Median(truncdalp1, -inf, inf)
				alpha1[other] = (Wavemax(truncdalp1)-results)/(Wavemax(truncdalp1)+results)	
				
				results = Median(truncdalp3, -inf, inf)
				alpha3[other] = (Wavemax(truncdalp3)-results)/(Wavemax(truncdalp3)+results)
				
				Variable testzero = mean(truncdalp1)
				if(testzero <= 0)
					alpha1[other] = -1
				endif
				testzero = mean(truncdalp3)
				if(testzero <= 0)
					alpha3[other] = -1
				endif
				
				Variable alftest1 = alpha1[other]
				variable alftest3 =alpha3[other]
				if((alftest1 > 1) || (alftest3 > 1))
					alpha1[other] =-1
					alpha3[other] =-1
				endif
			endfor				
			
			Make/O/N=(numpnts(alpha1)) shotnum_alpha
			shotnum_alpha = wave1[i]
			
			Smooth/M=(NaN)/R=0 1,alpha1
			Smooth/M=(NaN)/R=0 1,alpha3
			Variable NANtest, count
			Variable stop = numpnts(alpha3)
			count = 0
			for(j=0;j<(stop);j+=1)
				NANtest = alpha3[j]
				if(NANtest == 0)
					count +=1
				endif
			endfor
			if(count > 0)
					Deletepoints (stop-count),count, shotnum_alpha
					Deletepoints (stop-count),count, alpha1
					Deletepoints (stop-count),count, t_alpha
					Deletepoints (stop-count),count, alpha3
			endif
			
				
			Concatenate/NP {shotnum_alpha}, root:shotnum_alpha_tot
			Concatenate/NP {alpha1}, root:alpha1_tot
			Concatenate/NP {t_alpha}, root:t_alpha_tot
			Concatenate/NP {alpha3}, root:alpha3_tot
			
			if (Killwav == 1)
				KillWaves/Z FS03, t_FS03, t_TSTIMECO
				KillWaves/Z FS01, t_FS01, truncdalp3, t_truncdalp3
				KillWaves/Z truncdalp1,t_truncdalp1, TSTIMECO
			endif
		endif
	endfor
	printf "Time elasped %g seconds\r", round((ticks-t0)/60)
	SetDataFolder root:
	KillPath DALPHParam
End


//Function/D Median(w, x1, x2)	// Returns median value of wave w
//	Wave w
//	Variable x1, x2	// range of interest
//
//	Variable result
//
//	Duplicate/R=(x1,x2) w, tempMedianWave	// Make a clone of wave
//	Sort tempMedianWave, tempMedianWave	// Sort clone
//	SetScale/P x 0,1,tempMedianWave
//	result = tempMedianWave((numpnts(tempMedianWave)-1)/2)
//	KillWaves tempMedianWave
//
//	return result
//End
//
//Function/D PerctSmooth(frac,w, x1, x2)	// Returns median value of wave w
//	Variable frac 	// fraction of distribustion to take
//	Wave w
//	Variable x1, x2	// range of interest
//
//	Variable result
//
//	Duplicate/R=(x1,x2) w, tempMedianWave	// Make a clone of wave
//	Sort tempMedianWave, tempMedianWave	// Sort clone
//	SetScale/P x 0,1,tempMedianWave
//	result = tempMedianWave((numpnts(tempMedianWave)-1)*frac)
//	KillWaves tempMedianWave
//
//	return result
//End