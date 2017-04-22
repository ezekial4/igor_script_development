#pragma rtGlobals=1		// Use modern global access method.


Function rebase(baseWAV,Xdatawav, Ydatawav)
	Wave baseWAV
	String Xdatawav
	String Ydatawav
	
	Variable i,loc,lgth,pnt	
	lgth = numpnts(baseWAV)
	
	Wave dum1 = $Xdatawav
	Wave dum2 = $Ydatawav
	Make/O/N=(lgth) $Ydatawav+"_rebase"
	Wave dum3 = $Ydatawav+"_rebase"
	
	for (i= 0; i<(lgth);i+=1)
		loc = baseWAV[i]
		pnt =BinarySearchInterp(dum1,loc)
		dum3[i] = dum2[pnt]
	endfor
	
End
