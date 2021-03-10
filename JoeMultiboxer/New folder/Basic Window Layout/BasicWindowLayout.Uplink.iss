#include "BasicWindowLayout.Common.iss"

objectdef bwlUplink
{
    variable bwlSettings Settings

    variable bool SwapOnActivate=TRUE
    variable bool LeaveHole=TRUE
    variable bool FocusFollowsMouse=FALSE    
    variable bool AvoidTaskbar=FALSE


    method Initialize()
    {
        LGUI2:LoadPackageFile[BasicWindowLayout.Uplink.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[BasicWindowLayout.Uplink.lgui2Package.json]
    }

    method ToggleFocusFollowsMouse()
    {
        This:SetFocusFollowsMouse[${Settings.FocusFollowsMouse.Not}]
    }

    method SetFocusFollowsMouse(bool newValue)
    {
        if ${newValue}==${Settings.FocusFollowsMouse}
            return
        Settings.FocusFollowsMouse:Set[${newValue}]
        Settings:Store

        ; push updated setting
        relay all "BWLSession.Settings.FocusFollowsMouse:Set[${newValue}]"
    }

    method ToggleAvoidTaskbar()
    {
        This:SetAvoidTaskbar[${Settings.AvoidTaskbar.Not}]
    }

    method SetAvoidTaskbar(bool newValue)
    {
        if ${newValue}==${Settings.AvoidTaskbar}
            return
        Settings.AvoidTaskbar:Set[${newValue}]
        Settings:Store

        ; push updated setting
        relay all "BWLSession.Settings.AvoidTaskbar:Set[${newValue}]"
    }

    method ToggleSwapOnActivate()
    {
        This:SetSwapOnActivate[${Settings.SwapOnActivate.Not}]
    }

    method SetSwapOnActivate(bool newValue)
    {
        if ${newValue}==${Settings.SwapOnActivate}
            return
        Settings.SwapOnActivate:Set[${newValue}]
        Settings:Store

        ; push updated setting
        relay all "BWLSession.Settings.SwapOnActivate:Set[${newValue}]"
    }

    method ToggleLeaveHole()
    {
        This:SetLeaveHole[${Settings.LeaveHole.Not}]
    }

    method SetLeaveHole(bool newValue)
    {
        if ${newValue}==${Settings.LeaveHole}
            return
        Settings.LeaveHole:Set[${newValue}]
        Settings:Store

        ; push updated setting
        relay all "BWLSession.Settings.LeaveHole:Set[${newValue}]"
    }    

    method ApplyWindowLayout()
    {
        relay jmb1 "BWLSession:ApplyWindowLayout"
    }
}

variable(global) bwlUplink BWLUplink

function main()
{
    while 1
        waitframe
}