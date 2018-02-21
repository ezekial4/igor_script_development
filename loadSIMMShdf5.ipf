#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.


Function getSIMMShdf(fnam, grpnam)
	string fnam
	string grpnam
	
	string/G neuPath
	variable fileID
	
	PathInfo DropboxSIMMS
	if(V_flag == 0)
		makeDROPBOXpmi(neuPAth)
	endif
	String unixPath
	unixPath = ParseFilePath(5,S_path,"/",0,0)
	
	print "Loading Data into IGOR"
	print "From:"+unixPath+fnam
	
	HDF5OpenFile/P=DropboxSIMMS/R/Z fileID as fnam
	HDF5LoadGroup/T/O/R/Z/IGOR=-1 :, fileID, grpnam
	HDF5CloseFile/A/Z fileID
	
	
End
	

Function makeDROPBOXpmi(neuPATH)
   string neuPATH
   NewPath/Q/M="Made new IgorPro path to Dropbox SIMMS folder" DropboxSIMMS, neuPATH
End
   
   
