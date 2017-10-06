Sequences['Restoration_Test'] = {
-- This Sequence was exported from GSE 2.2.00.
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
        "/cast [@focus, exists, noform:5] Treant Form; [@focus, nohelp, noform:4] Moonkin Form",
      },
      PreMacro={
      },
        "/castsequence [@focus,exists] reset=15/combat  Cenarion Ward; Solar Wrath, Solar Wrath, Lunar Strike, Sunfire",
        "/castsequence [@focus,exists] reset=15/combat  Lifebloom, Regrowth, Rejuvenation, Wild Growth, Healing Touch;  reset=target  Moonfire, Sunfire, null",
        "/castsequence [@focus,exists] reset=15/combat  Regrowth, Healing Touch, Swiftmend; Solar Wrath, Lunar Strike, Lunar Strike, Moonfire",
        "/castsequence [@focus,exists] reset=15/combat  Healing Touch, Regrowth, Rejuvenation, Ironbark; Starsurge",
      PostMacro={
      },
      KeyRelease={
      },
    },
    [2] = {
      StepFunction = "Sequential",
      KeyPress={
        "/stopmacro [channeling]",
        "/cast [talent:3/1, noform:5] Treant Form; [talent:3/2, noform:4][talent:3/3, noform:4] Treant Form",
        "/castsequence [@player] reset=combat  Efflorescence, null",
      },
      PreMacro={
      },
        "/cast [@focus,exists][@Party1,exists] Cenarion Ward",
        "/castsequence [@focus,exists][@Party1,exists] reset=15/combat  Lifebloom, Regrowth, Rejuvenation, Wild Growth, Healing Touch",
        "/castsequence [@focus,exists][@Party1,exists] reset=15/combat  Regrowth, Healing Touch, Swiftmend",
        "/castsequence [@focus,exists][@Party1,exists] reset=15/combat  Healing Touch, Regrowth, Rejuvenation, Ironbark",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}
