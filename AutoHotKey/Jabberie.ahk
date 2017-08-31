WinGet, wowid, list, World of Warcraft

#IfWinActive, World of Warcraft
{  
	^Space::
	KeyWait, Space, D
	ControlSend,, {Space}, ahk_id %wowid1%
	ControlSend,, {Space}, ahk_id %wowid2%
	ControlSend,, {Space}, ahk_id %wowid3%
	ControlSend,, {Space}, ahk_id %wowid4%
	ControlSend,, {Space}, ahk_id %wowid5%
	Return

	+v::
	KeyWait, v, D
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid1%
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid2%
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid3%
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid4%
	ControlSend,, {shift down}v{shift up}, ahk_id %wowid5%
	Return	

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

	Down::
	KeyWait, Down, D
	ControlSend,, {Down}, ahk_id %wowid1%
	ControlSend,, {Down}, ahk_id %wowid2%
	ControlSend,, {Down}, ahk_id %wowid3%
	ControlSend,, {Down}, ahk_id %wowid4%
	ControlSend,, {Down}, ahk_id %wowid5%	
	Return

	Numpad2::
	KeyWait, Numpad2, D
	ControlSend,, {Numpad2}, ahk_id %wowid1%
	ControlSend,, {Numpad2}, ahk_id %wowid2%
	ControlSend,, {Numpad2}, ahk_id %wowid3%
	ControlSend,, {Numpad2}, ahk_id %wowid4%
	ControlSend,, {Numpad2}, ahk_id %wowid5%	
	Return

	Numpad3::
	KeyWait, Numpad3, D
	ControlSend,, {Numpad3}, ahk_id %wowid1%
	ControlSend,, {Numpad3}, ahk_id %wowid2%
	ControlSend,, {Numpad3}, ahk_id %wowid3%
	ControlSend,, {Numpad3}, ahk_id %wowid4%
	ControlSend,, {Numpad3}, ahk_id %wowid5%	
	Return

}