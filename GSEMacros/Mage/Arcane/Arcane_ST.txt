Sequences['Arcane_ST'] = {
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
        "/cast Prismatic Barrier",
        "/cast [combat] Mark of Aluneth",
        "/castsequence Arcane Blast, Arcane Blast, Arcane Blast, Arcane Blast, Arcane Barrage",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",
      },
    },
  },
}