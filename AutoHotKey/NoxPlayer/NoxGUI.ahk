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
	ahkid := winlist%A_Index%
	WinGetPos, , , W, H, ahk_id %ahkid%	

	delta := W/H

	if delta < 0.1 then	
	{
		;msgbox NO %delta% %W% %H% 
		Continue
	}
	else 
	{
		;msgbox YES %delta% %W% %H% 
		oWinList.push(winlist%A_Index%)
	}
}
/*
==========================================================================
Interprets the "ControlClick" command into a broadcastable function.
==========================================================================
*/
SendClickToWindows(objWindows, xx, yy, WhichButton := "LEFT", ClickCount := 1, Options := "")
{
    SetControlDelay, -1
    for index, winID in objWindows
    {	
		WinGetPos, , , Width, Height, ahk_id %winID%
		xCoOrd := Width * xx
		yCoOrd := Height * yy
		;msgbox %Width%, %Height%, %winID% `nx%xx% y%yx% `nx%xCoOrd% y%yCoOrd%
		ControlClick, x%xCoOrd% y%yCoOrd%, ahk_id %winID%, , %WhichButton%, %ClickCount%, %options%
    }
    ;msgbox %Width%, %Height%, %winID% `nx%xx% y%yy% `nx%xCoOrd% y%yCoOrd%
}	

/*
==========================================================================
Interprets the "ControlClick" command into a broadcastable function.
==========================================================================
*/
SendClickToWindow(objWindows, windowNumber, xxx, yyy, WhichButtons := "LEFT", ClickCounts := 1, Optionss := "")
{
    SetControlDelay, -1
    singleID := objWindows[windowNumber]
	WinGetPos, , , Widthx, Heighty, ahk_id %singleID%
	xCoOrdx := Widthx * xxx
	yCoOrdy := Heighty * yyy
	ControlClick, x%xCoOrdx% y%yCoOrdy%, ahk_id %singleID%, , %WhichButtons%, %ClickCounts%, %optionss%
}

;;;;;; Variables

middle = 0.5

; bottom Buttons
bottomY 	= 	0.94
bottomX1 	= 	0.17
bottomX2 	=	0.32
bottomX3 	:=	middle
bottomX4 	=	0.68
bottomX5 	=	0.84

; top bar
topBarY		=	0.1
topBarX		:=	middle
; char List
charlistY	=	0.42
charlistX	:=	middle
; char list tow
rowY1	=	0.19
rowY2	=	0.30
rowY3	=	0.40
rowY4	=	0.52
rowY5	=	0.63
rowY6	=	0.74
rowY7	=	0.84
; collection
collectX := [0.48, 0.54, 0.61, 0.67, 0.73, 0.79, 0.86] 
collectY := [0.78, 0.82, 0.55, 0.60, 0.65, 0.72, 0.38, 0.44, 0.50, 0.21, 0.28] 
; delay
sleepdelay = 120

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Gui, Destroy
Gui, Margin, 5, 5
Gui, font, s8, Verdana 

Gui, Add, Button, xm ym 	w70 h25 gOpenApp, Open App
Gui, Add, Button, x+5 yp 	w95 h25 gCharacterList, Character List
Gui, Add, Button, x+5 yp 	w95 h25 gTurnInMission, Turn in Mission
Gui, Add, Button, x+5 yp 	w95 h25 gCollectRowAll, Collect All


Gui, Add, Text, xm y+5 w370 h1 0x7

Gui, Add, Button, xm y+5 	w70 h25 gMissions, Missions
Gui, Add, Button, x+5 yp 	w70 h25 gRecruits, Recruit
Gui, Add, Button, x+5 yp 	w70 h25 gMap, World Map
Gui, Add, Button, x+5 yp 	w70 h25 gChamps, Followers
Gui, Add, Button, x+5 yp 	w70 h25 gClassHall, Research

;Gui, Add, Text, xm y+5 w370 h1 0x7

;Gui, Add, Button, xm y+5 	w95 h25 gCharacterList, Character List
;Gui, Add, Button, x+5 yp 	w95 h25 gTurnInMission, Turn in Mission
;Gui, Add, Button, x+5 yp 	w95 h25 gCollectRowAll, Collect All

;Gui, Add, Text, xm y+5 w370 h1 0x7	

;Gui, Add, Button, xm y+5 	w70 h25 gCollectRowAll, Collect All
;Gui, Add, Button, x+5 yp 	w70 h25 gCollectRow1, Collect R1
;Gui, Add, Button, x+5 yp 	w70 h25 gCollectRow2, Collect R2
;Gui, Add, Button, x+5 yp 	w70 h25 gCollectRow3, Collect R3
;Gui, Add, Button, x+5 yp 	w70 h25 gCollectRow4, Collect R4


Gui, Add, Text, xm y+5 w370 h1 0x7	

Gui, Add, Button, xm y+5 	w48 h25 gRow1, Row 1
Gui, Add, Button, x+5 yp 	w48 h25 gRow2, Row 2
Gui, Add, Button, x+5 yp 	w48 h25 gRow3, Row 3
Gui, Add, Button, x+5 yp 	w48 h25 gRow4, Row 4
Gui, Add, Button, x+5 yp 	w48 h25 gRow5, Row 5
Gui, Add, Button, x+5 yp 	w48 h25 gRow6, Row 6
Gui, Add, Button, x+5 yp 	w48 h25 gRow7, Row 7

Gui, Add, Text, xm y+5 w370 h1 0x7

;Gui, Add, Button, xm y+5 	w48 h25 gTeam1, Team 1
;Gui, Add, Button, x+5 yp 	w48 h25 gTeam2, Team 2
;Gui, Add, Button, x+5 yp 	w48 h25 gTeam3, Team 3
;Gui, Add, Button, x+5 yp 	w48 h25 gTeam4, Team 4
;Gui, Add, Button, x+5 yp 	w48 h25 gTeam5, Team 5
;Gui, Add, Button, x+5 yp 	w48 h25 gTeam6, Team 6
;Gui, Add, Button, x+5 yp 	w48 h25 gTeam7, Team 7


Gui, Show

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#::
	Gui, Show
	Return
f10::
	Reload
	Return
GuiEscape:
	Gui, Destroy
	Return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OpenApp:
	Gui, Submit, NoHide
	SendClickToWindows(oWinList, 0.89, 0.57)
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CharacterList:
	Gui, Submit, NoHide
	Gui, color, 00ff00
	Gui, Show	
	SendClickToWindows(oWinList, middle, bottomY)
	sleep %sleepdelay%
    SendClickToWindows(oWinList, middle, topBarY)
    sleep %sleepdelay%
    SendClickToWindows(oWinList, middle, charlistY)
	Gui, color, E1E1E1
	Gui, Show    
	return
TurnInMission:
	Gui, Submit, NoHide
	Gui, color, 00ff00
	Gui, Show
    SendClickToWindows(oWinList, bottomX1, 0.79)

    longdelay := sleepdelay * 15

    sleep %longdelay%

    SendClickToWindows(oWinList, 0.92, 0.18)
	Gui, color, E1E1E1
	Gui, Show    
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Missions:
	Gui, Submit, NoHide
	; 0.17
    SendClickToWindows(oWinList, bottomX1, bottomY)
	return
Recruits:
	Gui, Submit, NoHide
	; 0.33
    SendClickToWindows(oWinList, bottomX2, bottomY)
	return
Map:
	Gui, Submit, NoHide
	; 0.50
    SendClickToWindows(oWinList, bottomX3, bottomY)
	return
Champs:
	Gui, Submit, NoHide
	; 0.66
    SendClickToWindows(oWinList, bottomX4, bottomY)
	return
ClassHall:
	Gui, Submit, NoHide
	; 0.83
    SendClickToWindows(oWinList, bottomX5, bottomY)
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Row1:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, middle, rowY1)
	return
Row2:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, middle, rowY2)
	return
Row3:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, middle, rowY3)
	return
Row4:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, middle, rowY4)
	return
Row5:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, middle, rowY5)
	return	
Row6:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, middle, rowY6)
	return	
Row7:
	Gui, Submit, NoHide
    SendClickToWindows(oWinList, middle, rowY7)
	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Team1:
	Gui, Submit, NoHide
	SendClickToWindow(oWinList, 1, middle, rowY2)	
	SendClickToWindow(oWinList, 2, middle, rowY5)	
	SendClickToWindow(oWinList, 3, middle, rowY6)	
	SendClickToWindow(oWinList, 4, middle, rowY5)	
	SendClickToWindow(oWinList, 5, middle, rowY5)	
	return
Team2:
	Gui, Submit, NoHide
	SendClickToWindow(oWinList, 2, middle, rowY5)
	SendClickToWindow(oWinList, 5, middle, rowY5)
	SendClickToWindow(oWinList, 3, middle, rowY6)
	SendClickToWindow(oWinList, 1, middle, rowY2)
	SendClickToWindow(oWinList, 4, middle, rowY5)
	return
Team3:
	Gui, Submit, NoHide
	SendClickToWindow(oWinList, 2, middle, rowY2)
	SendClickToWindow(oWinList, 5, middle, rowY6)
	SendClickToWindow(oWinList, 3, middle, rowY4)
	SendClickToWindow(oWinList, 1, middle, rowY1)
	SendClickToWindow(oWinList, 4, middle, rowY1)
	return
Team4:
	Gui, Submit, NoHide
    SendClickToWindow(oWinList, 4, middle, rowY4)




	return
Team5:
	Gui, Submit, NoHide
    SendClickToWindow(oWinList, 5, middle, rowY5)




	return	
Team6:
	Gui, Submit, NoHide
    SendClickToWindow(oWinList, 1, middle, rowY6)




	return	
Team7:
	Gui, Submit, NoHide
    SendClickToWindow(oWinList, 1, middle, rowY7)




	return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CollectRowAll:
	Gui, Submit, NoHide
	Gui, color, 00ff00
	Gui, Show
	for i, j in collectY
	{
		for k, l in collectX
		{
			SendClickToWindows(oWinList, l, j)
			sleep %sleepdelay%
		}
		sleep %sleepdelay%
	}
	Gui, color, E1E1E1
	Gui, Show
	;SplashTextOn,45,, Done!
	;Sleep 1500
	;SplashTextOff
	return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
