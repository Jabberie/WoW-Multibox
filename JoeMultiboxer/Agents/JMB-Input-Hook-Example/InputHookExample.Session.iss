objectdef iheSession
{
    method Initialize()
    {
        LGUI2:LoadPackageFile[InputHookExample.Session.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[InputHookExample.Session.lgui2Package.json]
    }

    method NextWindow()
    {
        BWLSession:NextWindow
    }
}

variable(global) iheSession IHESession

function main()
{
    while 1
        waitframe
}