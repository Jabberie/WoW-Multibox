Sequences['Blood_ST'] = {
  Author="Jabberie@Draka",
  SpecID=250,
  Talents = "2112133",
  Default=1,
  Icon='Spell_Deathknight_BloodPresence',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/cast [combat] Vampiric Blood",
        "/cast [combat] Dancing Rune Weapon",
      },
      PreMacro={
      },
        "/castsequence reset=combat Marrowrend, Marrowrend, Death Strike",
        "/cast Death Strike",
        "/cast [@player, combat] Death and Decay",
        "/cast [combat] Blood Boil",
        "/cast Heart Strike",
        "/castsequence [combat] reset=combat Heart Strike, Consumption",
        "/cast [@player, combat] Death and Decay",
        "/castsequence [combat] reset=combat Blood Boil, Heart Strike, Heart Strike",
        "/castsequence reset=combat Marrowrend, Heart Strike, Blood Boil, Heart Strike",
        "/cast [@player, combat] Death and Decay",        
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Blood Fury",   
        "/cast [combat] Berserking",  
      },
    },
  },
}


