Sequences['JMM_HU_MM_AoE'] = {
  Author="Jabberie@Draka",
  SpecID=254,
  Talents = "1113312",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Priority",
      KeyPress={
        "/cast [@focus, nodead][@party1, nodead][@pet, nodead] Misdirection",
      },
      PreMacro={
      },
        "/cast [talent:6/1] A Murder of Crows; [talent:6/2] Barrage",
        "/cast [nochanneling] Piercing Shot",
        "/cast [nochanneling] Windburst",
        "/castsequence [nochanneling] !Marked Shot, !Marked Shot",
        "/cast [nochanneling] Multi-Shot",
        "/castsequence Aimed Shot, Aimed Shot, Aimed Shot",
        "/cast [nochanneling] Multi-Shot",
        "/castsequence [nochanneling] !Marked Shot, !Marked Shot",
        "/cast [nochanneling] Multi-Shot",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Trueshot",
        "/cast [combat] Blood Fury",
        "/cast [combat] Berserking",        
      },
    },
  },
}