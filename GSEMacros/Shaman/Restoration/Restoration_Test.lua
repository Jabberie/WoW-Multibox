Sequences['Restoration_Test'] = {
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
        "/castsequence [@focus, exists, nodead] Healing Wave, Healing Wave;  reset=combat/target  Flame Shock, Lightning Bolt, Lightning Bolt, Lightning Bolt, Lightning Bol",
        "/cast [@focus, exists, nodead] Riptide; Lava Burst",
      PostMacro={
      },
      KeyRelease={
        "/cast [@focus, exists, nodead, combat] Healing Stream Totem",
        "/cast [combat] Blood Fury",
      },
    },
    [2] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/stopmacro [channeling]", 
      },
      PreMacro={
      },
        "/cast [@focus, exists, nodead, nomod][@Party1, exists, nodead, nomod] Riptide",
        "/castsequence [combat, mod:ctrl] reset=combat Flame Shock, Lava Burst, Lightning Bolt, Lightning Bolt, Lightning Bolt, Lightning Bolt",
        "/castsequence [@focus, exists, nodead, nomod][@Party1, exists, nodead, nomod][] Healing Wave, Healing Wave",
        "/cast [@player, combat, nomod] Healing Rain",
        "/cast [@player, combat, nomod] Gift of the Queen",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Healing Stream Totem",
        "/cast [combat] Blood Fury",
      },
    },
    [3] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/stopmacro [channeling]", 
      },
      PreMacro={
      },
        "/cast [@focus, exists, nodead][@Party1, exists, nodead] Riptide",
        "/castsequence [@focus, exists, nodead, nomod][@Party1, exists, nodead, nomod] Healing Wave, Healing Wave",
        "/castsequence [@focus, exists, nodead, mod:ctrl][@Party1, exists, nodead, mod:shift] Chain Heal, Chain Heal, Chain Heal",
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

