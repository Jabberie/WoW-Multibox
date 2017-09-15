Sequences['Demo_AoE'] = {
  Author="Jabberie@draka",
  SpecID=266,
  Talents = "3,1,2,1,1,2,2",
  Help = "",
  Default=1,
  Icon='INV_MISC_QUESTIONMARK',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/stopmacro [channeling]",
        "/cast [mod:shift] Drain Life",
        "/castsequence reset=target Doom, null",
      },
      PreMacro={
      },
        "/castsequence [combat] reset=combat/15 Demonwrath, Hand of Gul'dan, Demonic Empowerment, Demonwrath, Demonwrath, Life Tap",
        "/cast [combat] reset=combat/15 Grimoire: Felguard",
        "/cast [combat] reset=combat/15 Command Demon",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",
        "/cast [combat] Berserking",        
        "/petautocastoff [group] Threatening Presence",
        "/petautocaston [nogroup] Threatening Presence",
      },
    },
  },
}