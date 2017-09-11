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
        "/use [mod:alt] Drain Life",
        "/castsequence  reset=target  Doom, null",
      },
      PreMacro={
      },
        "/castsequence [nochanneling] Demonbolt, Call Dreadstalkers, Demonic Empowerment, Life Tap",
        "/castsequence [nochanneling] Demonbolt, Hand of Gul'dan, Demonic Empowerment",
        "/castsequence [nochanneling] Summon Doomguard, Demonic Empowerment",
        "/castsequence [nochanneling] Demonbolt, Hand of Gul'dan, Call Dreadstalkers, Thal'kiel's Consumption",
        "/castsequence [nochanneling] Demonbolt, Demonbolt, Grimoire: Felguard, Demonic Empowerment",
        "/cast [nochanneling] Command Demon",
        "/cast [nochanneling] Demonbolt",
      PostMacro={
      },
      KeyRelease={
        "/petautocastoff [group] Threatening Presence",
        "/petautocaston [nogroup] Threatening Presence",
      },
    },
  },
}
 
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
        "/use [mod:alt] Drain Life",
        "/castsequence  reset=target  Doom, null",
      },
      PreMacro={
      },
        "/castsequence [nochanneling] Demonwrath, Hand of Gul'dan, Demonic Empowerment, Demonwrath, Demonwrath, Life Tap",
        "/cast [nochanneling] Grimoire: Felguard",
        "/cast [nochanneling] Command Demon",
      PostMacro={
      },
      KeyRelease={
        "/petautocastoff [group] Threatening Presence",
        "/petautocaston [nogroup] Threatening Presence",
      },
    },
  },
}