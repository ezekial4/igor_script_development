#pragma rtGlobals=1		// Use modern global access method.

Macro Asdex_cali(timeref_mks,timeref_asdex,refwav_mks,multi_asdex,shotnum)
	Variable shotnum 
	String timeref_mks
	String timeref_asdex
	Variable multi_asdex // do single wave our whole ASDEX set analysis; 1=single, 2=all
	String refwav_mks
//	Variable backshot  //impliment later
	
	
	Silent 1; DelayUpdate
	
	Variable i_sm=11
	Variable errcalc=1
	
	String mks_name = refwav_mks+"_"+num2istr(shotnum)
	Variable/G G_mks
	
	Duplicate/O $timeref_mks $mks_name+"_valu",$mks_name+"_std_valu"
	nebar_sm_n_sdev(i_sm,mks_name,2)
	Find_pnts_stdev_XY($timeref_mks,refwav_mks,errcalc,shotnum)
	$mks_name+"_valu" = G_mks*($refwav_mks+"_valu")
	$mks_name+"_std_valu" = G_mks*($refwav_mks+"_std_valu")
	KillWaves $refwav_mks+"_valu",$refwav_mks+"_std_valu"
	
	Get_ASDEX_valu(shotnum,multi_asdex,timeref_asdex, i_sm, errcalc)
	
	//Get background data
//	SetDataFolder root:background
//	Get_ASDEX_valu(backshot,multi_asdex,timeref_asdex, i_sm, errcalc)

//	Variable i =0
//	Variable j=0
//	Do	
//		do
//			Wave $backdum+j = $refwave_all[0]+"ji_"num2istr(backnum)+"_valu"
//			Wave backdum1 = $refwave_all[0]+"ji_"num2istr(backnum)+"_std_valu"
//			Wave backdum2 = $refwave_all[0]+"je_"num2istr(backnum)+"_valu"
//			Wave backdum3 = $refwave_all[0]+"je_"num2istr(backnum)+"_std_valu"
//		
//		i +=1
//	While(i<4)
//	String G_asdex = "G_"+refwav_asdex
//	Variable/G G_asdex
	//Plot the data
	Killwaves refwave_all
EndMacro

Function Get_ASDEX_valu(shotnum,multi_asdex,timeref_asdex, i_sm, errcalc)
	Variable shotnum
	Variable multi_asdex
	String timeref_asdex
	Variable i_sm
	Variable errcalc
	
	if (multi_asdex ==1)
		String refwav_asdex
		Prompt refwav_asdex, "ASDEX reference (e.g. upbaf,rdp30,etc.)"
		String ji_wave = refwav_asdex+"ji_"+num2istr(shotnum)
		pntname_sm_n_sdev(i_sm,ji_wave,2)
		String ji_refwav = refwav_asdex+"ji"
		Find_pnts_stdev_XY($timeref_asdex,ji_refwav,errcalc,shotnum)
		Duplicate/O $ji_wave  $ji_wave+"_valu" ,$ji_wave+"_std_valu" 
		Wave store = $ji_wave+"_valu" 
		Wave store2 = $ji_refwav+"_valu" 
		Wave store3 = $ji_wave+"_std_valu" 
		Wave store4 = $ji_refwav+"_std_valu" 
		store = store2
		store3 = store4
		Killwaves $ji_refwav+"_valu",$ji_refwav+"_std_valu" 
		
		
		String je_wave = refwav_asdex+"je_"+num2istr(shotnum)
     		 pntname_sm_n_sdev(i_sm,je_wave,2)
     		 String je_refwav = refwav_asdex+"je"
		Find_pnts_stdev_XY($timeref_asdex,je_refwav,errcalc,shotnum)
	elseif (multi_asdex ==2)
		Make/O/N=4/T refwave_all
		refwave_all[0] ="lobaf"
		refwave_all[1]="pri30"
		refwave_all[2]="rdp30"
		refwave_all[3]="upbaf"
		
		variable i
		for(i=0;i<4;i+=1)
			String temp = refwave_all[i]
			ji_wave = temp+"ji_"+num2istr(shotnum)
			pntname_sm_n_sdev(i_sm,ji_wave,2)
			ji_refwav = temp+"ji"
			Find_pnts_stdev_XY($timeref_asdex,ji_refwav,errcalc,shotnum)
			Duplicate/O $timeref_asdex  $ji_wave+"_valu" ,$ji_wave+"_std_valu" 
			Wave store = $ji_wave+"_valu" 
			Wave store2 = $ji_refwav+"_valu" 
			Wave store3 = $ji_wave+"_std_valu" 
			Wave store4 = $ji_refwav+"_std_valu" 
			store = store2
			store3 = store4
			Killwaves $ji_refwav+"_valu",$ji_refwav+"_std_valu" 
			
			je_wave = temp+"je_"+num2istr(shotnum)
			pntname_sm_n_sdev(i_sm,je_wave,2)
			je_refwav = temp+"je"
			Find_pnts_stdev_XY($timeref_asdex,je_refwav,errcalc,shotnum)
			Duplicate/O $timeref_asdex  $je_wave+"_valu" ,$je_wave+"_std_valu" 
			Wave store5 = $je_wave+"_valu" 
			Wave store6 = $je_refwav+"_valu" 
			Wave store7 = $je_wave+"_std_valu" 
			Wave store8 = $je_refwav+"_std_valu" 
			store5 = store6
			store7 = store8
			Killwaves $je_refwav+"_valu",$je_refwav+"_std_valu" 
		endfor
		
	else 
		Abort "Set Multi_asdex variable to 1 for single sig. or 2 for all ASDEX"
	endif
	
	return 1
End