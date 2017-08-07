Sequences['Ret_AoE'] = {
  Author="Jabberie@Draka",
  SpecID=70,
  Talents = "3133222",
  Default=1,
  Icon='Spell_Holy_AuraOfLight',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
      },
      PreMacro={
      },
        "/cast Crusader Strike",      
        "/cast [combat] Blade of Justice",
        "/cast [combat] Judgment",
        "/cast [combat] Divine Storm",
        "/cast [combat] Wake of Ashes",
        "/cast Crusader Strike",
        "/cast [combat] Divine Storm",
        "/cast [combat] Judgment",
        "/cast [combat] Wake of Ashes",
        "/cast [combat] Divine Hammer",        
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}