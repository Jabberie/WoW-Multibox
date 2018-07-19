Sequences['BM_AoE'] = {
  Author="Jabberie@draka",  
  SpecID=253,
  Talents = "2,1,1,1,?,1,3",
  Default=1,
  Icon='ability_hunter_bestialdiscipline',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [@focus, nodead][@party1, nodead][@pet, nodead] Misdirection",
        "/petautocastoff [group] Growl",
        "/petautocaston [nogroup] growl",
      },
      PreMacro={
      },
        "/cast [nopet][@pet,dead] Revive Pet",
        "/cast Dire Beast",
        "/cast [nopet] Call Pet 1",
        "/castsequence Kill Command, Multi-Shot, Multi-Shot, Multi-Shot, Multi-Shot",
        "/cast [talent:6/1] A Murder of Crows; [talent:6/2] Barrage",
        "/castsequence [combat] Dire Beast, Titan's Thunder",
        "/castsequence Kill Command, Multi-Shot, Multi-Shot, Multi-Shot, Multi-Shot",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Bestial Wrath",
        "/cast [combat] Blood Fury",
        "/cast [combat] Berserking",
        "/cast [combat] Aspect of the Wild",
      },
    },
  },
}


