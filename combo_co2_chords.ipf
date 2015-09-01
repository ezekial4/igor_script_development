#pragma rtGlobals=1		// Use modern global access method.

Macro Combo_co2_chords(ishot,fname,ism,fname2,dwld)
	Variable ishot = 110000
	String fname = "nev3"
	Variable ism = 21
	String fname2 = "nebar"
	Variable dwld=0
	
	String setname = "s"+num2istr(ishot)
	Setdatafolder root:$setname
	
	if (dwld ==1)
		String Y_dname= fname+"_"+num2istr(ishot)+".ibw"
		GA_Download(Y_dname)
	
		String X_dname = "t_"+num2istr(ishot)+".ibw"
		GA_Download(X_dname)
	endif
	
	variable testwav =exists(fname2)
	if (testwav == 0)
		String Y_new2=fname2+"_"+num2istr(ishot)
		Duplicate/O $Y_new2 $fname2
		Killwaves $Y_new2
	
		String X_new2 = "t_"+fname2+num2istr(ishot)
		Duplicate/O $X_new2 $"time_"+fname
		Killwaves $X_new2
	endif
	
	testwav =exists(fname)
	if (testwav == 0)
		String Y_new=fname+"_"+num2istr(ishot)
		Duplicate/O $Y_new $fname
		Killwaves $Y_new
	
		String X_new = "t_"+fname+num2istr(ishot)
		Duplicate/O $X_new $"time_"+fname
		Killwaves $X_new
	endif
	
	nebar_sm_n_sdev(ism,fname)
	nebar_sm_n_sdev(ism,fname2)
	make_gener_layout(fname,fname2)
End