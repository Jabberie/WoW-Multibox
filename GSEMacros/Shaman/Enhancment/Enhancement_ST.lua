Sequences['Enhancement_ST'] = {
  Author="Jabberie@Draka",
  SpecID=263,
  Talents = "3112213",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [combat] Doom Winds",
      },
      PreMacro={
      },
        "/cast Rockbiter",
        "/cast Earthen Spike",
        "/castsequence  reset=9  Lightning Bolt",
        "/cast Flametongue",
        "/cast [combat] Crash Lightning",
        "/cast [combat] Feral Spirit",
        "/cast Stormstrike",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}