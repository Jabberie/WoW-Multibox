objectdef bpUplink
{
    method Initialize()
    {
        maxfps -fg -calculate 30
        maxfps -bg -calculate 30
        Proc -all

        LGUI2:LoadPackageFile[BasicPerformance.Uplink.lgui2Package.json]
    }

    method Shutdown()
    {
        LGUI2:UnloadPackageFile[BasicPerformance.Uplink.lgui2Package.json]
    }
}

variable(global) bpUplink BPUplink

function main()
{
    while 1
        waitframe
}