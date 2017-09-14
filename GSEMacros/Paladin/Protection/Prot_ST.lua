Sequences['Prot_ST'] = {
  Author="Jabberie@Draka",
  SpecID=66,
  Talents = "2133121",
  Default=1,
  Icon='Ability_Paladin_ShieldoftheTemplar',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
      },
      PreMacro={
      },
        "/castsequence  reset=combat  Shield of the Righteous, Consecration, Consecration",
        "/cast Avenger's Shield",
        "/cast Judgment",
        "/cast [combat] Hammer of the Righteous",
        "/cast Avenger's Shield",
        "/castsequence  reset=combat  Shield of the Righteous, Consecration, Consecration",
      PostMacro={
      },
      KeyRelease={
        "/cast Shield of the Righteous",
      },
    },
  },
}
