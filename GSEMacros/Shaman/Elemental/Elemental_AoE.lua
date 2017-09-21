Sequences['Elemental_AoE'] = {
  Author="Thundrella@Draka",  
  SpecID=262,
  Talents = "3212332",
  Default=1,
  Icon='Spell_Nature_Lightning',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/castsequence  reset=target  Flame Shock, null",
        "/castsequence  [talent:1/3] reset=combat  Totem Mastery, null",
      },
      PreMacro={
      },
        "/cast Stormkeeper",
        "/castsequence Chain Lightning, Chain Lightning, Chain Lightning, Flame Shock",                
        "/cast [talent:5/3] Elemental Blast",
        "/castsequence Chain Lightning, Chain Lightning, Flame Shock",
        "/castsequence Chain Lightning, Chain Lightning, Chain Lightning, Earth Shock",
        "/castsequence Chain Lightning, [@player,combat] Earthquake",
        "/castsequence Chain Lightning, [@player,combat] Liquid Magma Totem",
      PostMacro={
      },
      KeyRelease={
        "/cast Lava Burst",
      },
    },
  },
}