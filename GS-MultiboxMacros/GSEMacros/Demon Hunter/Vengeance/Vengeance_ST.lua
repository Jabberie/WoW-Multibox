Sequences['Vengeance_ST'] = {
  Author="Jabberie@Draka",
  SpecID=581,
  Talents = "3222233",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
      },
      PreMacro={
      },
        "/cast [combat] Immolation Aura",
        "/cast Fiery Brand",
        "/cast Soul Carver",
        "/cast [@player, combat] Sigil of Flame",
        "/cast Shear",
        "/cast [combat] Empower Wards",
        "/castsequence [@player, combat] Infernal Strike, Shear, Shear, Infernal Strike",
        "/cast [combat] Immolation Aura",
        "/cast Fracture",
        "/cast Fracture",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Demon Spikes",
        "/cast [combat] Soul Barrier",
      },
    },
  },
}