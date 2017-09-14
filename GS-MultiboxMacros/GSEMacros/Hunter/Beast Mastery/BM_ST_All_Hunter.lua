Sequences['BM_ST_All_Hunter'] = {
  Author="Jabberie@draka",  
  SpecID=253,
  Talents = "3112333",
  Default=1,
  Icon='ability_hunter_bestialdiscipline',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [@focus, exists, nodead][@pet, exists, nodead] Misdirection",
      },
      PreMacro={
      },
        "/cast [nopet] Call Pet 1",
        "/cast Dire Beast",
        "/cast [nopet][@pet,dead] Revive Pet",
        "/castsequence Kill Command, Cobra Shot, Cobra Shot, Multi-Shot",
        "/castsequence [combat] Dire Beast, Titan's Thunder",
        "/cast [combat] Mend Pet",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Bestial Wrath",
        "/cast [combat] Blood Fury",
        "/cast [combat] Aspect of the Wild",
      },
    },
  },
}