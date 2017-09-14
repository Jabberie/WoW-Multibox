Sequences['Arcane_ST_AIO'] = {
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
        "/cast [mod:shift] Arcane Blast",
        "/castsequence [nomod] Arcane Blast, Arcane Blast, Arcane Blast, Arcane Blast, Arcane Barrage",
        "/cast [mod:shift] Arcane Missiles",      
      PostMacro={
      },
      KeyRelease={
        "/cast [combat, mod:shift] Presence of Mind",
        "/cast [combat, mod:shift] Arcane Power",
        "/cast [combat] Blood Fury",
      },
    },
  },
}