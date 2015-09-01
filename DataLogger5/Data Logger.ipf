#pragma rtGlobals=2	// Use modern global access method.
#pragma version=5.01

#include "Data Logger User Functions", version >=3.00

// Author: Tony Withers
// email: withe012@umn.edu
//
// An alias/shortcut to this file should reside in the igor procedures folder
// Must have VDT2 XOP in igor extensions folder
//
// Needs pkzipc, scp2 and postie command line programs for full functionality.
//


// version history sebsequent to 4.00
//
// 5.01 9/28/06 
// open ports at start of log in DL_StartStopLog (if port settings have been changed this ensures 
// that we'll hve the right settings)
// delay function is fixed - make sure it's called with a sensible number of microseconds.
// call DL_UserInit() after loading a saved log from file or memory
// can adjust DL_InfoStr from the user defined function so that we can print a nice summary of 
// an old log
// 5.00 4/3/06
// started to work on mac compatibility. store port names in chantxt (mac usb adaptors 
// add strange names). added empty points at the beginning of configuration waves
// so that referencing with a bad dimension label returns NaN (or ""). 
// 4.20 2/27/06
// added calls to user defined functions at startup, reset, and in background task.
// 4.19 11/4/05
// have a guess at a unique experiment name based on default name, if the save directory is set.
// 4.18 10/8/05
// fixed bug in loop that checks for different settings on the same com port
// added option to introduce delay in acquisition loop to allow for RS485 turnaround time.
// 4.17 9/18/05
// testing new feature: save a little html file on web server
// 4.16 8/10/05
// In display panel can use shift key to switch scaling of all axes with one click
// 4.15 5/8/05
// if the time is way out of sync we loop for a second to avoid printing multiple error messages
// 4.14 4/18/05
// tweaked win scaling
// 4.13 4/11/05
// added new 'win' scaling for vertical axes - sets limits according to display range
// 4.12 4/9/05
// fixed DL_LogData so that DL_OpenPort is called whenever channels with 
// conflicting com settings share the same port (for RS485/422 networks)..
// 4.11 2/12/05
// fixed minor bug in DL_UpdateGraphSetUpPanel()
// 4.10 2/7/05
// save chan files when display is changed, so that current display prefs are remembered.
// Don't try and save if using demo version.
// 4.09 2/2/05
// changed default appearance of log graph - darker traces, no bg window colour
// 4.08 1/31/05
// added check for valid email address and prompt for correct address at startup
// 4.07 9/24/04
// Found a few more SetVars that didn't specify the window name.
// 4.06 8/31/04 After editing a log, prompt for saving the edited version or revert to saved
// struggling to get BeforeFileOpenHook to work
// 4.05 6/7/04 added shortcuts to turn all channels off/on etc (allows programmatic control)
// replaced GetKeyBoardState with GetKeyState (no need for GetInputState XOP)
// Added menu option to toggle tracking
// 4.04 5/14/04 allowed specification of terminator characters with VDTRead2 when
// reading directly to a variable, removed some global variables in Channel Setup
// procedures.
// 4.03 removed some modal dialogs 
// 4.01 fixed bug in DataLoggerSaveGraphToFile(): GetWindow was relying on 
// DoWindow/F to bring LogGraph to front. LogGraph now explicit in GetWindow.
// Could have caused a problem if another window was brought to the front just 
// as these lines were executed.
// 4.00 Updated for Igor 5 : major overhaul

// --------------------------------------------------------------------------------------------------------------------
//
//	Copyright © 2003 Anthony C Withers
//	
//	All rights reserved.
//	
//	Redistribution and use in source and binary forms, with or without modification, 
//	are permitted provided that the following conditions are met:
//	
//	Redistributions of source code must retain the above copyright notice, this list 
//	of conditions and the following disclaimer.
//	
//	Redistributions in binary form must reproduce the above copyright notice, this 
//	list of conditions and the following disclaimer in the documentation and/or other 
//	materials provided with the distribution.
//	
//	The name of the Author may not be used to endorse or promote products 
//	derived from this software without specific prior written permission.
//	
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
//	CONTRIBUTORS "AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
//	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
//	MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
//	DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE 
//	LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, 
//	OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
//	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
//	DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
//	AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
//	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING 
//	IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED 
//	OF THE POSSIBILITY OF SUCH DAMAGE.
//
// --------------------------------------------------------------------------------------------------------------------

static constant kTesting=0
static constant kdefaultWinScaling=1// 1 for Win scaling, 0 for Auto
static constant kdefaultTicksPerSec=0 // zero for auto

// kTesting
// 0: normal data logger (procedure files hidden)
// 1: data logger with procedures 
// -------------------------------------- Data Logger -------------------------------------- 

SetIgorHook BeforeFileOpenHook=DL_BeforeFileOpenHook

Menu "Logger"
	DL_MacrosMenuLogger(1), /Q , DL_InitialiseDataLogger() // "Initialise Data Logger"
	DL_MacrosMenuLogger(2), /Q, DL_ResetDataLogger("")
	DL_MacrosMenuLogger(3), /Q, DL_ExitDataLogger("")
	DL_MacrosMenuLogger(4), /Q, DL_MakeEditLogPanel()
	DL_MacrosMenuLogger(5), /Q, DL_ToggleTracking()
	submenu "Misc"
		DL_MacrosMenuLogger(10), /Q, DL_EditUserFuncs()
		DL_MacrosMenuLogger(11), /Q, DL_CreateWebPageTemplate()
	end
end

function /S DL_MacrosMenuLogger(item)
	variable item
	variable started=(strlen(WinList("LogPanel",",","WIN:64")))
	switch(item)
		case 1:
			if (started)
				return "(Initialise Data Logger"
			else
				return "Initialise Data Logger"
			endif
		case 2:
			if (started)
				return "Reset Logger"
			else
				return "(Reset Logger"
			endif		
		case 3:		
			if (started)
				return "Exit Logger"
			else
				return "(Exit Logger"
			endif
		case 4:		
			if (started)
				return "Edit, Print Log..."
			else
				return "(Edit, Print Log..."
			endif
		case 5:
			if (started)
				wave config=root:Packages:RS232Logger:config 
				if(config[%update])
					return "!"+num2char(18)+"Tracking"	// Tracking with a check
				else
					return "Tracking"
				endif
			else
				return "(Tracking"
			endif
		case 10:
			if (started)
				return "Edit User Funcs..."
			else
				return "(Edit User Funcs..."
			endif
		case 11:
			if (started)
				return "Create Web Page Template..."
			else
				return "(Create Web Page Template..."
			endif
	endswitch
end

// InitialiseDataLogger() starts from scratch, overwriting any pre-existing log
// and rebuilding the control panel and log graph
function DL_InitialiseDataLogger() //start from scratch
	SetIgorHook BeforeFileOpenHook=DL_BeforeFileOpenHook
	DL_InitialiseDataLogVariables()
	DL_UserInit()
	DL_MakeLogPanel()
	DL_MakeLogGraph()
	// update dynamic menu
	BuildMenu "Logger"
	DL_PromptForEmailAddress()
	return 1
end

function DL_PromptForEmailAddress()
	wave /T configtxt=root:Packages:RS232Logger:configtxt
	wave config=root:Packages:RS232Logger:config
	string str_checkemailaddress=configtxt[%email]
	if (strlen(str_checkemailaddress)==0 || config[%SendEmailAlerts]==0)
		return 1
	endif	
	do	
		prompt str_checkemailaddress, "Send email alerts to"
		DoPrompt /HELP="type a valid email address inside the quotes" "Address for email alerts", str_checkemailaddress
		if (V_Flag<1)
			configtxt[%email]=str_checkemailaddress		
		else
			configtxt[%email]=""
			str_checkemailaddress=""
		endif		
	while (strlen(str_checkemailaddress) && DL_EmailValid(str_checkemailaddress)==0)
	DL_UpdateExternalConfigFile() // saves default email address in serversettings.txt
end

// wrapper functions to use as menu items

function DL_EditUserFuncs()
	if (DL_LogStatus()==1)
		doalert 0, "Stop log before editing Data Logger User Functions"
		return 0
	endif
	DisplayProcedure "DL_DataLoggerGraphStyle"
end

// DL_LogStatus() returns 1 if log is in progress
// returns -1 if another background task is running
// returns 0 if no background process is active	
function DL_LogStatus() 
	variable status
	BackgroundInfo
	if (V_Flag==2) // background task is running
		if (cmpstr(S_value, "DL_LogData()")==0) // Log in progress
			status=1	
		else	// another background task in progress
			status=-1
		endif
	else
		status=0
	endif
	return status
end

function DL_ToggleTracking()
	wave config=root:Packages:RS232Logger:config
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave W_display_time=root:Packages:RS232Logger:W_display_time
	config[%update]=1-config[%update]	
	if (config[%update]) //turn tracking on	 		
		W_log[%xRight]=datetime+Config[%UpdateInterval]*60
		if (numpnts(W_display_time))		
			SetAxis bottom W_display_time[0], W_log[%xRight]
		else	// not sure how we would arrive here
			SetAxis bottom datetime, W_log[%xRight]
		endif		
	 else //turn tracking off
		setAxis /W=LogGraph /A bottom
		config[%update]=0
	endif
	BuildMenu "Logger"
	return 1
end

function DL_ResetDataLogger(ctrlName) : ButtonControl // reset the log to start over. 
	string ctrlName
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave config=root:Packages:RS232Logger:config
	
	// DL_LogStatus() determines whether log is active
	variable status=DL_LogStatus()
	if (status) // background task is running
		if (status==1) // Log in progress
			if (W_Log[%i]) // we've recorded something
				doalert 1, "A log is active. Do you want to kill this log (no save) and start over?"
				if (V_Flag==2) // click=no
					doalert 0, "The current log has to be stopped before log can be reset"
					return 0
				endif
			endif
			config[%StopLog]=1 // halt log after next pass		
		else	// another background task in progress
			doalert 1, "A background task is active. Do you want to kill this task?"
			if (V_Flag==2) // click=no
				doalert 0, "The current background task has to be stopped before log can be reset"
				return 0
			else
				CtrlBackground stop // kill any other background process
			endif
		endif
	endif	
	// kill any windows that shouldn't be open
	doWindow /K FileControlPanel
	doWindow /K DisplayControlPanel
	doWindow /K CommErrorPanel
	doWindow /K AlarmSetupPanel
	DL_InitialiseDataLogVariables()
	DL_MakeLogPanel()
	DL_MakeLogGraph()
	BuildMenu "Logger"
	return 1
end

// DL_SaveLog() saves the experiment, giving it a new name if none was set.
// If we're publishing on the web, a screenshot is copied to the server
// When neccessary the graph is rescaled and the summary plot is updated 
function DL_SaveLog()
	wave config=root:Packages:RS232Logger:config
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	
	if (strlen(ConfigTxt[%SavePathStr]))
		DL_AutoSaveLogFile()			
	endif
	
	If ((cmpstr(IgorInfo(1), "Untitled")==0)||(cmpstr(IgorInfo(1), "Data Logger")==0))
		if (strlen(ConfigTxt[%SavePathStr]))
			SaveExperiment /P=SavePath as cleanupname(ConfigTxt[%experiment]+"_"+secs2date(datetime,0),0)+".pxp"
		endif
	else
		SaveExperiment
	endif
	
	if ( config[%PublishOnWeb] && (strlen(WinList("LogGraph",",","WIN:1"))) ) 
		PathInfo LoggerPath
		string WinPathStr=DL_MacPath2WinPath(S_Path)
		string UnixPathStr=DL_MacPath2ForwardSlashPath(S_Path)
		string cmd
		if (strlen(ConfigTxt[%ServerLogName])) // 
			SavePICT/E=-5/B=144/O/Z/WIN=LogGraph/P=LoggerPath as "LogGraph.png" // save picture locally as LogGraph.png
			sprintf cmd, "scp2 \"%sLogGraph.png\" %s/%s", UnixPathStr, ConfigTxt[%ServerAddress], ConfigTxt[%ServerLogName]
			ExecuteScriptText /B cmd
			// Command line scp. Runs in the background. uses ssh user key.								
					
		endif
		
		if ((datetime-W_Log[%LastSummary])>Config[%DisplayRange]*60)			
			
			if (strlen( ConfigTxt[%ServerItxName]))
				DL_SaveLogGraphToFile() // create itx file to contain LogGraph data and macro to rebuild graph			
				variable refnum=0
				open /P=LoggerPath refnum as "ZipScpLogGraph.bat"
				// always overwrite this file in case ConfigTxt has been updated				
				// needs pkzipc and scp2
				string StrPkzipcPath=ConfigTxt[%pkzipcPathStr]
				if (strlen(StrPkzipcPath))
					StrPkzipcPath=DL_MacPath2WinPath(StrPkzipcPath)
				endif
				fprintf refnum, "if exist \"%sLogGraph.itx\" \"%spkzipc\" ", WinPathStr, StrPkzipcPath
				fprintf refnum, "-add=update -silent \"%sLogGraph.zip\" \"%sLogGraph.itx\"\r\n", WinPathStr, WinPathStr
				fprintf refnum, "if exist \"%sLogGraph.zip\" scp2 \"%sLogGraph.zip\" ",WinPathStr, UnixPathStr
				fprintf refnum, "%s/%s\r\n", ConfigTxt[%ServerAddress], ConfigTxt[%ServerItxName]
				close refnum // the batch file is used because these commands need to be executed sequentially, 
				// if they run directly through ExecuteScriptText the scp will happen before the zip is updated.
				sprintf cmd, "cmd.exe /C \"%sZipScpLogGraph.bat\"", WinPathStr
				ExecuteScriptText /B cmd
			endif
			
			// now rescale axes and save summary plot image
			if(strlen(ConfigTxt[%ServerSummaryName]))
				wave chan=root:Packages:RS232Logger:chan
				variable ax=1, ch		
				do
					getAxis /W=LogGraph /Q $"Axis"+num2str(ax)
					if (V_Flag==1)
						break
					endif
					if (strlen(StringByKey("SETAXISFLAGS" ,AxisInfo("LogGraph", "Axis"+num2str(ax) )))>0)
						// axis is autoscaled
						for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
							if(Chan[%axis][ch]==ax)
								chan[%AxMin][ch]=0; chan[%AxMax][ch]=0
							endif
						endfor
					elseif(chan[%AxMin][ch]<chan[%AxMax][ch])
						// axis is manually scaled; save limits
						for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
							if(Chan[%axis][ch]==ax)
								chan[%AxMin][ch]=V_min; chan[%AxMax][ch]=V_max
							endif
						endfor					
					endif				
					ax+=1				
				while(1)
				ax-=1
				variable Nax=ax
				variable AutoBottom=(strlen(StringByKey("SETAXISFLAGS" ,AxisInfo("LogGraph", "Bottom" )))>0)
				GetAxis /W=LogGraph /Q bottom			
				SetAxis 	/W=LogGraph /A // autoscale all axes
				doupdate
				for (ax=1; ax<=Nax; ax+=1)
					for (ch=0;ch<max(1,DimSize(Chan,1)); ch+=1)
						if (Chan[%axis][ch]==ax)
							if (chan[%AxMax][ch]==-1 && chan[%AxMin][ch]==-1)
								DL_SummaryWinScaleAxis(ax)
							endif
							break
						endif
					endfor				
				endfor
				
				
				SavePICT/E=-5/B=144/O/Z/P=LoggerPath/WIN=LogGraph as "LogSummary.png"
				// reset axes
				if (!(AutoBottom))
					SetAxis 	/W=LogGraph bottom, V_min, V_max
				endif
				do
					for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
						if(Chan[%axis][ch]==ax)
							if (abs(chan[%AxMax][ch]-chan[%AxMin][ch])>0)
								SetAxis /W=LogGraph $"Axis"+num2str(ax), chan[%AxMin][ch],chan[%AxMax][ch]
							elseif(chan[%AxMin][ch]==-1 && chan[%AxMax][ch]==-1)
								DL_WinScaleAxis(ax)
							endif
						endif
					endfor
					ax-=1
				while (ax>0)			
				// copy full scale image to server
				sprintf cmd, "scp2 \"%sLogSummary.png\" %s/%s", UnixPathStr, ConfigTxt[%ServerAddress], ConfigTxt[%ServerSummaryName]
				ExecuteScriptText /B cmd
			endif // end of saving summary plot
			W_Log[%LastSummary]=datetime						
		endif
	endif
	DL_UserSave() // call user defined function	
end
// Example of contents of ZipScpLogGraph.bat:
// if exist C:\Path\To\LogGraph.itx pkzipc -add=update -silent C:\Path\To\LogGraph.zip C:\Path\To\LogGraph.itx
// if exist C:\Path\To\LogGraph.zip scp2 C:/Path/To/LogGraph.zip withe012@foo.bar.edu:www/LogGraph.zip


function DL_TicksTest(interval) // to test the number of ticks per second
	variable interval
	
	variable startTicks, endTicks
	variable theTime
	
	theTime=datetime+1
	do
	while(datetime<theTime)
	startTicks=ticks
	
	theTime+=interval
	variable foo=0, count=0
	do
		if (ticks>startTicks+count*60*interval/100 && foo==0)
			printf "*"
			count +=1
			foo=1
		endif
		if(mod(ticks, 60)>0)
			foo=0
		endif
	while(datetime<theTime)
	endTicks=ticks
	
	printf "\rtick rate = %*.*f ticks/s\r", ceil(log(interval))+3, ceil(log(interval)), (endTicks-startTicks)/interval
	return (endTicks-startTicks)/interval
end

function DL_PrintToHistory(StrToPrint) //need to add log to file option
	string StrToPrint
	
	wave config=root:Packages:RS232Logger:config
	if (config[%Verbose])
		print date()+" "+time()+" "+StrToPrint
	endif
end

function DL_ResetTicksRef()
	wave W_Log=root:Packages:RS232Logger:W_Log
	W_Log[%timeRef]=datetime+1
	do
	while (datetime<W_Log[%timeRef])
	W_Log[%ticksRef]=ticks // allows us to calculate time precisely
	W_Log[%timeNow]=W_Log[%timeRef]+(ticks-W_Log[%ticksRef])/W_Log[%TicksPerSec]
end

function /T DL_MacPath2ForwardSlashPath(str)
	string str
	variable i=3
	str[1,1]=":/"
	do
		if (stringmatch (str[i], ":"))
			str[i,i]="/"
		endif
		i+=1	
	while(i<strlen(str))
	return str
end

// converts C:Program Files:Wavemetrics: to C:\\Program Files\\Wavemetrics\\
// double backslashes are needed when building commands as strings
function /T DL_MacPath2WinPath(str) 
	string str
	variable i=3
	str[1,1]=":\\"
	do
		if (stringmatch (str[i], ":"))
			str[i,i]="\\"
		endif
		i+=1	
	while(i<strlen(str))
	return str
end


// kill windows that will need updating when # of channels changes
// this is executed when we load a saved log
Function DL_KillSomeDataLoggerWindows() 
	DoWindow /K LogGraph
	DoWindow /K LogPanel
	DoWindow /K DisplayControlPanel
	DoWindow /K AlarmSetupPanel
	DoWindow /K DL_SummaryLayout
	DoWindow /K GraphSetUpPanel
	DoWindow /K LogSetupPanel
	DL_DoneWithEditLogPanel("")
end

// -------------------------------------- Data Logger Alarms -------------------------------------- 

Function DL_MakeAlarmPanel(ctrlName)
	string ctrlName
	
	doWindow /K AlarmSetupPanel
	
	//string savDF= GetDataFolder(1)		// Save current DF for restore.
	//NewDataFolder /O/S root:Packages:RS232Logger:Alarms			
	wave chan=root:Packages:RS232Logger:chan
	wave /T chanTxt=root:Packages:RS232Logger:chanTxt
	wave config=root:Packages:RS232Logger:config
	variable numChan=max(1, DimSize(Chan, 1))
	string StrListOfChannels=""
	NewPanel /N=AlarmSetupPanel/K=1/W=(330,236.75,800.25,410+25*numChan) as "Set Alarm Conditions"
	SetDrawEnv /W=AlarmSetupPanel fstyle=2^0; DrawText /W=AlarmSetupPanel 30,37,"Channel"
	SetDrawEnv /W=AlarmSetupPanel fstyle=2^0; DrawText /W=AlarmSetupPanel 125,37,"Full scale high"
	SetDrawEnv /W=AlarmSetupPanel fstyle=2^0; DrawText /W=AlarmSetupPanel 270,37,"Setpoint"
	SetDrawEnv /W=AlarmSetupPanel fstyle=2^0; DrawText /W=AlarmSetupPanel 350,37,"Deviation"
	variable ch, i
	for (ch=0; ch<numChan; ch+=1)
		StrListOfChannels+=ChanTxt[%ChanName][ch]+";"
		SetDrawEnv /W=AlarmSetupPanel textyjust=2 
		DrawText /W=AlarmSetupPanel 30,45+25*ch,ChanTxt[%ChanName][ch]
						
		for (i=0; i<dimsize(chan, 0); i+=1)
			if (stringmatch(GetDimLabel(chan, 0, i ), "FSHvalue"))
				break
			endif
		endfor
		SetVariable $"setFSH"+num2str(ch),pos={150,45+25*ch},size={50,16},title=" ", win=AlarmSetupPanel 
		SetVariable $"setFSH"+num2str(ch),value=chan[ch * Dimsize(chan,0) + i], win=AlarmSetupPanel 
				
		for (i=0; i<dimsize(chan, 0); i+=1)
			if (stringmatch(GetDimLabel(chan, 0, i ), "DEVsetpoint"))
				break
			endif
		endfor
		SetVariable $"setSP"+num2str(ch),pos={270,45+25*ch},size={50,16},title=" ", win=AlarmSetupPanel 
		SetVariable $"setSP"+num2str(ch),value=chan[ch * Dimsize(chan,0) + i], win=AlarmSetupPanel 
	
		for (i=0; i<dimsize(chan, 0); i+=1)
			if (stringmatch(GetDimLabel(chan, 0, i ), "DEVvalue"))
				break
			endif
		endfor
		SetVariable $"setDEV"+num2str(ch),pos={350,45+25*ch},size={50,16},title=" ", win=AlarmSetupPanel 
		SetVariable $"setDEV"+num2str(ch),value=chan[ch * Dimsize(chan,0) + i], win=AlarmSetupPanel 

		CheckBox $"checkDEV"+num2str(ch), win=AlarmSetupPanel ,pos={250,45+25*ch},size={16,14},title="",value= (chan[%DEVstatus][ch]>=0)
		CheckBox $"checkDEV"+num2str(ch), win=AlarmSetupPanel, proc=DL_AlarmCheckProc
		CheckBox $"checkFSH"+num2str(ch), win=AlarmSetupPanel,pos={125,45+25*ch},size={16,14},title="",value= (chan[%FSHstatus][ch]>-1)
		CheckBox $"checkFSH"+num2str(ch), win=AlarmSetupPanel, proc=DL_AlarmCheckProc		
	endfor	
	
		
	CheckBox checkSendEmails, win=AlarmSetupPanel, pos={30,60+25*ch},size={16,14},title="", value=config[%SendEmailAlerts]
	CheckBox checkSendEmails, win=AlarmSetupPanel, proc=DL_AlarmCheckProc
	setvariable email, win=AlarmSetupPanel, pos={50,60+25*ch}, size={250,14}, value = root:Packages:RS232Logger:ConfigTxt[%email]
	setvariable email, win=AlarmSetupPanel, title="Send email alerts to:", proc=DL_ParseEmail

	CheckBox checkStartCondition, win=AlarmSetupPanel, pos={30,87+25*ch},size={16,14},title=""
	CheckBox checkStartCondition, win=AlarmSetupPanel, value=(config[%AutoActivateAlarms]), proc=DL_AlarmCheckProc
	popupmenu PopChannelToStartAlarms, pos={240,85+25*ch}, title="Activate ALL alarms when ", win=AlarmSetupPanel
	popupmenu PopChannelToStartAlarms, bodyWidth=100, mode=mod(config[%AutoActivateAlarms], 10)+1, win=AlarmSetupPanel
	popupmenu PopChannelToStartAlarms, proc=DL_AlarmsPopProc, win=AlarmSetupPanel
	execute "PopupMenu PopChannelToStartAlarms,value= #\"\\\""+StrListOfChannels+"\\\"\", win=AlarmSetupPanel"
	popupmenu PopStartAlarmsCondition, pos={300,85+25*ch}, title="is", value=">;<", win=AlarmSetupPanel
	popupmenu PopStartAlarmsCondition, mode=1+(config[%AutoActivateAlarms]>=20), win=AlarmSetupPanel
	popupmenu PopStartAlarmsCondition, proc=DL_AlarmsPopProc, win=AlarmSetupPanel
	
	SetVariable setStartAlarmValue, pos={380,87+25*ch}, title=" ", size={60,30}, bodyWidth=60, limits={-inf,inf,0 }, win=AlarmSetupPanel
	SetVariable setStartAlarmValue, value= root:Packages:RS232Logger:config[%AAAvalue], win=AlarmSetupPanel
	
	CheckBox checkEndCondition, win=AlarmSetupPanel, pos={30,112+25*ch},size={16,14},title=""
	CheckBox checkEndCondition, win=AlarmSetupPanel, value=(config[%AutoDeactivateAlarms]), proc=DL_AlarmCheckProc
	popupmenu PopChannelToStopAlarms, pos={240,110+25*ch},title="Deactivate ALL alarms when", win=AlarmSetupPanel
	popupmenu PopChannelToStopAlarms, bodyWidth=100 , mode=mod(config[%AutoDeactivateAlarms], 10)+1, win=AlarmSetupPanel
	popupmenu PopChannelToStopAlarms, proc=DL_AlarmsPopProc, win=AlarmSetupPanel
	execute "PopupMenu PopChannelToStopAlarms,value= #\"\\\""+StrListOfChannels+"\\\"\", win=AlarmSetupPanel"
	popupmenu PopStopAlarmsCondition, pos={300,110+25*ch}, title="is", value=">;<", win=AlarmSetupPanel
	popupmenu PopStopAlarmsCondition, mode=2-(config[%AutoDeactivateAlarms]<20&&config[%AutoDeactivateAlarms]), win=AlarmSetupPanel
	popupmenu PopStopAlarmsCondition, proc=DL_AlarmsPopProc, win=AlarmSetupPanel
	SetVariable setStopAlarmValue, pos={380,112+25*ch}, title=" ", size={60,30}, bodyWidth=60, limits={-inf,inf,0 }, win=AlarmSetupPanel
	SetVariable setStopAlarmValue, value= root:Packages:RS232Logger:config[%ADAvalue], win=AlarmSetupPanel
	
	Button Clear,pos={30,140+25*ch},size={80,20},title="All Off", proc=DL_ClearDataLoggerAlarms, win=AlarmSetupPanel
	Button Reset,pos={130,140+25*ch},size={80,20},title="Reset", proc=DL_ResetDataLoggerAlarms, win=AlarmSetupPanel
	Button Done,pos={390,140+25*ch},size={50,20},title="Done", proc=DL_DoneWithAlarmSetupPanel, win=AlarmSetupPanel
			
	SetWindow AlarmSetupPanel, hook=DL_HookAlarmSetupPanel
	ModifyPanel /W=AlarmSetupPanel , fixedSize= 1
end


function DL_HookAlarmSetupPanel(infoStr)
	string infoStr
	String event= StringByKey("EVENT",infoStr)
	if(stringmatch(event, "activate")) // update controls to reflect their current status
		DL_UpdateAlarmPanel()
	endif
end

function DL_UpdateAlarmPanel()
	doWindow AlarmSetupPanel
	if(V_Flag==0)
		return 0
	endif
	wave chan=root:Packages:RS232Logger:chan
	wave config=root:Packages:RS232Logger:config
	variable numChan=max(1, DimSize(Chan, 1))
	
	variable ch
	for (ch=0; ch<numChan; ch+=1)
		CheckBox $"checkDEV"+num2str(ch), win=AlarmSetupPanel, value= (chan[%DEVstatus][ch]>=0)
		CheckBox $"checkFSH"+num2str(ch), win=AlarmSetupPanel, value= (chan[%FSHstatus][ch]>-1)
		
		// Clear deviation alarm indicators on LogPanel
		if ( (Chan[%DEVstatus][ch]<2) && (Chan[%FSHstatus][ch]<1) ) // don't reset indicator if we've tripped FSH
			ValDisplay $("ChannelValue"+num2str(ch)) labelBack=0, win=LogPanel
		endif				
	endfor
	CheckBox checkStartCondition, win=AlarmSetupPanel, value=(config[%AutoActivateAlarms])
	CheckBox checkEndCondition, win=AlarmSetupPanel, value=(config[%AutoDeactivateAlarms])		
End


Function DL_AlarmsPopProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	wave config=root:Packages:RS232Logger:config
	
	controlinfo /W=AlarmSetupPanel checkEndCondition
	variable AutoEndChecked=V_value
	controlinfo /W=AlarmSetupPanel checkStartCondition
	variable AutoStartChecked=V_value
	
	strswitch(ctrlName)	
		case "PopChannelToStartAlarms":		
			if(AutoStartChecked==0)
				return 0
			endif
			config[%AutoActivateAlarms]-=mod(config[%AutoActivateAlarms], 10)
			config[%AutoActivateAlarms]+=popNum-1
			break
		case "PopStartAlarmsCondition":
			if(AutoStartChecked==0)
				return 0
			endif		
			config[%AutoActivateAlarms]=mod(config[%AutoActivateAlarms], 10)+10*PopNum
			break
		case "PopChannelToStopAlarms":		
			if(AutoEndChecked==0)
				return 0
			endif
			config[%AutoDeactivateAlarms]-=mod(config[%AutoDeactivateAlarms], 10)
			config[%AutoDeactivateAlarms]+=popNum-1	
			break		
		case "PopStopAlarmsCondition":
			if(AutoEndChecked==0)
				return 0
			endif
			config[%AutoDeactivateAlarms]=mod(config[%AutoDeactivateAlarms], 10)+10*PopNum
			break	
	endswitch
End


function DL_ClearDataLoggerAlarms(ctrlName): ButtonControl
	String ctrlName
	wave chan=root:Packages:RS232Logger:chan
	
	chan[%FSHstatus][]=-1
	chan[%DEVstatus][]=-1
	
	variable numChan=max(1, DimSize(Chan, 1))		
	variable ch
	for (ch=0; ch<numChan; ch+=1)
		ValDisplay $("ChannelValue"+num2str(ch)) labelBack=0, win=LogPanel
	endfor
	DL_UpdateAlarmPanel()
End

function DL_ResetDataLoggerAlarms(ctrlName): ButtonControl
	String ctrlName
	wave chan=root:Packages:RS232Logger:chan
	wave config=root:Packages:RS232Logger:config
		
	variable numChan=max(1, DimSize(Chan, 1))		
	variable ch
	for (ch=0; ch<numChan; ch+=1)
		ValDisplay $("ChannelValue"+num2str(ch)) labelBack=0, win=LogPanel
		chan[%FSHstatus][ch]=-1+(chan[%FSHstatus][ch]>-1)
		chan[%DEVstatus][ch]=-1+(chan[%DEVstatus][ch]>-1)		
	endfor
	DL_UpdateAlarmPanel()
End

function DL_DoneWithAlarmSetupPanel(ctrlName): ButtonControl
	String ctrlName
	DoWindow /K AlarmSetupPanel
end

// alarms can be reset by turning them off and on
Function DL_AlarmCheckProc(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked		
	
	wave config=root:Packages:RS232Logger:config
	wave chan=root:Packages:RS232Logger:chan
	
	// if we're going to set auto activate, config[%AutoActivateAlarms] will be set to StartStatus
	// value = channel# +10 to activate when channel value > set value
 	// value = channel# +20 to activate when channel value <= set value
 	// value =0 for no auto activation
		
	controlinfo /W=AlarmSetupPanel PopChannelToStartAlarms
	variable StartStatus=V_Value-1
	controlinfo /W=AlarmSetupPanel PopStartAlarmsCondition
	StartStatus+=10*V_Value
	
	controlinfo /W=AlarmSetupPanel PopChannelToStopAlarms
	variable StopStatus=V_Value-1
	controlinfo /W=AlarmSetupPanel PopStopAlarmsCondition
	StopStatus+=10*V_Value
	
	variable channel, AlarmsWillBeTripped, numChan	
	numChan=max(1, DimSize(Chan, 1))
	
	strswitch(ctrlName)	
		case "checkSendEmails":		
			config[%SendEmailAlerts]=checked
			return 1					
		case "checkStartCondition":	
			if (checked==0)
				config[%AutoActivateAlarms]=0
			else // we want to set auto activate
				
				// check whether alarms will activate immediately (sets AlarmsWillBeTripped=1) 
				channel=mod(StartStatus, 10)
				AlarmsWillBeTripped=((Chan[%value][channel]>config[%AAAvalue])==(StartStatus<20))
				
				// check whether an alarm will trip immediately
				if (AlarmsWillBeTripped)	
					AlarmsWillBeTripped=0
					for (channel=0; channel<numChan; channel+=1)
						if (Chan[%value][channel]>Chan[%FSHvalue][channel]) // FSH alarm condition
							AlarmsWillBeTripped=1
							break
						endif
						if (abs(Chan[%value][channel]-Chan[%DEVsetpoint][channel])>Chan[%DEVvalue][channel]) 
							AlarmsWillBeTripped=1
							break
						endif							
					endfor
				endif
				
				if (AlarmsWillBeTripped)
					DoAlert 1, "Alarm will trip immediately! Continue?"
					if (V_Flag==2) // No was clicked
						CheckBox checkStartCondition, value=0, win=AlarmSetupPanel
						return 0
					endif
				endif

				config[%AutoActivateAlarms]=StartStatus			
			endif
			return 1
		case "checkEndCondition":	
			if (checked==0)				
				config[%AutoDeactivateAlarms]=0
			else
				config[%AutoDeactivateAlarms]=StopStatus
			endif
			return 1
	endswitch

	// if we get to here we must be turning an alarm on or off
	channel=str2num(ctrlName[strlen(ctrlName)-1])
	
	if (stringmatch(ctrlName, "checkDEV*"))
		if (checked)
			chan[%DEVstatus][channel]=0
		else
			chan[%DEVstatus][channel]=-1
			if (Chan[%FSHstatus][channel]<1) // don't reset indicator if we've tripped FSH
				ValDisplay $("ChannelValue"+num2str(channel)) labelBack=0, win=LogPanel
			endif
		endif
	else // FSH alarm checkbox
		if (checked)
			chan[%FSHstatus][channel]=0
		else
			chan[%FSHstatus][channel]=-1
			ValDisplay $("ChannelValue"+num2str(channel)) labelBack=0, win=LogPanel
		endif		
	endif
End

function DL_SendEmailAlert(ToStr, MsgStr)	
	string ToStr, MsgStr
	string cmd=""

	wave /T configTxt=root:Packages:RS232Logger:configTxt
	string PostiePath=ConfigTxt[%PostiePathStr]
	if (strlen(PostiePath))
		PostiePath=DL_MacPath2WinPath(PostiePath)
	endif
	
	if (strlen(configTxt[%url]))
		MsgStr+="\r"+configTxt[%url]
	endif	
	sprintf cmd ,"\"%spostie.exe\"", PostiePath
	sprintf cmd , "%s -host:%s -to:%s -from:%s ", cmd, ConfigTxt[%emailSMTP], ToStr, ConfigTxt[%emailFrom]
	sprintf cmd, "%s -s:\"%s\" -msg:\"%s\" %s" , cmd, ConfigTxt[%emailSubject], MsgStr, ConfigTxt[%emailFlags]	
	ExecuteScriptText /B cmd
end

function newDL_SendEmailAlert(ToStr, MsgStr)	
	string ToStr, MsgStr
	string cmd=""

	wave /T configTxt=root:Packages:RS232Logger:configTxt
	string PostiePath=ConfigTxt[%PostiePathStr]
	if (strlen(PostiePath))
		PostiePath=DL_MacPath2WinPath(PostiePath)
	endif
	
	if (strlen(configTxt[%url]))
		MsgStr+="\r"+configTxt[%url]
	endif
	
	sprintf cmd ,"\"%svmailer.exe ", PostiePath
	PathInfo LoggerPath
	sprintf cmd ,"%s %sDL_email.txt", cmd, DL_MacPath2WinPath(S_Path)
	
	//  VMAILER.EXE Filename SmtpServer To From User Password
	
	newnotebook /F=0 /N=DL_NB_emailMsg /V=0
	Notebook DL_NB_emailMsg text="Subject: Hello\r\rtest\r"
	SaveNotebook /O/P=LoggerPath/S=6 DL_NB_emailMsg as "DL_email.txt" // save plain text file
	dowindow /k DL_NB_emailMsg
	
	
	// sprintf cmd , "%s -host:%s -to:%s -from:%s ", cmd, ConfigTxt[%emailSMTP], ToStr, ConfigTxt[%emailFrom]
	// sprintf cmd, "%s -s:\"%s\" -msg:\"%s\" %s" , cmd, ConfigTxt[%emailSubject], MsgStr, ConfigTxt[%emailFlags]	
	
	sprintf cmd,"%s %s %s %s", cmd, ConfigTxt[%emailSMTP], ToStr, ConfigTxt[%emailFrom]
	sprintf cmd,"%s %s %s", cmd, ConfigTxt[%user], ConfigTxt[%pswd] // for SSL authentication
	
	sprintf cmd,"%s \"", cmd
	//smtp-server.mn.rr.com
	
	
	print cmd
	//ExecuteScriptText /B cmd
	//ExecuteScriptText  cmd
end


// Functions to deal with alarm conditions
// These functions are called the first time an alarm condition is realised.
// They won't be called gain until the alarm is reset and tripped again.
Function DL_DataLoggerFSHAlarm(channel)
	variable channel
	
	wave chan=root:Packages:RS232Logger:chan
	wave /T chanTxt=root:Packages:RS232Logger:chanTxt
	wave config=root:Packages:RS232Logger:config
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	string msg

	sprintf msg, "ALARM: %s full scale high", ChanTxt[%ChanName][channel]
	DL_PrintToHistory(msg) 	
	if (config[%SendEmailAlerts])
		DL_SendEmailAlert(ConfigTxt[%email], msg)
	endif	
End

Function DL_DataLoggerDevAlarm(channel)
	variable channel
	wave chan=root:Packages:RS232Logger:chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	
	string historyStr
	sprintf historyStr, "ALARM: %s deviation", ChanTxt[%ChanName][channel]	
	DL_PrintToHistory(historyStr) 	
End

// -------------------------------------- Data Logger Channel Setup -------------------------------------- 

Function DL_MakeChannelSetupPanel(ctrlName) : ButtonControl
	string ctrlName
	if (strlen(ctrlName))
		variable /G root:Packages:RS232Logger:DoReset=0// keep track of whether we add or kill any channels
		// DoReset >0 requires rebuilding of LogGraph and LogPanel windows
		// DoReset >99 requires reinitialisation of variables
		DL_SaveLogToFolder("")
	endif
	
	wave chan=root:Packages:RS232Logger:chan
	wave chantxt=root:Packages:RS232Logger:chantxt
	
	// close any windows that will need updating when channel info changes
	doWindow /K AlarmSetupPanel
	doWindow /K DisplayControlPanel
	DoWindow /K ChannelSetupPanel

	variable numChan=max(1, DimSize(Chan, 1))
	
	NewPanel /N=ChannelSetupPanel/k=2 /W=(100,100,620+100*(NumChan>4)*(NumChan-4),550) as "Set up channels"
	variable i
	for (i=0; i<numChan; i+=1)
		DL_MakeChannel(i)
	endfor	
	Button buttonAddChannel, title="Add Channel", pos={400+100*(NumChan>4)*(NumChan-4),20}, win=ChannelSetupPanel
	Button buttonAddChannel, size={90,20}, proc=DL_ChannelSetUpButtonProc, win=ChannelSetupPanel
	Button buttonDoneWithChannel, pos={415+100*(NumChan>4)*(NumChan-4),410}, size={60,30}, win=ChannelSetupPanel
	Button buttonDoneWithChannel, title="Done", proc=DL_ChannelSetUpButtonProc, win=ChannelSetupPanel
	Button buttonLoadChannelSetup, pos={100,20}, size={140,20}, title="Load Channel Setup...", win=ChannelSetupPanel
	Button buttonLoadChannelSetup, proc=DL_LoadChannelSetup, win=ChannelSetupPanel
	Button buttonSaveChannelSetup, pos={250,20}, size={140,20}, title="Save Channel Setup...", win=ChannelSetupPanel
	Button buttonSaveChannelSetup, proc=DL_SaveChannelSetup, win=ChannelSetupPanel
	Button buttonAscii, pos={100,410}, size={140,20}, title="ASCII string builder", win=ChannelSetupPanel
	Button buttonAscii, proc=DL_LaunchASCIIConverter, win=ChannelSetupPanel
	
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,50,"Channel"
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,80,"Axis Label"
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,110,"Query String"
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,140,"Format"	
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,170,"Start/Stop"	
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,200,"Port"
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,230,"Baud Rate"
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,260,"Data Bits"
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,290,"Stop Bits"
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,320,"Parity"	
	SetDrawEnv /W=ChannelSetupPanel fstyle= 1, textyjust= 2; DrawText /W=ChannelSetupPanel 20,350,"User function"
	
	ModifyPanel , fixedSize= 1
	pauseforuser ChannelSetupPanel, AsciiPanel
End


// DL_MakeChannel adds the controls for each channel to ChannelSetupPanel
// called for each channel as ChannelSetupPanel is created
function DL_MakeChannel(ch) 
	variable ch
	
	variable i
	wave chan=root:Packages:RS232Logger:chan
	wave /T chantxt=root:Packages:RS232Logger:chantxt
	
	i=DL_GetIndex(chantxt, "ChanName")
	SetVariable $"setChanName"+Num2Str(ch), pos={100+ch*100,50},size={90,20},title=" ", win=ChannelSetupPanel
	SetVariable $"setChanName"+Num2Str(ch), value=ChanTxt[ch * Dimsize(ChanTxt,0) + i], win=ChannelSetupPanel
	SetVariable $"setChanName"+Num2Str(ch), proc=DL_ChanSetupVarProc, win=ChannelSetupPanel
		
	i=DL_GetIndex(chantxt, "AxisLabel")
	SetVariable $"setAxLabel"+Num2Str(ch), pos={100+ch*100,80},size={90,20},title=" ", win=ChannelSetupPanel
	SetVariable $"setAxLabel"+Num2Str(ch), value=ChanTxt[ch * Dimsize(ChanTxt,0) + i], win=ChannelSetupPanel
	SetVariable $"setAxLabel"+Num2Str(ch), proc=DL_ChanSetupVarProc, win=ChannelSetupPanel
	
	i=DL_GetIndex(chantxt, "Query")
	SetVariable $"setQueryStr"+Num2Str(ch), pos={100+ch*100,110},size={90,20},title=" ", win=ChannelSetupPanel
	SetVariable $"setQueryStr"+Num2Str(ch), value=ChanTxt[ch * Dimsize(ChanTxt,0) + i], win=ChannelSetupPanel
	SetVariable $"setQueryStr"+Num2Str(ch), proc=DL_ChanSetupVarProc	, win=ChannelSetupPanel

	i=DL_GetIndex(chantxt, "FormatStr")
	SetVariable $"setFormatStr"+Num2Str(ch), pos={100+ch*100,140},size={90,20},title=" ", win=ChannelSetupPanel
	SetVariable $"setFormatStr"+Num2Str(ch), value=ChanTxt[ch * Dimsize(ChanTxt,0) + i], win=ChannelSetupPanel
	SetVariable $"setFormatStr"+Num2Str(ch), proc=DL_ChanSetupVarProc, win=ChannelSetupPanel

	i=DL_GetIndex(chantxt, "StartChar")
	SetVariable $"setStartChar"+Num2Str(ch), pos={110+ch*100,170},size={20,20},title=" ", win=ChannelSetupPanel
	SetVariable $"setStartChar"+Num2Str(ch), value=ChanTxt[ch * Dimsize(ChanTxt,0) + i], win=ChannelSetupPanel
	SetVariable $"setStartChar"+Num2Str(ch), proc=DL_ChanSetupVarProc, win=ChannelSetupPanel

	i=DL_GetIndex(chantxt, "Terminator")
	SetVariable $"setTerminator"+Num2Str(ch), pos={160+ch*100,170},size={20,20},title=" ", win=ChannelSetupPanel
	SetVariable $"setTerminator"+Num2Str(ch), value=ChanTxt[ch * Dimsize(ChanTxt,0) + i], win=ChannelSetupPanel
	SetVariable $"setTerminator"+Num2Str(ch), proc=DL_ChanSetupVarProc, win=ChannelSetupPanel
	
	PopupMenu $"popcom"+num2str(ch), pos={115+ch*100,195},size={60,20}, value= "none;"+DL_PortList()
	PopupMenu $"popcom"+num2str(ch), mode=Chan[%com][ch]+1, proc=DL_ChanPopupProc, bodyWidth=60
	PopupMenu $"popbaud"+num2str(ch), pos={115+ch*100,225},size={60,20}, proc=DL_ChanPopupProc
	PopupMenu $"popbaud"+num2str(ch), value= #"\"300;600;1200;2400;4800;9600;19200;38400;57600;115200;256000\""
	variable val=Chan[%baud][ch]
	val=1+(val>300)+(val>600)+(val>1200)+(val>400)+(val>4800)+(val>9600)+(val>19200)+(val>38400)+(val>57600)+(val>115200)
	PopupMenu $"popbaud"+num2str(ch), mode=val, bodyWidth=60
	PopupMenu $"popbaud"+num2str(ch), disable=2*(Chan[%com][ch]==0)
	PopupMenu $"popdata"+num2str(ch), pos={115+ch*100,255},size={60,20}, value= #"\"7;8\"", bodyWidth=60
	PopupMenu $"popdata"+num2str(ch), mode=Chan[%data][ch]-6, proc=DL_ChanPopupProc
	PopupMenu $"popdata"+num2str(ch), disable=2*(Chan[%com][ch]==0)
	PopupMenu $"popstop"+num2str(ch), pos={115+ch*100,285},size={60,20}, value= #"\"1;2\""
	PopupMenu $"popstop"+num2str(ch), mode=Chan[%stop][ch], proc=DL_ChanPopupProc, bodyWidth=60
	PopupMenu $"popstop"+num2str(ch), disable=2*(Chan[%com][ch]==0)
	PopupMenu $"popparity"+num2str(ch), pos={115+ch*100,315},size={60,20}, value= #"\"None;Odd;Even\""
	PopupMenu $"popparity"+num2str(ch), mode=Chan[%parity][ch]+1, proc=DL_ChanPopupProc, bodyWidth=60
	PopupMenu $"popparity"+num2str(ch), disable=2*(Chan[%com][ch]==0)	
	
	val=1+WhichListItem(chantxt[%FuncName][ch], "None;DL_Simulation1;DL_Simulation2;"+FunctionList("*", ";", "KIND:2,NPARAMS:0,Win:Data Logger User Functions.ipf" ) )
	if (val==0)
		chan[%Ufunc][ch]=0
		chantxt[%FuncName][ch]="None"
		val=1
	endif
	PopupMenu $"popufunc"+num2str(ch), mode=val, proc=DL_ChanPopupProc, bodyWidth=60	
	PopupMenu $"popufunc"+num2str(ch), pos={115+ch*100,345},size={60,20}, proc=DL_ChanPopupProc, bodyWidth=60
	PopupMenu $"popufunc"+num2str(ch), value="None;DL_Simulation1;DL_Simulation2;"+FunctionList("*", ";", "KIND:2,NPARAMS:0,Win:Data Logger User Functions.ipf" )
	
	button $"deleteChan"+num2str(ch), pos={115+ch*100,375}, size={60,20}, title="Delete", proc=DL_ChannelSetUpButtonProc	
end

function DL_GetIndex(w, str)
	wave w
	string str
	
	variable i
	for (i=0; i<dimsize(w, 0); i+=1)
		if (stringmatch(GetDimLabel(w, 0, i ), str))
			return i
			break
		endif
	endfor
	return -1
end

Function DL_ChannelSetUpButtonProc(ctrlName) : ButtonControl
	string ctrlName
	
	wave chan=root:Packages:RS232Logger:chan
	wave /T chantxt=root:Packages:RS232Logger:chantxt
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	NVAR DoReset=root:Packages:RS232Logger:DoReset
	variable numChan=max(1,DimSize(Chan, 1))
	strswitch(ctrlName)
		case "buttonAddChannel":	
			if (NumChan==10) // we already have maximum number of channels
				return 0
			endif
			InsertPoints /M=1 numChan, 1, chan //there are numChan channels now
			chan[%com][numChan]=0
			chan[%baud][numChan]=19200
			chan[%stop][numChan]=1
			chan[%data][numChan]=7
			chan[%parity][numChan]=2
			chan[%delta][numChan]=1			
			chan[%axis][numChan]=numChan+1
			DL_CleanUpLogGraphAxes()
			
			InsertPoints /M=1 numChan, 1, chantxt
			
			string NewChannelName="Channel"+num2str(NumChan), channelNameList=""
			variable ch
			for(ch=0;ch<max(1,DimSize(Chan,1)); ch+=1)
				channelNameList+=ChanTxt[%ChanName][ch]+";"
			endfor
			if(FindListItem(NewChannelName, channelNameList)>-1)
				ch=0
				do
					ch+=1
					NewChannelName="Channel"+num2str(ch)			
				while (FindListItem(NewChannelName, channelNameList)>-1)
			endif
			
			chantxt[%AxisLabel][numChan]=NewChannelName+" (?)"
			chantxt[%Query][numChan]=""
			ChanTxt[%ChanName][numChan]=NewChannelName	
			DoReset+=100
			break					
		case "buttonDoneWithChannel":		
			if (DL_CheckChanNames()==0)
				DoAlert 0, "Please enter channel names before saving"
				return 0
			endif
			doWindow /K ChannelSetupPanel
			if (DoReset)
				if (DoReset>=100) // we've changed number of channels or loaded a new setup
					DL_InitialiseDataLogVariables() // reset everything
				endif
				DL_MakeLogPanel()
				DL_MakeLogGraph()
				wave W_Log=root:Packages:RS232Logger:W_Log
				DoWindow /K LogSetupPanel
				DL_MakeLogSetupPanel("")
			endif			
			//always update default channel setup				
			DL_UpdateExternalChanFiles()		
//			Save/O/T/P=LoggerPath/M="\r\n" ChanTxt,Chan as "ChannelSetup.itx"			
			dowindow /F LogSetupPanel
			killvariables DoReset
			return 1
		default:	// delete a channel						
			if (numChan==1)
				return 0
			endif
			variable i=str2num(ctrlName[10])
			DeletePoints /M=1 i,1,chan, chantxt
			DoReset+=100
	endswitch
	DL_MakeChannelSetupPanel("") // rebuild the panel
End

function DL_CleanUpLogGraphAxes()
	// clean up Chan[%axis][] so that there are no gaps in axis #s	
	wave chan=root:Packages:RS232Logger:chan
	variable used	, ax, ch, resetAx=1
	
	// make sure at least one channel is to be plotted
	for(ch=0;ch<max(DimSize(Chan, 1), 1);ch+=1)
		if (chan[%axis][ch])					
			resetAx=0
			break
		endif
	endfor
	if (resetAx) // no channels chosen to be plotted
		Chan[%axis][]=q+1 // plot 'em all
	endif
	
	// make sure there's no gaps in axis #s	
	for(ax=1;ax<11; ax+=1)
		 used=0
		 for(ch=0;ch<max(1,DimSize(Chan,1)); ch+=1)
		 	if (Chan[%axis][ch]==ax)
		 		used=1
		 		break
		 	endif
		 endfor
		 if(used==0)
		 	for(ch=0;ch<max(1,DimSize(Chan,1)); ch+=1)
		 		if(Chan[%axis][ch]>ax)
		 			Chan[%axis][ch]-=1
		 		endif
		 	endfor
		 endif
	endfor
end

Function DL_ChanPopupProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	wave /T chantxt=root:Packages:RS232Logger:chantxt
	variable val, i
	i=str2num(ctrlName[strlen(ctrlName)-1])
	ctrlName=ctrlName[3,strlen(ctrlName)-2]	
	strswitch(ctrlName)
		case "com":
			val=popNum-1
			PopupMenu $"popbaud"+num2str(i), disable=2*(val==0), win=ChannelSetupPanel
			PopupMenu $"popdata"+num2str(i), disable=2*(val==0), win=ChannelSetupPanel
			PopupMenu $"popstop"+num2str(i), disable=2*(val==0), win=ChannelSetupPanel
			PopupMenu $"popparity"+num2str(i), disable=2*(val==0), win=ChannelSetupPanel
			ChanTxt[%portname][i]=stringfromlist(val-1,  DL_PortList())	
			break
		case "parity":
			val=popNum-1
			break
		case "ufunc":
			val=(popNum>1)
			chantxt[%FuncName][i]=popStr
			break			
		default:							
			val=str2num(popStr)				
	endswitch
	string cmd
	sprintf cmd "root:Packages:RS232Logger:chan[%%%s][%d]=%d", ctrlName, i, val
	execute cmd
	
End

Function DL_ChanSetupVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName, VarStr, varName; Variable varNum
	
	wave /T chantxt=root:Packages:RS232Logger:chantxt
	NVAR DoReset=root:Packages:RS232Logger:DoReset
			
	if (stringmatch(ctrlName, "setChanName*"))
		variable ch=str2num(ctrlName[strlen(ctrlName)-1])
		varStr=cleanupname(varStr,0) // tidy up the name
		// check for unique channel name
		//string channelNameList=""
		variable i, badname=0
		for(i=0;i<max(1,DimSize(chantxt,1)); i+=1)
			if (stringmatch(ChanTxt[%ChanName][i], varStr)&&i!=ch)
				beep; doAlert 0, "Channel names must be unique"
				badname=1
				break
			endif
		endfor
		if (badname)
			ChanTxt[%ChanName][ch]=""
		else
			ChanTxt[%ChanName][ch]=VarStr
		endif
	endif

	DoReset+=1
End

function DL_LoadChannelSetup(ctrlName) : ButtonControl
	string ctrlName
	
	String savDF= GetDataFolder(1)
	NewDataFolder /O/S root:Packages:RS232Logger:temp
	LoadWave /T/O/P=LoggerPath
	if (V_flag==0) // cancel
		SetDataFolder savDF
		KillDataFolder root:Packages:RS232Logger:temp:
		return 0
	endif
	if (stringmatch(S_waveNames, "ChanTxt;Chan;"))
		Duplicate /O ChanTxt root:Packages:RS232Logger:ChanTxt
		Duplicate /O Chan root:Packages:RS232Logger:Chan
	else
		DoAlert 0, S_fileName+" is not a channel setup."
	endif	
	SetDataFolder savDF
	KillDataFolder root:Packages:RS232Logger:temp:
	NVAR DoReset=root:Packages:RS232Logger:DoReset
	DoReset=100
	DL_MakeChannelSetupPanel("") // resets channel setup panel	
end

function DL_SaveChannelSetup(ctrlName) : ButtonControl
	string ctrlName
	wave Chan=root:Packages:RS232Logger:Chan
	wave/T ChanTxt=root:Packages:RS232Logger:ChanTxt
	if (DL_CheckChanNames())
		Save /T/M="\r\n"/P=LoggerPath ChanTxt,Chan as "NewChannelSetup.itx"
	else
		DoAlert 0, "Please enter channel names before saving"
	endif
end

function DL_CheckChanNames()
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	variable ch, i
	for(ch=0;ch<max(1,DimSize(chantxt,1)); ch+=1)
		if (stringmatch(ChanTxt[%ChanName][ch], ""))
			return 0
		endif
//		for (i=max(1,DimSize(chantxt,1)); i>ch; i-=1)
//			if(stringmatch(ChanTxt[%ChanName][ch], ChanTxt[%ChanName][i]))
//				return -1
//			endif
//		endfor
	endfor
	return 1
end

// wrapper function for button control
function DL_LaunchASCIIConverter(ctrlName)
	string ctrlName
	DL_ASCIIconverter()
end

function DL_ASCIIconverter()
	doWindow /K AsciiPanel
	
	String savDF= GetDataFolder(1)		// Save current DF for restore.
	NewDataFolder/O/S root:Packages		// Make sure this exists.
	NewDataFolder/O/S ASCII	// Our stuff goes in here.	
	make /O /n=20 DecWave=nan
	make /O/T /n=20 CharWave=""
	string /G CtrlStr=""
	variable i
	NewPanel /N=AsciiPanel/K=1 /W=(130,50,820,173) as "ASCII Converter"
	SetDrawLayer UserBack
	SetDrawEnv /W=AsciiPanel  textyjust= 2; DrawText 5,20,"ASCII Code"
	SetDrawEnv /W=AsciiPanel textyjust= 2; DrawText 5,45,"Character"
	string cmd
	for (i=0; i<20; i+=1)
		sprintf cmd, "SetVariable setvarDec%d,pos={%d,20},size={20,16},value=DecWave[%d], bodywidth=25, limits={0,255,0 }, title=\" \", proc=DL_ConvertAscii, win=AsciiPanel", i, 80+30*i , i
		execute cmd
		sprintf cmd, "SetVariable setvarCha%d,pos={%d,45},size={20,16},value=CharWave[%d], bodywidth=15, title=\" \", proc=DL_ConvertAscii, win=AsciiPanel", i, 75+30*i , i
		execute cmd
	endfor
	Button buttonCopyStr,pos={10,95},size={70,20},proc=DL_CopyStr,title="Copy String", win=AsciiPanel
	ModifyPanel /W=AsciiPanel , fixedSize= 1
	setwindow AsciiPanel, hook=DL_ASCIIhook
	setDataFolder savDF
End

Function DL_ConvertAscii(ctrlName,varNum,varStr,varName) 
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	wave DecWave=root:Packages:ASCII:DecWave
	wave /T CharWave=root:Packages:ASCII:CharWave
	variable i=str2num(ctrlName[9,10])
	if (stringmatch(ctrlName, "setvarDec*"))
		CharWave[i]=num2char(varNum)
	else
		CharWave[i]=varStr[0,0]
		DecWave[i]=char2num(CharWave[i])
	endif
End

Function DL_CopyStr(ctrlName) 
	String ctrlName
	wave /T CharWave=root:Packages:ASCII:CharWave
	string str=""
	variable i=0
	do
		str[i,i]=CharWave[i]
		i+=1
	while(strlen(CharWave[i]))
	PutScrapText str
	doalert 0, "Copied string '"+str+"' to clipboard"
End

Function DL_ASCIIhook(infoStr)
	String infoStr

	String event= StringByKey("EVENT",infoStr)
	strSwitch (event)
		case "kill":
			dowindow /k AsciiPanel
			killdatafolder "root:Packages:ASCII:"
			return 1
	endswitch
	return 0	// 0 if nothing done, else 1 or 2
End

// -------------------------------------- Data Logger Display Controls -------------------------------------- 

function DL_MakeDisplayControlPanel(ctrlName) : ButtonControl
	String ctrlName
	
	dowindow LogGraph
	if (V_Flag==0) // should never get here
		DL_MakeLogGraph()
		print "Error at MakeDisplayPanel()"
		return 0
	endif
	
	wave chan=root:Packages:RS232Logger:chan
	wave /T chanTxt=root:Packages:RS232Logger:chanTxt
	string ListOfAxes=AxisList("LogGraph")
	ListOfAxes=RemoveFromList("bottom", ListOfAxes) 
	variable numAx=ItemsInList(ListOfAxes)
	variable ch
	
	doWindow DisplayControlPanel
	if (V_flag)
		doWindow /K DisplayControlPanel
	endif
	
	getwindow LogGraph, wsize
	NewPanel /N=DisplayControlPanel/k=1 /W=(V_right+200,V_top,V_right+424,V_top+240+25*numAx) as "Display Controls"	
	
	groupbox VertScaleBox, pos={10,10}, size={205, 50+25*NumAx}, title="Vertical scale controls", win=DisplayControlPanel
	SetDrawEnv /W=DisplayControlPanel textrot=90; DrawText /W=DisplayControlPanel 143,50,"Full"
	SetDrawEnv /W=DisplayControlPanel textrot=90; DrawText /W=DisplayControlPanel 168,50,"Win"
	SetDrawEnv /W=DisplayControlPanel textrot=90; DrawText /W=DisplayControlPanel 193,50,"Man"
	string ChanName
	variable ax=NumAx
	variable i
	do
		for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
			if(Chan[%axis][ch]==ax)
				ChanName=ChanTxt[%ChanName][ch]
				// check whether any more channels plotted on this axis
				for (i=ch+1; i<max(1,DimSize(Chan,1)); i+=1)
					if (Chan[%axis][i]==ax)
						ChanName+=" +" // append a + to the channel name
						break
					endif
				endfor				
				SetDrawEnv /W=DisplayControlPanel textyjust= 2; DrawText /W=DisplayControlPanel 20,55+25*(numAx-ax),ChanName[0,min(20,strlen(ChanName)-1)]
				CheckBox $"cboxFullScale"+num2str(ax) mode=1, pos={145,55+25*(NumAx-ax) }, proc=DL_ChannelScaleProc, title="", win=DisplayControlPanel
				CheckBox $"cboxWinScale"+num2str(ax) mode=1, pos={170,55+25*(NumAx-ax) }, proc=DL_ChannelScaleProc, title="", win=DisplayControlPanel
				CheckBox $"cboxManScale"+num2str(ax) mode=1, pos={195,55+25*(NumAx-ax) }, proc=DL_ChannelScaleProc, title="", win=DisplayControlPanel
				
				variable val=(strlen(StringByKey("SETAXISFLAGS" ,AxisInfo("LogGraph", "Axis"+num2str(ax) )))>0)
				CheckBox $"cboxFullScale"+num2str(ax) value=(val), win=DisplayControlPanel
				CheckBox $"cboxWinScale"+num2str(ax) value=(!(val)  && Chan[%AxMax][ch]==-1 && Chan[%AxMin][ch]==-1 ), win=DisplayControlPanel
				CheckBox $"cboxManScale"+num2str(ax) value=(!(val)  && Chan[%AxMax][ch]>Chan[%AxMin][ch]), win=DisplayControlPanel
				break // use the first channel on axis as label
			endif
		endfor
		ax-=1
	while(ax>0)
	groupbox HorizScaleBox, pos={22, 80+25*NumAx}, size={180, 115}, title="Horizontal scale controls", win=DisplayControlPanel
	Button PanLeft,pos={32,135+25*NumAx},size={30,20},title="<<", proc=DL_ZoomButtonProc, win=DisplayControlPanel
	Button PanLeft help={"Pan Left"}, win=DisplayControlPanel
	Button PanRight,pos={102,135+25*NumAx},size={30,20},title=">>", proc=DL_ZoomButtonProc, win=DisplayControlPanel
	Button PanRight help={"Pan Right"}, win=DisplayControlPanel
	Button Stretch ,pos={67,110+25*NumAx},size={30,20},title="<->", proc=DL_ZoomButtonProc, win=DisplayControlPanel
	Button Stretch help={"Zoom Out"}, win=DisplayControlPanel
	Button Shrink,pos={67,160+25*NumAx},size={30,20},title="-><-", proc=DL_ZoomButtonProc, win=DisplayControlPanel
	Button Shrink help={"Zoom In"}, win=DisplayControlPanel
	Button AutoScale,pos={67,135+25*NumAx},size={30,20},title="<A>", proc=DL_ZoomButtonProc, win=DisplayControlPanel
	Button AutoScale help={"Auto Scale"}, win=DisplayControlPanel
	Button Track, pos={157,135+25*NumAx},size={30,20},title=">T>", proc=DL_ZoomButtonProc, win=DisplayControlPanel
	Button Track help={"Track Data"}, win=DisplayControlPanel
	
	Button buttonSetupGraph, pos={10, 205+25*NumAx}, size={50,20}, title="Setup...", proc=DL_MakeGraphSetUpPanel, win=DisplayControlPanel
	Button buttonDone, pos={175, 205+25*NumAx}, size={40,20}, title="Done", proc=DL_DoneWithDisplayControlPanel, win=DisplayControlPanel
	
	SetWindow DisplayControlPanel, hook=DL_UpdateDisplayControlPanel
	ModifyPanel, fixedSize= 1
end

Function DL_DoneWithDisplayControlPanel(ctrlName) : ButtonControl
	String ctrlName
	doWindow /K DisplayControlPanel
end

Function DL_UpdateDisplayControlPanel(infoStr)
	String infoStr
	
	wave chan=root:Packages:RS232Logger:chan
	doWindow DisplayControlPanel
	if (V_Flag==0)
		return 0
	endif
	doWindow LogGraph // in case we're rebuilding LogGraph as hook function is run
	if (V_Flag==0)
		return 0
	endif
	
	string ListOfAxes=AxisList("LogGraph")
	variable numAx=ItemsInList(ListOfAxes)-1 // don't count bottom axis
	variable val, ax, ch
	for(ax=1; ax<NumAx+1; ax+=1)		
		// find out which channel is plotted on this axis
		for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
			if(Chan[%axis][ch]==ax)
				break
			endif
		endfor
		val=(strlen(StringByKey("SETAXISFLAGS" ,AxisInfo("LogGraph", "Axis"+num2str(ax) )))>0)
		CheckBox $"cboxFullScale"+num2str(ax) value=val, win=DisplayControlPanel 
		CheckBox $"cboxWinScale"+num2str(ax) value=(!(val)  && Chan[%AxMax][ch]==-1 && Chan[%AxMin][ch]==-1 ), win=DisplayControlPanel
		CheckBox $"cboxManScale"+num2str(ax) value=(!(val)  && Chan[%AxMax][ch]>Chan[%AxMin][ch]), win=DisplayControlPanel		
	endfor
End

Function DL_ChannelScaleProc(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	wave chan=root:Packages:RS232Logger:chan
	variable ax=str2num(ctrlName[strlen(ctrlName)-1])
	ax+=10*(ax==0) // for axis 10
	variable ch
	
	variable axmax=ax, axmin=ax
	if (GetKeyState(0)&4) // shift key
		axmin=1
		string ListOfAxes=AxisList("LogGraph")
		axmax=ItemsInList(ListOfAxes)-1 // don't count bottom axis
	endif
	
	for (ax=axmin; ax<axmax+1; ax+=1)
		if (stringmatch(ctrlName[4], "F")) // fullscale - use normal autoscaling for axis
			SetAxis /W=LogGraph /A /Z $"Axis"+num2str(ax)
			CheckBox $"cboxManScale"+num2str(ax) value=0, win=DisplayControlPanel
			CheckBox $"cboxWinScale"+num2str(ax) value=0, win=DisplayControlPanel
			CheckBox $"cboxFullScale"+num2str(ax) value=1, win=DisplayControlPanel
		else // Win or Man scaling
			DL_WinScaleAxis(ax)	
			CheckBox $"cboxFullScale"+num2str(ax) value=0, win=DisplayControlPanel
			if (stringmatch(ctrlName[4], "W")) // Win scaling
				CheckBox $"cboxManScale"+num2str(ax) value=0, win=DisplayControlPanel
				CheckBox $"cboxWinScale"+num2str(ax) value=1, win=DisplayControlPanel
				for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
					if(Chan[%axis][ch]==ax) // for each wave on Axis ax
						Chan[%AxMin][ch]=-1
						Chan[%AxMax][ch]=-1
					endif
				endfor				
			else // Man scaling
				CheckBox $"cboxWinScale"+num2str(ax) value=0, win=DisplayControlPanel
				CheckBox $"cboxManScale"+num2str(ax) value=1, win=DisplayControlPanel
				GetAxis /W=LogGraph/Q $"Axis"+num2str(ax)
				for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
					if(Chan[%axis][ch]==ax) // for each wave on Axis ax
						Chan[%AxMin][ch]=V_min
						Chan[%AxMax][ch]=V_max
					endif
				endfor
			endif
		endif
	endfor
		
End

Function DL_WinScaleAxis(ax)
	variable ax
	
	wave config=root:Packages:RS232Logger:config
	wave chan=root:Packages:RS232Logger:chan
	wave W_time=root:Packages:RS232Logger:W_time
	wave W_Log=root:Packages:RS232Logger:W_Log
	
	variable setLow=inf, setHigh=-inf
	variable low, high // find point locations of horizontal axis limits
	GetAxis /W=LogGraph /Q Bottom
	variable left=V_min
	variable right=V_max
	low=max(0,BinarySearch(W_time, left )); high=BinarySearch(W_time, right )
	if (high<1)
		high=numpnts(W_time)
	endif
	
	variable ch, expand=0
	
	for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
		
		if(Chan[%axis][ch]==ax) // for each wave on Axis ax
			wave displayWave=$"root:Packages:RS232Logger:W_display"+num2str(ch)
			wave channelWave=$"root:Packages:RS232Logger:channel"+num2str(ch)
			V_Min=-inf; V_Max=inf
			if (W_Log[%j])
				wavestats /Q displayWave
			endif
			if (numtype(V_Min)==0)
				setLow=min(setLow, V_Min)
			else
				expand=-1
			endif
			if (numtype(V_Max)==0)
				setHigh=max(setHigh, V_Max)
			else
				expand=-1
			endif
		
			if(W_Log[%i]) // don't try to call wavestats on empty waves
				wavestats /Q/R=[low, high] channelWave
			endif
			if (numtype(V_Min)==0)
				setLow=min(setLow, V_Min)
			else
				expand=-1
			endif
			if (numtype(V_Max)==0)
				setHigh=max(setHigh, V_Max)
			else
				expand=-1
			endif
			
			if (numtype(setLow)==1 && numtype(setHigh)==1)
				if (numtype(chan[%value][ch])==0)
					setLow=chan[%value][ch]-5*chan[%delta][ch]
				else
					setLow=0
				endif
			endif
				
			if (numtype(setLow)==1) // +/-inf
				if ( setHigh>0 )
					setLow=0
				else
					setLow=setHigh-10*chan[%delta][ch]
				endif
			endif
			if (numtype(setHigh)==1) // +inf
				setHigh=setLow+10*chan[%delta][ch]
			endif
			
			
			if ((setHigh-setLow)<10*chan[%delta][ch]) // range is small relative to channel threshold
				if (0<=setLow && setHigh<10*chan[%delta][ch]) // we're probably sitting close to zero
					setLow=0
					setHigh=10*chan[%delta][ch]
				else	// expand the range a little
					setLow-=5*chan[%delta][ch]
					setHigh+=5*chan[%delta][ch]
				endif
			else
				expand+=1						
			endif
		endif
	endfor
	
	if (expand>0)
		expand=5*config[%UpdateInterval]*60/(right-left)*(setHigh-setLow)
		setLow-=expand
		setHigh+=expand	
	endif
		
	SetAxis /W=LogGraph $"Axis"+num2str(ax), setLow, setHigh
	return 1	
end

Function DL_SummaryWinScaleAxis(ax)
	variable ax
	
	wave config=root:Packages:RS232Logger:config
	wave chan=root:Packages:RS232Logger:chan
	wave W_time=root:Packages:RS232Logger:W_time
	wave W_Log=root:Packages:RS232Logger:W_Log
	
	variable setLow=inf, setHigh=-inf
	variable low, high // find point locations of horizontal axis limits
	GetAxis /W=LogGraph /Q Bottom
	variable left=V_min
	variable right=V_max
	low=max(0,BinarySearch(W_time, left )); high=BinarySearch(W_time, right )
	if (high<1)
		high=numpnts(W_time)
	endif
	
	variable ch, expand=0
	
	for(ch=0; ch<max(1,DimSize(Chan,1)); ch+=1)
		
		if(Chan[%axis][ch]==ax) // for each wave on Axis ax
			wave displayWave=$"root:Packages:RS232Logger:W_display"+num2str(ch)
			wave channelWave=$"root:Packages:RS232Logger:channel"+num2str(ch)
			V_Min=-inf; V_Max=inf
			if (W_Log[%j])
				wavestats /Q displayWave
			endif
			if (numtype(V_Min)==0)
				setLow=min(setLow, V_Min)
			else
				expand=-1
			endif
			if (numtype(V_Max)==0)
				setHigh=max(setHigh, V_Max)
			else
				expand=-1
			endif
		
			if(W_Log[%i]) // don't try to call wavestats on empty waves
				wavestats /Q/R=[low, high] channelWave
			endif
			if (numtype(V_Min)==0)
				setLow=min(setLow, V_Min)
			else
				expand=-1
			endif
			if (numtype(V_Max)==0)
				setHigh=max(setHigh, V_Max)
			else
				expand=-1
			endif
			
			if (numtype(setLow)==1 && numtype(setHigh)==1)
				if (numtype(chan[%value][ch])==0)
					setLow=chan[%value][ch]-5*chan[%delta][ch]
				else
					setLow=0
				endif
			endif
				
			if (numtype(setLow)==1) // +/-inf
				if ( setHigh>0 )
					setLow=0
				else
					setLow=setHigh-10*chan[%delta][ch]
				endif
			endif
			if (numtype(setHigh)==1) // +inf
				setHigh=setLow+10*chan[%delta][ch]
			endif
			
			
			if ((setHigh-setLow)<10*chan[%delta][ch]) // range is small relative to channel threshold
				if (0<=setLow && setHigh<10*chan[%delta][ch]) // we're probably sitting close to zero
					setLow=0
					setHigh=10*chan[%delta][ch]
				else	// expand the range a little
					setLow-=5*chan[%delta][ch]
					setHigh+=5*chan[%delta][ch]
				endif
			else
				expand+=1						
			endif
		endif
	endfor
	
	if (expand>0)
		SetAxis /A /W=LogGraph $"Axis"+num2str(ax)
	else
		SetAxis /W=LogGraph $"Axis"+num2str(ax), setLow, setHigh
	endif	
	return 1	
end

Function DL_ZoomButtonProc(ctrlName) : ButtonControl
	String ctrlName
	variable pc=20 // percentage of range to shrink/expand
	
	wave W_display_time=root:Packages:RS232Logger:W_display_time
	wave W_time=root:Packages:RS232Logger:W_time
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave config=root:Packages:RS232Logger:config
	
	if (strlen(WinList("LogGraph",",","WIN:1"))==0)	//	LogGraph doesn't exist
		return 0
	elseif (!(numpnts(W_display_time)||numpnts(W_time))) // both are empty
		return 0
	endif	
	
	if (numpnts(W_display_time)) // normal situation when log is active
		wave timewave=root:Packages:RS232Logger:W_display_time
	else	// display waves may have been cleared
		wave timewave=root:Packages:RS232Logger:W_time
	endif
	
	GetAxis /Q/W=LogGraph bottom
	variable range=V_max-V_min
	config[%update]=0 // turn off tracking
	strswitch(ctrlName)	// string switch
		case "PanLeft":		
			V_min=max( (V_min-range), W_time[0])
			V_max=V_min+range
			break
		case "PanRight":		
			V_max=min( (V_max+range), timewave[inf])
			V_min=V_max-range
			break
		case "Stretch":		
			V_max=min( (V_max + pc/200*range), timewave[inf])
			V_min=max(V_min-pc/200*range, W_time[0])
			if ( (V_max-V_min) < ((100+pc)/100*range) ) //didn't expand fully
				// repeat expand 
				// if one end of axis is at its limit the other can expand further
				V_max=min( (V_min + range + pc/100*range), timewave[inf])
				V_min=max( (V_max - range - pc/100*range), W_time[0])
			endif
			break
		case "Shrink":
			V_max=V_max-(range-100/(100+pc)*range)/2
			V_min=V_min+(range-100/(100+pc)*range)/2
			break
		case "AutoScale":
			SetAxis 	/W=LogGraph /A bottom
			BuildMenu "Logger"
			return 1	
		case "Track":	// not valid if log is finished
			V_max=W_log[%xRight]
			V_min=timewave[0]// if display waves are cleared, show full log
			config[%update]=1 // turn tracking on			
	endswitch
	SetAxis /W=LogGraph bottom V_min, V_max
	BuildMenu "Logger"
 	return 1	
End

Function DL_MakeGraphSetUpPanel(ctrlName) : ButtonControl
	string ctrlName
		
	doWindow GraphSetUpPanel
	if (V_Flag)
		dowindow /F GraphSetUpPanel
	else
		NewPanel /N=GraphSetUpPanel /K=1/W=(600,115.25,900,346.25) as "Change Display"
	endif
	
	Button buttonAdd,pos={210,65},size={60,20},title="Add", proc=DL_AddRemoveDisplayChannel, win=GraphSetUpPanel
	Button buttonRemove,pos={210,150},size={60,20},title="Remove", proc=DL_AddRemoveDisplayChannel, win=GraphSetUpPanel	
	Button buttonDoneWithPanel, pos={210,200},size={60,20},title="Done", proc=DL_AddRemoveDisplayChannel, win=GraphSetUpPanel
	GroupBox AddBox frame=1, pos={10,10}, size={280,90}, title="Add channel to display", win=GraphSetUpPanel
	GroupBox RemoveBox frame=1, pos={10,120}, size={280,65}, title="Remove channel from display", win=GraphSetUpPanel
	
	ModifyPanel /W=GraphSetUpPanel, fixedSize= 1
	DL_UpdateGraphSetUpPanel()
	
	setwindow GraphSetUpPanel hook=DL_hookGraphSetupPanel
//	PauseForUser GraphSetUpPanel, GraphSetUpPanel
//	DL_UpdateExternalChanFiles()
End

function DL_HookGraphSetupPanel(infoStr)
	String infoStr

	String event= StringByKey("EVENT",infoStr)
	if (stringmatch (event, "activate") )	
		DL_UpdateGraphSetUpPanel()
		return 1
	endif
	return 0				// 0 if nothing done, else 1 or 2
End

function DL_UpdateGraphSetUpPanel()
	wave Chan=root:Packages:RS232Logger:chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
		
	string ListOfChannelsNotDisplayed=""
	variable i
	for(i=0;i<max(1,DimSize(Chan,1)); i+=1)
		if(Chan[%axis][i]==0)
			ListOfChannelsNotDisplayed+=ChanTxt[%ChanName][i]+";"
		endif
	endfor
	
	string ListOfAxes=AxisList("LogGraph")
	ListOfAxes=RemoveFromList("bottom", ListOfAxes) 
	if (ItemsInList(ListOfAxes)<10)
		ListOfAxes+="new"
	endif
	
	string ListOfDisplayedWaves= TraceNameList("LogGraph", ";", 1 )
	string ListOfDisplayedChannels=""
	i=0
	do
		if (StringMatch(StringFromList(i, ListOfDisplayedWaves),"channel*"))
			ListOfDisplayedChannels+=ChanTxt[%ChanName][str2num(StringFromList(i, ListOfDisplayedWaves)[7])]+";"			
		endif
		i+=1
	while (i<ItemsInList(ListOfDisplayedWaves))
	
	if (!itemsinlist(ListOfChannelsNotDisplayed))
		ListOfChannelsNotDisplayed="No More Channels"		
	endif
	
	PopupMenu popAddChan,pos={40,35},size={150,21},title="", mode=1, win=GraphSetUpPanel	
	execute "PopupMenu popAddChan, win=GraphSetUpPanel,value=#\"\\\""+ListOfChannelsNotDisplayed+"\\\"\""
	PopupMenu popAxis,pos={40,65},size={80,21},title="Axis:",mode=ItemsInList(ListOfAxes), win=GraphSetUpPanel
	execute "PopupMenu popAxis, win=GraphSetUpPanel,value= #\"\\\""+ListOfAxes+"\\\"\""
	PopupMenu popRemoveChannel,pos={40,150},size={150,21},title="",mode=ItemsInList(ListOfDisplayedChannels), win=GraphSetUpPanel
	execute "PopupMenu popRemoveChannel, win=GraphSetUpPanel,value= #\"\\\""+ListOfDisplayedChannels+"\\\"\""
	if (itemsinlist(ListOfDisplayedChannels)>1)
		Button buttonRemove, disable=0, win=GraphSetUpPanel
	else	
		Button buttonRemove, disable=2, win=GraphSetUpPanel
	endif	
end


Function DL_AddRemoveDisplayChannel(ctrlName) : ButtonControl
	String ctrlName
		
	if (stringmatch("buttonDoneWithPanel", ctrlName)) // quit
		doWindow /K GraphSetUpPanel
		return 0
	endif
	
	wave chan=root:Packages:RS232Logger:chan
	wave /T chanTxt=root:Packages:RS232Logger:chanTxt
	variable ch, ax	
	if (stringmatch("buttonAdd", ctrlName)) // we want to add to display
		ControlInfo /W=GraphSetUpPanel popAddChan		
		for(ch=0;ch<max(1,DimSize(Chan,1)); ch+=1)
			if (stringmatch(ChanTxt[%ChanName][ch], S_Value))
				ControlInfo /W=GraphSetUpPanel popAxis				
				Chan[%Axis][ch]=V_Value
				break
			endif
		endfor
	else // we want to remove channel from display
		ControlInfo /W=GraphSetUpPanel popRemoveChannel
		for(ch=0;ch<max(1,DimSize(Chan,1)); ch+=1)
			if (stringmatch(ChanTxt[%ChanName][ch], S_Value))
				variable oldAxis=Chan[%Axis][ch]
				Chan[%Axis][ch]=0
				break
			endif
		endfor
	endif
	
	// clean up Chan[%axis][] so that axis #s are consecutive
	DL_CleanUpLogGraphAxes()
	DL_MakeLogGraph()
	DL_MakeDisplayControlPanel("")	
	DL_MakeGraphSetUpPanel("")
	
	//always update default channel setup
	DL_UpdateExternalChanFiles()
	
End

// -------------------------------------- Data Logger Edit Log -------------------------------------- 

function DL_MakeEditLogPanel()
	if (DL_LogStatus()==1) // log is active
		DoAlert 0, "Cannot edit log while it's active"
		return 0
	endif
	DL_SaveLogToFolder("")
	DL_ClearDisplayWaves()
	variable ch=0	
	doWindow  EditLogPanel
	if (V_FLag)
		dowindow /F EditLogPanel
	else
		NewPanel /N=EditLogPanel/K=1/W=(830,58.25,1020,270.25) as "Edit Log"
	endif
	
	PopupMenu popupMoveCsrs,pos={22,12},size={153,21},title="Cursors:", win=EditLogPanel
	PopupMenu popupMoveCsrs,proc=DL_MoveCsrsToChannel, win=EditLogPanel
	DL_UpdateEditLogPanel()
		
	Button buttonClearData,pos={30,50},size={75,20},title="Clear Data", proc=DL_ClearBetweenCursors, win=EditLogPanel
	Button buttonTruncateChannels,pos={30,85},size={130,20},title="Truncate Channels...", proc=DL_TruncateChannels, win=EditLogPanel
	Button buttonTimeAv,pos={30,120},size={130,20},title="Time Average...", proc=DL_timeAverage, win=EditLogPanel
	Button buttonDone,pos={120,155},size={40,20},title="Done", proc=DL_DoneWithEditLogPanel, win=EditLogPanel
	Button buttonUndo,pos={120,50},size={40,20},title="Undo", disable=2, proc=DL_UndoClearBetweenCursors, win=EditLogPanel
	Button buttonprint,pos={30,155},size={70,20},proc=DL_MakePrintableLog,title="Printable...", win=EditLogPanel
	DL_UpdateCursors()
	setwindow  EditLogPanel, hook=DL_HookEditLogPanel
end

function DL_ClearDisplayWaves()
	wave Chan=root:Packages:RS232Logger:Chan
	wave W_Log=root:Packages:RS232Logger:W_Log
	variable ch
	for (ch=0;ch<max(1, DimSize(Chan, 1));ch+=1)
		wave ToClear=$"root:Packages:RS232Logger:W_display"+num2str(ch)
		redimension /N=0 ToClear
	endfor
	wave W_display_time=root:Packages:RS232Logger:W_display_time
	redimension /N=0 W_display_time
	W_Log[%j]=0
end

function DL_HookEditLogPanel(infoStr)
	String infoStr

	String event= StringByKey("EVENT",infoStr)
	if (stringmatch(event, "activate"))
		DL_UpdateEditLogPanel()	
		return 1
	endif
	if (stringmatch(event, "kill"))
		DL_DoneWithEditLogPanel("")	
		return 1
	endif	
	
	return 0
End

Function DL_MoveCsrsToChannel(ctrlName,popNum,popStr)
	String ctrlName
	Variable popNum
	String popStr
	
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	
	showinfo /W=LogGraph // just in case
	variable i=0
	do
		if (StringMatch(ChanTxt[%ChanName][i], popStr))
			break
		endif
		i+=1
	while (i<DimSize(Chan, 1))
	string StrCh="channel"+num2str(i)
	variable startP=0, endP=numpnts($"root:Packages:RS232Logger:"+StrCh)-1
	
	if (strlen(CsrWave(A, "LogGraph"))) // cursor is already on graph
		startP=pcsr(A, "LogGraph")
	endif
	if (strlen(CsrWave(B, "LogGraph"))) // cursor is already on graph
		endP=pcsr(B, "LogGraph")
	endif
	
	Cursor /P/W=LogGraph B, $StrCh, endP
	Cursor /P/W=LogGraph A, $StrCh , startP
End

function DL_CheckLogGraphCursors() 
	if (cmpstr(CsrWave(A, "LogGraph"), CsrWave(B, "LogGraph")))
		doAlert 0, "Cursors not on the same wave!"
		return 0 // cursors on different waves
	endif
	if (stringmatch(CsrWave(A, "LogGraph"), "channel*"))
		if (pcsr(A, "LogGraph")>pcsr(B, "LogGraph")) // swap cursors
			variable V_swap=pcsr(B, "LogGraph")
			wave c=CsrWaveRef(A, "LogGraph")
			
			Cursor /P/W=LogGraph B, $CsrWave(A, "LogGraph"), pcsr(A, "LogGraph")
			Cursor /P/W=LogGraph A, $CsrWave(A, "LogGraph") , V_swap
		endif
		return 1
	else
		doAlert 0, "Cursors not on a channel!"
		return 0 // cursors not on a channel wave
	endif
end

function DL_UpdateEditLogPanel()
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	string cmd, ListOfDisplayedChannels=""
	variable ch		
	for (ch=0;ch<max(1, DimSize(Chan, 1));ch+=1)
		if (Chan[%axis][ch])
			ListOfDisplayedChannels+=ChanTxt[%ChanName][ch]+";"
		endif
	endfor
	sprintf cmd, "PopupMenu popupMoveCsrs, win=EditLogPanel, Value=\"%s\"", ListOfDisplayedChannels
	execute cmd
	ch=DL_UpdateCursors() // makes sure cursors are on a channel
	PopupMenu popupMoveCsrs, win=EditLogPanel, mode=WhichListItem(ChanTxt[%ChanName][ch], ListOfDisplayedChannels)+1
end

// ensures that both cursors are on the same channel; returns channel #
function DL_UpdateCursors()

	ShowInfo /W=LogGraph	
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt	
	variable ch
	if (stringmatch(CsrWave(A, "LogGraph"), "Channel*") && stringmatch( CsrWave(A, "LogGraph"), CsrWave(B, "LogGraph") ))
		for (ch=0; ch<max(1, DimSize(ChanTxt, 1)); ch+=1)
			if(stringmatch(CsrWave(A, "LogGraph"), "Channel"+num2str(ch)))
				return ch
			endif
		endfor		
	endif
	
	// put cursors on first displayed channel
	for (ch=0; ch<max(1, DimSize(ChanTxt, 1)); ch+=1)
		if (Chan[%axis][ch])
			break
		endif
	endfor
	
	wave W_channel=$"root:Packages:RS232Logger:Channel"+num2str(ch)
	
	variable i=-1
	do
		i+=1
	while (numtype(W_channel[i])==2&&i<numpnts(W_channel)-1)
	Cursor /A=1/H=0/W=LogGraph A, $nameofwave(W_channel), i
	i=max(1,numpnts(CsrWaveRef(A, "LogGraph")))
	do
		i-=1
	while (numtype(W_channel[i])==2&&i)
	Cursor /A=1/H=0/W=LogGraph B, $nameofwave(W_channel), i 
		
	doUpdate
	return ch	
end

function DL_TimeAverage(ctrlName) // calculate an approximate time averaged value for channel between cursors
	String ctrlName
	if (DL_CheckLogGraphCursors()==0)
		return 0
	endif	
	variable av	
	wave channel=CsrWaveRef(a)
	wave W_time=CsrXWaveRef(a)	
	variable total=0, i=pcsr(a)
	do
		total+=channel[i]*(W_time[i+1]-W_time[i])	
		i+=1
	while (i<pcsr(b))
	av= total/(W_time[pcsr(b)]-W_time[pcsr(a)])
	
	variable time1=W_time[pcsr(a)]
	variable time2=W_time[pcsr(b)]
	string date1="", date2=""
	if ((time2-time1)>24*60*60) // more than one day, *real time only, no elapsed time*
		date1=" on "+Secs2Date(time1,0)
		date2=" on "+Secs2Date(time2,0)
	endif	
	string msg
	sprintf msg, "%s time average from %s%s to %s%s = %g", DL_GetChanName(), Secs2Time(time1, 2), date1, Secs2Time(time2, 2), date2, av
	doalert 0, msg
	print msg
end

function /T DL_GetChanName() // requires that cursor is on a channel# wave
	string strCh=CsrWave(A, "LogGraph")
	variable ch=str2num(strCh[strlen(strCh)-1, strlen(strCh)])
	if (numtype(ch)) // just in case
		return ""
	endif	
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	return ChanTxt[%ChanName][ch]
end


function DL_TruncateChannels(ctrlName) : ButtonControl
	String ctrlName
	if (DL_CheckLogGraphCursors()==0)
		return 0
	endif
	doAlert 1, "Are you sure you want to truncate ALL channels outside of cursor range?"
	if (V_Flag==2)
		return 0
	endif
	
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave W_time=root:Packages:RS232Logger:W_Time
	wave chan=root:Packages:RS232Logger:Chan
	
	variable ch=0

	variable startPoint=pcsr(A, "LogGraph"), TruncatedLength=pcsr(B, "LogGraph")-	pcsr(A, "LogGraph")+1
	for (ch=0;ch<max(1, DimSize(Chan, 1));ch+=1)
		wave ToTruncate=$"root:Packages:RS232Logger:channel"+num2str(ch)
		DeletePoints 0, startPoint-1, ToTruncate
		DeletePoints TruncatedLength+1, inf, ToTruncate
	endfor
	DeletePoints 0, startPoint-1, W_Time
	DeletePoints TruncatedLength+1, inf, W_Time
	W_Log[%i]=DimSize(W_Time, 0)
	W_Log[%StartTime]=W_Time[0] // can't use elapsed time
	cursor /W=LogGraph A, $CsrWave(A, "LogGraph"), 0 
	cursor /W=LogGraph B, $CsrWave(A, "LogGraph"), inf
	
	doupdate
	killwaves /Z root:Packages:RS232Logger:TmpClearedData
	button buttonUndo, win=EditLogPanel, disable=2
	doWindow /F LogGraph
	SetAxis/A
end

function DL_ClearBetweenCursors(ctrlName) : ButtonControl
	String ctrlName
	if (DL_CheckLogGraphCursors()==0)
		return 0
	endif
	wave ToClear=CsrWaveRef(A, "LogGraph")
	make /o /N=(pcsr(B, "LogGraph")-pcsr(A, "LogGraph")+1) root:Packages:RS232Logger:TmpClearedData
	wave TmpClearedData=root:Packages:RS232Logger:TmpClearedData
	TmpClearedData=ToClear[p+pcsr(A, "LogGraph")]
	Note /K TmpClearedData
	string noteStr
	sprintf noteStr "%s;%g;%g" CsrWave(A, "LogGraph"), pcsr(A, "LogGraph"), pcsr(B, "LogGraph")
	Note TmpClearedData noteStr
	ToClear[pcsr(A, "LogGraph"), pcsr(B, "LogGraph")]=NaN

	button buttonUndo, win=EditLogPanel, disable=0
	doWindow /F LogGraph
end

function DL_UndoClearBetweenCursors(ctrlName) : ButtonControl
	String ctrlName
	wave TmpClearedData=root:Packages:RS232Logger:TmpClearedData
	wave EditChannel=$"root:Packages:RS232Logger:"+StringFromList(0, note(TmpClearedData))
	variable p1=str2num(StringFromList(1, note(TmpClearedData)))
	variable p2=str2num(StringFromList(2, note(TmpClearedData)))
	EditChannel[p1,p2]=TmpClearedData[p-p1]
	button buttonUndo, win=EditLogPanel, disable=2
end

function DL_DoneWithEditLogPanel(ctrlName) : ButtonControl
	String ctrlName
	dowindow /K EditLogPanel
	if (V_flag<1) // nothing to close
		return 0
	endif
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave W_Log=root:Packages:RS232Logger:W_Log 
	string StrSaveName=CleanupName(ConfigTxt[%experiment], 0)
	if (DataFolderExists("root:"+StrSaveName ))
		wave savedW_Log=$"root:"+StrSaveName+":LogSetup:W_Log"
		if (savedW_Log[%i]>W_Log[%i] || exists("root:Packages:RS232Logger:TmpClearedData")==1)
			DoAlert 2, "Save edited log to memory?\r\r    Choose cancel to revert to saved"
			if (V_Flag==1) // yes
				DL_SaveLogToFolder("")
			endif
			if (V_Flag==3) //cancel
				DL_RevertToSavedLog(StrSaveName)
			elseif (strlen(ConfigTxt[%SavePathStr]))
				DoAlert 1, "Update log file on hard drive?"
				if (V_Flag==1)
					variable success=DL_AutoSaveLogFile()
					if (success==0)
						doAlert 0, "Couldn't find file "+ConfigTxt[%SavePathStr]+strSaveName
						DL_SaveLogToFile(ctrlName)
					endif
				endif
			endif
		endif
		
	endif	
	killwaves /Z root:Packages:RS232Logger:TmpClearedData
	dowindow LogGraph
	if (V_Flag)
		hideinfo /W=LogGraph
		cursor /K /W=LogGraph A
		cursor /K /W=LogGraph B
	endif
end

function DL_RevertToSavedLog(strLogName) // this is a cut down version of DL_LoadSavedLog
							// used for reverting to a saved log after editing
	string strLogName
	
	String savDF= GetDataFolder(1)		// Save current DF for restore.
	 if (!DataFolderExists("root:"+strLogName))
	 	doalert 0, "Couldn't find saved log"
	 	DL_LoadSavedLog("")
	 	return 0
	 endif
	
	SetDataFolder $("root:"+strLogName)
		
	duplicate /o :LogSetup:Chan root:Packages:RS232Logger:Chan
	duplicate /o :LogSetup:ChanTxt root:Packages:RS232Logger:ChanTxt	
	duplicate /o :LogSetup:W_Log root:Packages:RS232Logger:W_Log	

	string ChannelName
	variable i
	for (i=0;i<CountObjects(":", 1 );i+=1)
		ChannelName=StringByKey("ch", note($GetIndexedObjName(":", 1, i )), ":", "\r")
		if (strlen(ChannelName)) // look for waves with channel name in the wavenote
			duplicate /o $GetIndexedObjName(":", 1, i ) $"root:Packages:RS232Logger:"+ChannelName
		endif
	endfor	
		
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	
	W_Log[%j]=0
	if (strlen(note(Chan)))
		ConfigTxt[%experiment]=note(Chan)
	else
		ConfigTxt[%experiment]=strLogName // for backward compatibility
	endif
	
	DL_MakeLogGraph()
	SetAxis/A/E=0/N=0 bottom
	DL_PrintToHistory("Reverted to saved log "+strLogName)
	SetDataFolder savDF
	
end


// -------------------------------------- Data Logger File Settings -------------------------------------- 

Function DL_MakeFileControlPanel(ctrlName) : ButtonControl
	String ctrlName
	wave config=root:Packages:RS232Logger:config
	dowindow FileControlPanel
	if (V_Flag)
		doWindow /F FileControlPanel
	else
		NewPanel /N=FileControlPanel/K=1/W=(500,450,660,750) as "File Control"
		Button SaveButton,pos={30,40},size={100,20},proc=DL_SaveLogToFolder,title="To memory"	
		Button SaveToFileButton,pos={30,70},size={100,20},title="To file..."	,proc=DL_SaveLogToFile
		Button ExportButton,pos={30,100},size={100,20},proc=DL_ExportText,title="Export Text..."
			
		Button LoadButton,pos={30,180},size={100,20},proc=DL_LoadSavedLog,title="From memory..."
		Button LoadFromFileButton,pos={30,210},size={100,20},title="From file..",proc=DL_LoadLogFromFileDialog
		
		Button ServerSettingsButton, pos={30,265},size={100,20},title="Server Settings..",proc=DL_MakeServerSettingsPanel
		
		GroupBox SaveBox frame=1, pos={10,10}, size={140,130}, title="Save log"
		GroupBox LoadBox frame=1, pos={10,150}, size={140,100}, title="Load log"
		ModifyPanel, fixedSize=1
	endif
end

// DL_ExportText() exports waves to a text file. Uses open dialog to select a file name, 
// writes headers for columns, then appends tab delimited data to file 
function DL_ExportText(ctrlName) : ButtonControl
	string ctrlName
		
	wave Config=root:Packages:RS232Logger:Config
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T chanTxt=root:Packages:RS232Logger:chanTxt
	wave W_time=root:Packages:RS232Logger:W_time
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave W_Log=root:Packages:RS232Logger:W_Log
	
	if (W_Log[%i]==0)
		doAlert 0, "No data to save"
		return 0
	endif
	
	String savDF= GetDataFolder(1)		// Save current DF for restore.	
	string StrSaveName
	
	setdatafolder root:Packages:RS232Logger:
	duplicate/O/B/U W_time TimeFromStart
	TimeFromStart=round(1e3*(W_time-W_time[0]))/1e3
	variable numChan=max(1, DimSize(Chan, 1))
	
	StrSaveName=cleanupname(ConfigTxt[%experiment], 1)	
	string ChanNameList="TimeFromStart"
	string ChanList="TimeFromStart"
	variable channel
	for (channel=0; channel<numChan; channel+=1)
		ChanNameList+="\t"+ChanTxt[%ChanName][channel]
		ChanList+=";channel"+num2str(channel)
	endfor
	variable refnum
	string S_fileName
	open /D /T="Text" /M="Save "+StrSaveName+" as text file:" refnum as StrSaveName
	if (strlen(S_fileName))
		if (!stringmatch(S_fileName[strlen(S_fileName)-4,strlen(S_fileName)-1], ".txt"))
			S_fileName+=".txt"
		endif
		open refnum as S_fileName
		fprintf refnum, ChanNameList
		close refnum
		Save/J/A/B ChanList as S_fileName
	endif
	killwaves TimeFromStart
	SetDataFolder savDF
	return 1		
end


function DL_SaveLogToFolder(ctrlName) : ButtonControl
	string ctrlName
	String savDF= GetDataFolder(1)		// Save current DF for restore.	
	string StrSaveName	

	wave Chan=root:Packages:RS232Logger:Chan
	wave/T ChanTxt=root:Packages:RS232Logger:ChanTxt
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave W_time=root:Packages:RS232Logger:W_time
	string cmd=""
	
	if (W_Log[%i]==0)
		return 0
	endif
	
	StrSaveName=CleanupName(ConfigTxt[%experiment], 0)
	variable i=0
	do		
		if (cmpstr(GetIndexedObjName("root:", 4, i ),StrSaveName)==0)		
			cmd="Saving "+StrSaveName+" Log.\r"+StrSaveName+" already exists. Overwrite?"
			break		
		endif
		i+=1
	while (i<CountObjects("root:", 4 ))
	if (strlen(cmd)==0)
		cmd="Save log to "+StrSaveName+"?"
	endif
	if (strlen(ctrlName)) // we're pushing a button
		doAlert 1, cmd
		if (V_flag==2)
			return 0
		endif
	endif
	
	NewDataFolder/O/S root:$StrSaveName			
	StrSaveName=CleanupName(ConfigTxt[%experiment]+"_time", 0)
	duplicate /O root:Packages:RS232Logger:W_time $StrSaveName
	
	string noteStr=note($StrSaveName)
	noteStr=ReplaceStringByKey("ch", noteStr, "W_time", ":", "\r")
	note /k $StrSaveName; note $StrSaveName, noteStr
	
	i=0
	do
		StrSaveName=CleanupName(ConfigTxt[%experiment]+"_"+ChanTxt[%ChanName][i], 0)		
		sprintf cmd "duplicate /O root:Packages:RS232Logger:channel%d %s" i, StrSaveName
		execute cmd
		noteStr=note($StrSaveName)
		noteStr=ReplaceStringByKey("ch", noteStr, "channel"+num2str(i), ":", "\r")
		note /k $StrSaveName; note $StrSaveName, noteStr // save channel name in wavenote so that we can reload log
		i+=1
	while (i<max(1, DimSize(Chan, 1)))
	DL_PrintToHistory("Saved log to "+getdatafolder(1))
	
	NewDataFolder/O/S LogSetup
	note /K Chan
	note Chan ConfigTxt[%experiment] // save experiment ID as wavenote
	duplicate /O root:Packages:RS232Logger:Chan Chan
	duplicate /T/O root:Packages:RS232Logger:ChanTxt ChanTxt
	duplicate /O root:Packages:RS232Logger:W_Log W_Log
	W_Log[%j]=0 // we haven't saved display waves	
	SetDataFolder savDF	
	return 1		
end

// DL_LoadSavedLog looks for a folder in root containing a subfolder named LogSetup
// restores setup waves from LogSetup
// checks log waves for channel names stored as a key in the wavenote and restores them
// overwrites display waves with empty waves
Function DL_LoadSavedLog(ctrlName)
	string ctrlName
	
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave W_Log=root:Packages:RS232Logger:W_Log
	
	String savDF= GetDataFolder(1)		// Save current DF for restore.
	SetDataFolder root:
// saved log folder has to be in root
// could do a recursive search...
	string ListOfLogs=""
	variable i
	for (i=0;i<CountObjects(":", 4 );i+=1)
		SetDataFolder GetIndexedObjName(":", 4, i )
		if (stringmatch(DataFolderDir(1), "*LogSetup*"))
			ListOfLogs+=GetDataFolder(0)+";"
		endif
		SetDataFolder root:
	endfor
	if (strlen(ListOfLogs)==0)
		doAlert 0, "No saved logs in current experiment\r (Note that log folder must be in root)"
		return 0
	endif
	string LogToLoad
	Prompt LogToLoad, "Choose Log to Load: ", popup ListOfLogs
	DoPrompt "Looking for a saved log", LogToLoad
	if (V_Flag==1) // user cancelled
		return 0
	endif
	
	if (W_Log[%i])
		doalert 2, "Save "+ConfigTxt[%experiment]+" before loading log?"
		if (V_Flag==1) // yes click
			if (DL_SaveLogToFolder("")==0) // tries to save current log
				return 0 // exits on failure
			endif
		endif
		if (V_Flag==3) // cancel
			return 0
		endif
	endif
	
	DL_KillSomeDataLoggerWindows() // kill the display and anything else that may need updating	
	
	SetDataFolder $("root:"+LogToLoad)
		
	duplicate /o :LogSetup:Chan root:Packages:RS232Logger:Chan
	duplicate /o :LogSetup:ChanTxt root:Packages:RS232Logger:ChanTxt
	
	DL_UpdateExternalChanFiles() //saves new chan and chantxt as default
	DL_InitialiseDataLogVariables() // resets everything; ports are open
	
	duplicate /o :LogSetup:W_Log root:Packages:RS232Logger:W_Log	
	string ChannelName
	for (i=0;i<CountObjects(":", 1 );i+=1)
		ChannelName=StringByKey("ch", note($GetIndexedObjName(":", 1, i )), ":", "\r")
		if (strlen(ChannelName)) // look for waves with channel name in the wavenote
			duplicate /o $GetIndexedObjName(":", 1, i ) $"root:Packages:RS232Logger:"+ChannelName
		endif
	endfor	
	
	
	wave Config=root:Packages:RS232Logger:Config
	wave Chan=root:Packages:RS232Logger:Chan
	
	W_Log[%j]=0
	if (strlen(note(Chan)))
		ConfigTxt[%experiment]=note(Chan)
	else
		ConfigTxt[%experiment]=LogToLoad // for backward compatibility
	endif
	
	DL_UserInit() // update DL_infostr here
	
	DL_MakeLogPanel() // rebuild the control panel
	DL_MakeLogGraph()
	SetAxis/A/E=0/N=0 bottom
	DL_PrintToHistory("Loaded log from root:"+LogToLoad)
	SetDataFolder savDF
end

function DL_MakeServerSettingsPanel(ctrlName)
	string ctrlName

	doWindow /K ServerSettingsPanel
	String savDF= GetDataFolder(1)		// Save current DF for restore.	
	SetDataFolder root:Packages:RS232Logger
	
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	
	duplicate /O ConfigTxt root:Packages:RS232Logger:ConfigTxtTemp
	wave /T ConfigTxtTemp=root:Packages:RS232Logger:ConfigTxtTemp
	
	NewPanel /N=ServerSettingsPanel/K=1/W=(719.25,106.25,1016.25,550.25) as "Server Settings"
	
	groupbox groupEmail title="Email", pos={20,15}, size={255,115}
	groupbox groupServer title="Web Server", pos={20,140}, size={255,115}
	groupbox groupPaths title="Paths", pos={20,265}, size={255,130}
	
	SetVariable setvarEmail,pos={35,40},size={225,16},title="Send Email To",value= ConfigTxtTemp[%email], win=ServerSettingsPanel
	SetVariable setvarEmail, help={"Email address to which email alerts should be sent"}, proc=DL_ParseEmail, win=ServerSettingsPanel
	SetVariable setvarFrom,pos={35,60},size={225,16},title="From Address",value= ConfigTxtTemp[%emailFrom], win=ServerSettingsPanel
	SetVariable setvarFrom, help={"From field for automatically generated emails"}, win=ServerSettingsPanel
	SetVariable setvarSMTP,pos={35,80},size={225,16},title="SMTP Server", value= ConfigTxtTemp[%emailSMTP], win=ServerSettingsPanel
	SetVariable setvarSMTP, help={"Address of SMTP server"}, win=ServerSettingsPanel
	SetVariable setvarSubject,pos={35,100},size={225,16},title="Subject Line",value= ConfigTxtTemp[%emailSubject], win=ServerSettingsPanel
	SetVariable setvarSubject, help={"Subject line for automatically generated emails"}, win=ServerSettingsPanel
	
	
	SetVariable setvarServerAddress,pos={35,165},size={225,16},title="Server Address", win=ServerSettingsPanel
	SetVariable setvarServerAddress,value= ConfigTxtTemp[%ServerAddress], win=ServerSettingsPanel
	SetVariable setvarServerAddress, help={"Web server address: used by scp2, usually has format username@server.address:www"}, win=ServerSettingsPanel
	SetVariable setvarServerLogName,pos={35,185},size={225,16},title="Remote Log Name", win=ServerSettingsPanel
	SetVariable setvarServerLogName,value= ConfigTxtTemp[%ServerLogName], proc=DL_ServerSettingsCheckString, win=ServerSettingsPanel
	SetVariable setvarServerLogName, help={"Name of frequently reposted screenshot of recently collected data (png file) to post on web server"}, win=ServerSettingsPanel
	SetVariable setvarServerSummaryName,pos={35,205},size={225,16},title="Remote Summary Name", win=ServerSettingsPanel
	SetVariable setvarServerSummaryName,value= ConfigTxtTemp[%ServerSummaryName], proc=DL_ServerSettingsCheckString, win=ServerSettingsPanel
	SetVariable setvarServerSummaryName, help={"Name for picture of entire log (png file) to post on web server - leave blank to prevent uploading"}, win=ServerSettingsPanel
	SetVariable setvarServerItxName,pos={35,225},size={225,16},title="Remote Data Name", win=ServerSettingsPanel
	SetVariable setvarServerItxName,value= ConfigTxtTemp[%ServerItxName], proc=DL_ServerSettingsCheckString, win=ServerSettingsPanel
	SetVariable setvarServerItxName, help={"Name for compressed data (zip file) to post on web server - leave blank to prevent uploading."}, win=ServerSettingsPanel
	
	SetVariable setvardefaultLog,pos={35,290},size={225,16},title="Default Log Name", win=ServerSettingsPanel
	SetVariable setvardefaultLog,value= ConfigTxtTemp[%defaultLog], win=ServerSettingsPanel
	SetVariable setvardefaultLog, help={"Default Log Name: the default name for a new log"}, win=ServerSettingsPanel
	
	SetVariable setvarSavePath,pos={35,312},size={195,20},title="Save Path", win=ServerSettingsPanel
	SetVariable setvarSavePath,limits={0,0,0},barmisc={0,1000}, win=ServerSettingsPanel
	SetVariable setvarSavePath, value=ConfigTxtTemp[%SavePathStr], noedit=1, win=ServerSettingsPanel
	SetVariable setvarSavePath, help={"Save Path: log files wil be automatically saved in this location"}, win=ServerSettingsPanel
	button buttonSavePath, pos={238,310},size={20,20}, proc=DL_UpdateConfigPaths, title="...", win=ServerSettingsPanel
	
	SetVariable setvarPostiePath,pos={35,337},size={195,20},title="Postie Path", win=ServerSettingsPanel
	SetVariable setvarPostiePath,limits={0,0,0},barmisc={0,1000}, win=ServerSettingsPanel
	SetVariable setvarPostiePath, value=ConfigTxtTemp[%PostiePathStr], noedit=1, win=ServerSettingsPanel
	SetVariable setvarPostiePath, help={"Postie Path:set location of standalone postie.exe - if postie is registered with Windoze you don't need to set this"}, win=ServerSettingsPanel
	button buttonPostiePath, pos={238,335},size={20,20}, proc=DL_UpdateConfigPaths, title="...", win=ServerSettingsPanel
	
	SetVariable setvarpkzipcPath,pos={35,362},size={195,20},title="pkzipc Path", win=ServerSettingsPanel
	SetVariable setvarpkzipcPath,limits={0,0,0},barmisc={0,1000}, win=ServerSettingsPanel
	SetVariable setvarpkzipcPath, value=ConfigTxtTemp[%pkzipcPathStr], noedit=1, win=ServerSettingsPanel
	SetVariable setvarpkzipcPath, help={"pkzipc Path: set location of standalone pkzipc.exe - if pkzipc is registered with Windoze you don't need to set this"}, win=ServerSettingsPanel
	button buttonpkzipcPath, pos={238,360},size={20,20}, proc=DL_UpdateConfigPaths, title="...", win=ServerSettingsPanel
	
	Button buttonSave,pos={150,410},size={40,20},title="Save", Proc=DL_DoneWithServerSettingsPanel, win=ServerSettingsPanel
	Button buttonCancel,pos={220,410},size={45,20},title="Cancel", Proc=DL_DoneWithServerSettingsPanel, win=ServerSettingsPanel
	
	ModifyPanel /W=ServerSettingsPanel fixedSize= 1
	setwindow ServerSettingsPanel, hook=DL_HookServerSettingsPanel
	SetDataFolder savDF
end

function DL_ParseEmail(ctrlName,varNum,varStr,varName)
	string ctrlName,varStr,varName
	variable varNum
	if (strlen(varStr)==0)
		return 1
	endif	
	if (DL_EmailValid(varStr))
		return 1
	else
		doAlert 0, "Invalid email address!"
		if (stringmatch (ctrlName, "setvarEmail")) // function called from ServerSettingsPanel
			wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxtTemp
		else
			wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
		endif
		ConfigTxt[%email]=""
		return 0
	endif	
end

function DL_EmailValid(email)
	string email
	
	string parsed
	if (strsearch(email, " ", 0)>-1)
		return 0 // reject string containing whitespace
	endif
	variable pos=strsearch(email, "@", 1 )
	if (pos>0)
		if (strsearch(email, "@", pos+1)>0)
			return 0
		endif
		if (strsearch(email, "<", pos+1)>0)
			return 0
		endif
		if (strsearch(email, ">", pos+1)>0)
			return 0
		endif
		if (strsearch(email, ".", pos)<pos+2 || strlen(email)-1<strsearch(email, ".", inf, 1)+2)
			return 0
		endif
	endif
	return (pos>0)
end

function DL_HookServerSettingsPanel(infoStr)
	string infoStr
	wave/T ConfigTxtTemp=root:Packages:RS232Logger:ConfigTxtTemp
	wave/T ConfigTxt=root:Packages:RS232Logger:ConfigTxt 
	variable i
	String event= StringByKey("EVENT",infoStr)
	if (stringmatch(event, "kill"))
		for (i=0; i<numpnts(ConfigTxt); i+=1)
			if (cmpstr (ConfigTxt[i], ConfigTxtTemp[i]) && cmpstr(GetDimLabel(ConfigTxt, 0, i), "TimeCounter"))
				doalert 1, "Do you want to save new values?"
				if (V_Flag==1)
					DL_DoneWithServerSettingsPanel("Save")
				else
					DL_DoneWithServerSettingsPanel("")
				endif
				return 1
			endif
		endfor
		DL_DoneWithServerSettingsPanel("")
		return 1
	endif

	return 0
end

function DL_ServerSettingsCheckString(ctrlName,varNum,varStr,varName)
	String ctrlName, varStr, varName; Variable varNum
	string suffix=".png"
	
	if (strlen(varStr)==0)
		return 0
	endif
	ctrlName[0,5]=""
	if (stringmatch(ctrlName, "*ItxName"))
		suffix=".zip"
	endif
	if (cmpstr(varStr[strlen(varStr)-4,strlen(varStr)-1], suffix))
		execute "root:Packages:RS232Logger:ConfigTxtTemp[%"+ctrlName+"]=\""+varStr+suffix+"\""
	endif
end

function DL_DoneWithServerSettingsPanel(ctrlName)
	String ctrlName
	wave/T ConfigTxtTemp=root:Packages:RS232Logger:ConfigTxtTemp
	wave/T ConfigTxt=root:Packages:RS232Logger:ConfigTxt

	if (StringMatch (ctrlName, "*Save"))		
		variable i=0
		string msg=""
		for (i=0; i<numpnts(ConfigTxt); i+=1)
			if (cmpstr (ConfigTxt[i], ConfigTxtTemp[i]) && cmpstr(GetDimLabel(ConfigTxt, 0, i), "TimeCounter"))
				sprintf msg, "%s, %s = %s", msg, GetDimLabel(ConfigTxt, 0, i), ConfigTxtTemp[i]
			endif
		endfor
		if (strlen(msg))
			msg[0,0]=""
			DL_PrintToHistory(msg)
		endif	
		duplicate /O ConfigTxtTemp root:Packages:RS232Logger:ConfigTxt
		if (strlen(ConfigTxt[%SavePathStr]))
			NewPath /C /O /Q /Z SavePath, ConfigTxt[%SavePathStr]
		endif
		Save /T/M="\r\n"/P=LoggerPath/O ConfigTxt as "ServerSettings.itx"
	endif
	DoWindow /K ServerSettingsPanel
	KillWaves ConfigTxtTemp
end

function DL_UpdateConfigPaths(ctrlName)
	string ctrlName
	
	wave/T ConfigTxtTemp=root:Packages:RS232Logger:ConfigTxtTemp
	variable fileref=0, i
	ctrlName[0,5]="" // remove "button" from ctrlName
	strswitch(ctrlName)	
		case "PostiePath":
			open /R/D /M="Looking for postie.exe" /T=".exe" fileref as "postie.exe"
			i=strlen(S_fileName)
			do
				i-=1
			while (stringmatch(S_fileName[i], "!:")&&i>0)
			ConfigTxtTemp[%PostiePathStr]=S_fileName[0,i] // cancel will set path to ""		
			break
		case "pkzipcPath":		// execute if case matches expression
			open /R/D /M="Looking for pkzipc.exe" /T=".exe" fileref as "pkzipc.exe"
			i=strlen(S_fileName)
			do
				i-=1
			while (stringmatch(S_fileName[i], "!:")&&i>0)
			ConfigTxtTemp[%pkzipcPathStr]=S_fileName[0,i] // cancel will set path to ""		
			break
		case "SavePath":
			newPath /C/M="Where to save logs?"/O/Q tempPath
			if (V_Flag)
				ConfigTxtTemp[%SavePathStr]=""
				return 0
			endif
			PathInfo tempPath		
			ConfigTxtTemp[%SavePathStr]=S_path
			KillPath tempPath			
	endswitch		
end

function DL_UpdateExternalChanFiles()
	// update default channel setup
	wave ChanTxt=root:Packages:RS232Logger:ChanTxt
	wave Chan=root:Packages:RS232Logger:Chan
		
	if (stringmatch(StringByKey("IGORKIND", IgorInfo(0)) , "*demo")) // demo version
		return 0
	endif
	Save/O/T/P=LoggerPath/M="\r\n" ChanTxt,Chan as "ChannelSetup.itx"
	return 1
end

function DL_UpdateExternalConfigFile()
	// update default config
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt	
	if (stringmatch(StringByKey("IGORKIND", IgorInfo(0)) , "*demo")) // demo version
		return 0
	endif
	Save /T/M="\r\n"/P=LoggerPath/O ConfigTxt as "ServerSettings.itx"
	return 1
end

function DL_SaveLogToFile(ctrlName)
	string ctrlName
	wave Chan=root:Packages:RS232Logger:Chan	
	wave/T ConfigTxt=root:Packages:RS232Logger:ConfigTxt	
	wave W_Log=root:Packages:RS232Logger:W_Log
	
	if (W_Log[%i]==0)
		doAlert 0, "No data to save"
		return 0
	endif
	
	note /K Chan
	note Chan ConfigTxt[%experiment]
	
	string ListOfWavesToSave="root:Packages:RS232Logger:Chan;"
	ListOfWavesToSave+="root:Packages:RS232Logger:ChanTxt;"
	ListOfWavesToSave+="root:Packages:RS232Logger:W_Log;"
	ListOfWavesToSave+="root:Packages:RS232Logger:W_time;"
	variable channel
	for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
		ListOfWavesToSave+="root:Packages:RS232Logger:channel"+num2str(channel)+";"
	endfor
	
	save /B/T /P=SavePath ListOfWavesToSave as "temp"+ConfigTxt[%experiment]+".ilf"
	// SetFileFolderInfo /INV=1 /P=SavePath /Z "temp"+ConfigTxt[%experiment]+".ilf" 
	// Norton antivirus creates error with above line
	MoveFile /D/I=2 /P=SavePath /S="Save log to file" /Z=1 "temp"+ConfigTxt[%experiment]+".ilf" as ConfigTxt[%experiment]+".ilf"
	if (V_Flag)
		DeleteFile /P=SavePath /Z=1 "temp"+ConfigTxt[%experiment]+".ilf" 
	else
		return 0
	endif
	return 1
end

function DL_LoadLogFromFileDialog(ctrlName)
	string ctrlName
	
	variable refnum=0
	open /R/D/M="Looking for a log file"/P=SavePath/T=".ilf" refnum
	if (strlen(S_fileName)) // 
		DL_LoadLogFromFile(S_fileName)		
	endif
end

Function DL_LoadLogFromFile(strFileToLoad)
	string strFileToLoad
	
	if (datafolderexists("root:Packages:RS232Logger")==0)
		DL_InitialiseDataLogVariables()		
	endif
	BuildMenu "Macros"
	
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave W_log=root:Packages:RS232Logger:W_log
	wave Chan=root:Packages:RS232Logger:Chan	
	
	if (W_log[%i]) // Data Logger has a log loaded 
		doalert 2, "Save "+ConfigTxt[%experiment]+" before loading log?"
		if (V_Flag==1) // yes click
			if (DL_SaveLogToFolder("")==0) // tries to save current log
				return 0 // exits on failure
			endif
		endif
		if (V_Flag==3) // cancel
			return 0
		endif
	endif	
		
	DL_KillSomeDataLoggerWindows() // kill the display and anything else that may need updating	
			
	String savDF= GetDataFolder(1)		// Save current DF for restore.	
	SetDataFolder root:Packages:RS232Logger
	LoadWave /O/Q/T strFileToLoad
		
	DL_UpdateChan()
	DL_UpdateExternalChanFiles() //saves new chan and chantxt as default
	DL_InitialiseDataLogVariables() // resets everything; ports are open
	LoadWave /O/Q/T strFileToLoad // load again - need to reload W_Log and channel files
	DL_UpdateChan() // update any out of date log files
	DL_UserInit() // should update DL_infostr
	
	ConfigTxt[%experiment]=note(Chan)	
	Chan[%monitor][]=0
	Chan[%record][]=0
	W_Log[%j]=0
	
	DL_MakeLogPanel() // rebuild the control panel
	DL_MakeLogGraph()
	SetAxis/A/E=0/N=0 bottom
	DL_PrintToHistory("Loaded log from file: "+S_fileName)
	SetDataFolder savDF	
end

function DL_AutoSaveLogFile()
	wave Chan=root:Packages:RS232Logger:Chan
	wave/T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	
	if (strlen(ConfigTxt[%SavePathStr])==0)
		return 0
	endif
	
	note /K Chan
	note Chan ConfigTxt[%experiment]
	
	string ListOfWavesToSave="root:Packages:RS232Logger:Chan;"
	ListOfWavesToSave+="root:Packages:RS232Logger:ChanTxt;"
	ListOfWavesToSave+="root:Packages:RS232Logger:W_Log;"
	ListOfWavesToSave+="root:Packages:RS232Logger:W_time;"
	variable channel
	for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
		ListOfWavesToSave+="root:Packages:RS232Logger:channel"+num2str(channel)+";"
	endfor
	
	variable fileref=0 // use open to make sure the file isn't already open
	open /Z/A/P=SavePath fileref as DL_WindowsFileNameCleanUp(ConfigTxt[%experiment])+".ilf"
	if (fileref)		
		close fileref
	else
		close /A
	endif
	
	save /B/T/O /P=SavePath ListOfWavesToSave as DL_WindowsFileNameCleanUp(ConfigTxt[%experiment])+".ilf"
	
	fileref=0
	open /Z/A/P=SavePath fileref as DL_WindowsFileNameCleanUp(ConfigTxt[%experiment])+".ilf"
	if (fileref)		
		close fileref
		return 1
	else
		return 0 // failed to save file
	endif
end

function DL_ReplaceLogPicture()
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave Config=root:Packages:RS232Logger:Config
		
	variable refnum=0
	open /Z /R/P=LoggerPath refnum as "DefaultLogGraph.png"
	if (V_flag==0) // file exists
		close refnum
	else		
		return 0
	endif
		
	PathInfo LoggerPath
	string cmd, UnixPathStr=DL_MacPath2ForwardSlashPath(S_Path)
	sprintf cmd, "scp2 \"%sDefaultLogGraph.png\" %s/%s", UnixPathStr, ConfigTxt[%ServerAddress], ConfigTxt[%ServerLogName]
	ExecuteScriptText /B cmd	
end

function /T DL_WindowsFileNameCleanUp(str)
	string str
	if (strlen(str)==0)
		str= "Log "+Secs2Date(DateTime,0)
	endif
	variable i=0
	for (i=0; i<strlen(str); i+=1)
		strswitch (str[i])
			case "*":
				str[i,i]="_"
				break
			case "\"":
				str[i,i]="_"
				break
			case "/":
				str[i,i]="_"
				break
			case ":":
				str[i,i]="_"
				break
			case "?":
				str[i,i]="_"
				break
			case "|":
				str[i,i]="_"
				break
			case "<":
				str[i,i]="_"
				break
			case ">":
				str[i,i]="_"
				break
		endswitch			
	endfor
	for (i=0; i<strlen(str)-1; i+=1)
		if (stringmatch(str[i,i+1], "__"))
			str[i,i+1]="_"
		endif
	endfor
	return str
end

function DL_CreateWebPageTemplate()
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	if (strlen(ConfigTxt[%ServerLogName]+ConfigTxt[%ServerItxName]+ConfigTxt[%ServerSummaryName])==0)
		doalert 0, "You must first set the filenames for the remote files.\rSee web server settings."
		return 0
	endif
	String nb = "DLNotebook"
	NewNotebook/N=$nb/F=1/V=0 as "Data Logger Test.htm" 
	Notebook $nb newRuler=HTMLCode
	Notebook $nb ruler=HTMLCode, text="<head>\r"
	Notebook $nb text="<meta http-equiv=\"Refresh\" content=\"60\">\r"
	Notebook $nb text="<TITLE>Data Logger for Igor Pro</TITLE>\r"
	Notebook $nb text="<META HTTP-EQUIV=\"Pragma\" CONTENT=\"no-cache\">\r"
	Notebook $nb text="<META HTTP-EQUIV=\"Expires\" CONTENT=\"-1\">\r"
	Notebook $nb text="</head>\r"
	Notebook $nb text="<body>\r"
	Notebook $nb text="<h1>Data Logger</h1>\r"
	Notebook $nb text="<p> <HTML>\r"
	if (strlen(ConfigTxt[%ServerLogName]))	
		Notebook $nb text="<p>When a log is published on the web you should see a screenshot of the log below.</p>\r"
		Notebook $nb text="<p>Click on the log for a full resolution image:</p>\r"
		Notebook $nb text="<a href=\""+ ConfigTxt[%ServerLogName]+"\">\r"
		Notebook $nb text="<img border=\"0\" src=\""+ ConfigTxt[%ServerLogName]+"\" width=\"606\" height=\"472\"></a></p>\r"
	endif	
	if (strlen(ConfigTxt[%ServerItxName]))
		Notebook $nb text="<p>The entire log may be perused using\r"
		Notebook $nb text="<a href=\"http://www.wavemetrics.com/\">Igor Pro</a>, the graphing and data \r"
		Notebook $nb text="analysis program made by Wavemetrics. If you have a copy of Igor Pro installed \r"
		Notebook $nb text="on your computer,\r"
		Notebook $nb text="<a href=\""+ ConfigTxt[%ServerItxName]+"\">click \r"
		Notebook $nb text="here</a> to download a zipped file containing the full log. \r"
		if (strlen(ConfigTxt[%ServerSummaryName]))
			Notebook $nb text="Alternatively, "
		endif
	endif
	if (strlen(ConfigTxt[%ServerSummaryName]))
		Notebook $nb text="<a href=\""+ ConfigTxt[%ServerSummaryName]+"\">\r"
		Notebook $nb text="click here</a> for a screenshot of the entire log.</p>\r"
	endif
	Notebook $nb text="<p>A demo version of Igor Pro may be downloaded from\r"
	Notebook $nb text="<a href=\"http://www.wavemetrics.com/Products/IGORPro/Demo.html\">Wavemetrics</a>.</p>\r"
	Notebook $nb text="</body>"
	SaveNotebook /I/M="Save web page template"/P=LoggerPath/S=5 $nb as "Web Logger Template.htm"
	DoWindow /K $nb
End

// -------------------------------------- Data Logger Initialisation -------------------------------------- 

function DL_InitialiseDataLogVariables()	
	
	String savDF= GetDataFolder(1)		// Save current DF for restore.
	NewDataFolder/O root:Packages		// Make sure this exists.
	NewDataFolder /O/S root:Packages:RS232Logger
	
	killstrings /Z root:Packages:RS232Logger:DL_infostr
	variable i=0
	
	pathinfo LoggerPath
	if (V_Flag==0) // path not set yet	
		pathinfo igor
		newpath /Q/O LoggerPath, S_Path+"User Procedures:Data Logger:"
		if (V_Flag) // bad guess
			newpath /C/M="Set path to data logger folder"/Q LoggerPath
			if (V_Flag) // cancel
				return 0
			endif
		endif
	endif
 	
	// reset config and variable waves to default values
 	if (exists("Config")==0)
	 	make /O/N=20 Config // user configurable options
	 	
	 	setdimlabel 0, 0, null, Config
	 	setdimlabel 0, 1, StopLog, Config
	 	setdimlabel 0, 2, Verbose, Config
	 	setdimlabel 0, 3, UpdateInterval, Config
	 	setdimlabel 0, 4, DisplayRange, Config
	 	setdimlabel 0, 5, SaveInterval, Config
	 	setdimlabel 0, 6, PublishOnWeb, Config
	 	setdimlabel 0, 7, SendEmailAlerts, Config
	 	setdimlabel 0, 8, MinInterval, Config
	 	setdimlabel 0, 9, update, Config
	 	setdimlabel 0, 10, AutoActivateAlarms, Config
	 	setdimlabel 0, 11, AAAvalue, Config
	 	setdimlabel 0, 12, AutoDeactivateAlarms, Config
	 	setdimlabel 0, 13, ADAvalue, Config
	 	setdimlabel 0, 14, delay, Config

	 	
	 	Config[%null]=nan
	 	Config[%StopLog]=1			// 0 to run log, 1 to stop
	 	Config[%Verbose]=1			// record stuff to history
	 	Config[%UpdateInterval]=1		// minutes, time between time axis autoupdate
	 	Config[%DisplayRange]=30	// minutes, range of display for autoupdate
	 	Config[%SaveInterval]=5		// minutes, time between saves [and web publishing]
	 	Config[%PublishOnWeb]=0
	 	Config[%SendEmailAlerts]=0	// 
	 	Config[%MinInterval]=60		// seconds, minimum time between recordings
	 	Config[%update]=1			// autoupdate time axis to track log
	 	Config[%AutoActivateAlarms]=0	// value = channel# +10 to activate when channel value > set value
		Config[%AutoDeactivateAlarms]=0	// value = channel# +20 to activate when channel value < set value
	 								// value =0 for no auto activation
	 	Config[%delay]=0
	endif
 		
 	make /O/N=20/D W_Log // storage space for variables
 	
 	setdimlabel 0, 0, null, W_Log
 	setdimlabel 0, 1, RecordData, W_Log	// so that we can force a record	
	setdimlabel 0, 2, xRight, W_Log	// high value of time axis	
	setdimlabel 0, 3, i, W_Log		// recorded data index
 	setdimlabel 0, 4, j, W_Log		// display data index
 	setdimlabel 0, 5, ticksRef, W_Log		// ticks value at start of log
 	setdimlabel 0, 6, timeRef, W_Log		// start of log
 	setdimlabel 0, 7, TicksPerSec, W_Log	// ticks per second, to calculate time
 	setdimlabel 0, 8, LastSaveTime, W_Log
 	setdimlabel 0, 9, OnScreen, W_Log	 // redundant
 	setdimlabel 0, 10, rate, W_Log // data acquisition rate, /s
 	setdimlabel 0, 11, LastSummary, W_Log // last summary save time
 	setdimlabel 0, 12, StartTime, W_Log 
 	setdimlabel 0, 13, timeNow, W_Log 
 	setdimlabel 0, 14, recordNext, W_Log
 	setdimlabel 0, 15, its_per_ms, W_Log
 	
 	W_Log[%null]=nan
 	W_Log[%xRight]=0
 	W_Log[%LastSaveTime]=0
 	W_Log[%i]=0
 	W_Log[%j]=0
 	W_Log[%OnScreen]=0 // redundant
 	W_Log[%rate]=0
 	W_Log[%LastSummary]=0
 	W_Log[%StartTime]=0 // start time will one day allow us to switch between real and elapsed time
 	W_Log[%recordNext]=0 // so that we can set RecordData from outside of the loop
 	
 	if (kdefaultTicksPerSec>0)
 		W_Log[%TicksPerSec]=kdefaultTicksPerSec
 	else
		if ( cmpstr(igorinfo(2)[0],"W")==0) //Windows OS
			W_Log[%TicksPerSec]=58.8245	// check this using DL_TicksTest() function
		else
			W_Log[%TicksPerSec]=60.15
		endif
	endif
	W_Log[%timeRef]=datetime+1
	do // wait until the system clock rolls around to a new second
	while (datetime<W_Log[%timeRef])
	W_Log[%ticksRef]=ticks
	// W_Log[%its_per_ms]=DL_CalibrateComputerSpeed()
	// wait for DL_UpdateChan to set this
	

	variable fileref=0 // check whether ConfigTxt has been saved 
	open /P=LoggerPath/Z=1 /R fileref as "ServerSettings.itx"
	if (fileref)
 		close fileref
 		LoadWave /P=LoggerPath/Q/O/T "ServerSettings.itx"	 		
	endif
	
	if (!(exists("ConfigTxt"))) // set up ConfigTxt wave with default values
		
		make /O/N=20/T ConfigTxt
		
		setdimlabel 0, 0, null, ConfigTxt
	 	setdimlabel 0, 1, experiment, ConfigTxt
	 	setdimlabel 0, 2, email, ConfigTxt
	 	setdimlabel 0, 3, ServerLogName, ConfigTxt
	 	setdimlabel 0, 4, ServerSummaryName, ConfigTxt
	 	setdimlabel 0, 5, ServerItxName, ConfigTxt
	 	setdimlabel 0, 6, ServerAddress, ConfigTxt
	 	setdimlabel 0, 7, SavePathStr, ConfigTxt
	 	setdimlabel 0, 8, defaultLog, ConfigTxt
	 	setdimlabel 0, 9, TimeCounter, ConfigTxt
	 	setdimlabel 0, 10, PostiePathStr, ConfigTxt
	 	setdimlabel 0, 11, pkzipcPathStr ConfigTxt
	 	setdimlabel 0, 12, emailFrom, ConfigTxt
	 	setdimlabel 0, 13, emailSMTP, ConfigTxt
	 	setdimlabel 0, 14, emailFlags, ConfigTxt
	 	setdimlabel 0, 15, emailSubject, ConfigTxt
	 	setdimlabel 0, 16, url, ConfigTxt
	 	setdimlabel 0, 17, user, ConfigTxt
	 	setdimlabel 0, 18, pswd, ConfigTxt
	 	 	
	 	ConfigTxt[%null]=""
	 	ConfigTxt[%email]="user@somewhere.edu"
	 	ConfigTxt[%ServerLogName]="LogGraph.png"
	 	ConfigTxt[%ServerSummaryName]="LogSummary.png"
	 	ConfigTxt[%ServerItxName]="LogGraph.zip"
	 	ConfigTxt[%ServerAddress]="username@server.address:www"
	 	ConfigTxt[%SavePathStr]=""	
	 	ConfigTxt[%defaultLog]="default" 
	 	ConfigTxt[%PostiePathStr]=""// only needed if program is used as standalone
	 	ConfigTxt[%pkzipcPathStr]=""// only needed if program is used as standalone
	 	ConfigTxt[%emailFrom]="Igor@abc.edu"
	 	ConfigTxt[%emailSMTP]="smtp.server.address"
	 	ConfigTxt[%emailFlags]="" // user can add custom Postie flags
	 	ConfigTxt[%emailSubject]="igor wants you to know..."
	 	ConfigTxt[%url]=""
	 	ConfigTxt[%user]=""
	 	ConfigTxt[%pswd]=""
	 		
	endif
	ConfigTxt[%experiment]=ConfigTxt[%defaultLog] // +" "+secs2date(datetime, 0)
	ConfigTxt[%TimeCounter]="00:00:00"
	
	if (strlen(ConfigTxt[%SavePathStr]))
		NewPath /C /O /Q /Z SavePath, ConfigTxt[%SavePathStr]
		string FilesInDirectory=IndexedFile(SavePath, -1, ".ilf" )
		variable BigIndex=0, testIndex
		for (i=0;i<itemsinlist(FilesInDirectory); i+=1)
			sscanf StringFromList(i, FilesInDirectory), ConfigTxt[%defaultLog]+"%d.ilf", testindex
			if (V_Flag)
				BigIndex=max(BigIndex, testindex)
			endif
		endfor
		ConfigTxt[%experiment]+=num2str(BigIndex+1)	
	else	
		PathInfo home
		if (strlen(S_Path))
			NewPath /C /O /Q /Z SavePath, S_path
		else
			NewPath /C /O /Q /Z SavePath, "C:"
		endif
	endif
	
	doWindow LogSetupPanel
	if (V_Flag==0)	// not called from Channel Setup
		fileref=0 // check whether channel setup has been saved 
		open /P=LoggerPath/Z=1 /R fileref as "ChannelSetup.itx"
	 	if (fileref)
	 		close fileref
	 		LoadWave /P=LoggerPath/Q/O/T "ChannelSetup.itx" 		
	 	endif 
	 endif	
 	
 	if (!(exists("Chan"))) // set up Chan wave with default values
 		make /N=(20,2) Chan
		
		setdimlabel 0, 0, null, Chan
 		setdimlabel 0, 1, value, Chan	// current value
 		setdimlabel 0, 2, delta, Chan	// threshold values to trigger recording
 		setdimlabel 0, 3, monitor, Chan	// monitor the channel
		setdimlabel 0, 4, record, Chan	// log the channel
		setdimlabel 0, 5, com, Chan	// com port
		setdimlabel 0, 6, baud, Chan	// baud rate
		setdimlabel 0, 7, stop, Chan	// stop bits
		setdimlabel 0, 8, data, Chan	// data bits
		setdimlabel 0, 9, parity, Chan	// parity
		setdimlabel 0, 10, errors, Chan	// count of read errors
		setdimlabel 0, 11, Ufunc, Chan	// use a user defined function to read value
		setdimlabel 0, 12, FSHvalue, Chan	// FSH alarm value
		setdimlabel 0, 13, FSHstatus, Chan	// FSH alarm status
		setdimlabel 0, 14, DEVvalue, Chan	// Deviation alarm value
		setdimlabel 0, 15, DEVstatus, Chan	// Deviation alarm status
		setdimlabel 0, 16, DEVsetpoint, Chan	// Deviation alarm setpoint
		setdimlabel 0, 17, AxMax, Chan	// Manual axis scaling
		setdimlabel 0, 18, AxMin, Chan	// 
		setdimlabel 0, 19, axis, Chan		// number of axis on which channel should be plotted
				
		Chan[%null][]=nan
		Chan[%delta][0]=0.05
		Chan[%delta][1]=0.5
		Chan[%com][0]=0
		Chan[%com][1]=0
		Chan[%baud][]=19200
		Chan[%stop][]=1
		Chan[%data][]=7
		Chan[%parity][]=2
		Chan[%errors][]=0
		Chan[%Ufunc][]=1
		Chan[%FSHvalue][]=5000
		Chan[%FSHstatus][]=-1 // alarms off
		Chan[%DEVstatus][]=-1 // alarms off
		
		Chan[%axis][]=q+1	

		make /T/N=(10,2) ChanTxt
 		
 		setdimlabel 0, 0, null, ChanTxt
 		setdimlabel 0, 1, AxisLabel, ChanTxt
 		setdimlabel 0, 2, Query, ChanTxt
 		setdimlabel 0, 3, FuncName, ChanTxt
 		setdimlabel 0, 4, FormatStr, ChanTxt
 		setdimlabel 0, 5, ChanName, ChanTxt
 		setdimlabel 0, 6, Terminator, ChanTxt
 		setdimlabel 0, 7, StartChar, ChanTxt
 		setdimlabel 0, 8, portname, ChanTxt
		
		ChanTxt[%null][]=""
		ChanTxt[%AxisLabel][0]="Sim 1 (unit 1)"
		ChanTxt[%AxisLabel][1]="Sim 2 (unit 2)"		
		ChanTxt[%Query][]=""	
		ChanTxt[%FuncName][0]="DL_Simulation1"	
		ChanTxt[%FuncName][1]="DL_Simulation2"
		ChanTxt[%ChanName][0]="Simulation1"	
		ChanTxt[%ChanName][1]="Simulation2"
		ChanTxt[%Terminator][]=""	
		ChanTxt[%StartChar][]=""	
		
	endif
		
	DL_UpdateChan() // For backward compatibility
	Chan[%monitor][]=0
	Chan[%record][]=0
	
	i=0
	string cmd	
		
	// kill unused channel waves
	cmd=wavelist("channel*", ",", "")
	do
		if(strlen(StringFromList(i, cmd, ","))==8 && numtype(str2num(StringFromList(i, cmd, ",")[7,7]))==0)
			i+=1
		else
			cmd=RemoveFromList(StringFromList(i, cmd, ","), cmd , ",")
		endif
	while (i<itemsinlist(cmd, ","))
	cmd+=wavelist("W_display*", ",", "")
	do
		if(strlen(StringFromList(i, cmd, ","))==10 && numtype(str2num(StringFromList(i, cmd, ",")[9,9]))==0)
			i+=1
		else
			cmd=RemoveFromList(StringFromList(i, cmd, ","), cmd , ",")
		endif
	while (i<itemsinlist(cmd, ","))
	cmd[strlen(cmd)-1,strlen(cmd)-1]="" // strip trailing comma
		
	if (strlen(cmd)) // this won't work if they're displayed in LogGraph
		execute "killwaves /Z "+cmd
	endif
	
	for(i=0; i<max(1, DimSize(Chan, 1)); i+=1)		// create channel and display waves
		sprintf cmd, "make /O/N=0 channel%d; ", i
		sprintf cmd, "%s make /O/N=0 W_display%d; ", cmd, i
		execute cmd
	endfor
	make /O /n=0 /D W_time, W_display_time
	SetScale d 0,0,"dat", W_time, W_display_time
	
	// Set communication parameters
	if (exists("VDT2")==4)	
		string portlist= DL_PortList()
		ChanTxt[%portname][]=StringFromList(Chan[%com][q]-1, portlist)
		for(i=0;i<max(1, DimSize(Chan, 1)); i+=1)
			if (strlen(ChanTxt[%portname][i]))
				DL_OpenPort(ChanTxt[%portname][i],Chan[%baud][i], Chan[%stop][i], Chan[%data][i], Chan[%parity][i])			
			endif		
		endfor
	else 
		// no VDT: give a warning - maybe we want to use another communications method 
		// (in this case all channels must have the same comms settings)
		// I've not tested non-VDT communications...
		
		// actually, I don't think we can even compile without VDT2...
		
		doalert 0, "VDT is not present. To use VDT for communications, put a shortcut\rto VDT2 in the Igor Extensions folder and restart Igor."
	endif
	
	

	SetDataFolder savDF		// Restore current DF	
end

function DL_OpenPort(portname, baud, stop, data, parity)
	string portname
	variable baud, stop, data, parity
	
	// VDT2 XOP must be in igor extensions folder for this procedure to compile 
	VDT2 /P=$portname baud=baud, stopbits=stop, databits=data, parity=parity, in=0, out=0, buffer=4096
end

function /T DL_PortList()
	string  S_VDT=""
	if (exists("VDT2")==4)	
		VDTgetPortList2
	endif
	return S_VDT
end

Function DL_UpdateChan()
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt	
	wave Config=root:Packages:RS232Logger:Config	
	wave W_Log=root:Packages:RS232Logger:W_Log	
	variable i		
	
	// update Chan
	if (DimSize(Chan, 0)<20) // for backward compatibility
		Redimension /N=(20,-1) Chan		
		for (i=max(DimSize(Chan, 0), 1)-1; i>0; i-=1)
			Chan[i][]=Chan[i-1][q]
		endfor
	endif	
	setdimlabel 0, 0, null, Chan
	setdimlabel 0, 1, value, Chan	// current value
	setdimlabel 0, 2, delta, Chan	// threshold values to trigger recording
	setdimlabel 0, 3, monitor, Chan	// monitor the channel
	setdimlabel 0, 4, record, Chan	// log the channel
	setdimlabel 0, 5, com, Chan	// com port
	setdimlabel 0, 6, baud, Chan	// baud rate
	setdimlabel 0, 7, stop, Chan	// stop bits
	setdimlabel 0, 8, data, Chan	// data bits
	setdimlabel 0, 9, parity, Chan	// parity
	setdimlabel 0, 10, errors, Chan	// count of read errors
	setdimlabel 0, 11, Ufunc, Chan	// use a user defined function to read value
	setdimlabel 0, 12, FSHvalue, Chan	// FSH alarm value
	setdimlabel 0, 13, FSHstatus, Chan	// FSH alarm status
	setdimlabel 0, 14, DEVvalue, Chan	// Deviation alarm value
	setdimlabel 0, 15, DEVstatus, Chan	// Deviation alarm status
	setdimlabel 0, 16, DEVsetpoint, Chan	// Deviation alarm setpoint
	setdimlabel 0, 17, AxMax, Chan	// Manual axis scaling
	setdimlabel 0, 18, AxMin, Chan	// for Win scaling AxMax=AxMin=-1; for autoscaling AxMax=AxMin=0
	setdimlabel 0, 19, axis, Chan
		
	DL_CleanUpLogGraphAxes() // make sure there's no gaps in axis #s
	
	Chan[%null][]=nan
	Chan[%value][]=NaN
	Chan[%monitor][]=0
	Chan[%record][]=0
	Chan[%AxMax][]=-kdefaultWinScaling
	Chan[%AxMin][]=-kdefaultWinScaling
	Chan[%FSHstatus][]=-1
	Chan[%DEVstatus][]=-1
	Chan[%errors][]=0
	
	// update ChanTxt
	if (DimSize(ChanTxt, 0)<10) // for backward compatibility
		Redimension /N=(10,-1) ChanTxt
		for (i=max(DimSize(ChanTxt, 0), 1)-1; i>0; i-=1)
			ChanTxt[i][]=ChanTxt[i-1][q]
		endfor			
 	endif

	setdimlabel 0, 0, null, ChanTxt
	setdimlabel 0, 1, AxisLabel, ChanTxt
	setdimlabel 0, 2, Query, ChanTxt
	setdimlabel 0, 3, FuncName, ChanTxt
	setdimlabel 0, 4, FormatStr, ChanTxt
	setdimlabel 0, 5, ChanName, ChanTxt
	setdimlabel 0, 6, Terminator, ChanTxt
 	setdimlabel 0, 7, StartChar, ChanTxt
 	setdimlabel 0, 8, portname, ChanTxt		
 	ChanTxt[%null][]=""
 	
 	string portlist= DL_PortList()
	ChanTxt[%portname][]=StringFromList(Chan[%com][q]-1, portlist) // assumes COM ports are in order...
	// if the com order changes loading old log files will mess up the com settings.

	// update ConfigTxt
	if (DimSize(ConfigTxt, 0)<20) // for backward compatibility
		Redimension /N=20 ConfigTxt
		for (i=max(DimSize(ConfigTxt, 0)-1, 1); i>0; i-=1)
			ConfigTxt[i]=ConfigTxt[i-1]
		endfor	
 	endif
 	setdimlabel 0, 0, null, ConfigTxt
 	setdimlabel 0, 1, experiment, ConfigTxt
 	setdimlabel 0, 2, email, ConfigTxt
 	setdimlabel 0, 3, ServerLogName, ConfigTxt
 	setdimlabel 0, 4, ServerSummaryName, ConfigTxt
 	setdimlabel 0, 5, ServerItxName, ConfigTxt
 	setdimlabel 0, 6, ServerAddress, ConfigTxt
 	setdimlabel 0, 7, SavePathStr, ConfigTxt
 	setdimlabel 0, 8, defaultLog, ConfigTxt
 	setdimlabel 0, 9, TimeCounter, ConfigTxt
 	setdimlabel 0, 10, PostiePathStr, ConfigTxt
 	setdimlabel 0, 11, pkzipcPathStr ConfigTxt
 	setdimlabel 0, 12, emailFrom, ConfigTxt
 	setdimlabel 0, 13, emailSMTP, ConfigTxt
 	setdimlabel 0, 14, emailFlags, ConfigTxt
 	setdimlabel 0, 15, emailSubject, ConfigTxt
 	setdimlabel 0, 16, url, ConfigTxt
 	setdimlabel 0, 17, user, ConfigTxt
	setdimlabel 0, 18, pswd, ConfigTxt
 	ConfigTxt[%null]=""

 	// update config
 	if (DimSize(Config, 0)<20) // for backward compatibility
		Redimension /N=20 Config	
		for (i=max(DimSize(Config, 0)-1, 1); i>0; i-=1)
			Config[i]=Config[i-1]
		endfor	
 	endif
 	
	setdimlabel 0, 0, null, Config
 	setdimlabel 0, 1, StopLog, Config
 	setdimlabel 0, 2, Verbose, Config
 	setdimlabel 0, 3, UpdateInterval, Config
 	setdimlabel 0, 4, DisplayRange, Config
 	setdimlabel 0, 5, SaveInterval, Config
 	setdimlabel 0, 6, PublishOnWeb, Config
 	setdimlabel 0, 7, SendEmailAlerts, Config
 	setdimlabel 0, 8, MinInterval, Config
 	setdimlabel 0, 9, update, Config
 	setdimlabel 0, 10, AutoActivateAlarms, Config
 	setdimlabel 0, 11, AAAvalue, Config
 	setdimlabel 0, 12, AutoDeactivateAlarms, Config
 	setdimlabel 0, 13, ADAvalue, Config
 	setdimlabel 0, 14, delay, Config
 	
	 	
 	Config[%null]=nan
 	Config[%StopLog]=1			// 0 to run log, 1 to stop
 	Config[%Verbose]=1			// record stuff to history
 	Config[%UpdateInterval]=1		// minutes, time between time axis autoupdate
 	Config[%DisplayRange]=30	// minutes, range of display for autoupdate
 	Config[%SaveInterval]=5		// minutes, time between saves [and web publishing]
 	Config[%PublishOnWeb]=0
 	Config[%SendEmailAlerts]=0	// 
 	Config[%MinInterval]=60		// seconds, minimum time between recordings
 	Config[%update]=1			// autoupdate time axis to track log
 	Config[%AutoActivateAlarms]=0	// value = channel# +10 to activate when channel value > set value
	Config[%AutoDeactivateAlarms]=0	// value = channel# +20 to activate when channel value < set value
 								// value =0 for no auto activation
 	Config[%delay]=0
 	
 	
 	//update W_Log
 	if (DimSize(W_Log, 0)<20) // for backward compatibility
		Redimension /N=20 W_Log	
		for (i=max(DimSize(W_Log, 0)-1, 1); i>0; i-=1)
			W_Log[i]=W_Log[i-1]
		endfor	
 	endif
 	setdimlabel 0, 0, null, W_Log
 	setdimlabel 0, 1, RecordData, W_Log	// so that we can force a record	
	setdimlabel 0, 2, xRight, W_Log	// high value of time axis	
	setdimlabel 0, 3, i, W_Log		// recorded data index
 	setdimlabel 0, 4, j, W_Log		// display data index
 	setdimlabel 0, 5, ticksRef, W_Log		// ticks value at start of log
 	setdimlabel 0, 6, timeRef, W_Log		// start of log
 	setdimlabel 0, 7, TicksPerSec, W_Log	// ticks per second, to calculate time
 	setdimlabel 0, 8, LastSaveTime, W_Log
 	setdimlabel 0, 9, OnScreen, W_Log	 // redundant
 	setdimlabel 0, 10, rate, W_Log // data acquisition rate, /s
 	setdimlabel 0, 11, LastSummary, W_Log // last summary save time
 	setdimlabel 0, 12, StartTime, W_Log 
 	setdimlabel 0, 13, timeNow, W_Log 
 	setdimlabel 0, 14, recordNext, W_Log
 	setdimlabel 0, 15, its_per_ms, W_Log 
 	
 	W_Log[%null]=nan
 	W_Log[%its_per_ms]=DL_CalibrateComputerSpeed()
 	
end

// -------------------------------------- Data Logger Log Graph -------------------------------------- 

function DL_MakeLogGraph()	
	String savDF= GetDataFolder(1)		// Save current DF for restore.
	NewDataFolder/O/S root:Packages		// Make sure this exists.
	if( DataFolderExists("RS232Logger") )
		SetDataFolder RS232Logger		// Our stuff should be in here.
	else
		doalert 0, "Missing Data Folder!"
	endif 

	wave W_Log=root:Packages:RS232Logger:W_Log
	wave Config=root:Packages:RS232Logger:Config
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	wave W_display_time=root:Packages:RS232Logger:W_display_time
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	
	variable TrackingStatus=1
	if (strlen(WinList("LogGraph",",","WIN:1")))		//	LogGraph exists
		if (strlen(StringByKey("SETAXISFLAGS" ,AxisInfo("LogGraph", "bottom" )))>0)
			TrackingStatus=0 // axis is autoscaled
		endif
		DoWindow /K LogGraph					//	Kill it
	endif
	
	string titleStr=ConfigTxt[%experiment]
	if (W_Log[%i]) // log has been started
		if (DL_LogStatus()==1) // log is active
			titleStr+=" <ACTIVE>"
		else
			titleStr+=" <STOPPED>"
		endif	
	endif
	Display /N=LogGraph/W=(5,40,481,380)/K=2 as titleStr

	variable ax=0, ch=0, i=0
	string cmd, RGBstring, winrec
	
	for (ax=1; ax<11; ax+=1)	// plot the "display" and log waves
		for(ch=0;ch<max(1,DimSize(Chan,1)); ch+=1)
			if (Chan[%axis][ch]==ax)
				sprintf cmd,"AppendToGraph /W=LogGraph /%c=Axis%d W_Display%d vs W_display_time;", 82-6*mod(ax,2), ax, ch
				// %c returns "L" for odd i and "R" for even i		
				sprintf cmd,"%s AppendToGraph /W=LogGraph /%c=Axis%d Channel%d vs W_time", cmd, 82-6*mod(ax,2), ax, ch
				execute cmd		
				// set colours of log waves and axes
				sprintf RGBstring "%d,%d,%d", ((ax==2)||(ax==6))*52224, ((ax==3)||(ax==7))*52224, ((ax==4)||(ax==8))*52224
				sprintf cmd "ModifyGraph /W=LogGraph /Z rgb(channel%d)=(%s); ", ch, RGBstring	
				sprintf cmd "%s ModifyGraph /W=LogGraph axRGB(Axis%d)=(%s);", cmd, ax, RGBstring
				sprintf cmd "%s ModifyGraph /W=LogGraph tlblRGB(Axis%d)=(%s); ", cmd, ax, RGBstring
				sprintf cmd "%s ModifyGraph /W=LogGraph alblRGB(Axis%d)=(%s)", cmd, ax, RGBstring
				execute cmd
				// set display wave and grid colours
				sprintf RGBstring "%d, %d", 48896+((ax==2)||(ax==6))*16384, 48896+ ((ax==3)||(ax==7))*16384
				sprintf RGBstring "%s, %d", RGBstring, 48896+((ax==4)||(ax==8))*16384
				sprintf cmd "ModifyGraph /W=LogGraph /Z rgb(W_display%d)=(%s);", ch, RGBstring
				sprintf cmd "%s ModifyGraph /W=LogGraph gridRGB(axis%d)=(%s)", cmd, ax, RGBstring
				execute cmd
				// label axes
				sprintf cmd "ModifyGraph /W=LogGraph mirror(Axis%d)=1;", ax
				if (strsearch(WinRecreation("", 0 ),"Label Axis"+num2str(ax)+" ",0)==-1)
					sprintf cmd "%s Label /W=LogGraph Axis%d \"%s\";", cmd, ax, ChanTxt[%AxisLabel][ch]
				else
					// axis already labelled with first wave on that axis.
					for (i=0; i<max(1,DimSize(Chan,1)); i+=1)
						if (Chan[%axis][i]==ax)
							sprintf cmd "%s Label /W=LogGraph Axis%d \"%s +\";", cmd, ax, ChanTxt[%AxisLabel][i]
							// append + to the axis label
							break
						endif
					endfor
				endif
				sprintf cmd "%s ModifyGraph /W=LogGraph freePos(Axis%d)={%g,bottom}" , cmd, ax, (1/mod(ax,2)-1)
				//sets axis position to 0 or inf on bottom axis
				execute cmd	
				
			endif
		endfor
	endfor
	
	string ListOfAxes=AxisList("LogGraph")
	ListOfAxes=RemoveFromList("bottom", ListOfAxes) 
	variable Nax=ItemsInList(ListOfAxes) // Nax is number of axes
	variable low, high // space the axes out
	high=0.1+0.1*(Nax<10)+0.1*(Nax<8)+0.1*(Nax<6)+0.1*(Nax<4)+0.5*(Nax==1)
	sprintf cmd, "ModifyGraph /W=LogGraph axisEnab(%s)={0,%g}", StringFromList(0,ListOfAxes), high
	execute cmd
	for(ax=2; ax-1<Nax;ax+=1)
		low=high	
		high=0.1*ax+0.1*(Nax<10)+0.1*(Nax<9)+0.1*(Nax<8)+0.1*(Nax<7)+0.1*(Nax<6)+0.1*(Nax<5)+0.1*(Nax<4)+0.1*(Nax<3)
		sprintf cmd, "ModifyGraph /W=LogGraph /Z axisEnab(%s)={%g,%g}", StringFromList(ax-1,ListOfAxes), low, high
		execute cmd
	endfor			
	ModifyGraph /W=LogGraph margin(left)=72,margin(right)=72, margin(top)=15
	ModifyGraph /W=LogGraph grid=1, zero=1, mirror=1, btLen=3
	ModifyGraph /W=LogGraph mirror(bottom)=2, standoff(bottom)=0
	ModifyGraph /W=LogGraph lblPos=60   //,wbRGB=(60928,60928,60928)
//	ModifyGraph live=1
	ModifyGraph /W=LogGraph dateInfo(bottom)={0,1,0}
	Label /W=LogGraph bottom "Time (hh:mm)"
	SetAxis/W=LogGraph/A/E=0/N=1
	
	SetAxis/A/E=0/N=0 bottom	// so that autoscaling graph will show sensible range
	
	W_log[%xRight]=datetime+Config[%UpdateInterval]*60
	if (numpnts(W_display_time)&&TrackingStatus)		
		SetAxis bottom W_display_time[0], W_log[%xRight]
	else	// Log hasn't started yet, or we've reloaded an old log
		if (TrackingStatus||(numpnts(W_time)==0))
			SetAxis bottom datetime, W_log[%xRight]
		endif
	endif
	
	if (strlen(functionlist("DL_DataLoggerGraphStyle",";", "SUBTYPE:GraphStyle,WIN:Data Logger User Functions.ipf")))
		DL_DataLoggerGraphStyle() // allows user to tweak plot by editing a simple function
	endif	
		
	for (ax=1; ax-1<Nax; ax+=1)
		for (ch=0;ch<max(1,DimSize(Chan,1)); ch+=1)
			if (Chan[%axis][ch]==ax)
				if (chan[%AxMax][ch]==-1 && chan[%AxMin][ch]==-1)
					DL_WinScaleAxis(ax)
				endif
				break
			endif
		endfor				
	endfor
		
	SetDataFolder savDF		// Restore current DF	
	return 1

End

// -------------------------------------- Data Logger Log Settings -------------------------------------- 

Function DL_MakeLogSetupPanel(ctrlName) : ButtonControl
	String ctrlName 
	
	wave Config=root:Packages:RS232Logger:Config
	wave chan=root:Packages:RS232Logger:chan
	wave /T chanTxt=root:Packages:RS232Logger:chanTxt
	
	variable numChan=max(1, DimSize(Chan, 1))
	variable ch, i
	doWindow LogSetupPanel
	if (V_Flag) 
		dowindow /F LogSetupPanel
//		GetWindow LogSetupPanel, wsize
//		MoveWindow /W=LogSetupPanel V_Left, V_Top, V_Left+295*72/ScreenResolution, V_Top+72/ScreenResolution*(315+25*numChan)
	else
		NewPanel /N=LogSetupPanel /K=1 /W=(315,160,610,475+25*numChan) as "Set Log Options"
	endif
	SetVariable setUpInt,pos={70,40}, bodyWidth=50,size={200,16},title="Update interval for tracking (min)", win=LogSetupPanel
	SetVariable setUpInt,limits={0.1,60,1},value= root:Packages:RS232Logger:Config[%UpdateInterval], win=LogSetupPanel
	SetVariable setUpInt, proc=DL_checkRange, win=LogSetupPanel
	SetVariable setRange,pos={70,65}, bodyWidth=50, size={200,16},title="Display range for tracking (min)", win=LogSetupPanel
	SetVariable setRange,limits={1,1440,1},value= root:Packages:RS232Logger:Config[%DisplayRange], win=LogSetupPanel
	SetVariable setRange, proc=DL_checkRange, win=LogSetupPanel
	GroupBox DisplaySettingsBox frame=1, pos={10,20}, size={277,70}, title="Tracking Settings", win=LogSetupPanel
	
	SetVariable setMinInt,pos={70,130}, bodyWidth=50,size={200,16},title="Maximum interval between recordings (s)", win=LogSetupPanel
	SetVariable setMinInt,limits={0,300,1},value= root:Packages:RS232Logger:Config[%MinInterval], win=LogSetupPanel
	SetVariable setSaveInt,pos={70,155}, bodyWidth=50,size={200,16},title="Save interval (min)", win=LogSetupPanel
	SetVariable setSaveInt,limits={3,60,1},value= root:Packages:RS232Logger:Config[%SaveInterval], win=LogSetupPanel
	// find index for threshold values in Chan
	i=DL_GetIndex(chan,"delta")
	for (ch=0; ch<numChan; ch+=1)
		SetVariable $"SetThreshold"+num2str(ch), pos={10,200+25*ch}, size={250,16}, win=LogSetupPanel
		SetVariable $"SetThreshold"+num2str(ch), bodyWidth=70, title="Threshold "+ChanTxt[%AxisLabel][ch], win=LogSetupPanel
		SetVariable $"SetThreshold"+num2str(ch), value=Chan[%d], win=LogSetupPanel
		SetVariable $"SetThreshold"+num2str(ch), value=chan[ch * Dimsize(chan,0) + i]	, win=LogSetupPanel	
		if (Chan[%delta][ch])
			SetVariable $"SetThreshold"+num2str(ch) ,limits={0,inf, alog(floor(log(Chan[%delta][ch])))}, win=LogSetupPanel
			// sets increment to correct order of magnitude, not perfect			
		endif
	endfor
	GroupBox LogSettingsBox frame=1, pos={10,100}, size={277,105+25*ch}, title="Recording Settings", win=LogSetupPanel		
	CheckBox checkWeb,pos={20,225+25*ch},size={16,14},title="Publish log on the web", win=LogSetupPanel
	CheckBox checkWeb,value=Config[%PublishOnWeb]	, proc=DL_WebCheckProc	, win=LogSetupPanel
	CheckBox checkVerbose,pos={20,250+25*ch},size={200,14},title="Verbose mode (saves info to history)", win=LogSetupPanel
	CheckBox checkVerbose,value=Config[%verbose], proc=DL_checkVerboseFunc, win=LogSetupPanel
	Button UpdateWebButton size={100,20},pos={170,220+25*ch}, proc=DL_UpdateWebButtonProc, win=LogSetupPanel
	Button UpdateWebButton title="Update Web", win=LogSetupPanel
	Button SetChannels,pos={20,280+25*ch},size={110,20},proc=DL_MakeChannelSetupPanel,title="Channel Setup...", win=LogSetupPanel
	Button SetChannels, disable=2*(DL_LogStatus()==1), win=LogSetupPanel
	Button Done,pos={230,280+25*ch},size={50,20},title="Done", proc=DL_DoneWithLogSetupPanel
	
	ModifyPanel, fixedSize= 1
	setwindow LogSetupPanel hook=DL_HookLogSetupPanel
end

function DL_HookLogSetupPanel(infoStr)
	String infoStr

	String event= StringByKey("EVENT",infoStr)
	if (stringmatch(event, "activate"))
		Button SetChannels, disable=2*(DL_LogStatus()==1), win=LogSetupPanel
		return 1
	endif
	return 0
end

function DL_checkRange(ctrlName,newRange,varStr,varName)
	String ctrlName, varStr, varName; Variable newRange
	wave config=root:Packages:RS232Logger:Config
	
	if (config[%DisplayRange]<=config[%UpdateInterval])
		DoAlert 0, "Display range must be greater than update interval"
		config[%DisplayRange]=config[%UpdateInterval]+1	
	endif
end

Function DL_WebCheckProc(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	wave config=root:Packages:RS232Logger:config
	if (checked)
		config[%PublishOnWeb]=1
		DL_PrintToHistory("Web Publishing On")
	else
		config[%PublishOnWeb]=0
		DL_PrintToHistory("Web Publishing Off")
	endif
End

Function DL_checkVerboseFunc(ctrlName, checked) : CheckBoxControl
	string ctrlName; variable checked
	wave config=root:Packages:RS232Logger:config
	if (checked)
		config[%verbose]=1
		DL_PrintToHistory("Verbose mode on")
	else
		DL_PrintToHistory("Verbose mode off")
		Config[%verbose]=0
	endif
end

Function DL_DoneWithLogSetupPanel(ctrlName) : ButtonControl
	String ctrlName

	DoWindow /K LogSetupPanel		
End

Function DL_UpdateWebButtonProc(ctrlName) : ButtonControl
	String ctrlName
	wave config=root:Packages:RS232Logger:config
	variable temp=config[%PublishOnWeb]
	config[%PublishOnWeb]=1
	DL_SaveLog()
	config[%PublishOnWeb]=temp
End

// -------------------------------------- Data Logger Main Control Panel -------------------------------------- 

Function DL_MakeLogPanel()

	wave config=root:Packages:RS232Logger:config
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave chan=root:Packages:RS232Logger:chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	variable numChan=max(1, DimSize(Chan, 1))
	if (strlen(WinList("LogPanel",",","WIN:64")))		//	LogPanel exists
		DoWindow /K LogPanel
	endif
	NewPanel /N=LogPanel /K=2 /W=(750,50,1017,305+25*numChan) as "Data Logger"
	Button button_Log,pos={20,15},size={45,20},proc=DL_StartStopLog,title="\\W649", win=LogPanel
	Button button_Log fColor=(16384,65280,16384), win=LogPanel
	Button button_Log,help={"Starts or Stop data logger. Toggles communication with devices"}, win=LogPanel
	Button Reset,pos={20,40},size={45,20},proc=DL_ResetDataLogger, title="Reset", win=LogPanel
	Button Reset, help={"Reset: clear the current log and start over"}, win=LogPanel
	Button Exit,pos={20,65},size={45,20},proc=DL_ExitDataLogger, title="Exit", win=LogPanel
	Button Exit, help={"Exit: close down data logger"}, win=LogPanel

	SetVariable setvarExperimentName,pos={70,40},size={180,20},title="Experiment ID:", win=LogPanel
	SetVariable setvarExperimentName,value= root:Packages:RS232Logger:ConfigTxt[%experiment], win=LogPanel
	SetVariable setvarExperimentName proc=DL_SetExperimentNameProc, win=LogPanel
	SetVariable setvarExperimentName help={"Experiment ID: data will be saved under this name"}, win=LogPanel
	ValDisplay RateValDisplay, pos={70,65}, title="Acquisition Rate :", size={135,15}, frame=0, win=LogPanel
	ValDisplay RateValDisplay, win=LogPanel, value=#root:Packages:RS232Logger:W_Log[%rate]
	ValDisplay RateValDisplay, barmisc={0,100}, format="%5.2f Hz", win=LogPanel
	ValDisplay RateValDisplay, help={"Acquisition Rate: approximate frequency of data readings. Not all data are recorded!"}, win=LogPanel
	SetVariable setvarTimeCounter, pos={200,15},size={50,20},title=" ", frame=0, bodywidth=50, win=LogPanel
	SetVariable setvarTimeCounter,value=ConfigTxt[%TimeCounter], noedit=1, win=LogPanel
	SetVariable setvarTimeCounter, help={"Current time: if time is frozen something bad has happened. Stop & Start log to restart"}, win=LogPanel
	
	SetDrawEnv /W=LogPanel fstyle= 1; DrawText 159,136,"Off"
	SetDrawEnv /W=LogPanel fstyle= 1; DrawText 193,136,"On"
	SetDrawEnv /W=LogPanel fstyle= 1; DrawText 227,136,"Rec"	
	string cmd; variable ch=0
	do	
		ValDisplay $("ChannelValue"+num2str(ch)) win=LogPanel, pos={20,140+25*ch}, title=ChanTxt[%AxisLabel][ch]
		ValDisplay $("ChannelValue"+num2str(ch)) win=LogPanel, help={"Current value for this channel: reads NaN when communications timeout or channel turned off"}
		ValDisplay $("ChannelValue"+num2str(ch)) win=LogPanel, size={120,15}, barmisc={0,100}
		execute "ValDisplay ChannelValue"+num2str(ch)+" win=LogPanel,  value=#root:Packages:RS232Logger:Chan[%value]["+num2str(ch)+"]"		
		
		CheckBox $("checkOff"+num2str(ch)) win=LogPanel, proc=DL_CheckProcChooseChannel, title="", pos={160,140+25*ch}
		CheckBox $("checkOff"+num2str(ch)) win=LogPanel, value=(!chan[%monitor][ch]), mode=1, help={"Off: stop monitoring this channel"}
	
		CheckBox $("checkMon"+num2str(ch)) win=LogPanel, proc=DL_CheckProcChooseChannel, title="", pos={195,140+25*ch}
		CheckBox $("checkMon"+num2str(ch)) win=LogPanel,  value=chan[%monitor][ch], mode=1, help={"On: monitor this channel"}

		CheckBox $("checkLog"+num2str(ch)) win=LogPanel, pos={230,140+25*ch},size={16,14}, mode=0, proc=DL_CheckProcChooseChannel
		CheckBox $("checkLog"+num2str(ch)) win=LogPanel, title="", value=chan[%record][ch], help={"Rec: record data from this channel"}
		
		ch+=1
	while (ch<numChan)		
	GroupBox ChannelsBox win=LogPanel, frame=1, pos={10,100}, size={250,55+25*ch}, title="Channels", win=LogPanel
	Button SetLog,win=LogPanel, pos={20,200+25*ch},size={50,20},proc=DL_MakeLogSetupPanel,title="Log"
	Button SetLog, win=LogPanel, help={"Log Settings: opens log options panel to set acquisition parameters and instrument settings"}
	Button DisplayButton,win=LogPanel, pos={80,200+25*ch},size={50,20},proc=DL_MakeDisplayControlPanel,title="Display"
	Button DisplayButton,win=LogPanel,  help={"Display Settings: scale axes of log graph and choose channels to be displayed"}
	Button FileButton,win=LogPanel, pos={140,200+25*ch},size={50,20},proc=DL_MakeFileControlPanel,title="File"
	Button FileButton, win=LogPanel, help={"File Settings: load and save logs and edit server settings"}
	Button AlarmsButton,win=LogPanel, pos={200,200+25*ch},size={50,20},proc=DL_MakeAlarmPanel,title="Alarms"
	Button AlarmsButton, win=LogPanel, help={"Alarm Settings: define and activate alarms"}
	
	GroupBox SettingsBox frame=1, pos={10,170+25*ch}, size={250,70}, title="Settings", win=LogPanel
	
	ModifyPanel /W=LogPanel, fixedSize= 1
End


Function DL_StartStopLog(ctrlName) : ButtonControl
	String ctrlName
	variable V_Flag, start=0, bg=DL_LogStatus()
	string S_value
	wave W_Log=root:Packages:RS232Logger:W_Log
	wave config=root:Packages:RS232Logger:config
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	
	wave chan=root:Packages:RS232Logger:Chan
	variable ch
	
	ControlInfo /W=LogPanel button_log
	if (strsearch(S_recreation, "title=\"\\\\W649\"", 0 )>0) // we're trying to start log
		start=1
	endif
	//variable status=DL_LogStatus() 
	if (bg==-1) 
		doalert 1, "A background task (other than data logger) is active.\r Do you want to kill this task?"
		if (V_Flag==2) // click=no
			doalert 0, "The current background task has to be stopped before a log can be started"
			return 0
		endif
		CtrlBackground stop // kill any other background process
		bg=0
	endif
	if (start) // we want to start log
		if (bg) // log is already active
			Button button_Log title="\\W616" , fColor=(65280,0,0) // oops...
			print time()+" Error: Tried to start when log was active"
			return 0
		endif
		config[%StopLog]=0
		W_Log[%RecordData]=1	//always record data on restart
		DL_ResetTicksRef() // always reset ticksref for time calculation
		
		//DL_OpenPort(ChanTxt[%portname][i],Chan[%baud][i], Chan[%stop][i], Chan[%data][i], Chan[%parity][i])
		for(ch=0;ch<max(1, DimSize(Chan, 1)); ch+=1)
			if (strlen(ChanTxt[%portname][ch]))
				DL_OpenPort(ChanTxt[%portname][ch],Chan[%baud][ch], Chan[%stop][ch], Chan[%data][ch], Chan[%parity][ch])			
			endif		
		endfor
		
		setbackground DL_LogData()
		CtrlBackground start, period=1, dialogsOK=1, noBurst=1	//start the log	
		Button button_Log title="\\W616", fColor=(65280,0,0)
		Button Reset disable=2, win=LogPanel
		Button Exit disable=2, win=LogPanel
		Button FileButton disable=2, win=LogPanel
		doWindow /K FileControlPanel		
		DL_DoneWithEditLogPanel("")
		

		DoWindow/T LogGraph, ConfigTxt[%experiment]+" log <ACTIVE>"
		DoWindow/T LogPanel "Data Logger <ACTIVE>"
		DL_PrintToHistory("Data Logger Started")		
		
		// commentise these lines for testing
		if (kTesting==0 || kTesting==2)
			SetIgorMenuMode "Windows", "Procedure Window", DisableItem // try to stop user from recompiling
			SetIgorMenuMode "Open File", "Procedure", DisableItem
			SetIgorMenuMode "New", "Procedure", DisableItem
			SetIgorMenuMode "Windows", "Other Windows", DisableItem 
			HideProcedures
		endif
		// uncomment when testing is done!	
		
	else // we want to stop log
		config[%StopLog]=1 // halt log after next pass
		Button button_Log title="\\W649", fColor=(16384,65280,16384), win=LogPanel
		// the next lines in case we were already stopped due to error
		ConfigTxt[%TimeCounter]="00:00:00"
		Button Reset disable=0, win=LogPanel
		Button FileButton disable=0, win=LogPanel
		Button Exit disable=0, win=LogPanel
		DoWindow/T LogGraph, ConfigTxt[%experiment]+" log <STOPPED>"
		DoWindow/T LogPanel "Data Logger <STOPPED>"
		DoWindow /K CommErrorPanel // just in case
		SetIgorMenuMode "Windows", "Procedure Window", EnableItem
		SetIgorMenuMode "Open File", "Procedure", EnableItem
		SetIgorMenuMode "New", "Procedure", EnableItem
		SetIgorMenuMode "Windows", "Other Windows", EnableItem
		if (bg) // don't print if we were already stopped
			// we're stopping an active log, so:
			string cmd="Data Logger Stopped"
			for (ch=0; ch<max(DimSize(Chan, 1), 1); ch+=1)
				if (Chan[%errors][ch]) // there have been read errors - report this in history.
					cmd+="\r	"+ChanTxt[%ChanName][ch]+" read errors: "+num2str(Chan[%errors][ch])
					Chan[%errors][ch]=0 // reset error counter
				endif
			endfor
			DL_PrintToHistory(cmd)			
		endif
	endif	
End

Function DL_SetExperimentNameProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	wave config=root:Packages:RS232Logger:config
	wave /T configTxt=root:Packages:RS232Logger:configTxt
	wave Chan=root:Packages:RS232Logger:Chan
	wave W_Log=root:Packages:RS232Logger:W_Log
	
	
	string StrExpName=CleanupName(varStr, 0)
	variable i=0
	string cmd=""
	do
		if (cmpstr(GetIndexedObjName("root:", 4, i ),StrExpName)==0)			
			cmd="Using this name will overwrite "+StrExpName+" in memory\r"
			break
		endif
		i+=1
	while (i<CountObjects("root:", 4 ))
	
	variable refnum=0
	if (strlen(ConfigTxt[%SavePathStr]))
		open /R/Z=1 /P=SavePath refnum as varStr+".ilf"
		if (V_Flag==0)
			close refnum
			cmd +="Using this name will overwrite the file "+varStr+".ilf\r"
		endif
	endif
	
	if (strlen(cmd))	
		doAlert 0, cmd
	endif
	
	note /k Chan; note Chan, varStr // save experiment name with Chan wave
	
	if (strlen(WinList("LogGraph",",","WIN:1")))		//	LogGraph exists
		varStr+=" log"
		if (W_Log[%i]) // log has been started
			if (DL_LogStatus()==1) // log is active
				varStr+=" <ACTIVE>"
			else
				varStr+=" <STOPPED>"
			endif	
		endif
		DoWindow /T LogGraph, varStr 		//	update graph title
	endif	
End

Function DL_CheckProcChooseChannel(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	// ctrlName can be:
	// checkOff#, checkMon#, checkLog#
	// where # is the channel number of the checkbox clicked, or:
	// AllOff, AllMon, AllLog
	
	wave chan=root:Packages:RS232Logger:chan
	wave W_Log=root:Packages:RS232Logger:W_Log
	
	variable ch, chLow, chHigh
	if (stringmatch(ctrlName, "All*"))
		chLow=0
		chHigh=max(1, DimSize(Chan, 1))
		ctrlName=ctrlName[3,5]
	else
		ch=str2num(ctrlName[strlen(ctrlName)-1])
		// ch is the channel we clicked
		chLow=ch; chHigh=ch+1
		ctrlName=ctrlName[5,7]
	endif
	if (GetKeyState(0)&4) // shift key
		chLow=0
		chHigh=max(1, DimSize(Chan, 1))
	endif
	
	for (ch=chLow; ch<chHigh; ch+=1)	
		strswitch (ctrlName)
			case "Off":
				if (Chan[%record][ch])
					Chan[%record][ch]=0
					W_Log[%recordNext]=11
					// when we stop recording a channel we save a NaN into the current position,
					// and save the previous data so that all data up to present are recorded.
				endif
				Chan[%record][ch]=0
				Chan[%monitor][ch]=0			
				checkbox $"checkMon"+num2str(ch) win=LogPanel, value=0
				checkbox $"checkLog"+num2str(ch) win=LogPanel, value=0
				checkbox $"checkOff"+num2str(ch) win=LogPanel, value=1
				// nb we can call this function from DL_MakeReadErrorPanel()
				break
			case "Mon":
				Chan[%monitor][ch]=1
				checkbox $"checkOff"+num2str(ch) win=LogPanel, value=0
				checkbox $"checkMon"+num2str(ch) win=LogPanel, value=1				
				break		
			case "Log":				
				if (checked) // start recording
					Chan[%monitor][ch]=1
					Chan[%record][ch]=1 
					W_Log[%recordNext]=1 
					// when we start to record a channel we force a recording					
					checkbox $"checkMon"+num2str(ch) win=LogPanel, value=1
					checkbox $"checkLog"+num2str(ch) win=LogPanel, value=1
					checkbox $"checkOff"+num2str(ch) win=LogPanel, value=0				
				elseif(Chan[%record][ch]) // we were recording
					Chan[%record][ch]=0 
					checkbox $"checkLog"+num2str(ch) win=LogPanel, value=0
					W_Log[%recordNext]=11
					// when we stop recording a channel we save a NaN into the current position,
					// and save the previous data so that all data up to present are recorded.		
				endif				
		endswitch
	endfor
End

function DL_ExitDataLogger(ctrlName) : ButtonControl
	string ctrlName
	variable status=DL_LogStatus()
	if (status==1) // log is active
		Button Exit disable=2
		doAlert 0, "You must stop the active log before you can exit from Data Logger"
		return 0 // log is active
	endif
	wave W_Log=root:Packages:RS232Logger:W_Log
	if (W_Log[%i]) // stuff has been recorded
		if (DL_SaveLogToFolder("")==0) // invokes save dialog; returns 0 on No Save
			doalert 1, "You haven't saved the current log. Are you sure you want to exit?"
			if (V_flag==2)
				return 0
			endif
		endif
	endif
	
	DL_DoneWithEditLogPanel("") // kills panel and cleans up
	doWindow /K LogGraph
	doWindow /K LogPanel
	doWindow /K FileControlPanel
	doWindow /K DisplayControlPanel
	doWindow /K EditLogPanel
	doWindow /K ServerSettingsPanel
	KillWaves /Z ConfigTxtTemp 
	doWindow /K AlarmSetupPanel
	BuildMenu "Macros" // update dynamic menu
end

// -------------------------------------- Data Logger Main Loop -------------------------------------- 

Function DL_LogData() // this is the main loop: background function calls this loop while we're active
	wave W_time=root:Packages:RS232Logger:W_time
	wave W_display_time=root:Packages:RS232Logger:W_display_time
	wave config=root:Packages:RS232Logger:config
	wave chan=root:Packages:RS232Logger:chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave W_Log=root:Packages:RS232Logger:W_Log
	
	string cmd
	variable channel=0, k
	variable doLog=0
	variable stop=config[%StopLog] // make sure we know from the start of a cycle that we want to stop
	// so that we can do some housekeeping
	
	// take a reading from each of the monitored channels
	for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
		doLog+=Chan[%record][channel] // find out whether we need to record any data
		if (Chan[%monitor][channel])
			
			if (config[%delay])
				// pause here for config[%delay] microseconds
				 DL_delay(config[%delay])
			endif
			
			// for rs485 networks where instruments inadvisably have different com settings
			// check to see whether we need to change com settings
			if(Chan[%com][channel])
				k=channel
				variable ChangePortSettings=0  
				do
					k-=1
					if (k==-1)
						k=DimSize(Chan,1)-1 // if there's only one channel this still works
			  		endif
			 		if (Chan[%com][channel]==Chan[%com][k])
						// another channel uses the same com port...
						if (Chan[%baud][channel]!=Chan[%baud][k])
			 				ChangePortSettings=1 // ... and a different baud rate
							break
						endif
						if (Chan[%stop][channel]!=Chan[%stop][k])
		 					ChangePortSettings=1
							break
						endif
						if (Chan[%data][channel]!=Chan[%data][k])
							ChangePortSettings=1
							break
						endif
					endif
	            		while (k!=channel)
	            		
		             if (ChangePortSettings&&strlen(ChanTxt[%portname][channel])) //another channel may have used different com settings with our port
					DL_OpenPort(ChanTxt[%portname][channel],Chan[%baud][channel], Chan[%stop][channel], Chan[%data][channel], Chan[%parity][channel])
		            endif       
	            endif 					
			
			variable V_VDT=0
			if (strlen(chantxt[%Query][channel])&&strlen(ChanTxt[%portname][channel])) // send query string to instrument
				VDTOperationsPort2 $ChanTxt[%portname][channel]
				VDT2 killio
				if (cmpstr(chantxt[%Query][channel], num2char(255)) ) // character 255 sets port without writing anything
					VDTwrite2 /O=0.5/Q chantxt[%Query][channel]+"\r"
				endif
			endif
			if (Chan[%Ufunc][channel])	 // use a user defined function to read value 		
				sprintf cmd, "%s[%%value][%d]=%s()", GetWavesDataFolder(chan, 2 ), channel, chantxt[%FuncName][channel]
				execute cmd
			elseif ( strlen(ChanTxt[%FormatStr][channel]) ) // read to a string and parse for data
				string VDTReadStr=""
				variable value
				if (strlen(chantxt[%StartChar][channel]))
					do // keep reading a character until we've read the StartChar
						VDTRead2 /Q/O=0.5/N=1 VDTReadStr
						if (V_VDT==0)
							break
						endif
					while(cmpstr(VDTReadStr, chantxt[%StartChar][channel]))				
				endif
				
				VDTRead2 /T="\t\r"+chantxt[%Terminator][channel] /Q/O=0.5 VDTReadStr
				sscanf VDTReadStr ,ChanTxt[%FormatStr][channel], Value
				if (V_Flag<1)
					value=NaN
				endif
				Chan[%value][channel]=value						
			else // read directly to a variable
				variable VDTReadValue
				if (strlen(chantxt[%Terminator][channel]))
					VDTread2 /Q/T=chantxt[%Terminator][channel] /O=0.5 VDTReadValue
				else
					VDTread2 /Q /O=0.5 VDTReadValue
				endif
				if (V_VDT)
					Chan[%value][channel]=VDTReadValue
				else
					Chan[%value][channel]=NaN
				endif
			endif
			
			DoWindow /K CommErrorPanel // clear any old error warnings					
			if (numtype(Chan[%value][channel])==2) // VDTread or user function returned NaN
				Chan[%errors][channel]+=1
				DL_MakeReadErrorPanel(channel) 
			endif

			if (config[%AutoActivateAlarms])
				if(mod(config[%AutoActivateAlarms], 10)==channel )
					// this is the channel that activates all alarms
					if ((Chan[%value][channel]>config[%AAAvalue])==(config[%AutoActivateAlarms]<20))
						Chan[%FSHstatus][]=Chan[%FSHstatus][q]*(1-(Chan[%FSHstatus][q]==-1))
						Chan[%DEVstatus][]=Chan[%DEVstatus][q]*(1-(Chan[%DEVstatus][q]==-1))
						config[%AutoActivateAlarms]=0
						DL_PrintToHistory("All Alarms Activated")
						DL_UpdateAlarmPanel()
					endif
				endif
			endif
			
			// AutoDeactivate doesn't happen if AutoActivate is set & hasn't tripped
			if (!config[%AutoActivateAlarms]&&config[%AutoDeactivateAlarms])
				if(mod(config[%AutoDeactivateAlarms], 10)==channel ) 
				// this is the channel that deactivates all alarms
					if ((Chan[%value][channel]>config[%ADAvalue])==(config[%AutoDeactivateAlarms]<20))
						Chan[%FSHstatus][]=-1
						Chan[%DEVstatus][]=-1
						config[%AutoDeactivateAlarms]=0
						DL_PrintToHistory("All Alarms Deactivated")	
						DL_UpdateAlarmPanel()		
					endif
				endif
			endif
						
			// FSH alarm status key -1: not in use; 0: in use; 1: tripped
			if (Chan[%FSHstatus][channel]>-1) // FSH alarm in use
				if (Chan[%value][channel]>Chan[%FSHvalue][channel]) // FSH alarm condition
					if (Chan[%FSHstatus][channel]==0)
						DL_DataLoggerFSHAlarm(channel)
						ValDisplay $("ChannelValue"+num2str(channel)) labelBack=(65535,0,0), win=LogPanel
					endif
					Chan[%FSHstatus][channel]=1
				endif
			endif
					
			// deviation alarm status key -1: not in use; 0: in use, not tripped; 1: tripped; 2: active			
			if (Chan[%DEVstatus][channel]>-1) // deviation alarm in use
				if (abs(Chan[%value][channel]-Chan[%DEVsetpoint][channel])>Chan[%DEVvalue][channel]) // DEV alarm condition
					if (Chan[%DEVstatus][channel]<2)
						ValDisplay $("ChannelValue"+num2str(channel)) labelBack=(65535,0,0), win=LogPanel
					endif
					if (Chan[%DEVstatus][channel]==0)
						//do something!!!
						DL_DataLoggerDevAlarm(channel)					
					endif
					Chan[%DEVstatus][channel]=2
				else // inside deviation limit
					if (Chan[%DEVstatus][channel]==2 )
						if (Chan[%FSHstatus][channel]<1) // don't reset indicator if we've tripped FSH
							ValDisplay $("ChannelValue"+num2str(channel)) labelBack=0, win=LogPanel
						endif
						Chan[%DEVstatus][channel]=1
					endif
				endif	
			endif			
						
		else // not monitoring this channel
			Chan[%value][channel]=nan
		endif
	endfor
	
	// calculate the time
	W_Log[%timeNow]=W_Log[%timeRef]+(ticks-W_Log[%ticksRef])/W_Log[%TicksPerSec]
	ConfigTxt[%TimeCounter]=Secs2Time(W_Log[%timeNow],3)	
	
	if (stop)
		ConfigTxt[%TimeCounter]="00:00:00"
	endif
	
	if (doLog || (W_Log[%recordNext]&&W_Log[%i]))	// doLog = # of channels to record	
		
		if ((W_Log[%i]==0) || (mod(trunc(W_Log[%timeNow]-W_Log[%timeRef]),(6*60*60))==0)) // 6 hourly interval
			// this may run many times, or not at all if acquisition rate is too slow.
			variable TimeSyncError=datetime-W_Log[%timeNow]
			if (abs(TimeSyncError)>120) // big time sync error - not just drifting out of sync due to innacurate ticks calculation
				// if time sync error is very large, don't resync - maybe clock has changed
				// will get here every 6 hours, so be careful about printing etc.
				variable nextSec=datetime+1
				do // loop so that we only print the error message once
				while(datetime<nextSec)				
				print date()+" "+time()+" WARNING: Time sync error: "+num2str(TimeSyncError)+" seconds"
				
			elseif (abs(TimeSyncError)>3) // getting out of sync - could be just 2 seconds, though
				DL_ResetTicksRef()
				DL_PrintToHistory("Time sync error of "+num2str(round(TimeSyncError))+" seconds corrected")
			endif	
			
		endif
		
		if (W_Log[%i]==0) // first time through		
			W_Log[%StartTime]=W_Log[%timeNow]
			W_Log[%LastSummary]=W_Log[%timeNow]
		endif
		
		// always put new values in display waves
		InsertPoints W_Log[%j]+1,1, W_display_time
		W_display_time[W_Log[%j]]=W_Log[%timeNow]
		
		for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
			wave W_display=$"root:Packages:RS232Logger:W_display"+num2str(channel)
			InsertPoints W_Log[%j]+1,1, W_display			
			W_display[W_Log[%j]]=Chan[%value][channel]+ 0/Chan[%record][channel]
		endfor
		W_Log[%j]+=1
		// W_Log[%j] is now numpnts(display)

		// calculate data acquisition rate - a rough estimate: if log is stopped and started it'll be confused
		W_Log[%rate]=W_Log[%j]/(W_display_time[inf]-W_display_time[0])					
		
		W_Log[%RecordData]=W_Log[%recordNext]
		W_Log[%recordNext]=0 // this lets us trigger a recording externally
					
		do	// record data if something has changed
			if (W_Log[%i]==0) //first time through
				W_Log[%RecordData]=1
				break
			endif
			for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
				wave w=$"root:Packages:RS232Logger:channel"+num2str(channel)
								
				// if last recorded point is NaN, we trigger a recording with first non-NaN value
				if ( Chan[%record][channel] && numtype(Chan[%value][channel])==0 && numtype(w[W_Log[%i]-1])==2)
					W_Log[%RecordData]+=1*(W_Log[%RecordData]==0)
				endif
				
				if ( Chan[%record][channel] && (abs(Chan[%value][channel]-w[W_Log[%i]-1])>=Chan[%delta][channel]*0.999) )				
					// quick fix to floating point problem
					W_Log[%RecordData]+=1*(W_Log[%RecordData]==0)
					if (abs(Chan[%value][channel]-w[W_Log[%i]-1])>=Chan[%delta][channel]*1.5)	//big jump
						W_Log[%RecordData]+=10	// W_Log[%RecordData]>10 means there was a big jump
					endif
				endif
			endfor		
			if ( config[%MinInterval]<=(W_Log[%timeNow]-W_time[W_Log[%i]-1]) )
				W_Log[%RecordData]+=1
			endif
			if (stop)
				W_Log[%RecordData]+=1
			endif			
		while (0)
	// 	if no big jump, W_Log[%RecordData] < 10
	//	big jump defined as >1.5 * threshold
		
		if (W_Log[%RecordData])
			// if big jump and the previous data weren't recorded, save them too		
			if ((W_Log[%j]>3)&&(W_Log[%RecordData]>10)&&(W_time[W_Log[%i]-1]<W_display_time[W_Log[%j]-2])) 
			//j-2 is point before last in display
				InsertPoints W_Log[%i]+1,1, W_time
				W_time[W_Log[%i]]=W_display_time[W_Log[%j]-2]
				for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
					wave w=$"root:Packages:RS232Logger:channel"+num2str(channel)
					wave w2=$"root:Packages:RS232Logger:W_display"+num2str(channel)
					InsertPoints W_Log[%i]+1,1, w
					w[W_Log[%i]]=w2[W_Log[%j]-2]
				endfor			
				W_Log[%i]+=1
			endif
			
			InsertPoints W_Log[%i]+1,1, W_time
			W_time[W_Log[%i]]=W_Log[%timeNow]
			for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
				wave w=$"root:Packages:RS232Logger:channel"+num2str(channel)				
				InsertPoints W_Log[%i]+1,1, w
				w[W_Log[%i]]=Chan[%value][channel] + 0/Chan[%record][channel]
			endfor			
			W_Log[%i]+=1
		endif
	
		if (stop)	//this forces recording of NaNs, so that if log is restarted there will be a gap		
			InsertPoints W_Log[%i]+1,1, W_time
			W_time[W_Log[%i]]=W_Log[%timeNow]
			InsertPoints W_Log[%j]+1,1, W_display_time
			W_display_time[W_Log[%j]]=W_Log[%timeNow]
			for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
				wave w=$"root:Packages:RS232Logger:channel"+num2str(channel)	
				InsertPoints W_Log[%i]+1,1, w
				w[W_Log[%i]]=NaN
				wave w=$"root:Packages:RS232Logger:W_display"+num2str(channel)
				InsertPoints W_Log[%j]+1,1, w
				w[W_Log[%j]]=NaN
				Chan[%value][channel]=NaN // clears monitored values from LogPanel
			endfor
			W_Log[%i]+=1; W_Log[%j]+=1
			W_Log[%rate]=0 // set acquisition rate estimate to zero
		endif
		
		// update display range if we're within 2s of right axis limit, whether we're tracking or not
		if ( ((W_Log[%timeNow]-W_Log[%xRight])>-2 ) )
			
			variable count=0
			if ( (W_Log[%j]>1)&&(W_display_time[W_Log[%j]-1]>(W_Log[%timeNow]-config[%DisplayRange]*60+config[%UpdateInterval]*60)) )
				do	// equivalent to find level function
					count+=1
				while (W_display_time[count-1]<(W_Log[%timeNow]-config[%DisplayRange]*60+config[%UpdateInterval]*60))
				count-=1
				DeletePoints 0, count, W_display_time
				for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
					wave w=$"root:Packages:RS232Logger:W_display"+num2str(channel)
					DeletePoints 0, count, w
				endfor
				W_Log[%j]-=count				
			endif
			W_Log[%xRight]=W_Log[%timeNow]+config[%UpdateInterval]*60
			if (config[%update]) // LogGraph tracking on
				SetAxis /W=LogGraph bottom W_display_time[0], W_Log[%xRight]
				string ListOfAxes=AxisList("LogGraph")
				ListOfAxes=RemoveFromList("bottom", ListOfAxes) 
				variable Nax=ItemsInList(ListOfAxes) // Nax is number of axes
				variable ax
				for (ax=1; ax-1<Nax; ax+=1)
					for (channel=0; channel<max(1, DimSize(Chan, 1)); channel+=1)
						if (Chan[%axis][channel]==ax)
							if (chan[%AxMax][channel]==-1 && chan[%AxMin][channel]==-1)
								DL_WinScaleAxis(ax)
							endif
							break
						endif
					endfor				
				endfor
				
				doUpdate // update axis range
			endif		
		endif
				
		if ( (config[%SaveInterval]*60<(W_Log[%timeNow]-W_Log[%LastSaveTime])) && (W_Log[%i]>1) )
			DL_SaveLog()
			W_Log[%LastSaveTime]=W_Log[%timeNow]
		endif
				
	else // we're not recording
		if (stop) // we're trying to stop log
			Chan[%value][]=nan // set monitored values to NaN
		endif
	endif
	
	if(stop)
		DL_SaveLogToFolder("") // save log to a data folder  in current Igor experiment
		DL_AutoSaveLogFile() // save data file on hard drive
		if (config[%PublishOnWeb])
			DL_SaveLog() // update www files
			DL_ReplaceLogPicture() // replace history pic with default	
		endif
		DL_UserStop()
	endif
			
	DL_UserBG()
	
	return stop
end

Function DL_Delay(microSeconds)
	variable microSeconds // delay in microseconds
	wave W_log=root:Packages:RS232Logger:W_log
	variable iterations=round(microSeconds*W_log[%its_per_ms]/1000)
	do
		iterations-=1
	while (iterations>0)
	return 1
End

function DL_CalibrateComputerSpeed() // called during initialisation
	variable maxits=2000
	make /o/n=(maxits) W_tempTestCompSpeed
	W_tempTestCompSpeed=DL_MicrosecsToIterate(x)	
	variable K0=0
	CurveFit /N/H="10"/Q line  W_tempTestCompSpeed /D 
	wave W_coef=W_coef
	// remove outliers
	W_tempTestCompSpeed+=0/(W_tempTestCompSpeed/(W_coef[1]*x) < 1.01)
	// do the fit again
	CurveFit /N/H="10"/Q line  W_tempTestCompSpeed /D 
	killwaves W_tempTestCompSpeed	
	
	return round (1000/W_coef[1]) // iterations per millisecond
end

function DL_MicrosecsToIterate(iterations)
	variable iterations
	variable microSeconds // delay in microseconds
	Variable timerRefNum
	iterations+=1	
	timerRefNum = startMSTimer
	do
	iterations-=1
	while(iterations)
	microSeconds = stopMSTimer(timerRefNum)	
	return microseconds
end



function DL_Info(msg)
	string msg
	// kill the panel with << DoWindow /K DL_infoPanel >> when done
	DoWindow /K DL_infoPanel
	variable toolong=max(0, strlen(msg)-32)
	NewPanel /N=DL_infoPanel/W=(150,77,460+toolong*8,261) as "Data Logger Busy"
	SetDrawLayer /W=DL_infoPanel UserBack
	SetDrawEnv /W=DL_infoPanel fsize= 14,fstyle= 1,textrgb= (65280,0,0)
	DrawText /W=DL_infoPanel 40,88, msg
	doupdate
	return 1
end

function DL_MakeReadErrorPanel(channel)
	variable channel
	wave chan=root:Packages:RS232Logger:chan
	wave /T chanTxt=root:Packages:RS232Logger:chanTxt
	
	NewPanel /N=CommErrorPanel/K=1/W=(280,220,660,330) as "Communications Error"	
	SetDrawLayer /W=CommErrorPanel UserBack
	DrawText /W=CommErrorPanel 15,35,"There appears to be a problem with Channel "+num2str(channel)+" ("+ChanTxt[%ChanName][channel]+")"
	DrawText /W=CommErrorPanel 15,65,"To turn this channel off, press escape!"
	
	ModifyPanel /W=CommErrorPanel, fixedSize= 1
	doupdate

	variable waituntil=datetime+3
	do
		if ((GetKeyState(0) & 32) != 0) // esc is pressed
			DL_CheckProcChooseChannel("checkOff"+num2str(channel),1)
			DL_PrintToHistory("Channel "+num2str(channel)+" communications error: channel turned off")
			DoWindow /K CommErrorPanel
			break
		endif
	while(datetime<waituntil)	
end


// -------------------------------------- Data Logger Save Graph -------------------------------------- 

Function DL_SaveLogGraphToFile()	
	Variable i, pos0, pos1, pos2, refnum=0
	String WinRecStr, fileName="LogGraph.itx"
	
	wave Chan=root:Packages:RS232Logger:Chan
	wave /T ChanTxt=root:Packages:RS232Logger:ChanTxt
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave W_time=root:Packages:RS232Logger:W_time
				
	GetWindow LogGraph, wavelist
	Wave/T wlist=W_WaveList
	i=0
	do // remove display waves from list
		if (stringmatch(wlist[i][0], "W_display*"))
			deletepoints i, 1, wlist
		else
			i+=1
		endif
	while (i<DimSize(wlist, 0))
	
	Open /Z/P=LoggerPath refnum as filename
	if (refnum==0)
		KillWaves/Z wlist
		return 0 // failed to save file
	endif
	
	fprintf refnum, "IGOR\r"
	fprintf refnum, "X DoWindow /K WebLogGraph\r"
	fprintf refnum, "X KillStrings S_waveNames\r"
	fprintf refnum, "X NewDataFolder/S/O root:%s\r", CleanupName(ConfigTxt[%experiment], 0)
	close refnum
	
	string noteStr, StrSaveName, WavesToSave="root:Packages:RS232Logger:W_time;"
	
	note /K Chan
	note Chan ConfigTxt[%experiment] // save experiment ID as wavenote
	
	noteStr=note(W_time)
	noteStr=ReplaceStringByKey("ch", noteStr, "W_time", ":", "\r")
	note /k W_time; note W_time, noteStr

	for (i=0; i<max(1, DimSize(Chan, 1)); i+=1)
		wave tempWaveRef=$"root:Packages:RS232Logger:channel"+num2str(i)
		//StrSaveName="channel"+num2str(i)
		WavesToSave+="root:Packages:RS232Logger:channel"+num2str(i)+";"		
		noteStr=note(tempWaveRef)
		noteStr=ReplaceStringByKey("ch", noteStr, "channel"+num2str(i), ":", "\r")
		note /k tempWaveRef; note tempWaveRef, noteStr // save channel # in wavenote so that we can reload log		
	endfor
	WavesToSave+="root:Packages:RS232Logger:Chan;"
	WavesToSave+="root:Packages:RS232Logger:ChanTxt;"
	WavesToSave+="root:Packages:RS232Logger:W_Log;"
	
	Save /A/B/T/P=LoggerPath WavesToSave as "LogGraph.itx"	

	WinRecStr = WinRecreation("LogGraph", 2)
	i = 0	
	do // substitutes trace numbers with paths to waves
		pos0=0
		do
			pos0=strsearch(WinRecStr, wlist[i][2], pos0+1)
			if (pos0 < 0)
				break
			endif
			WinRecStr[pos0,pos0+strlen(wlist[i][2])-1] = PossiblyQuoteName(wlist[i][0])			
		while (1)	
		i += 1
	while (i<DimSize(wlist, 0))
	
	pos0=0; pos1=0; pos2=0
	do
		pos0=pos1
		pos1= strsearch(WinRecStr, "\r", pos0+1)
		if (pos1 == -1)
			break
		endif
		pos2=strsearch(WinRecStr, "##", pos0+1)
		if (pos2<0)
			break
		endif
		if (pos2<pos1) // remove lines with unsubstituted trace #s
			WinRecStr[pos0+1,pos1]=""
			pos0=0; pos1=0; pos2=0
		endif
	while(1)
		
	pos0=0 // add /Z flag to ModifyGraph commands
	do
		pos0= strsearch(WinRecStr, "ModifyGraph", pos0+1)
		if (pos0 == -1)
			break
		endif
		WinRecStr[pos0,pos0+10] = "ModifyGraph /Z"
	while(1)
		
	Open/A/P=LoggerPath refnum as "LogGraph.itx"
	
	pos0= strsearch(WinRecStr, "\r", 0)
	pos0= strsearch(WinRecStr, "\r", pos0+1)+1 // skip a couple of lines
	fprintf refnum,"X Preferences 0\r"
	fprintf refnum,"X Display /K=1 as \"Web Log Graph\"\r"
	String str
	do
		pos1= strsearch(WinRecStr, "\r", pos0) 
		if( (pos1 == -1) %| (cmpstr(WinRecStr[pos0,pos0+2],"End") == 0 ) )
			break
		endif
		str= "X"+WinRecStr[pos0,pos1-1]+";DelayUpdate\r"
		// write the recreation lines with X prepended
		FBinWrite refnum, str
		pos0= pos1+1
	while(1)	
	fprintf refnum,"X ModifyGraph /Z wbRGB=(65535, 65535, 65535);DelayUpdate\r"	
	
	// rename waves to channel names
	for (i=0; i<max(1, DimSize(Chan, 1)); i+=1)
		StrSaveName=CleanupName(ConfigTxt[%experiment]+"_"+ChanTxt[%ChanName][i], 0)
		// only rename wave when there's no conflict with stuff other than waves
		// just in case channel names conflict with a user function or something
		if (exists(strSaveName)<2)
			fprintf refnum, "X killwaves /Z %s\r", strSaveName
			fprintf refnum, "X rename channel%d %s \r", i, strSaveName
		endif
	endfor	
	fprintf refnum, "X killwaves /Z %s\r", CleanupName(ConfigTxt[%experiment]+"_time", 0)
	fprintf refnum, "X Rename W_time %s\r", CleanupName(ConfigTxt[%experiment]+"_time", 0)
	fprintf refnum, "X DoWindow /C WebLogGraph\r"
	fprintf refnum, "X DoWindow /T WebLogGraph \"%s\"\r", ConfigTxt[%experiment]+" Log"	
	// save log settings
	fprintf refnum, "X NewDataFolder/O LogSetup\r"
	fprintf refnum, "X W_Log[%j]=0\r"
	fprintf refnum, "X duplicate /O Chan :LogSetup:Chan\r"
	fprintf refnum, "X duplicate /O ChanTxt :LogSetup:ChanTxt\r"
	fprintf refnum, "X duplicate /O W_Log :LogSetup:W_Log\r"
	fprintf refnum, "X killwaves Chan, ChanTxt, W_Log\r"
		
	fprintf refnum, "X SetDataFolder ::\r" 
	fprintf refnum, "X Preferences 1\r"
	close refnum	
	KillWaves/Z wlist
	return 0
end


// -------------------------------------- Data Logger Summary Layout-------------------------------------- 

function  DL_MakePrintableLog(str) //
	string str
	
	if (DL_LogStatus()==1) // log is active
		DoAlert 0, "Cannot make summary while log is active"
		return 0
	endif
	wave /T ConfigTxt=root:Packages:RS232Logger:ConfigTxt
	wave W_time=root:Packages:RS232Logger:W_time
	
	dowindow /k DL_SummaryLayout
		
	NewLayout/P=Portrait /K=1 /W=(319.5,66.5,838.5,551) /N=DL_SummaryLayout as "Experiment Summary" 
	PrintSettings /I /W=DL_SummaryLayout margins={1 , 0.5 ,1 , 0.5 }, colorMode=0
	
	string title="Experiment: "
	title +=ConfigTxt[%experiment]
	string datestr=Secs2Date(W_time[0],1)
	
	string s_info	
	variable v_left, v_top, v_right, v_bottom	
	
	PrintSettings/W=DL_SummaryLayout getPageDimensions
	s_info=StringByKey("PAGE", s_value)	
	sscanf s_info, "%g,%g,%g,%g",  v_left, v_top, v_right, v_bottom
	
	variable m_top, m_left
	PrintSettings/W=DL_SummaryLayout getPageSettings
	s_info=StringByKey("MARGINS", s_value)
	
	sscanf s_info, "%g,%g,%*g,%*g", m_left, m_top
	v_left+=m_left; v_right+=m_left
	v_top+=m_top; v_bottom+=m_top

	TextBox/N=text_title/F=0/A=LT/X=0/Y=0 title
	TextBox/N=textdate/F=0/A=RT/X=0/Y=0 datestr
	
	s_info=StringByKey("RECT", AnnotationInfo("DL_SummaryLayout", "text_title" ))
	sscanf s_info, "%*g,%*g,%*g,%g", v_top // bottom of title will be top of plot
	
	if(exists("root:Packages:RS232Logger:DL_infostr")) // created by user
		SVAR DL_infostr=root:Packages:RS232Logger:DL_infostr
		if (strlen(DL_infostr))
			TextBox /W=DL_SummaryLayout/N=infobox/F=0/A=MB/X=0/Y=0 DL_infostr
			s_info=StringByKey("RECT", AnnotationInfo("DL_SummaryLayout", "infobox" ))
			sscanf s_info, "%*g,%g,%*g,%*g", v_bottom
		endif
	endif	
	
	AppendLayoutObject /F=0 /R=(v_left, v_top, v_right, v_bottom) /W=DL_SummaryLayout graph LogGraph
	
	doalert 1, "ready to print?"
	if (V_flag==1)
		PrintLayout /C=0 DL_SummaryLayout
	endif
//	DL_UserSummary()	
	return 1
EndMacro



// ---------------------------------- handle log files of type ilf ---------------------------------------------

Function DL_BeforeFileOpenHook(refNum,fileName,pathName,type,creator,kind)
	Variable refNum,kind
	String fileName,pathName,type,creator
	
	Variable handledOpen=0
	
	// Load log files (.ilf)
	if (stringmatch(type, ".ilf"))					
		PathInfo $pathName
		DL_LoadLogFromFile(S_path+fileName)		
		handledOpen=1
	endif
	
	return handledOpen
End

// ---------------- demo functions for default setup (doesn't use communications) ------------

Function DL_Simulation1() // demo function for default setup
	return sin(ticks/960)*sin(ticks/3600)
end

Function DL_Simulation2() // demo function for default setup
	return -2.5+5* (DL_Simulation1()>0)+gnoise(0.1)+sin(ticks/1200)
end