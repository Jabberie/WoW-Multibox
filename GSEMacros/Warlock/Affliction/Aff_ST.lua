Sequences['Aff_ST'] = {
  Author="Jabberie@draka",
  SpecID=265,
  Talents = "3121113",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/stopmacro [channeling]",
        "/castsequence reset=target/combat  Agony, Corruption, Unstable Affliction, Drain Soul, Null",
      },
      PreMacro={
      },
        "/cast [mod:shift] Seed of Corruption",
        "/castsequence [combat] reset=combat Phantom Singularity, Unstable Affliction, Unstable Affliction",
        "/castsequence reset=combat/target  Drain Soul, Agony, Corruption, Drain Soul, Agony, Corruption, Unstable Affliction, Life Tap",
        "/castsequence [combat] reset=combat Reap Souls, Unstable Affliction, Unstable Affliction",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",
        "/cast [combat] Berserking",
      },
    },
  },
} 