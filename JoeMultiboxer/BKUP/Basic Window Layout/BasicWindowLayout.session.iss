objectdef bwlSession
{

    variable bool SwapOnActivate=TRUE
    ;variable bool SwapOnActivate=FALSE

    method Initialize()
    {
        LavishScript:RegisterEvent[On Activate]
        LavishScript:RegisterEvent[OnWindowStateChanging]

        Event[On Activate]:AttachAtom[This:OnActivate]
        Event[OnWindowStateChanging]:AttachAtom[This:OnWindowStateChanging]

        FocusClick eat
        Echo "Is this thing on?"
    }

    method OnActivate()
    {
        if ${SwapOnActivate}
            This:ApplyWindowLayout
    }


    method OnActivate2()
    {
        variable jsonvalueref Slots="JMB.Slots"

        variable uint monitorWidth=${Display.Monitor.Width}
        variable uint monitorHeight=${Display.Monitor.Height}

        variable uint mainHeight=${monitorWidth}
        variable uint numSmallRegions=${Slots.Used}
        variable uint mainWidth
        variable uint smallHeight
        variable uint smallWidth

        ; if there's only 1 window, just go full screen windowed
        if ${numSmallRegions}==1
        {
            WindowCharacteristics -pos -viewable 0,0 -size -viewable ${monitorWidth}x${monitorHeight} -frame none
            return
        }

        ; 2 windows is actually a 50/50 split screen and should probably handle differently..., pretend there's 3
        if ${numSmallRegions}==2
            numSmallRegions:Set[3]

        mainWidth:Set["${monitorWidth}"]
        ; mainHeight:Set["${monitorHeight}*${numSmallRegions}/(${numSmallRegions}+1)"]

        mainHeight:Set["${monitorHeight}"]

        smallWidth:Set["960"]
        smallHeight:Set["540"]
        

        WindowCharacteristics -pos -viewable 0,0 -size -viewable ${mainWidth}x${mainHeight} -frame none

        variable uint numSmallRegion
        variable uint useX
        variable uint numSlot


        variable uint slaveX1
        variable uint slaveX2
        variable uint slaveX3
        variable uint slaveX4

        variable uint slaveY1
        variable uint slaveY2
        variable uint slaveY3
        variable uint slaveY4

        slaveX1:Set["2560"]
        slaveY1:Set["360"]

        slaveX2:Set["2560"]
        slaveY2:Set["900"]

        slaveX3:Set["3520"]
        slaveY3:Set["360"] 

        slaveX4:Set["3520"]
        slaveY4:Set["900"]

        variable uint slotID

        for (numSlot:Set[1] ; ${numSlot}<=${Slots.Used} ; numSlot:Inc)
        {
            slotID:Set["${Slots[${numSlot}].Get[id]~}"]
            if ${slotID}!=${JMB.Slot}
            {
                relay jmb${slotID} "WindowCharacteristics -stealth -pos -viewable ${CoordX${numSlot}},${CoordY${numSlot}}  -size -viewable ${smallWidth}x${smallHeight}"
            }
        }
    }

    method ApplyWindowLayout()
    {
        if ${Session.Equal[jmb1]}
        {
            relay jmb1 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb2 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,360 -size -viewable 960x540 -frame none"
            relay jmb3 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,360 -size -viewable 960x540 -frame none"
            relay jmb4 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,900 -size -viewable 960x540 -frame none"
            relay jmb5 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,900 -size -viewable 960x540 -frame none"
        }
        if ${Session.Equal[jmb2]}
        {
            relay jmb2 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb1 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,360 -size -viewable 960x540 -frame none"
            relay jmb3 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,360 -size -viewable 960x540 -frame none"
            relay jmb4 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,900 -size -viewable 960x540 -frame none"
            relay jmb5 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,900 -size -viewable 960x540 -frame none"
        }
        if ${Session.Equal[jmb3]}
        {
            relay jmb3 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb2 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,360 -size -viewable 960x540 -frame none"
            relay jmb1 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,360 -size -viewable 960x540 -frame none"
            relay jmb4 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,900 -size -viewable 960x540 -frame none"
            relay jmb5 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,900 -size -viewable 960x540 -frame none"
        }
        if ${Session.Equal[jmb4]}
        {
            relay jmb4 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb2 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,360 -size -viewable 960x540 -frame none"
            relay jmb3 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,360 -size -viewable 960x540 -frame none"
            relay jmb1 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,900 -size -viewable 960x540 -frame none"
            relay jmb5 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,900 -size -viewable 960x540 -frame none"
        }
        if ${Session.Equal[jmb5]}
        {
            relay jmb5 "WindowCharacteristics -pos -viewable 0,0 -size -viewable 2560x1440 -frame none"
            relay jmb2 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,360 -size -viewable 960x540 -frame none"
            relay jmb3 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,360 -size -viewable 960x540 -frame none"
            relay jmb4 "WindowCharacteristics -visibility down -stealth -pos -viewable 2560,900 -size -viewable 960x540 -frame none"
            relay jmb1 "WindowCharacteristics -visibility down -stealth -pos -viewable 3520,900 -size -viewable 960x540 -frame none"
        }        
    }


    method OnWindowStateChanging(string change)
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


