objectdef basiclauncher
{
    method Initialize()
    {

    }

    variable uint LaunchSlots=5

    variable string UseGame="World of Warcraft"
    variable string UseGameProfile="World of Warcraft Default Profile"


    method InstallCharacters()
    {
        variable jsonvalue jo

        variable uint Slot

        for (Slot:Set[1] ; ${Slot}<=${LaunchSlots} ; Slot:Inc)
        {
            jo:SetValue["$$>
            {
                "id":${Slot},
                "display_name":"Generic Character",
                "game":${UseGame.AsJSON~},
                "gameProfile":${UseGameProfile.AsJSON~}
                "virtualFiles":[
                    {
                        "pattern":"*/Config.WTF",
                        "replacement":"{1}/Config.Generic.JMB${Slot}.WTF"
                    }
                ]
            }
            <$$"]
            echo ${jo}
            JMB:AddCharacter["${jo.AsJSON~}"]
        }        
    }

    method Launch()
    {
        JMB:ClearSlots
        This:InstallCharacters
        
        variable uint Slot
        for (Slot:Set[1] ; ${Slot}<=${LaunchSlots} ; Slot:Inc)
        {
            JMB:AddSlot
            JMB.Slot[${Slot}]:SetCharacter[${Slot}]
            JMB.Slot[${Slot}]:Launch
        }
    }

    method AllFullScreen()
    {
        relay all "WindowCharacteristics -pos -viewable ${Display.Monitor.X},${Display.Monitor.Y} -size -viewable ${Display.Monitor.Width}x${Display.Monitor.Height} -frame none"
    }

    method ShowConsoles()
    {
        relay all "LGUI2.Element[consoleWindow]:SetVisibility[Visible]"
    }

    method CloseAll()
    {
        relay all exit
    }
}

variable(global) basiclauncher BasicLauncher

function main()
{
    while 1
        waitframe
}