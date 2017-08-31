
;; this makes a list of the WoW windows you have open
WinGet, wowid, list, World of Warcraft 


;; only works in you are in a WoW window
#IfWinActive, World of Warcraft
{  
	;; Ctrl+Space makes everyone jump
	^Space::
	KeyWait, Space, D
	ControlSend,, {Space}, ahk_id %wowid1%
	ControlSend,, {Space}, ahk_id %wowid2%
	ControlSend,, {Space}, ahk_id %wowid3%
	ControlSend,, {Space}, ahk_id %wowid4%
	ControlSend,, {Space}, ahk_id %wowid5%
	Return

	;; Shift+V is on my action bars. It has a mount
	+v::
	KeyWait, v, D
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid1%
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid2%
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid3%
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid4%
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid5%
	Return	

	;; E is my main GSE macro keybind
	;; I have added a macro to my numpad 2 for my slaves with /assist LEADCHARNAME
	e::
	KeyWait, e, D
	ControlSend,, {Numpad2}, ahk_id %wowid1%
	Sleep 150
	ControlSend,, {e}, ahk_id %wowid1% 

	ControlSend,, {Numpad2}, ahk_id %wowid2%
	Sleep 150
	ControlSend,, {e}, ahk_id %wowid2% 

	ControlSend,, {Numpad2}, ahk_id %wowid3%
	Sleep 150
	ControlSend,, {e}, ahk_id %wowid3% 

	ControlSend,, {Numpad2}, ahk_id %wowid4%
	Sleep 150
	ControlSend,, {e}, ahk_id %wowid4% 

	ControlSend,, {Numpad2}, ahk_id %wowid5%
	Sleep 150
	ControlSend,, {e}, ahk_id %wowid5% 	
	Return

	;; F2 is my IWT Button
	;; Numpad2 is my assist Macro
	F2::
	KeyWait, F2, D
	ControlSend,, {Numpad2}, ahk_id %wowid1%
	Sleep 150
	ControlSend,, {F2}, ahk_id %wowid1% 

	ControlSend,, {Numpad2}, ahk_id %wowid2%
	Sleep 150
	ControlSend,, {F2}, ahk_id %wowid2% 

	ControlSend,, {Numpad2}, ahk_id %wowid3%
	Sleep 150
	ControlSend,, {F2}, ahk_id %wowid3% 

	ControlSend,, {Numpad2}, ahk_id %wowid4%
	Sleep 150
	ControlSend,, {F2}, ahk_id %wowid4% 

	ControlSend,, {Numpad2}, ahk_id %wowid5%
	Sleep 150
	ControlSend,, {F2}, ahk_id %wowid5% 	
	Return

	;; Break Follow
	Down::
	KeyWait, Down, D
	ControlSend,, {Down}, ahk_id %wowid1%
	ControlSend,, {Down}, ahk_id %wowid2%
	ControlSend,, {Down}, ahk_id %wowid3%
	ControlSend,, {Down}, ahk_id %wowid4%
	ControlSend,, {Down}, ahk_id %wowid5%	
	Return


	;; Assist by itself
	Numpad2::
	KeyWait, Numpad2, D
	ControlSend,, {Numpad2}, ahk_id %wowid1%
	ControlSend,, {Numpad2}, ahk_id %wowid2%
	ControlSend,, {Numpad2}, ahk_id %wowid3%
	ControlSend,, {Numpad2}, ahk_id %wowid4%
	ControlSend,, {Numpad2}, ahk_id %wowid5%	
	Return

	;; Spare macro button
	Numpad3::
	KeyWait, Numpad3, D
	ControlSend,, {Numpad3}, ahk_id %wowid1%
	ControlSend,, {Numpad3}, ahk_id %wowid2%
	ControlSend,, {Numpad3}, ahk_id %wowid3%
	ControlSend,, {Numpad3}, ahk_id %wowid4%
	ControlSend,, {Numpad3}, ahk_id %wowid5%	
	Return

}