Sequences['AffinityBoom'] = {
  Author="Jabberie@Draka",
  SpecID=105,
  Talents = "?,?,1,?,?,?,?",
  Help = "Tier 3 choose Balance Affinity",
  Default=1,
  Icon='Spell_Nature_HealingTouch',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [noform:4] Moonkin Form",
      },
      PreMacro={
      },
        "/castsequence  reset=target  Moonfire, Sunfire, null",
        "/castsequence [combat] Solar Wrath, Solar Wrath, Solar Wrath, Lunar Strike",
        "/cast [combat] Starsurge",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}