Sequences['BM_ST'] = {
  Author="Jabberie@draka",
  SpecID=253,
  Talents = "3,1,1,2,3,3,3",
  Default=1,
  Raid=2,
  Dungeon=2,
  Heroic=2,
  Mythic=2,
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
        "/castsequence Kill Command, Cobra Shot, Cobra Shot, Multi-Shot",
        "/cast [talent:6/1] A Murder of Crows; [talent:6/2] Barrage",
        "/castsequence [combat] Dire Beast, Titan's Thunder",
        "/castsequence Kill Command, Cobra Shot, Cobra Shot, Multi-Shot",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Bestial Wrath",
        "/cast [combat] Blood Fury",
        "/cast [combat] Berserking",
        "/cast [combat] Aspect of the Wild",
      },
    },
    [2] = {
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
        "/castsequence Kill Command, Cobra Shot, Cobra Shot, Cobra Shot",
        "/cast [talent:6/1] A Murder of Crows; [talent:6/2] Barrage",
        "/castsequence [combat] Dire Beast, Titan's Thunder",
        "/castsequence Kill Command, Cobra Shot, Cobra Shot, Cobra Shot",
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
