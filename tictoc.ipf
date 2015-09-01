#pragma rtGlobals=3		// Use modern global access method and strict wave access.

function tic()
	variable/G tictoc = startMSTimer
end
 
function toc()
	NVAR/Z tictoc
	variable ttTime = stopMSTimer(tictoc)
	printf "%g seconds\r", (ttTime/1e6)
	killvariables/Z tictoc
end