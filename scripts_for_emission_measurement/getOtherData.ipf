#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function getOtherData(setname, ishot, GA, Local)
   String setname
	Variable ishot
	Variable GA
	Variable Local
	
	string dum
	Variable j=0
	String fnamerho, fnamepsi,fnamermaj
	String timewav="timepoints"
	If (Local == 1)
		dum = "rmidout"
		Setdatafolder root:$setname
		getGADAT(ishot,"rmidout","localhost")
		Duplicate/O root:$"s"+num2istr(ishot):$"pyd3dat_rmidout_"+num2istr(ishot):sig_Z, root:$"s"+num2istr(ishot):$dum
		Duplicate/O root:$"s"+num2istr(ishot):$"pyd3dat_rmidout_"+num2istr(ishot):sig_X, root:$"s"+num2istr(ishot):$"t_"+dum
		KillDataFolder root:$"s"+num2istr(ishot):$"pyd3dat_rmidout_"+num2istr(ishot) 
		
		Wavestats/Q/M=1 root:$timewav
		Wave tt = root:$timewav
		do
			getRHOPSI(ishot,tt[j],"localhost")
			Duplicate/O root:$"s"+num2istr(ishot):$"pyEFIT_rhoN_psiN_"+num2istr(ishot):rhoN, $"fsmid_rho_"+num2istr(tt[j])
			Duplicate/O root:$"s"+num2istr(ishot):$"pyEFIT_rhoN_psiN_"+num2istr(ishot):psiN, $"fsmid_psi_"+num2istr(tt[j])
			KillDataFolder root:$"s"+num2istr(ishot):$"pyEFIT_rhoN_psiN_"+num2istr(ishot) 
			j+=1
		while(j<(V_npnts))				
	elseif (GA == 1)
		dum = "rmidout"
		Setdatafolder root:$setname
		getGADAT(ishot,"rmidout","atlas.gat.com")
		Duplicate/O root:$"s"+num2istr(ishot):$"pyd3dat_rmidout_"+num2istr(ishot):sig_Z, root:$"s"+num2istr(ishot):$dum
		Duplicate/O root:$"s"+num2istr(ishot):$"pyd3dat_rmidout_"+num2istr(ishot):sig_X, root:$"s"+num2istr(ishot):$"t_"+dum
		KillDataFolder root:$"s"+num2istr(ishot):$"pyd3dat_rmidout_"+num2istr(ishot) 

		Wavestats/Q/M=1 root:$timewav
		Wave tt = root:$timewav
		do
			getRHOPSI(ishot,tt[j],"atlas.gat.com")
			Duplicate/O root:$"s"+num2istr(ishot):$"pyEFIT_rhoN_psiN_"+num2istr(ishot):rhoN, $"fsmid_rho_"+num2istr(tt[j])
			Duplicate/O root:$"s"+num2istr(ishot):$"pyEFIT_rhoN_psiN_"+num2istr(ishot):psiN, $"fsmid_psi_"+num2istr(tt[j])
			KillDataFolder root:$"s"+num2istr(ishot):$"pyEFIT_rhoN_psiN_"+num2istr(ishot) 
			j+=1
		while(j<(V_npnts))				
	endif
End