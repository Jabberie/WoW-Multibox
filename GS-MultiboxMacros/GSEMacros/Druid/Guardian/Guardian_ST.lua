Sequences['Guardian_ST'] = {
  Author="Jabberie@Draka",
  SpecID=104,
  Talents = "3,3,1,1,1,2,1",
  Default=1,
  Icon='Ability_Racial_BearForm',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/cast [noform:1] !Bear Form", -- bear form from any other
        "/castsequence  reset=target  Moonfire, null", -- moonfire pull 
      },
      PreMacro={
      },
        "/cast [combat] Thrash",
        "/castsequence [combat] Swipe, Mangle, Swipe, Mangle, Moonfire",
        "/castsequence [combat] Ironfur, Frenzied Regeneration",
        "/cast [combat] Thrash",
        "/castsequence [combat] Mangle, Rage of the Sleeper",
        "/castsequence [combat] Mangle, Mangle, Mangle, Frenzied Regeneration",
        "/cast [combat] Thrash",
      PostMacro={
      },
      KeyRelease={
        "/cast Mangle",
      },
    },
  },
}