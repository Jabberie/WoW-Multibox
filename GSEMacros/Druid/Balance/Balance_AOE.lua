Sequences['Boomkin_AOE'] = {
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
        "/castsequence Lunar Strike, Solar Wrath, [@player] Starfall, Solar Wrath, Lunar Strike, [@player] Starfall",
        "/castsequence [combat] Solar Wrath, Lunar Strike, Solar Wrath, Moonfire",
        "/castsequence [combat] Solar Wrath, [@player] Starfall, Lunar Strike, Solar Wrath",
        "/castsequence [combat] Solar Wrath, Lunar Strike, [@player] Starfall, Moonfire",
        "/castsequence [combat] Lunar Strike, Solar Wrath, Lunar Strike",
        "/cast New Moon",
        "/cast [combat, @player] Starfall",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Celestial Alignment",
        "/cast [combat] Berserking",
      },
    },
  },
}
