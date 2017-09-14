Sequences['Destro_AOE'] = {
  Author="Jabberie@Draka",
  SpecID=267,
  Talents = "1331222",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Priority",
      KeyPress={
        "/stopmacro [channeling]", 
        "/cast [nopet] Summon Imp",      
        "/castsequence reset=target Immolate, null",
      },
      PreMacro={
      },
        "/cast [@player] Rain of Fire",
        "/cast Conflagrate",
        "/cast [@player] Cataclysm",
        "/cast Channel Demonfire",
        "/cast Shadow Bolt",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",
      },
    },
  },
}