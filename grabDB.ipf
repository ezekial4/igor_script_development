#pragma rtGlobals=1		// Use modern global access method.

Function getGAdataDUMP(shot, icoil_type)
	variable shot
	variable icoil_type
	string pntname
	
	PathInfo DataDump  
	if(V_flag  == 0)
		Abort "Data Path does Exist: Make New Path."
	endif
	String unixPath
	unixPath = ParseFilePath(5,S_path,"/",0,0)
	
	print unixPath
	print "Getting data from GA MDSplus"
	tic()
	grabDB(shot, icoil_type, unixPath,0)
	toc()
End

Function grabDB(shot,icoil_type,unixPath,printCmd)
	variable shot
	variable icoil_type
	string unixPath
	variable printCmd
	
	string savPAth = "~/Dropbox/1_NearTerm/DIIID_Analysis/DIIID_shotSum/"+num2istr(shot)
	string pytoolsPATH = "~/Pytools/DIIID/DIIID_DBwork"
	string igorCmd, exeCmd
	if(icoil_type)
	   igorCmd = "cd "+savPath+";source ~/.bash_profile;python "+pytoolsPATH+"/data_grab_nosqlDB.py "+num2istr(shot)+" --icoil 'pc'"
	else
	   igorCmd = "cd "+savPath+";source ~/.bash_profile;python "+pytoolsPATH+"/data_grab_nosqlDB.py "+num2istr(shot)
	endif
	if(printCmd)
		print igorCmd
	endif
	sprintf exeCmd, "do shell script \"%s\"", igorCmd
	ExecuteUnixShellCommand(igorCmd, 0, 1)
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

