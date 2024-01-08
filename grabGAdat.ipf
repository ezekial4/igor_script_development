#pragma rtGlobals=1		// Use modern global access method.

Function getGADAT(shot,pntname,server)
	variable shot
	string pntname
	string server
	
	PathInfo usrDesktop 
	if(V_flag == 0)
		Abort "Data Path does Exist: Make New Path."
	endif
	String unixPath = ParseFilePath(5,S_path,"/",0,0)
	
	PathInfo Python
	if(V_flag == 0)
		Abort "Data Path does Exist: Make New Path."
	endif
	String pythonPath = ParseFilePath(5,S_path,"/",0,0)
	
	print "Getting data from GA MDSplus"
	grabGAdat(shot,pntname,server,unixPath,pythonPath,0)
	
	string fname = "pyd3dat_"+pntname+"_"+num2istr(shot)+".h5"
	variable fileID
	print "Loading Data into IGOR for pointname: "+pntname
	HDF5OpenFile/P=usrDesktop/R/Z fileID as fname
	HDF5LoadGroup/T/O/Z/IGOR=-1 :, fileID,"/"
	HDF5CloseFile/A/Z fileID
	
	string igorCmd = "cd ~;source .bash_profile;cd '"+unixPath+"';rm -f "+fname
	string exeCmd
	sprintf exeCmd, "do shell script \"%s\"", igorCmd
	ExecuteScriptText/UNQ/B/Z igorCmd
End

Function grabGAdat(shot,tags,server,unixPath,pythonPath,printCmd)
	Variable shot
	String tags
	String server
	String pythonPath
	String unixPath
	Variable printCmd
	
	string igorCmd, exeCmd
	igorCmd = "cd ~;source .bash_profile;cd '"+unixPath+"';python "+pythonPath+"/DIIID/DIIID_mdsdat/pyD3D2hdf5.py "+" '"+server+"' "+num2istr(shot)+" '"+tags+"' "
	if(printCmd)
		print igorCmd
	endif
	sprintf exeCmd, "do shell script \"%s\"", igorCmd
	ExecuteScriptText/UNQ/Z igorCmd
End