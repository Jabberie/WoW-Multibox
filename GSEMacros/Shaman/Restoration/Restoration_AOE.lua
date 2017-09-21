Sequences['Restoration_AOE'] = {
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
        "/cast [@focus, exists, nodead][@Party1, exists, nodead][] Chain Heal",
        "/cast [@player, combat] Gift of the Queen",
        "/cast [@player, combat]  Healing Rain",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Healing Stream Totem",
        "/cast [combat] Blood Fury",
      },
    },
  },
}