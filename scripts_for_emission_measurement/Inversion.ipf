#pragma rtGlobals=1		// Use modern global access method.

Function Invert_data(inwav)
	String inwav

	NVAR need_length =root:need_length
	if(need_length==1)
		Variable imax=8
		Variable jmax=8
		Variable YN=0
		Build_length_matrix(imax,jmax,YN)
	endif
	
	NVAR ishot = root:ishot
	String setname = "s"+num2istr(ishot)
	DFREF df=root:$setname
	
	Variable end_Str = strsearch(inwav,"_",11)
	String emis_str = "emiss"+inwav[5,(end_Str-1)]
	
	Wave fswav=df:$inwav
	Duplicate/O fswav df:$emis_str
	Wave emis_wav = df:$emis_str
	
	Wave Length_matrix=root:Length_matrix
	matrixop/o outmat=inv(Length_matrix)
	//Make the error length matrix
	duplicate/o outmat outmat_err
	outmat_err /= outmat_err
	outmat_err *=.3

	matrixop/o emis_wav=outmat x fswav
	
//	String fs_pererr = inwav[0,13]+"per_err"
//	duplicate/o  $inwav $fs_pererr, emiss_4000_splminus
//	
//	print fs_pererr,emis_str
//
//	String emis_pl_err = emis_str[0,10]+"_splplus"
//	duplicate/O fswav $fs_pererr
//	WAVE emis_plus =$emis_pl_err
//	Wave m_product
//	duplicate/o  fswav fs_perr, emis_plus
//	
//	String fswav_plus = inwav[0,10]+"splplus"
//	Wave plus_dum = $fswav_plus
//	fs_perr = sqrt((plus_dum/fswav)^2)
//	matrixmultiply outmat_err, fs_perr
//	emis_plus = sqrt(m_product)*emis_wav
//
////	
////	fsmid_4000_per_err = sqrt((fsmid_4000_splminus/fsmid_4000)^2)
////	matrixmultiply outmat_err, fsmid_4000_per_err
////	emiss_4000_splminus = sqrt(m_product)*emiss_4000
End