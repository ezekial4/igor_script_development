#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function Save2HDF(fnam)
	String fnam // "test14.h5"
	 
	NewPath/O SavePath, "TravelTronSSD:Users:unterbee:Desktop"
	
	Variable fileID
	HDF5CreateFile /O/P=SavePath fileID  as fnam
	HDF5SaveGroup/O  :,fileID,"." 
	HDF5CloseFile fileID
End