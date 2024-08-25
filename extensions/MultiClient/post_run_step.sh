#!/bin/bash
Exec=$YYprojectName
Exec="${Exec/-/_}"
NumOfInsts=$(($YYEXTOPT_MultiClient_Number_Of_Clients))

if [ $YYdebug = True ]; then
	exit 0
fi

if [ "$YYPLATFORM_name" = "macOS" ]; then
	for (( i=1; i<$NumOfInsts; i++ ))
	do
		if [[ $YYTARGET_runtime = VM ]]; then
			open -n "$YYruntimeLocation/mac/YoYo Runner.app" --args -game "$YYoutputFolder/game.ios" -runTest 
		fi

		if [[ $YYTARGET_runtime = YYC ]]; then
			open -n "/Users/$USER/GameMakerStudio2/GM_MAC/$YYprojectName/$Exec.app" --args —mc-window-number $i 
		fi
	done
fi

if [ "$YYPLATFORM_name" = "HTML5" ]; then
	for (( i=1; i<$NumOfInsts; i++ ))
	do
		open -u "$YYEXTOPT_MultiClient_GM_Web_Fallback_Address:$YYEXTOPT_MultiClient_GM_Web_Fallback_Port/index.html?mc-window-number=$i"
	done
fi