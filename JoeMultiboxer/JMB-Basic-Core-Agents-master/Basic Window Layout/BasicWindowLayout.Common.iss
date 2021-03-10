objectdef bwlSettings
{
    variable filepath AgentFolder="${Script.CurrentDirectory}"
    
    variable jsonvalue hotkeyToggleSwapOnActivate="$$>
    {
        "controls":"A",
        "modifiers":"shift+ctrl+alt"
    }
    <$$"
    variable jsonvalue hotkeyToggleFocusFollowsMouse="$$>
    {
        "controls":"M",
        "modifiers":"shift+ctrl+alt"
    }
    <$$"
    variable jsonvalue hotkeyFullscreen="$$>
    {
        "controls":"F",
        "modifiers":"shift+ctrl+alt"
    }
    <$$"
    variable jsonvalue hotkeyApplyWindowLayout="$$>
    {
        "controls":"W",
        "modifiers":"shift+ctrl+alt"
    }
    <$$"

    method Initialize()
    {
        This:Load
    }

    method Load()
    {
        variable jsonvalue jo
        if !${AgentFolder.FileExists[bwl.Settings.json]}
            return

        if !${jo:ParseFile["${AgentFolder~}/bwl.Settings.json"](exists)} || !${jo.Type.Equal[object]}
        {
            return
        }

        if ${jo.Has[swapOnActivate]}
            SwapOnActivate:Set["${jo.Get[swapOnActivate]~}"]

        if ${jo.Has[leaveHole]}
            LeaveHole:Set["${jo.Get[leaveHole]}"]

        if ${jo.Has[focusFollowsMouse]}
            FocusFollowsMouse:Set["${jo.Get[focusFollowsMouse]}"]

        if ${jo.Has[avoidTaskbar]}
            AvoidTaskbar:Set["${jo.Get[avoidTaskbar]}"]

        variable jsonvalue joHotkeys
        joHotkeys:SetValue["${jo.Get[hotkeys].AsJSON~}"]

        if ${joHotkeys.Type.Equal[object]}
        {
            if ${joHotkeys.Has[toggleSwapOnActivate]}
                hotkeyToggleSwapOnActivate:Set["${joHotkeys.Get[toggleSwapOnActivate].AsJSON~}"]
            if ${joHotkeys.Has[toggleFocusFollowsMouse]}
                hotkeyToggleFocusFollowsMouse:Set["${joHotkeys.Get[toggleFocusFollowsMouse].AsJSON~}"]
            if ${joHotkeys.Has[fullscreen]}
                hotkeyFullscreen:Set["${joHotkeys.Get[fullscreen].AsJSON~}"]
            if ${joHotkeys.Has[applyWindowLayout]}
                hotkeyApplyWindowLayout:Set["${joHotkeys.Get[applyWindowLayout].AsJSON~}"]
        }
    }


    method Store()
    {
        variable jsonvalue jo
        jo:SetValue["${This.AsJSON~}"]
        jo:WriteFile["${AgentFolder~}/bwl.Settings.json",TRUE]
    }

    member AsJSON()
    {
        variable jsonvalue jo
        jo:SetValue["$$>
        {
            "swapOnActivate":${SwapOnActivate.AsJSON~},
            "leaveHole":${LeaveHole.AsJSON~},
            "focusFollowsMouse":${FocusFollowsMouse.AsJSON~},
            "avoidTaskbar":${AvoidTaskbar.AsJSON~},
            "hotkeys":{
                "toggleSwapOnActivate":${hotkeyToggleSwapOnActivate.AsJSON~},
                "toggleFocusFollowsMouse":${hotkeyToggleFocusFollowsMouse.AsJSON~},
                "fullscreen":${hotkeyFullscreen.AsJSON~},
                "applyWindowLayout":${hotkeyApplyWindowLayout.AsJSON~}
            }
        }
        <$$"]
        return "${jo.AsJSON~}"
    }


    variable bool SwapOnActivate=TRUE
    variable bool LeaveHole=TRUE
    variable bool FocusFollowsMouse=FALSE    
    variable bool AvoidTaskbar=FALSE

}
