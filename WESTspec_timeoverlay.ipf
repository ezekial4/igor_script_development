#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

function plotMulti(pntST,pntED)
	variable pntST
	variable pntED
	
	variable i, j
	variable step
	int step1
	
	wave wav = root:Packages:ColorTables:Matplotlib:plasma
	wave xwav = root:WEST_VST_54696_LODIVOU20:MAIN:wavlngth:data_0
	
	Display :WEST_VST_54696_LODIVOU20:MAIN:radiance:data_0[][473] vs xwav
	ModifyGraph rgb=(3084,1799,34438,26214)
	ModifyGraph log=1,standoff=0,tick=2,mirror=1,mode=4,marker=8,opaque=1,msize=2
	
	j=1
	for(i=pntST;i<pntED;i+=1)
		step = j*(435/(pntED-pntST))
		step1 = step
		AppendToGraph :WEST_VST_54696_LODIVOU20:MAIN:radiance:data_0[][i] vs xwav
		ModifyGraph mode=0
		ModifyGraph rgb[j]=(wav[step1][0],wav[step1][1],wav[step1][2],26214)
		j +=1
	endfor
end