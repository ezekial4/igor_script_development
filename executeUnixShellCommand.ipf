#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function/S ExecuteUnixShellCommand(uCommand, printCommandInHistory, printResultInHistory)
	String uCommand				// Unix command to execute
	Variable printCommandInHistory
	Variable printResultInHistory

	if (printCommandInHistory)
		printf "Unix command: %s\r", uCommand
	endif

	String cmd
	sprintf cmd, "do shell script \"%s\"", uCommand
	ExecuteScriptText/Z cmd

	if (printResultInHistory)
		Print S_value
	endif

	return S_value
End