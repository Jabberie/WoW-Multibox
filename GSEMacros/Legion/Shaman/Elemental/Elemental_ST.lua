Sequences['Elemental_ST'] = {
  Author="Thundrella@Draka",  
  SpecID=262,
  Talents = "3212312",
  Default=1,
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
        "/cast [talent:5/3] Elemental Blast",
        "/cast Lava Burst",
        "/castsequence Lightning Bolt, Lightning Bolt, Flame Shock",
        "/cast [talent:5/3] Elemental Blast",
        "/cast Lava Burst",
        "/castsequence Lightning Bolt, Lightning Bolt, Lightning Bolt, Earth Shock",
        "/cast [combat] Fire Elemental",
      PostMacro={
      },
      KeyRelease={
        "/cast Lava Burst",
      },
    },
  },
}