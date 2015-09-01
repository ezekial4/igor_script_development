#pragma rtGlobals=3		// Use modern global access method and strict wave access.


function quickave(start,stop,colavg)
	variable start
	variable stop
	variable colavg
	
	Wave rne_2d,  rne_2d_ave
	Wave rte_2d, rte_2d_ave
	
	variable i
	for(i=0;i<11;i+=1)
		ImageStats/M=1/GS={i,i,start,stop} rne_2d
		rne_2d_ave[i][colavg] = V_avg
		
		ImageStats/M=1/GS={i,i,start,stop} rte_2d
		rte_2d_ave[i][colavg] = V_avg
	endfor
end