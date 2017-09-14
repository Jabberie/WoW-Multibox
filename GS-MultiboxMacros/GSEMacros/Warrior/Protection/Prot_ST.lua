Sequences['Prot_ST'] = {
  Author="Jabberie@Draka",
  SpecID=73,
  Talents = "1223312",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/castsequence [combat] reset=combat Devastate, Thunder Clap, null",
      },
      PreMacro={
      },
        "/cast Devastate",
        "/cast [combat] Shield Block",
        "/cast Shield Slam",
        "/castsequence [combat] reset=combat Revenge, Ignore Pain",
        "/cast Shield Slam",
        "/castsequence [combat] reset=combat Devastate, Shockwave",
        "/castsequence [combat] reset=combat Devastate, Thunder Clap",
        "/cast Shield Slam",
        "/castsequence [combat] reset=combat Revenge, Ignore Pain",
        "/cast Victory Rush",
        "/cast Shield Slam",
      PostMacro={
      },
      KeyRelease={
        "/castsequence [combat] reset=combat Devastate, Demoralizing Shout",
        "/castsequence [combat] reset=combat Devastate, Battle Cry",
        "/cast [combat] Blood Fury",
      },
    },
  },
}