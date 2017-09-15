Sequences['Aff_ST'] = {
  Author = "Jabberie@Draka",
  SpecID=265,
  Talents = "3,1,2,1,1,1,3",
  Default=1,
  Icon="INV_MISC_QUESTIONMARK",
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
        "/castsequence reset=combat/target  Drain Soul, Agony, Corruption, Unstable Affliction, Drain Soul, Agony, Corruption, Life Tap",
        "/castsequence [combat] reset=combat Reap Souls, Unstable Affliction, Unstable Affliction, Unstable Affliction",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",
        "/cast [combat] Berserking",
      },
    },
  },
} 