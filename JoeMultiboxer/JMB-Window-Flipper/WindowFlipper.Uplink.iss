;#include "WindowFlipper.Common.iss"

objectdef windowflipperUplink
{
    ;   variable windowflipperSettings Settings
    variable uint RestoreSlot

    variable bool SwitchAsHotkey

    method Initialize()
    {
        LGUI2:LoadPackageFile[WindowFlipper.Uplink.lgui2Package.json]
       ; Settings:Store
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[WindowFlipper.Uplink.lgui2Package.json]
    }

    method Flip(uint fromSlot, uint toSlot)
    {
        RestoreSlot:Set[${fromSlot}]
        focus "jmb${toSlot~}"
        if ${SwitchAsHotkey}
            relay "jmb${RestoreSlot}" "Event[OnHotkeyFocused]:Execute"
    }

    method Restore()
    {
        if !${RestoreSlot}
            return

        focus "jmb${RestoreSlot}"
        if ${SwitchAsHotkey}
            relay "jmb${RestoreSlot}" "Event[OnHotkeyFocused]:Execute"
        RestoreSlot:Set[0]
    }
}

variable(global) windowflipperUplink WindowFlipperUplink

function main()
{
    while 1
        waitframe
}