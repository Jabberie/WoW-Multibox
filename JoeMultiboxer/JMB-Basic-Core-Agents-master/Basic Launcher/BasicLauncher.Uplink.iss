objectdef basiclauncher
{
    method Initialize()
    {
        LavishScript:RegisterEvent[GamesChanged]

        Event[GamesChanged]:AttachAtom[This:RefreshGames]

        This:RefreshGames

        LGUI2:LoadPackageFile[BasicLauncher.Uplink.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[BasicLauncher.Uplink.lgui2Package.json]
    }

    variable uint LaunchSlots=3
    variable bool ReplaceSlots=TRUE

    variable string UseGame
    variable jsonvalue Games="[]"

    method InstallCharacter(uint Slot)
    {
        variable string UseGameProfile="${UseGame~} Default Profile"
        variable jsonvalue jo
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
        JMB:AddCharacter["${jo.AsJSON~}"]
    }

    method Launch()
    {
        if ${ReplaceSlots}
            JMB:ClearSlots

        This:InstallCharacters
        
        variable uint Slot
        variable uint NumAdded
        for (NumAdded:Set[1] ; ${NumAdded}<=${LaunchSlots} ; NumAdded:Inc)
        {
            Slot:Set["${JMB.AddSlot.ID}"]
            This:InstallCharacter[${Slot}]
            JMB.Slot[${Slot}]:SetCharacter[1]
            JMB.Slot[${Slot}]:Launch
        }
    }

    method AllFullScreen()
    {
        relay all "WindowCharacteristics -pos -viewable ${Display.Monitor.Left},${Display.Monitor.Top} -size -viewable ${Display.Monitor.Width}x${Display.Monitor.Height} -frame none"
    }

    method ShowConsoles()
    {
        relay all "LGUI2.Element[consoleWindow]:SetVisibility[Visible]"
    }

    method CloseAll()
    {
        relay all exit
    }

    method GenerateItemView_Game()
	{
        echo GenerateItemView_Game ${Context(type)} ${Context.Args}

		; build an itemview lgui2element json
		variable jsonvalue joListBoxItem
		joListBoxItem:SetValue["${LGUI2.Template["BasicLauncher.gameView"].AsJSON~}"]
        		
		Context:SetView["${joListBoxItem.AsJSON~}"]
	}

    method RefreshGames()
    {
        variable jsonvalue jo="${JMB.GameConfiguration.AsJSON~}"
        jo:Erase["_set_guid"]

        variable jsonvalue jaKeys
        jaKeys:SetValue["${jo.Keys.AsJSON~}"]
        jo:SetValue["[]"]

        variable uint i
        for (i:Set[1] ; ${i}<=${jaKeys.Used} ; i:Inc)
        {
            jo:Add["$$>
            {
                "display_name":${jaKeys[${i}].AsJSON~}
            }
            <$$"]
        }
    
        Games:SetValue["${jo.AsJSON~}"]
        LGUI2.Element[BasicLauncher.events]:FireEventHandler[onGamesUpdated]
    }
}

variable(global) basiclauncher BasicLauncher

function main()
{
    while 1
        waitframe
}