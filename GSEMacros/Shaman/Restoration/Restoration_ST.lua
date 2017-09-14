Sequences['Restoration_ST'] = {
  Author="Jabberie@Draka",
  SpecID=264,
  Talents = "3213323",
  Default=1,
  Icon='Spell_Nature_MagicImmunity',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
      	"/stopmacro [channeling]", 
      },
      PreMacro={
      },
        "/cast [@focus, exists, nodead][@Party1, exists, nodead][] Riptide",
        "/castsequence [combat, mod:shift] reset=combat Flame Shock, Lava Burst, Lightning Bolt, Lightning Bolt, Lightning Bolt, Lightning Bolt",
        "/castsequence [@focus, exists, nodead][@Party1, exists, nodead][] Healing Wave, Healing Wave",
        "/cast [@player, combat] Healing Rain",
        "/cast [@player, combat] Gift of the Queen",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Healing Stream Totem",
        "/cast [combat] Blood Fury",
      },
    },
  },
}

