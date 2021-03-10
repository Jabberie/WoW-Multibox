objectdef bhSession
{
    variable bool HighlightFullSize=FALSE

    method Initialize()
    {
        LavishScript:RegisterEvent[OnFrame]
        Event[OnFrame]:AttachAtom[This:OnFrame]
        LGUI2:LoadPackageFile[BasicHighlighter.Session.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[BasicHighlighter.Session.lgui2Package.json]
    }

    member:bool IsFullSize()
    {
        if ${Display.ViewableWidth}!=${Display.Width}
            return FALSE
        if ${Display.ViewableHeight}!=${Display.Height}
            return FALSE
        return TRUE
    }

    method OnFrame()
    {
        if ${Display.Window.IsForeground}
        {
            if !${This.HighlightFullSize} && ${This.IsFullSize}
                LGUI2.Element[bh.Highlight]:SetVisibility[Hidden]
            else
                LGUI2.Element[bh.Highlight]:SetVisibility[Visible]


            LGUI2.Element[bh.Number]:SetVisibility[Hidden]
        }
        else
        {
            LGUI2.Element[bh.Highlight]:SetVisibility[Hidden]
            LGUI2.Element[bh.Number]:SetVisibility[Visible]
        }        
    }
}

variable(global) bhSession BHSession

function main()
{
    while 1
        waitframe
}