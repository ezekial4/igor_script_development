#pragma rtGlobals=1		// Use modern global access method.

Function GA_Download(filename)
	String filename 
//       Prompt filename, "Name the file to download:"
	
	Killstrings/Z GA_url
	String Direct="idl/partbal/"
	String GA_url= "ftp://hydra.gat.com/u/unterbee/"+Direct+filename
	Killstrings/Z pathName
	NewPath/O/Q Get_data, "unterbee_hd:Users:unterbee:Desktop:4.Desktop Archive:GA_igor_downloads:"
	String pathName = "Get_data"

	FTPDownload/O/Z/N=22/S=0/V=0/P=$pathName/U="unterbee"/W="feb134178" GA_url, filename
	LoadWave/Q/O/H/P=$pathName filename

End