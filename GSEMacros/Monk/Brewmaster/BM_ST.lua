Sequences['BM_ST'] = {
  SpecID = 268,
  Author = "Jabberie@Draka",
  Talents = "2113112",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress = {
        "/stopmacro [channeling]"
      },
        "/castsequence Keg Smash, Tiger Palm, Blackout Strike, Tiger Palm",      
        "/castsequence [combat] reset=combat Rushing Jade Wind, Breath of Fire, Tiger Palm, Keg Smash",
        "/castsequence [combat] reset=combat Ironskin Brew, Tiger Palm, Blackout Strike",
        "/cast [@player, combat] Exploding Keg",        
      KeyRelease={
        "/cast [combat] Blood Fury",
        "/cast [combat] Berserking",
      },
    },
  },
}