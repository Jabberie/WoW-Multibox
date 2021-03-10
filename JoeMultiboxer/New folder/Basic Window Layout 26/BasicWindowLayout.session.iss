#include "BasicWindowLayout.Common.iss"

objectdef bwlSession
{
    variable bwlSettings Settings

    variable bool Applied

    method Initialize()
    {
        LavishScript:RegisterEvent[On Activate]
        LavishScript:RegisterEvent[OnWindowStateChanging]
		LavishScript:RegisterEvent[OnMouseEnter]
		LavishScript:RegisterEvent[OnMouseExit]

        Event[On Activate]:AttachAtom[This:OnActivate]
        Event[OnWindowStateChanging]:AttachAtom[This:OnWindowStateChanging]
		Event[OnMouseEnter]:AttachAtom[This:OnMouseEnter]
		Event[OnMouseExit]:AttachAtom[This:OnMouseExit]

        FocusClick eat
    }

    method ApplyWindowLayout(bool setOtherSlots=TRUE)
    {
           This:ApplyWindowLayout2[${setOtherSlots}]    
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

    method ApplyWindowLayout3(bool setOtherSlots=TRUE)
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

    method ApplyWindowLayout2(bool setOtherSlots=TRUE)
    {
        variable int whichMonitor=3

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

    method ApplyWindowLayout3(bool setOtherSlots=TRUE)
    {
        variable int monitorL=${Display.Monitor[4].Left}
        variable int monitorT=${Display.Monitor[4].Top}

        variable int monitorW=${Display.Monitor[4].Width}
        variable int monitorH=${Display.Monitor[4].Height}

        variable uint smallHeight=${monitorH}/2
        variable uint smallWidth=${monitorW}/2     

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
        if !${setOtherSlots}
            return


        variable uint numSlot
        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                relay jmb${slotID} "WindowCharacteristics -pos -viewable 0,0 -size -viewable ${Display.Monitor.Width}x${Display.Monitor.Height} -frame none"
            }
            else
            {
                variable uint i
                variable uint j
                for (i:Set[1] ; ${i}<=2 ; i:Inc)
                {
                    for (j:Set[1] ; ${j}<=2 ; j:Inc)
                    {
                        relay jmb${slotID} "WindowCharacteristics -visibility down -stealth -pos -viewable x${i},y${j} -size -viewable ${smallWidth}x${smallHeight} -frame none"
                    }
                }

            }
            



        }



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

    method OnWindowStateChanging(string change)
    {
      ;  echo OnWindowStateChanging ${change~}
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