Sequences['Disc_AoE'] = {
  Author="Jabberie@Draka",
  SpecID=256,
  Talents = "1123113",
  Default=1,
  Icon='Spell_Holy_PowerWordShield',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/stopmacro [channeling:Penance]",
        "/castsequence [@focus, exists, combat][@party1, exists, combat] reset=combat  Plea, null",
        "/castsequence [talent:7/1] reset=combat  Smite, Purge the Wicked, null; [talent:7/2][talent:7/3] reset=combat  Smite, Shadow Word: Pain, null",
      },
      PreMacro={
      },
        "/castsequence [@focus, exists][@party1, exists] reset=combat Power Word: Shield, Shadow Mend",
        "/castsequence [talent:7/2][talent:7/3] reset=combat  Smite, Smite, Smite, Shadow Word: Pain;[talent:7/1] Smite, Smite, Smite, Purge the Wicked",
        "/castsequence [combat] reset=combat  Smite, [combat, harm] Penance, [combat, harm] Penance, Power Word: Radiance",
        "/cast [@focus, exists][@party1, exists] Power Word: Shield",
        "/castsequence [talent:4/3] reset=combat  Smite, Mindbender;  reset=combat  Smite, Shadowfiend",
        "/cast [combat, harm] Penance",        
        "/castsequence [combat] reset=combat  Smite, [combat, harm] Penance, Power Word: Radiance, Evangelism",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}