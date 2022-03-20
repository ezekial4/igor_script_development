#pragma rtGlobals=1		// Use modern global access method.

Function grabGAdat(shot,tags)
	variable shot
	string tags
	
	string igorCmd , exeCmd

	igorCmd = "cd ~;source .bash_profile;cd ~/Desktop/DIIID_Dat/;python pyD3D2hdf5.py "+num2istr(shot)+" '"+tags+"' "
	
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
	ExecuteScriptText cmd

	if (printResultInHistory)
		Print S_value
	endif

	return S_value
End

Function getGADAT(shot,pntname)
	variable shot
	string pntname
	
	print "Getting data from GA MDSplus"
	grabGAdat(shot,pntname)
	
	NewPath/O/Q dataFile "DeskTron:Users:unterbee:Desktop:DIIID_Dat:"
	
	 string fname = "pyd3dat_"+pntname+"_"+num2istr(shot)+".h5"
	 variable fileID
	 print "Loading Data into IGOR"
	 HDF5OpenFile/P=dataFile/R/Z fileID as fname
	 HDF5LoadGroup/T/O/Z/IGOR=-1 :, fileID,"/"
	 HDF5CloseFile/A/Z fileID
	 
	 
	 string igorCmd = "cd ~;source .bash_profile;cd ~/Desktop/DIIID_Dat/;rm "+fname
	 sprintf exeCmd, "do shell script \"%s\"", igorCmd
	 ExecuteUnixShellCommand(igorCmd, 0, 0)
	 
End

