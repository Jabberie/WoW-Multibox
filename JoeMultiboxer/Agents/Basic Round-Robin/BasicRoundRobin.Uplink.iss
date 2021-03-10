#include "BasicRoundRobin.Common.iss"

objectdef brrUplink
{
    variable brrSettings Settings

    variable bool RestoreFocusFollowsMouse

    variable weakref:brrProfile EditingProfile

    method Initialize()
    {
        LGUI2:LoadPackageFile[BasicRoundRobin.Uplink.lgui2Package.json]
        Settings:Store

        This:SetEditingProfile["${Settings.Profiles.FirstKey~}"]
    }

    method Shutdown()
    {
        LGUI2.Element[brr.popupNewProfile]:Destroy
        LGUI2:UnloadPackageFile[BasicRoundRobin.Uplink.lgui2Package.json]
    }

    method SetIgnoreValue(string key, bool newValue)
    {
        LGUI2.DataBindingContext.Locate["",itemview,ancestor].Item.Data:Set[ignore,${newValue}]

        EditingProfile.Overrides["${key~}"]:Set["ignore",${newValue}]
    }

     method SetAllowValue(string key, bool newValue)
    {
        LGUI2.DataBindingContext.Locate["",itemview,ancestor].Item.Data:Set[allow,${newValue}]

        EditingProfile.Overrides["${key~}"]:Set["allow",${newValue}]
    }

    method SetEditingProfile(string newValue)
    {
;        echo SetEditingProfile["${newValue~}"]
        EditingProfile:SetReference["Settings.Profiles[\"${newValue~}\"]"]
        LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onEditingProfileChanged]
    }

    method ToggleProfile(string newProfile)
    {
        if !${newProfile.NotNULLOrEmpty} || ${Settings.CurrentProfile.Name.Equal["${newProfile~}"]}
        {
;            echo "[BRR] Disabling"
            ; activating same profile is a toggle off
            Settings:ClearCurrentProfile

            ; push updated setting
            relay all "BRRSession:Disable"

            if ${RestoreFocusFollowsMouse}
            {
                BWLUplink:SetFocusFollowsMouse[TRUE]
            }
        }
        else
        {
;            echo "[BRR] Enabling"
            if !${Settings.CurrentProfile.Reference(exists)}
                RestoreFocusFollowsMouse:Set[${BWLUplink.Settings.FocusFollowsMouse}]

            BWLUplink:SetFocusFollowsMouse[FALSE]
            Settings:SetCurrentProfile["${newProfile~}"]

            ; push updated setting
            relay all "BRRSession:Enable[${newProfile.AsJSON~}]"
        }        
    }

    method GenerateItemView_Profile()
	{
       ; echo GenerateItemView_Game ${Context(type)} ${Context.Args}

		; build an itemview lgui2element json
		variable jsonvalue joListBoxItem
		joListBoxItem:SetValue["${LGUI2.Template["basicRoundRobin.profileView"].AsJSON~}"]
        		
		Context:SetView["${joListBoxItem.AsJSON~}"]
	}

     method GenerateItemView_Override()
	{
;       echo GenerateItemView_Override[${BRRUplink.EditingProfile.Name~}] ${Context(type)} ${Context.Args}

		; build an itemview lgui2element json
		variable jsonvalue joListBoxItem
		joListBoxItem:SetValue["${LGUI2.Template["basicRoundRobin.overrideView"].AsJSON~}"]
        		
		Context:SetView["${joListBoxItem.AsJSON~}"]
	}

    method OnRemoveOverride()
    {
       ; echo OnRemoveOverride ${Context(type)} ${Context.Source} ${Context.Args}

;        echo EditingProfile.Overrides:Erase["${Context.Source.Locate["",itemview,ancestor].Item.Data.Get[key]}"]
        EditingProfile.Overrides:Erase["${Context.Source.Locate["",itemview,ancestor].Item.Data.Get[key]}"]
        LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onOverridesChanged]
    }

    method OnAddButton()
    {
;        echo OnAddButton ${Context(type)} ${Context.Source} ${Context.Args} ${Context.Source.Value.AsJSON~}

        if ${Context.Source.Value.Get[control](type).Name.Equal[unistring]}
        {
            variable jsonvalue joOverride="{}"
            if ${EditingProfile.DefaultAllow}
                joOverride:Set["ignore",true]
            else
                joOverride:Set["allow",true]
            EditingProfile.Overrides:Set["${Context.Source.Value.Get[control]~}","${joOverride.AsJSON~}"]
            LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onOverridesChanged]
        }
    }

    method OnCopySelected()
    {
        variable string name
        name:Set["${LGUI2.Element[brr.newProfileName].Text~}"]
        if !${name.NotNULLOrEmpty}
        {
            LGUI2.Element[brr.newProfileName]:KeyboardFocus
            return
        }

        if !${EditingProfile.Reference(exists)}
            return

        Settings.Profiles:Set["${name~}","${EditingProfile.AsJSON~}"]
        Settings.Profiles["${name~}"].Name:Set["${name~}"]
        LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onProfilesUpdated]

        LGUI2.Element[brr.popupNewProfile]:ToggleOpen

        This:SetEditingProfile["${name~}"]
    }

    method OnNewEmptyProfile()
    {
        variable string name
        name:Set["${LGUI2.Element[brr.newProfileName].Text~}"]
        if !${name.NotNULLOrEmpty}
        {
            LGUI2.Element[brr.newProfileName]:KeyboardFocus
            return
        }

        Settings.Profiles:Set["${name~}","{}"]
        Settings.Profiles["${name~}"].Name:Set["${name~}"]
        LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onProfilesUpdated]
        LGUI2.Element[brr.popupNewProfile]:ToggleOpen

        This:SetEditingProfile["${name~}"]
    }

    method OnDeleteProfile()
    {
        if !${EditingProfile.Reference(exists)}
            return

        Settings.Profiles:Erase["${EditingProfile.Name~}"]
        LGUI2.Element[basicRoundRobin.events]:FireEventHandler[onProfilesUpdated]
    }

    method OnSave()
    {
;       echo OnSave ${Context(type)} ${Context.Source} ${Context.Args}
        Settings:Store

        relay all "BRRSession.Settings:Load"
    }
}

variable(global) brrUplink BRRUplink

function main()
{
    while 1
        waitframe
}