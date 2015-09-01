#pragma rtGlobals=1		// Use modern global access method.

Macro Combo_rot(ishot,fname,fname2)
	Variable ishot = 110000
	String fname = "cert23q"
	String fname2 = "cert23qu"
	
	String setname = "s"+num2istr(ishot)
	Setdatafolder root:$setname
	
	String Y_dname= fname+"_"+num2istr(ishot)+".ibw"
	GA_Download(Y_dname)
	String Y_new=fname+"_"+num2istr(ishot)
	Duplicate/O $Y_new $fname
	Killwaves $Y_new
	
	String X_dname = "t_"+fname+"_"+num2istr(ishot)+".ibw"
	GA_Download(X_dname)
	String X_new = "t_"+fname+"_"+num2istr(ishot)
	Duplicate/O $X_new $"time_"+fname
	Killwaves $X_new
	
	String Y_dname2= fname2+"_"+num2istr(ishot)+".ibw"
	GA_Download(Y_dname2)
	String Y_new2=fname2+"_"+num2istr(ishot)
	Duplicate/O $Y_new2 $fname2
	Killwaves $Y_new2

	String X_dname2 = "t_"+fname2+"_"+num2istr(ishot)+".ibw"
	print x_dname2
	GA_Download(X_dname2)
	String X_new2 =  "t_"+fname2+"_"+num2istr(ishot)
	Duplicate/O $X_new2 $"time_"+fname2
	Killwaves $X_new2
	
	make_rot_layout(fname)
End