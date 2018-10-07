#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function getRHOPSI(shot,efittime,server)
	variable shot
	variable efittime
	string server
	
	PathInfo usrDesktop
	if(V_flag == 0)
		Abort "Data Path does Exist: Make New Path."
	endif
	String unixPath = ParseFilePath(5,S_path,"/",0,0)
	
	PathInfo python
	if(V_flag == 0)
		Abort "Data Path does Exist: Make New Path."
	endif
	String pythonPath = ParseFilePath(5,S_path,"/",0,0)
	
	print "Calculating rhoN"
	calcRHOfromEFIT(shot,efittime,server,unixPath,pythonPath,0)

	string fname = "pyEFIT_rhoN_psiN_"+num2istr(shot)+".h5"
	variable fileID
	HDF5OpenFile/P=usrDesktop/R/Z fileID as fname
	HDF5LoadGroup/T/O/Z/IGOR=-1 :, fileID,"/"
	HDF5CloseFile/A/Z fileID

	string igorCmd2 = "cd ~;source .bash_profile;cd '"+unixPath+"';rm -f "+fname
	string exeCmd2
	sprintf exeCmd2, "do shell script \"%s\"", igorCmd2
	ExecuteUnixShellCommand(igorCmd2, 0, 0)
End
	
Function calcRHOfromEFIT(shot,t_efit,server,unixPath,pythonPath,printCmd)
	Variable shot
	Variable t_efit
	String server
	String unixPath
	String pythonPath
	Variable printCmd
	
	string igorCmd, exeCmd, tags
	SVAR tanj_radii = root:FSmid_geometry:str_fs_tanj_radii
	SVAR tanj_zes = root:FSmid_geometry:str_fs_tanj_zes
	tags = "--Rin "+tanj_radii+" --Zin "+tanj_zes
	igorCmd = "cd ~;source .bash_profile;cd '"+unixPath+"';python ../../../pytools/EFIT/Calculate_rho_gt1.py "+num2istr(shot)+" "+num2str(t_efit)+" "+tags+" -s "+server
	if(printCmd)
		print igorCmd
	endif
	sprintf exeCmd, "do shell script \"%s\"", igorCmd
	ExecuteUnixShellCommand(igorCmd, 0, 0)
End	