objectdef bwlSettings
{
    variable filepath AgentFolder="${Script.CurrentDirectory}"

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
            "avoidTaskbar":${AvoidTaskbar.AsJSON~}
        }
        <$$"]
        return "${jo.AsJSON~}"
    }


    variable bool SwapOnActivate=TRUE
    variable bool LeaveHole=TRUE
    variable bool FocusFollowsMouse=FALSE    
    variable bool AvoidTaskbar=FALSE

}
