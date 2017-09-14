Sequences['Destro_ST'] = {
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
        "/castsequence Immolate, Shadow Bolt, Shadow Bolt, Shadow Bolt, Shadow Bolt, Shadow Bolt",
        "/cast Chaos Bolt",
        "/cast Channel Demonfire",
        "/cast Conflagrate",
        "/cast Grimoire: Imp",
        "/castsequence Shadow Bolt, Shadow Bolt, Shadow Bolt",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",
      },
    },
  },
}