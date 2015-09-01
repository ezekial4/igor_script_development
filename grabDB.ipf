#pragma rtGlobals=1		// Use modern global access method.

Function getGAdataDUMP(shot)
	variable shot
	string pntname
	
	PathInfo DataDump  
	if(V_flag  == 0)
		Abort "Data Path does Exist: Make New Path."
	endif
	String unixPath
	unixPath = ParseFilePath(5,S_path,"/",0,0)
	
	 print "Getting data from GA MDSplus"
	 grabDB(shot,unixPath,0)
	
	 string fname = "paramDB_"+num2istr(shot)+".h5"
	 variable fileID
	 print "Loading Data into IGOR"
	 HDF5OpenFile/P=DataDump/R/Z fileID as fname
	 HDF5LoadGroup/T/O/Z/IGOR=-1 :, fileID,"/"
	 HDF5CloseFile/A/Z fileID
End

Function grabDB(shot,unixPath,printCmd)
	variable shot
	string unixPath
	variable printCmd
	
	string pytoolsPATH = "~/Pytools/DIIID/DIIID_DBwork"
	string igorCmd, exeCmd
	igorCmd = "cd~;source ~/.bash_profile;python "+pytoolsPATH+"/data_grab_alone.py "+num2istr(shot)
	if(printCmd)
		print igorCmd
	endif
	sprintf exeCmd, "do shell script \"%s\"", igorCmd
	ExecuteUnixShellCommand(igorCmd, 1, 1)
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
	ExecuteScriptText cmd

	if (printResultInHistory)
		Print S_value
	endif

	return S_value
End

