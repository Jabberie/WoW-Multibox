#Warn
#NoEnv
#SingleInstance Force

/*
======================================================================
Get handles to all windows for a given executable and load them into an object.
======================================================================
*/
winget, winList, list, ahk_exe nox.exe
oWinList := object()
loop, % winlist
{
oWinList.push(winlist%A_Index%)
}

/*
==========================================================================
Interprets the "ControlClick" command into a broadcastable function.
==========================================================================
*/
SendClickToWindows(objWindows, x, y, WhichButton := "LEFT", ClickCount := 1, Options := "")
{
    SetControlDelay, -1
    for index, winID in objWindows
    {
        ControlClick, x%x% y%y%, ahk_id %winID%, , %WhichButton%, %ClickCount%, %options%
    }
}

[::
	Gui, Destroy
	Gui, Margin, 5, 5
	Gui, font, s8, Verdana 

	Gui, Add, Button, xm y+5 	w70 h25 gMissions, Missions
	Gui, Add, Button, x+5 yp 	w70 h25 gRecruits, Recruit
	Gui, Add, Button, x+5 yp 	w70 h25 gMap, World Map
	Gui, Add, Button, x+5 yp 	w70 h25 gChamps, Followers
	Gui, Add, Button, x+5 yp 	w70 h25 gClassHall, Research

	Gui, Add, Text, xm y+5 w370 h1 0x7
	
	Gui, Add, Button, xm y+5 	w95 h25 gCharacterList, Character List
	Gui, Add, Button, x+5 yp 	w95 h25 gTurnInMission, Turn in Mission
	Gui, Add, Button, x+5 yp 	w95 h25 gCloseMission, Close Mission

	Gui, Add, Text, xm y+5 w370 h1 0x7	

	Gui, Add, Button, xm y+5 	w48 h25 gRow1, Row 1
	Gui, Add, Button, x+5 yp 	w48 h25 gRow2, Row 2
	Gui, Add, Button, x+5 yp 	w48 h25 gRow3, Row 3
	Gui, Add, Button, x+5 yp 	w48 h25 gRow4, Row 4
	Gui, Add, Button, x+5 yp 	w48 h25 gRow5, Row 5
	Gui, Add, Button, x+5 yp 	w48 h25 gRow6, Row 6
	Gui, Add, Button, x+5 yp 	w48 h25 gRow7, Row 7
	
	Gui, Add, Text, xm y+5 w370 h1 0x7

	Gui, Show
	return

CharacterList:
	Gui, Submit, NoHide
	SendClickToWindows(oWinList, 174, 560)
	sleep 50
    SendClickToWindows(oWinList, 150, 50)
    sleep 50
    SendClickToWindows(oWinList, 150, 250)
	return

TurnInMission:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 55, 480)
	return

CloseMission:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 320, 115)
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Missions:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 55, 570)
	return

Recruits:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 110, 570)
	return

Map:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 174, 560)
	return

Champs:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 230, 570)
	return

ClassHall:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 290, 570)
	return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Row1:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 174, 120)
	return

	Gui, Submit, NoHide
Row2:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 174, 185)
	return

Row3:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 174, 250)
	return

Row4:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 174, 315)
	return

Row5:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 174, 380)
	return	

Row6:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 174, 445)
	return	

Row7:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, 174, 510)
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
F10::
	Reload
