#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function getGADAT(shot,pntname,server)
	variable shot
	string pntname
	string server
	
	PathInfo DataDump  
	if(V_flag == 0)
		Abort "Data Path does Exist: Make New Path."
	endif
	String unixPath
	unixPath = ParseFilePath(5,S_path,"/",0,0)
	
	print "Getting data from GA MDSplus"
	grabGAdat(shot,pntname,server,unixPath,0)
	
	string fname = "pyd3dat_"+pntname+"_"+num2istr(shot)+".h5"
	variable fileID
	print "Loading Data into IGOR"
	HDF5OpenFile/P=DataDump/R/Z fileID as fname
	HDF5LoadGroup/T/O/Z/IGOR=-1 :, fileID,"/"
	HDF5CloseFile/A/Z fileID
	
	string igorCmd = "cd ~;source .bash_profile;cd '"+unixPath+"';rm -f "+fname
	string exeCmd
	sprintf exeCmd, "do shell script \"%s\"", igorCmd
	ExecuteUnixShellCommand(igorCmd, 0, 0)
End

Function grabGAdat(shot,tags,server,unixPath,printCmd)
	Variable shot
	String tags
	String server
	String unixPath
	Variable printCmd
	
	string igorCmd, exeCmd
	igorCmd = "cd ~;source .bash_profile;cd '"+unixPath+"';python pyD3D2hdf5.py "+" '"+server+"' "+num2istr(shot)+" '"+tags+"' "
	if(printCmd)
		print igorCmd
	endif
	sprintf exeCmd, "do shell script \"%s\"", igorCmd
	ExecuteUnixShellCommand(igorCmd, 0, 0)
End

Function/S ExecuteUnixShellCommand(uCommand, printCommandInHistory, printResultInHistory)
	String uCommand				// Unix command to execute
	Variable printCommandInHistory
	Variable printResultInHistory

	if (printCommandInHistory)
		printf "Unix command: %s\r", uCommand
	endif

	String cmd
	sprintf cmd, "do shell script \"%s\"", uCommand
	ExecuteScriptText/Z cmd

	if (printResultInHistory)
		Print S_value
	endif

	return S_value
End

