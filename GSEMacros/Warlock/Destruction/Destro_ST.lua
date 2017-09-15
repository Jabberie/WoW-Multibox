Sequences['Destro_ST'] = {
  Author = "Jabberie@Draka",
  SpecID=267,
  Talents = "1,1,?,2,1,1,2",
  Default=1,
  Icon="INV_MISC_QUESTIONMARK",
  MacroVersions = {
    [1] = {
      StepFunction = "Priority",
      KeyPress={
        "/stopmacro [channeling]", 
        "/cast [nopet] Summon Doomguard", 
        "/castsequence reset=target Immolate, null",
      },
      PreMacro={
      },
        "/castsequence reset=combat Immolate, Shadow Bolt, Shadow Bolt, Shadow Bolt",
        "/cast Chaos Bolt",
        "/cast Conflagrate",
        "/cast [combat] Dimensional Rift",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",
        "/cast [combat] Berserking",     
      },
    },
  },
}
