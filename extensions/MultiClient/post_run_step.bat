@echo off
set "MCVersion=1.0.1"
set "NumOfInsts=%YYEXTOPT_MultiClient_Number_Of_Clients%"
set "ExecuteInDebug=%YYEXTOPT_MultiClient_Enable_Debug_Mode%"
set "MaxClients=1"

if %YYPLATFORM_name% NEQ operagx if %YYPLATFORM_name% NEQ HTML5 if %YYPLATFORM_name% NEQ Windows (
	echo Multi-Client: This does not work on other platforms at this time.
	exit 0
) 

rem Main Execution. 
if %YYdebug% EQU True (
	if %YYPLATFORM_name% NEQ operagx (
		if %YYPLATFORM_name% NEQ HTML5 (
			echo Multi-Client: Warning - This doesn't fully support debug mode. By default this is off within the extension options!
			if %ExecuteInDebug% EQU False (
				echo Multi-Client: Workaround not enabled... Exiting safely...
				exit 0
			) else (
				echo Multi-Client: ExecuteInDebug is set to True, will attempt workaround...
				set /A NumOfInsts=%NumOfInsts%+4
			)
		)
	)
)

echo -------------------------
echo Multi-Client v%MCVersion%: Running instances %YYEXTOPT_MultiClient_Number_Of_Clients%
echo -------------------------
if %YYPLATFORM_name% EQU HTML5 goto WebClient
if %YYPLATFORM_name% EQU operagx goto WebClient
goto main
:WebClient
set /a "NumOfInsts=%NumOfInsts%-1"
set /a "MaxClients=%MaxClients%+1"
if [%YYPREF_default_web_address%]==[] (
	echo -------------------------
	echo Multi-Client v%MCVersion%: Failed to find YYPREF_default_web_address ^& YYPREF_default_webserver_port. Is Web runner running? 
	if %YYEXTOPT_MultiClient_Use_GM_Web_Fallback% EQU False (
		echo Multi-Client v%MCVersion%: Use_GM_Web_Fallback is set to False. Please ensure that webserver is running or set Use_GM_Web_Preset to True.
		echo -------------------------
		exit 1
	)
	
	echo Multi-Client v%MCVersion%: Use_GM_Web_Fallback is set to True. Using preset.
	echo Multi-Client v%MCVersion%: Defaulting to 127.0.0.1:51264
	echo -------------------------
	set YYPREF_default_web_address=%YYEXTOPT_MultiClient_GM_Web_Fallback_Address%
	set YYPREF_default_webserver_port=%YYEXTOPT_MultiClient_GM_Web_Fallback_Port%
)
:main

for /l %%x in (1, %MaxClients%, %NumOfInsts%) do (
	:: Windows
	if %YYPLATFORM_name% EQU Windows (
		start /b cmd /C %YYruntimeLocation%\Windows\x64\runner.exe -game "%YYoutputFolder%\%YYprojectName%.win" —mc-window-number %%x
	)
	
	if %YYPLATFORM_name% EQU HTML5 (
		start /b %YYPREF_default_web_address%:%YYPREF_default_webserver_port%?mc-window-number=%%x
	)
	
	if %YYPLATFORM_name% EQU operagx (
		start /b %YYPREF_default_web_address%:%YYPREF_default_webserver_port%/runner.html?game=%YYPLATFORM_option_operagx_game_name%^&mc-window-number=%%x
	)
)

if %YYPLATFORM_name% NEQ operagx (
	if %YYPLATFORM_name% NEQ HTML5 goto exitIgor
)
goto WebClientExit
:exitIgor
echo -------------------------
echo Multi-Client v%MCVersion%: This will exit with a exit code of 1. Igor will "fail". This is intentional.
echo -------------------------
exit 1

:WebClientExit
echo -------------------------
echo Multi-Client v%MCVersion%: Task completed!
echo -------------------------
exit 0
