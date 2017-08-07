Sequences['Feral_ST'] = {
  Author="Jabberie@Draka",
  SpecID=103,
  Talents = "2,1,1,1,1,1,2", -- talents are important for this one
  Helplink = "https://www.youtube.com/watch?v=IT31Rp7aIOU",
  Default=1,
  Icon='Ability_Druid_CatForm',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/cast [noform:2] !Cat Form", -- cat form from any other
        "/cast [nostealth, nocombat] Prowl", -- prowl out of combat
        "/castsequence [combat] reset=combat  Rake, Shred, Shred, Rip, nulll",
      },
      PreMacro={
      },
        "/castsequence reset=combat  Shred, Rake, Shred, Shred, Ferocious Bite",
        "/castsequence [combat] reset=combat  Shred, Rake, Tiger's Fury",
        "/cast [combat] Ashamane's Frenzy",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Berserk",
        "/console autounshift 0",   -----------------------------------------------
        "/cast [@player] Regrowth", -- change @player to a name/focus or @party1 --
        "/console autounshift 1",   -----------------------------------------------
      },
    },
  },
}
