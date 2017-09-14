Sequences['BattleRez'] = {
  Author="Jabberie@Draka",
  SpecID=103,
  Talents = "?,?,?,?,?,?,?",
  Helplink = "",
  Default=1,
  Icon='Spell_Nature_Reincarnation',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
      },
      PreMacro={
      },
        "/cast [@focus,dead,combat][@party1,dead,combat][@party2,dead,combat][@party3,dead,combat][@party4,dead,combat][@party5,dead,combat] Rebirth",
        "/cast [@focus,dead,nocombat][@party1,dead,nocombat][@party2,dead,nocombat][@party3,dead,nocombat][@party4,dead,nocombat][@party5,dead,nocombat] Revive",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}
