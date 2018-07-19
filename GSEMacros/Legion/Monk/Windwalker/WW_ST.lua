Sequences['WW_ST'] = {
  Author="Jabberie@Draka",
  SpecID=269,
  Talents = "3233123",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/stopmacro [channeling]"
      },
      PreMacro={
      },
        "/cast Tiger Palm",
        "/cast Rising Sun Kick",
        "/castsequence reset=combat Tiger Palm, Touch of Death",
        "/cast Strike of the Windlord",
        "/castsequence reset=combat Tiger Palm, Fists of Fury",
        "/cast Tiger Palm",
        "/cast [combat] Chi Wave",
        "/castsequence [combat] Fists of Fury, Rising Sun Kick, Blackout Kick",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",      
      },
    },
  },
}