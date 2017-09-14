Sequences['BM_AoE_Farm'] = {
  Author="Jabberie@Draka",
  SpecID=253,
  Talents = "31133?3",
  Default=1,
  Icon='ability_hunter_bestialdiscipline',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/targetenemy [noharm][dead]", -- auto targets a new mob when your current one dies
        "/cast [@focus, exists, nodead][@pet, exists, nodead] Misdirection", -- MD to your own pet or focus
      },
      PreMacro={
      },
        "/cast [nopet] Call Pet 2", -- Pet 2 is a tenacity pet
        "/cast Dire Beast",
        "/castsequence Kill Command, Multi-Shot, Multi-Shot, Multi-Shot, Multi-Shot",
        "/cast [nopet][@pet,dead] Revive Pet",        
        "/castsequence [combat] reset=combat  Dire Beast, Titan's Thunder, Fetch",
        "/cast [combat] Mend Pet",
        "/cast Kill Command",
        "/castsequence Kill Command, Multi-Shot, Multi-Shot, Fetch",
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
