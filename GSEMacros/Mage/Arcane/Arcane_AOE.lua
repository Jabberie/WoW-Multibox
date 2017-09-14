Sequences['Arcane_AoE'] = {
  Author="Jabberie@Draka",
  SpecID=62,
  Talents = "2233122",
  Default=1,
  Icon='INV_MISC_QUESTIONMARK',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/stopmacro [channeling]",
      },
      PreMacro={
      },
        "/castsequence Arcane Explosion, Arcane Explosion, Arcane Explosion, Arcane Explosion, Arcane Barrage",
      PostMacro={
      },
      KeyRelease={
      "/cast [combat] Blood Fury",
      },
    },
  },
}