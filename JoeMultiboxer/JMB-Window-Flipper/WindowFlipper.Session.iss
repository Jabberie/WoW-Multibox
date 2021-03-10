;#include "WindowFlipper.Common.iss"

objectdef windowflipperSession
{
;    variable taskmanager TaskManager=${LMAC.NewTaskManager["windowflipperSession"]}
 ;   variable windowflipperSettings Settings

    variable uint KeySlot=2


    method Initialize()
    {
        LGUI2:LoadPackageFile[WindowFlipper.Session.lgui2Package.json]

 ;       This.Settings:EnableHotkeys
    }

    method Shutdown()
    {
   ;     This:Disable
  ;      This.Settings:DisableHotkeys
   ;     TaskManager:Destroy
        LGUI2:UnloadPackageFile[WindowFlipper.Session.lgui2Package.json]
    }

    method OnButtonHook()
    {
        echo OnButtonHook ${Context.Args.AsJSON~}

        if ${Context.Args[position]}
        {
            ; pressed
            if ${JMB.Slot}!=${KeySlot}
            {
                echo relay uplink "WindowFlipperUplink:Flip[${JMB.Slot},${KeySlot}]"
                relay uplink "WindowFlipperUplink:Flip[${JMB.Slot},${KeySlot}]"
            }
        }
        else
        {
            ; released
            if ${JMB.Slot}==${KeySlot}
            {
                echo relay uplink "WindowFlipperUplink:Restore"
                relay uplink "WindowFlipperUplink:Restore"
            }

        }

;            This:OnControlHook["${Context.Args[controlName]~}"]
    }
}

variable(global) windowflipperSession WindowFlipperSession

function main()
{
    while 1
        waitframe
}