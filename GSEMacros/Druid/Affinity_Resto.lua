Sequences['AffinityResto'] = {
  Author="Jabberie@Draka",
  SpecID=105,
  Talents = "?,?,3,?,?,?,?",
  Help = "Tier 3 choose Restoration Affinity",
  Default=1,
  Icon='Spell_Nature_StarFall',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [noform:5] Treant Form",
      },
      PreMacro={
      },
        "/castsequence [@focus, exists][@party1, exists][@player] reset=combat/15  Rejuvenation, Regrowth, Healing Touch, Swiftmend, Healing Touch",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}
