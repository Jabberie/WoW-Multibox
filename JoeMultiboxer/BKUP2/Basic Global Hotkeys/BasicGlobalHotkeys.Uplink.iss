objectdef bghUplink
{
    variable jsonvalue GlobalHotkeys="[]"
    variable bool Enabled=1
    variable filepath AgentFolder="${Script.CurrentDirectory}"

    method Initialize()
    {
        This:LoadSettings
        LGUI2.Element[bgh.filename]:SetText["${AgentFolder.Replace["/","\\"]~}\\bgh.Settings.json"]
    }
    
    method Shutdown()
    {
        This:Disable
    }

    method LoadSettings()
    {
        variable jsonvalue jo

        if !${AgentFolder.FileExists[bgh.Settings.json]}
        {
            jo:SetValue["$$>
            {
                "globalHotkeys":[
                    "Ctrl+Alt+1",
                    "Ctrl+Alt+2",
                    "Ctrl+Alt+3",
                    "Ctrl+Alt+4",
                    "Ctrl+Alt+5",
                    "Ctrl+Alt+6",
                    "Ctrl+Alt+7",
                    "Ctrl+Alt+8",
                    "Ctrl+Alt+9",
                    "Ctrl+Alt+0",
                    "Ctrl+Alt+-",
                    "Ctrl+Alt+=",
                ]
            }
            <$$"]

            jo:WriteFile["${AgentFolder~}/bgh.Settings.json",TRUE]
        }

        if !${jo:ParseFile["${AgentFolder~}/bgh.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }

        GlobalHotkeys:SetValue["${jo.Get["globalHotkeys"].AsJSON~}"]

        if !${GlobalHotkeys.Type.Equal[array]}
            GlobalHotkeys:SetValue["[]"]
    }

    method StoreSettings()
    {
        variable jsonvalue jo
        jo:SetValue["${This.AsJSON~}"]
        jo:WriteFile["${AgentFolder~}/bgh.Settings.json",TRUE]
    }

    member AsJSON()
    {
        variable jsonvalue jo="{}"
        jo:Set["globalHotkeys","${GlobalHotkeys.AsJSON~}"]
        return "${jo.AsJSON~}"
    }

    method Enable()
    {
        if ${Enabled}
            return

        Enabled:Set[1]
        
        relay all BGHSession:InstallHotkey
    }

    method Disable()
    {
        if !${Enabled}
            return
        Enabled:Set[0]
        relay all BGHSession:UninstallHotkey
    }

}

variable(global) bghUplink BGHUplink

function main()
{
    while 1
        waitframe
}