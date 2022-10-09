@echo off
rem Settings. Please modify these as needed.
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

echo Multi-Client: Running instances %YYEXTOPT_MultiClient_Number_Of_Clients%
if %YYPLATFORM_name% EQU HTML5 goto WebClient
if %YYPLATFORM_name% EQU operagx goto WebClient
goto main
:WebClient
set /a "NumOfInsts=%NumOfInsts%-1"
set /a "MaxClients=%MaxClients%+1"
:main


for /l %%x in (1, %MaxClients%, %NumOfInsts%) do (
	:: Windows
	if %YYPLATFORM_name% EQU Windows (
		start /b cmd /C %YYruntimeLocation%\Windows\x64\runner.exe -game "%YYoutputFolder%\%YYprojectName%.win"
	)
	
	if %YYPLATFORM_name% EQU HTML5 (
		start /b cmd /C explorer "%YYPREF_default_web_address%:%YYPREF_default_webserver_port%"
	)
	
	if %YYPLATFORM_name% EQU operagx (
		start /b cmd /C "%localappdata%\Programs\Opera GX\opera.exe" http://localhost:%YYPREF_default_webserver_port%/runner.html?game=%YYPLATFORM_option_operagx_game_name%
	)
)

if %YYPLATFORM_name% NEQ operagx (
	if %YYPLATFORM_name% NEQ HTML5 goto exitIgor
)
goto WebClientExit
:exitIgor
echo Multi-Client: This will exit with a exit code of 1. Igor will "fail". This is intentional.
exit 1

:WebClientExit
echo Multi-Client: Task completed!
exit 0
