Sequences['BM_Ridosaw'] = {
-- This Sequence was exported from GSE 2.1.00.
  Author="Jabberie@draka",
  SpecID=253,
  Talents = "31133?3",
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
        "/castsequence Kill Command, Cobra Shot, Cobra Shot, Cobra Shot",
        "/cast [combat] Mend Pet",
	      "/castsequence Kill Command, Multi-Shot, Multi-Shot, Multi-Shot",
        "/cast Kill Command",
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