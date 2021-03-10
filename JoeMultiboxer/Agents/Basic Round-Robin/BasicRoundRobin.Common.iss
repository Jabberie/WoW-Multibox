objectdef brrProfile
{
    variable string Name
    variable bool DefaultAllow=TRUE
    variable bool SwitchAsHotkey=TRUE
    variable bool IncludeMouse=FALSE
    variable jsonvalue Overrides="{}"
    variable jsonvalue Hotkey="{}"
    
    variable bool Enabled

    method Initialize(jsonvalue jo)
    {
        This:FromJSON[jo]
    }

    method Shutdown()
    {
        This:DisableHotkey
    }

    method FromJSON(jsonvalueref jo)
    {
        if !${jo.Type.Equal[object]}
            return
        
        if ${jo.Has[includeMouse]}
            IncludeMouse:Set["${jo.Get[includeMouse]~}"]
        if ${jo.Has[defaultAllow]}
            DefaultAllow:Set["${jo.Get[defaultAllow]~}"]
        if ${jo.Has[switchAsHotkey]}
            SwitchAsHotkey:Set["${jo.Get[switchAsHotkey]~}"]

        if ${jo.Has[overrides]}
            Overrides:SetValue["${jo.Get[overrides].AsJSON~}"]

        if ${jo.Has[hotkey]}
            Hotkey:SetValue["${jo.Get[hotkey].AsJSON~}"]
    }

    member OverridesList()
    {
;        echo OverridesList...
        variable jsonvalue jo="${Overrides.AsJSON~}"
        variable jsonvalue ja="[]"

        if !${jo.Type.Equal[object]}
            return "[]"

        jo:ForEach["ForEach.Value:Set[key,\"\${ForEach.Key.AsJSON~}\"]"]
        jo:ForEach["ja:Add[\"\${ForEach.Value.AsJSON~}\"]"]
        return "${ja.AsJSON~}"
    }

    member AsJSON()
    {
        variable jsonvalue jo
        jo:SetValue["$$>
        {
            "name":${Name.AsJSON~},
            "includeMouse":${IncludeMouse.AsJSON~},
            "overrides":${Overrides.AsJSON~},
            "defaultAllow":${DefaultAllow.AsJSON~},
            "switchAsHotkey":${SwitchAsHotkey.AsJSON~},
            "hotkey":${Hotkey.AsJSON~}
        }
        <$$"]

        if ${jo.Get[overrides].Type.Equal[null]}
            jo:Erase[overrides]
        if ${jo.Get[hotkey].Type.Equal[null]}
            jo:Erase[hotkey]
        return "${jo.AsJSON~}"
    }

    method EnableHotkey()
    {
        variable jsonvalue joBinding
        variable string startCommand
        if ${Hotkey.Type.Equal[object]} && ${Hotkey.Has[controls]}
        {
            joBinding:SetValue["${Hotkey.AsJSON~}"]
            joBinding:Set[name,"\"brr.profile.${Name~}\""]

            startCommand:Set["BRRSession:ToggleProfile[${Name.AsJSON~}]"]

            joBinding:Set[eventHandler,"$$>
            {
                "type":"task",
                "taskManager":"brrSession",
                "task":{
                    "type":"ls1.code",
                    "start":${startCommand.AsJSON~}
                }
            }
            <$$"]

            LGUI2:AddBinding["${joBinding.AsJSON~}"]

            Enabled:Set[1]
        }
    }

    method DisableHotkey()
    {
        LGUI2:RemoveBinding["brr.profile.${Name~}"]
        Enabled:Set[0]
    }
}

objectdef brrSettings
{
    variable filepath AgentFolder="${Script.CurrentDirectory}"

    method Initialize()
    {       
        This:Load

        if !${Profiles.Used}    
        {
            Profiles:Set[default,"$$>
            {
                "name":"default",
                "defaultAllow":true,
                "includeMouse":false,
                "switchAsHotkey":true,
                "hotkey":{
                    "controls":"F12"
                },
                "overrides":{
                    "F12":{"ignore":true},
                    "${Input.Button[160]}":{"ignore":true},
                    "${Input.Button[161]}":{"ignore":true},
                    "${Input.Button[162]}":{"ignore":true},
                    "${Input.Button[163]}":{"ignore":true},
                    "${Input.Button[164]}":{"ignore":true},
                    "${Input.Button[165]}":{"ignore":true}
                }
            }
            <$$"]
            LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onCurrentProfileChanged]
        }

    
    }

    method Convert(jsonvalueref jo)
    {
        ; make sure it hasnt already been converted
        if ${jo.Has[profiles]}
            return

        variable jsonvalue joHotkeys
        variable jsonvalue joWrapper
        joWrapper:SetValue["${jo.AsJSON~}"]
        joHotkeys:SetValue["${jo.Get[hotkeys].AsJSON~}"]

        if ${joHotkeys.Type.Equal[object]}
        {
            if ${joHotkeys.Has[toggleRoundRobin]}
                joWrapper:Set["hotkey","${joHotkeys.Get[toggleRoundRobin].AsJSON~}"]
        }

        joWrapper:Erase[hotkeys]

        jo:Clear
        jo:Set["profiles","{\"original\":${joWrapper.AsJSON~}}"]

;        Profiles:Set["original","${joWrapper.AsJSON~}"]

    }

    method Load()
    {
        variable jsonvalue jo
        if !${AgentFolder.FileExists[brr.Settings.json]}
            return

        if !${jo:ParseFile["${AgentFolder~}/brr.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }

        This:Convert[jo]
        Profiles:Clear

        if ${jo.Has[profiles]}
        {
            Profiles:FromJSON["${jo.Get[profiles].AsJSON~}"]
            Profiles:ForEach["ForEach.Value.Name:Set[\"\${ForEach.Key~}\"]"]
            LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onProfilesUpdated]
        }

    }


    method Store()
    {
        variable jsonvalue jo
        jo:SetValue["${This.AsJSON~}"]
        jo:WriteFile["${AgentFolder~}/brr.Settings.json",multiline]
    }

    member AsJSON()
    {
        variable jsonvalue jo
        jo:SetValue["$$>
        {
            "profiles":${Profiles.AsJSON~}
        }
        <$$"]
        return "${jo.AsJSON~}"
    }

    method EnableHotkeys()
    {
        Profiles:ForEach["ForEach.Value:EnableHotkey"]
    }

    method DisableHotkeys()
    {
        Profiles:ForEach["ForEach.Value:DisableHotkey"]
    }

    method SetCurrentProfile(string newValue)
    {        
        CurrentProfile:SetReference["Profiles.Get[${newValue.AsJSON~}]"]
        LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onCurrentProfileChanged]
    }

    method ClearCurrentProfile()
    {
        CurrentProfile:SetReference[NULL]
        LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onCurrentProfileChanged]
    }

    variable collection:brrProfile Profiles
    variable weakref CurrentProfile
}
