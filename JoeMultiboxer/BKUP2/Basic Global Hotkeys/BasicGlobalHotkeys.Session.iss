objectdef bghSession
{
    variable jsonvalue GlobalHotkeys="[]"
    variable bool Enabled=1
    variable bool HotkeyInstalled
    variable filepath AgentFolder="${Script.CurrentDirectory}"

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
        variable uint Slot=${JMB.Slot}
        if !${Slot} || ${Slot}>${GlobalHotkeys.Used}
            return

        if ${HotkeyInstalled}
            return
        
        HotkeyInstalled:Set[1]
        
        globalbind "focus" "${GlobalHotkeys.Get[${Slot}]~}" "windowvisibility foreground"
    }

    method UninstallHotkey()
    {
        if !${HotkeyInstalled}
            return
        HotkeyInstalled:Set[0]
        globalbind -delete "focus"
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