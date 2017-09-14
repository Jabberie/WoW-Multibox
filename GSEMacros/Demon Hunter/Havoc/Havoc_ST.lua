Sequences['Havoc_ST'] = {
  Author="Jabberie@Draka",
  SpecID=577,
  Talents = "2222211",
  Default=1,
  Icon='ability_demonhunter_specdps',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [nochanneling] Blur",
        "/cast [nochanneling] Nemesis",
      },
      PreMacro={
      },
        "/cast [nochanneling] Chaos Blades",
        "/cast [nochanneling] Felblade",
        "/cast [nochanneling, combat] Blade Dance",
        "/cast !Eye Beam",
        "/cast [nochanneling, combat] Fury of the Illidari",
        "/cast [nochanneling] Chaos Strike",
        "/cast [nochanneling] Throw Glaive",
        "/cast [nochanneling] Fel Eruption",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}