#include "BasicWindowLayout.Common.iss"

objectdef bwlSession
{
    variable taskmanager TaskManager=${LMAC.NewTaskManager["bwlSession"]}
    variable bwlSettings Settings

    variable bool Applied

    method Initialize()
    {
        LavishScript:RegisterEvent[On Activate]
        LavishScript:RegisterEvent[OnWindowStateChanging]
		LavishScript:RegisterEvent[OnMouseEnter]
		LavishScript:RegisterEvent[OnMouseExit]
        LavishScript:RegisterEvent[OnHotkeyFocused]

        Event[On Activate]:AttachAtom[This:OnActivate]
        Event[OnWindowStateChanging]:AttachAtom[This:OnWindowStateChanging]
		Event[OnMouseEnter]:AttachAtom[This:OnMouseEnter]
		Event[OnMouseExit]:AttachAtom[This:OnMouseExit]
        Event[OnHotkeyFocused]:AttachAtom[This:OnHotkeyFocused]

        This:EnableHotkeys
        FocusClick eat
    }

    method Shutdown()
    {
        This:DisableHotkeys
        TaskManager:Destroy
    }
 
    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
           This:ApplyWindowLayout2[${setOtherSlots}]    
    }

    method ApplyWindowLayout2(bool setOtherSlots=TRUE)
    {
        variable int whichMonitor=4

        variable int monitorL=${Display.Monitor[${whichMonitor}].Left}
        variable int monitorT=${Display.Monitor[${whichMonitor}].Top}

        variable uint smallHeight=${Display.Monitor[${whichMonitor}].Height}/2
        variable uint smallWidth=${Display.Monitor[${whichMonitor}].Width}/2     

        variable int x1=${monitorL}
        variable int x2=${x1}
        x2:Inc["${smallWidth}"]
        variable int y1=${monitorT}
        variable int y2=${y1}
        y2:Inc["${smallHeight}"]

        ; ${monitorL}
        ; ${monitorT}
        ; ${monitorW}
        ; ${monitorH}
        ; ${smallHeight}
        ; ${smallWidth}
        ; ${x1}
        ; ${x2}
        ; ${y1}
        ; ${y2}

        ;relay jmb1 "LGUI2.Element[consoleWindow]:SetVisibility[visible]"

        if !${setOtherSlots}
            return

        if ${Session.Equal[jmb1]}
        {
            echo ${x1} : ${x2} : ${y1} : ${y2} : ${smallWidth} : ${smallHeight}
            relay jmb1 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb2 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb3 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb4 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb5 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
        }
        if ${Session.Equal[jmb2]}
        {
            relay jmb2 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb1 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb3 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb4 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb5 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
        }
        if ${Session.Equal[jmb3]}
        {
            relay jmb3 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb2 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb1 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb4 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb5 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
        }
        if ${Session.Equal[jmb4]}
        {
            relay jmb4 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb2 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb3 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb1 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb5 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
        }
        if ${Session.Equal[jmb5]}
        {
            relay jmb5 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb2 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb3 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x1},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb4 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y1} -size -viewable ${smallWidth}x${smallHeight} -frame none"
            relay jmb1 "WindowCharacteristics -visibility down -stealth -pos -viewable ${x2},${y2} -size -viewable ${smallWidth}x${smallHeight} -frame none"
        }        
    } 


    method ApplyWindowLayout1(bool setOtherSlots=TRUE)
    {
        variable jsonvalueref Slots="JMB.Slots"

        variable uint monitorWidth=${Display.Monitor.Width}
        variable uint monitorHeight=${Display.Monitor.Height}
        variable int monitorX=${Display.Monitor.Left}
        variable int monitorY=${Display.Monitor.Top}

        variable uint mainHeight
        variable uint numSmallRegions=${Slots.Used}
        variable uint mainWidth
        variable uint smallHeight
        variable uint smallWidth

        if ${Settings.AvoidTaskbar}
        {
            monitorX:Set["${Display.Monitor.MaximizeLeft}"]
            monitorY:Set["${Display.Monitor.MaximizeTop}"]
            monitorWidth:Set["${Display.Monitor.MaximizeWidth}"]
            monitorHeight:Set["${Display.Monitor.MaximizeHeight}"]
        }


        ; if there's only 1 window, just go full screen windowed
        if ${numSmallRegions}==1
        {
            WindowCharacteristics -pos -viewable ${monitorX},${monitorY} -size -viewable ${monitorWidth}x${monitorHeight} -frame none
            This.Applied:Set[1]
            return
        }

        if !${Settings.LeaveHole}
            numSmallRegions:Dec

        ; 2 windows is actually a 50/50 split screen and should probably handle differently..., pretend there's 3
        if ${numSmallRegions}==2
            numSmallRegions:Set[3]

        mainWidth:Set["${monitorWidth}"]
        mainHeight:Set["${monitorHeight}*${numSmallRegions}/(${numSmallRegions}+1)"]

        smallHeight:Set["${monitorHeight}-${mainHeight}"]
        smallWidth:Set["${monitorWidth}/${numSmallRegions}"]

        WindowCharacteristics -pos -viewable ${monitorX},${monitorY} -size -viewable ${mainWidth}x${mainHeight} -frame none
        This.Applied:Set[1]

        if !${setOtherSlots}
            return

        variable uint numSmallRegion
        variable int useX
        variable uint numSlot

        variable uint slotID

        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                relay jmb${slotID} "WindowCharacteristics -stealth -pos -viewable ${useX},${mainHeight} -size -viewable ${smallWidth}x${smallHeight} -frame none"
                useX:Inc["${smallWidth}"]
            }
            else
            {
                if ${Settings.LeaveHole}
                    useX:Inc["${smallWidth}"]
            }
            
        }
    }

    method OnActivate()
    {
        if ${Settings.SwapOnActivate} && !${Settings.FocusFollowsMouse}
            This:ApplyWindowLayout
        else
        {
            if !${Applied}
                This:ApplyWindowLayout[FALSE]
        }
    }

    method OnHotkeyFocused()
    {
        ; if it would have been handled by SwapOnActivate, don't do it again here
        if (!${Settings.SwapOnActivate} || ${Settings.FocusFollowsMouse}) && ${Settings.SwapOnHotkeyFocused}
        {
            This:ApplyWindowLayout
        }
        else
        {
            if !${Applied}
                This:ApplyWindowLayout[FALSE]
        }
    }

    method OnWindowStateChanging(string change)
    {
      ;  echo OnWindowStateChanging ${change~}
    }

    method ToggleFocusFollowsMouse()
    {
        echo ToggleFocusFollowsMouse
        uplink "BWLUplink:ToggleFocusFollowsMouse"
    }

    method ToggleSwapOnActivate()
    {
        echo ToggleSwapOnActivate
        uplink "BWLUplink:ToggleSwapOnActivate"
    }
    method ToggleSwapOnHotkeyFocused()
    {
        echo ToggleSwapOnHotkeyFocused
        uplink "BWLUplink:ToggleSwapOnHotkeyFocused"
    }    
    method ToggleLeaveHole()
    {
        uplink "BWLUplink:ToggleLeaveHole"
    }
    method ToggleAvoidTaskbar()
    {
        uplink "BWLUplink:ToggleAvoidTaskbar"
    }

    
    member:uint GetNextSlot()
    {
        variable uint Slot=${JMB.Slot}
        if !${Slot}
            return 0

        Slot:Inc
        if ${Slot}>${JMB.Slots.Used}
            return 1

        return ${Slot}
    }

    member:uint GetPreviousSlot()
    {
        variable uint Slot=${JMB.Slot}
        if !${Slot}
            return 0

        Slot:Dec
        if !${Slot}
            return ${JMB.Slots.Used}

        return ${Slot}
    }

    method PreviousWindow()
    {
        variable uint previousSlot=${This.GetPreviousSlot}
        if !${previousSlot}
            return

        if !${Display.Window.IsForeground}
            return

        uplink focus "jmb${previousSlot}"
        relay "jmb${previousSlot}" "Event[OnHotkeyFocused]:Execute"
    }

    method NextWindow()
    {
        variable uint nextSlot=${This.GetNextSlot}
        if !${nextSlot}
            return

        if !${Display.Window.IsForeground}
            return

        uplink focus "jmb${nextSlot}"
        relay "jmb${nextSlot}" "Event[OnHotkeyFocused]:Execute"
    }

    method Fullscreen()
    {
        echo Fullscreen
        variable uint monitorWidth=${Display.Monitor.Width}
        variable uint monitorHeight=${Display.Monitor.Height}
        variable int monitorX=${Display.Monitor.Left}
        variable int monitorY=${Display.Monitor.Top}
        
        WindowCharacteristics -pos -viewable ${monitorX},${monitorY} -size -viewable ${monitorWidth}x${monitorHeight} -frame none        
    }

    method EnableHotkeys()
    {
        variable jsonvalue joBinding
        if ${Settings.hotkeyFullscreen.Type.Equal[object]} && ${Settings.hotkeyFullscreen.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyFullscreen.AsJSON~}"]
            joBinding:Set[name,"\"bwl.fullscreen\""]
            joBinding:Set[eventHandler,"$$>
            {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:Fullscreen"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }

        if ${Settings.hotkeyApplyWindowLayout.Type.Equal[object]} && ${Settings.hotkeyApplyWindowLayout.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyApplyWindowLayout.AsJSON~}"]
            joBinding:Set[name,"\"bwl.applyWindowLayout\""]
            joBinding:Set[eventHandler,"$$>
            {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:ApplyWindowLayout"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }

        if ${Settings.hotkeyToggleFocusFollowsMouse.Type.Equal[object]} && ${Settings.hotkeyToggleFocusFollowsMouse.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyToggleFocusFollowsMouse.AsJSON~}"]
            joBinding:Set[name,"\"bwl.toggleFocusFollowsMouse\""]
            joBinding:Set[eventHandler,"$$>
            {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:ToggleFocusFollowsMouse"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }


        if ${Settings.hotkeyToggleSwapOnActivate.Type.Equal[object]} && ${Settings.hotkeyToggleSwapOnActivate.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyToggleSwapOnActivate.AsJSON~}"]
            joBinding:Set[name,"\"bwl.toggleSwapOnActivate\""]
            joBinding:Set[eventHandler,"$$>
             {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:ToggleSwapOnActivate"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }

        if ${Settings.hotkeyToggleSwapOnHotkeyFocused.Type.Equal[object]} && ${Settings.hotkeyToggleSwapOnHotkeyFocused.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyToggleSwapOnHotkeyFocused.AsJSON~}"]
            joBinding:Set[name,"\"bwl.toggleSwapOnHotkeyFocused\""]
            joBinding:Set[eventHandler,"$$>
             {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:ToggleSwapOnHotkeyFocused"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }        

        if ${Settings.hotkeyNextWindow.Type.Equal[object]} && ${Settings.hotkeyNextWindow.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyNextWindow.AsJSON~}"]
            joBinding:Set[name,"\"bwl.nextWindow\""]
            joBinding:Set[eventHandler,"$$>
             {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:NextWindow"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }

        if ${Settings.hotkeyPreviousWindow.Type.Equal[object]} && ${Settings.hotkeyPreviousWindow.Has[controls]}
        {
            joBinding:SetValue["${Settings.hotkeyPreviousWindow.AsJSON~}"]
            joBinding:Set[name,"\"bwl.previousWindow\""]
            joBinding:Set[eventHandler,"$$>
             {
                "type":"task",
                "taskManager":"bwlSession",
                "task":{
                    "type":"ls1.code",
                    "start":"BWLSession:PreviousWindow"
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]
        }

    }

    method DisableHotkeys()
    {
        LGUI2:RemoveBinding["bwl.fullscreen"]
        LGUI2:RemoveBinding["bwl.applyWindowLayout"]
        LGUI2:RemoveBinding["bwl.toggleFocusFollowsMouse"]
        LGUI2:RemoveBinding["bwl.toggleSwapOnActivate"]
        LGUI2:RemoveBinding["bwl.toggleSwapOnHotkeyFocused"]
        LGUI2:RemoveBinding["bwl.nextWindow"]
        LGUI2:RemoveBinding["bwl.previousWindow"]
    }

    method ApplyFocusFollowMouse()
    {
        if !${Settings.FocusFollowsMouse}
            return

        if ${Display.Window.IsForeground}
            return

        relay all "BWLSession:FocusSession[\"${Session~}\"]"
    }
     
    method FocusSession(string name)
    {
        if !${Display.Window.IsForeground}
            return
        uplink focus "${name~}"
    }

    method OnMouseEnter()
    {
        This:ApplyFocusFollowMouse
    }

    method OnMouseExit()
    {

    }
}

variable(global) bwlSession BWLSession

function main()
{
    while 1
    {
        waitframe
    }
}