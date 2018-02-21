#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function doALL(fnam)
	string fnam
	
	string efGRP = fnam[0,3]+"_ef"
	string rbsGRP = fnam[0,3]+"_rbs"
	string simmsGRP = fnam[0,3]+"_simms"
	string arealGRP = fnam[0,3]+"_arealF"
	getDATAhdf(fnam, efGRP,0)
	getDATAhdf(fnam, rbsGRP,0)
	getDATAhdf(fnam, simmsGRP,0)
	getDATAhdf(fnam, arealGRP,0)
	
End

Function getDATAhdf(fnam, grpnam, quiet)
	string fnam
	string grpnam
	variable quiet
	
	string/G neuPath
	variable fileID
	
	PathInfo DropboxSIMMS
	if(V_flag == 0)
		makeDROPBOXpmi(neuPAth)
	endif
	String unixPath
	unixPath = ParseFilePath(5,S_path,"/",0,0)
	
	if(quiet == 1)
		print "Loading Data into IGOR"
		print "From:"+unixPath+fnam
	endif
	
	HDF5OpenFile/P=DropboxSIMMS/R/Z fileID as fnam
	HDF5LoadGroup/T/O/R/IGOR=-1 :, fileID, grpnam
	HDF5CloseFile/A/Z fileID
End
	
Function makeDROPBOXpmi(neuPATH)
   string neuPATH
   NewPath/Q/M="Made new IgorPro path to Dropbox SIMMS folder" DropboxSIMMS, neuPATH
End
   
   
