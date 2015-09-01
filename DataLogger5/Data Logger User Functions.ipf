#pragma rtGlobals=1		// Use modern global access method.
#pragma version = 3.00


// 3.00 27/2/06
// added user editable functions that are called at initialisation, starting, stopping and in background.
// 2.00  29/1/04
//  updated for Igor 5: removed fixed-named hook function, switched to VDT2.


// You can write functions to read data from instruments that return cryptic strings that need parsing
// Be careful to handle timeouts gracefully (use VDTRead2 /Q and return NaN for a timeout)
// see below for examples


// ------------------------ some simulation fuctions for demonstration ----------------------------

Function DLSimulation3()// 
	return gnoise(0.1)+max(10*sin(ticks/3600) , 5*cos(ticks/3600))
end

Function DLSimulation4()// 
	return 10*(mod(datetime,60)<30)+gnoise(0.2)
end

Function DLSimulation5()// 
	return DL_Simulation1()*sin(Ticks/120)
end

Function DLSimulation6()// 
	return -5+10* (mod(datetime,60)<30)+gnoise(0.1)+sin(ticks/1200)
end

Function DLSimulation7()// 	
	return gnoise(0.1)+10*sin(ticks/3600) + (mod(datetime,60)<5)
end


// -------------------------------------------------------------------------------------------------------------------------------------------------
// DL_DataLoggerGraphStyle can be edited to get adjust the default plot style so that specific channels
// are plotted sensibly
// Most of the trace and axis styles will be set according to the current graph preferences by default
// You may need to adjust "zero isn't special" (SetAxis /E=n) and "use data limits" (SetAxis /N=n) 
// options for a channel to appear as you wish
// If you plot multiple channels on a single axis (see Display options), you need only adjust the axis 
// settings for one of those traces
Function DL_DataLoggerGraphStyle() : GraphStyle
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	string ListOfTraces=TraceNameList("", ";", 1), StrTraceName	
	variable i, ch
	string StrAxisName
	
	for (i=0; i<ItemsInList(ListOfTraces); i+=1)
		StrTraceName=StringFromList(i,ListOfTraces)
		StrAxisName = StringByKey("YAXIS", TraceInfo("", StrTraceName, 0))
		ch=str2num(StrTraceName[strlen(StrTraceName)-1])
		strswitch (ChanTxt[%ChanName][ch])
			
			// edit the following to tweak graph appearance
			// use ModifyGraph,  SetAxis with $StrTraceName and $StrAxisName
			
			case "Motor":
				ModifyGraph mode($StrTraceName)=6 				
			break
			
			case "Pressure":
				SetAxis /A/E=1 $StrAxisName 
			break
			
			case "Temperature":
				SetAxis /A/E=1 $StrAxisName 
			break
						
			case "Example": // channel name string
				// ModifyGraph mode($StrTraceName)=6 
				// SetAxis /A/E=1 $StrAxisName 
			break					
		
		endswitch
	endfor
End

function DL_UserSave() // called when experiment and log files are saved
	
end

function DL_UserInit() // called during inititalisation	
	wave Config=root:Packages:RS232Logger:Config
	Config[%PublishOnWeb]=0
	Config[%SendEmailAlerts]=0
	Config[%delay]=0 	
end

function DL_UserBG() // called in every iteration of the background task

end

function DL_UserStop() // called after stopping
	
end

function DL_UserSummary()	

end


//      ++++++++++++++++ do not delete functions above this point ++++++++++++++++


// ReadMotorSpeed is a user-defined function to extract hex value from serial relay box...
// This is an example of a function written to extent the functionality of tha data logger
// beyond the settings allowed in the GUI.
// User functions must take 0 parameters and return a numerical value for the current reading;
// returning NaN will be interpreted by the logger as a read error and will trigger an error message.
// User functions must be written in this procedure file (Data Logger User Functions.ipf)

Function ReadMotorSpeed()
	string VDTReadStr=""
	variable value
	
	// for this instrument a query string ("S0") was entered in the channel setup
	// so we don't have to worry about executing a vdtwrite
	// otherwise we would do something like:
	
	// VDTOperationsPort2 COM4; VDT2 killio
	// VDTwrite2 /O=1/Q "S0"
	
	// note that the com port number is hard wired in the code above
	
	// The instrument with which we're interfacing is rather primitive: we cannot turn
	// off its remote echo, so we get around this by executing two VDT reads to VDTReadStr:
	VDTRead2 /Q/O=0.25 VDTReadStr, VDTReadStr
	
	// The instrument returns a hex value, so we use sscanf to convert to decimal:
	sscanf VDTReadStr, "%x", value // convert hex to dec	
	if (V_Flag<1) // something wrong, so return NaN
		return NaN
	endif

	if (value&0x40) // the first bit tells us whether motor is on
		if (value&0x80) // the second bit tells us whether motor is moving backward (negative speed)
			return -(value-0x40-0x80+1) // calculate speed from remaining bits
		else
			return (value-0x40+1)
		endif
	endif		
	return 0	// motor is off; speed =0	
end

// example User Function to edit:
Function DLexample()
	string VDTReadStr=""
	variable VDTReadValue
	
	variable value

	VDTOperationsPort2 COM4; VDT2 killio; // set the correct COM port #
	VDTwrite2 /O=1/Q "foo"  // replace foo with an ASCII string to send to instrument
	// see help for VDT to deal with more complicated interfacing
	
	VDTRead2 /Q/O=2 VDTReadStr
	
	sscanf VDTReadStr ,"bar123> %f", value // extract value from string	
	// always include a check for a bad reading (timeout from instrument, for example)
	if (V_Flag<1) // 
		return NaN
	endif		
	
	// enter code here to determine the value that you wish to read
	
	return value
End	












