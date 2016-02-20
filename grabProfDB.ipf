#pragma rtGlobals=1		// Use modern global access method.

Function getPROFDAT(shot,timeid,runid)
	variable shot
	variable timeid
	string runid
	
	PathInfo DataDump  
	if(V_flag  == 0)
		Abort "Data Path doesn't exist: Make New Path."
	endif
	String unixPATH
	unixPath = ParseFilePath(5,S_path,"/",0,0)
	
	 print "Getting data from GA MDSplus"
	 print unixPath
	 grabProfDB(shot,timeid,runid,unixPath)
	
	 string fname = "profdb_out_"+num2istr(shot)+"_"+num2istr(timeid)+"_"+runid+".h5"
	 variable fileID
	 print "Loading Data into IGOR"
	 HDF5OpenFile/P=DataDump/R/Z fileID as fname
	 HDF5LoadGroup/T/O/Z/IGOR=-1 :, fileID,"/"
	 HDF5CloseFile/A/Z fileID
	 
	 string igorCmd = "cd ~;source .bash_profile;cd "+unixPath+";rm "+fname
	 string exeCmd
	 sprintf exeCmd, "do shell script \"%s\"", igorCmd
	 ExecuteUnixShellCommand(igorCmd, 0, 0)
	 
	 print "Complete"
End

Function grabProfDB(shot,timeid,runid,unixPath)
	variable shot
	variable timeid
	string runid
	string unixPath
	
	variable prtCmd = 0
	variable prtRslt = 1
	
	string igorCmd, exeCmd
	igorCmd = "cd ~;source .bash_profile;cd '"+unixPath+"';python pyProfDB2IGOR.py "+num2istr(shot)+" "+num2istr(timeid)+" "+" "+runid
	sprintf exeCmd, "do shell script \"%s\"", igorCmd
	ExecuteUnixShellCommand(igorCmd, prtCmd, prtRslt)
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

