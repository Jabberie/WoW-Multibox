Sequences['Boomkin_ST'] = {
  Author="Jabberie@Draka",
  SpecID=102,
  Talents = "3,1,3,1,1,1,3",
  Default=1,
  Icon='Spell_Nature_StarFall',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [noform:4] Moonkin Form",
      },
      PreMacro={
      },
        "/castsequence  reset=target/combat  Sunfire, null",
        "/castsequence  reset=target/combat  Moonfire, null",
        "/cast New Moon",
        "/castsequence [combat] Starsurge, Solar Wrath, Lunar Strike, Solar Wrath",
        "/castsequence Lunar Strike, Solar Wrath, Starsurge, Solar Wrath, Lunar Strike, Starsurge",
        "/castsequence [combat] Solar Wrath, Lunar Strike, Solar Wrath, Moonfire",
        "/castsequence [combat] Solar Wrath, Starsurge, Lunar Strike, Solar Wrath",
        "/castsequence [combat] Starsurge, Solar Wrath, Solar Wrath, Sunfire",
        "/castsequence [combat] Solar Wrath, Lunar Strike, Starsurge, Moonfire",
        "/castsequence [combat] Lunar Strike, Solar Wrath, Lunar Strike",
        "/cast New Moon",
        "/cast Starsurge",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Celestial Alignment",
        "/cast [combat] Berserking",
      },
    },
  },
}