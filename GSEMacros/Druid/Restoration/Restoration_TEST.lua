Sequences['Restoration_Test'] = {
  Author="Jabberie@Draka",
  SpecID=105,
  Talents = "2,1,1,1,3,2,2",
  Default=1,
  Icon='Spell_Nature_HealingTouch',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/stopmacro [channeling]", 
        "/cast [talent:3/1, noform:5] !Treant Form; [talent:3/2, noform:4][talent:3/3, noform:4] !Treant Form", 
        "/castsequence [@player, talent:5/3] reset=combat  Efflorescence, null",
      },
      PreMacro={
      },
        "/cast [@focus,exists,talent:1/2][@Party1,exists,talent:1/2] Cenarion Ward; [@focus,exists][@Party1,exists] Regrowth",
        "/castsequence [@focus,exists,talent:2/1][@Party1,exists,talent:2/1] reset=15/combat Lifebloom, Regrowth, Rejuvenation, Healing Touch; [@focus,exists][@Party1,exists] reset=15/combat Regrowth, Rejuvenation, Regrowth",
        "/castsequence [@focus,exists][@Party1,exists] reset=15/combat Regrowth, Regrowth, Healing Touch, Swiftmend, Regrowth",
        "/castsequence [@focus,exists,talent:4/1][@Party1,exists,talent:4/1] reset=15/combat Healing Touch, Regrowth, Rejuvenation, Ironbark; [@focus,exists][@Party1,exists] reset=15/combat Healing Touch, Regrowth, Rejuvenation, Regrowth",
        "/cast [@focus,exists,talent:3/1][@Party1,exists,talent:3/1] Wild Growth",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}
