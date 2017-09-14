local _, Sequences = ...
---------------------------
---------------------------
---------------------------
Sequences['Demo_ST'] = {
  Author="Jabberie@draka",
  SpecID=266,
  Talents = "3,1,2,1,1,2,2",
  Help = "",
  Default=1,
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
        "/castsequence reset=combat/15 Shadow Bolt, Call Dreadstalkers, Demonic Empowerment, Life Tap, Shadow Bolt",
        "/castsequence reset=combat/15 Shadow Bolt, Hand of Gul'dan, Demonic Empowerment, Shadow Bolt",
        "/castsequence [combat] reset=combat/15 Shadow Bolt, Summon Doomguard, Demonic Empowerment, Shadow Bolt",
        "/castsequence reset=combat/15 Shadow Bolt, Hand of Gul'dan, Call Dreadstalkers, Thal'kiel's Consumption, Shadow Bolt",
        "/castsequence reset=combat/15 Shadow Bolt, Shadow Bolt, Grimoire: Felguard, Demonic Empowerment, Shadow Bolt",
        "/castsequence [combat] reset=combat/15 Shadow Bolt, Command Demon",
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