Sequences['Arcane_ST_Burn'] = {
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
        "/cast Arcane Blast",
        "/cast Arcane Missiles",      
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Presence of Mind",
        "/cast [combat] Arcane Power",
        "/cast [combat] Blood Fury",
      },
    },
  },
}