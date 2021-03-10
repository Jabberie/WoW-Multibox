objectdef bghSession
{
    variable jsonvalue GlobalHotkeys="[]"
    variable bool Enabled=1
    variable bool HotkeyInstalled
    variable filepath AgentFolder="${Script.CurrentDirectory}"

    variable string NextWindowKey="Ctrl+Alt+X"
    variable string PreviousWindowKey="Ctrl+Alt+Z"

    method Initialize()
    {
        LavishScript:RegisterEvent[On3DReset]
        Event[On3DReset]:AttachAtom[This:On3DReset]

        This:LoadSettings
    }

    method Shutdown()
    {
        This:Disable
    }

    method LoadSettings()
    {
        variable jsonvalue jo

        if !${jo:ParseFile["${AgentFolder~}/bgh.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }

        GlobalHotkeys:SetValue["${jo.Get["globalHotkeys"].AsJSON~}"]
        if ${jo.Has[nextWindowHotkey]}
            NextWindowKey:Set["${jo.Get["nextWindowHotkey"]~}"]
        if ${jo.Has[previousWindowHotkey]}
            PreviousWindowKey:Set["${jo.Get["previousWindowHotkey"]~}"]

        if !${GlobalHotkeys.Type.Equal[array]}
            GlobalHotkeys:SetValue["[]"]
    }

    method Enable()
    {
        if ${Enabled}
            return

        Enabled:Set[1]
        This:InstallHotkey
    }

    method Disable()
    {
        if !${Enabled}
            return
        Enabled:Set[0]
        This:UninstallHotkey
    }

    method InstallHotkey()
    {
        variable string useTarget="foreground"
        variable uint Slot=${JMB.Slot}
        if !${Slot} || ${Slot}>${GlobalHotkeys.Used}
            return

        if ${HotkeyInstalled}
            return
        
        HotkeyInstalled:Set[1]
        
        globalbind "focus" "${GlobalHotkeys.Get[${Slot}]~}" "windowvisibility foreground"

        if ${JMB.Build}<6741
        {
            ; old build does not support relay foreground
            useTarget:Set["all"]            
        }

        if ${Slot}==1
        {
            if ${NextWindowKey.NotNULLOrEmpty}
                globalbind "focusnext" "${NextWindowKey~}" "relay ${useTarget~} BGHSession:NextWindow"
            if ${PreviousWindowKey.NotNULLOrEmpty}
                globalbind "focusprev" "${PreviousWindowKey~}" "relay ${useTarget~} BGHSession:PreviousWindow"
        }
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
    }

    method NextWindow()
    {
        variable uint nextSlot=${This.GetNextSlot}
        if !${nextSlot}
            return

        if !${Display.Window.IsForeground}
            return

        uplink focus "jmb${nextSlot}"
    }

    method UninstallHotkey()
    {
        if !${HotkeyInstalled}
            return
        HotkeyInstalled:Set[0]
        globalbind -delete "focus"

        if ${Slot}==1
        {
            if ${NextWindowKey.NotNULLOrEmpty}
                globalbind -delete "focusnext"
            if ${PreviousWindowKey.NotNULLOrEmpty}
                globalbind -delete "focusprev"
        }
    }

    method On3DReset()
    {
        This:InstallHotkey
    }
}

variable(global) bghSession BGHSession

function main()
{
    while 1
        waitframe
}