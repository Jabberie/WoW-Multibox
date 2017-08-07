Sequences['AffinityBoom'] = {
  Author="Jabberie@Draka",
  SpecID=105,
  Talents = "?,?,1,?,?,?,?",
  Help = "Tier 3 choose Balance Affinity",
  Default=1,
  Icon='Spell_Nature_HealingTouch',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [noform:4] Moonkin Form",
      },
      PreMacro={
      },
        "/castsequence  reset=target  Moonfire, Sunfire, null",
        "/castsequence [combat] Solar Wrath, Solar Wrath, Solar Wrath, Lunar Strike",
        "/cast [combat] Starsurge",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}
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

Sequences['Boomkin_AOE'] = {
  Author="Jabberie@Draka",
  SpecID=102,
  Talents = "3,1,3,1,1,1,3",
  Default=1,
  Icon='Spell_Nature_StarFall',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [noform:4] Moonkin Form",
      },
      PreMacro={
      },
        "/castsequence  reset=target/combat  Sunfire, null",
        "/castsequence  reset=target/combat  Moonfire, null",
        "/cast New Moon",
        "/castsequence Lunar Strike, Solar Wrath, [@player] Starfall, Solar Wrath, Lunar Strike, [@player] Starfall",
        "/castsequence [combat] Solar Wrath, Lunar Strike, Solar Wrath, Moonfire",
        "/castsequence [combat] Solar Wrath, [@player] Starfall, Lunar Strike, Solar Wrath",
        "/castsequence [combat] Solar Wrath, Lunar Strike, [@player] Starfall, Moonfire",
        "/castsequence [combat] Lunar Strike, Solar Wrath, Lunar Strike",
        "/cast New Moon",
        "/cast [combat, @player] Starfall",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Celestial Alignment",
        "/cast [combat] Berserking",
      },
    },
  },
}

Sequences['Boomkin_ST'] = {
  Author="Jabberie@Draka",
  SpecID=102,
  Talents = "3,1,3,1,1,1,3",
  Default=1,
  Icon='Spell_Nature_StarFall',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [noform:4] Moonkin Form",
      },
      PreMacro={
      },
        "/castsequence  reset=target/combat  Sunfire, null",
        "/castsequence  reset=target/combat  Moonfire, null",
        "/cast New Moon",
        "/castsequence [combat] Starsurge, Solar Wrath, Lunar Strike, Solar Wrath",
        "/castsequence Lunar Strike, Solar Wrath, Starsurge, Solar Wrath, Lunar Strike, Starsurge",
        "/castsequence [combat] Solar Wrath, Lunar Strike, Solar Wrath, Moonfire",
        "/castsequence [combat] Solar Wrath, Starsurge, Lunar Strike, Solar Wrath",
        "/castsequence [combat] Starsurge, Solar Wrath, Solar Wrath, Sunfire",
        "/castsequence [combat] Solar Wrath, Lunar Strike, Starsurge, Moonfire",
        "/castsequence [combat] Lunar Strike, Solar Wrath, Lunar Strike",
        "/cast New Moon",
        "/cast Starsurge",
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Celestial Alignment",
        "/cast [combat] Berserking",
      },
    },
  },
}
Sequences['BattleRez'] = {
  Author="Jabberie@Draka",
  SpecID=103,
  Talents = "?,?,?,?,?,?,?",
  Helplink = "",
  Default=1,
  Icon='Spell_Nature_Reincarnation',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
      },
      PreMacro={
      },
        "/cast [@focus,dead,combat][@party1,dead,combat][@party2,dead,combat][@party3,dead,combat][@party4,dead,combat][@party5,dead,combat] Rebirth",
      PostMacro={
      },
      KeyRelease={
      },
    },
  },
}


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

Sequences['Guardian_ST'] = {
  Author="Jabberie@Draka",
  SpecID=104,
  Talents = "3,3,1,1,1,2,1",
  Default=1,
  Icon='Ability_Racial_BearForm',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/cast [noform:1] !Bear Form", -- bear form from any other
        "/castsequence  reset=target  Moonfire, null", -- moonfire pull 
      },
      PreMacro={
      },
        "/cast [combat] Thrash",
        "/castsequence [combat] Swipe, Mangle, Swipe, Mangle, Moonfire",
        "/castsequence [combat] Ironfur, Mark of Ursol",
        "/cast [combat] Thrash",
        "/castsequence [combat] Mangle, Rage of the Sleeper",
        "/castsequence [combat] Mangle, Mangle, Mangle, Frenzied Regeneration",
        "/cast [combat] Thrash",
      PostMacro={
      },
      KeyRelease={
        "/cast Mangle",
        "/cast [@focus,dead,combat][@party2,dead,combat] Rebirth", -- only BR Slot2 or focus
      },
    },
  },
}
Sequences['Restoration'] = {
  Author="Jabberie@Draka",
  SpecID=105,
  Talents = "2,1,1,1,3,2,2",
  Default=1,
  Icon='Spell_Nature_HealingTouch',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/stopmacro [channeling]", -- to protect tranq
        "/cast [talent:3/1, noform:5] !Treant Form; [talent:3/2, noform:4][talent:3/3, noform:4] !Treant Form", -- form # moves if boomkin affinity is picked
        "/castsequence [@player] reset=combat  Efflorescence, null", -- drops Efflorescence at the start of the fight
      },
      PreMacro={
      },
        "/cast [@focus,exists][@Party1,exists] Cenarion Ward",
        "/castsequence [@focus,exists][@Party1,exists] reset=15/combat Lifebloom, Regrowth, Rejuvenation, Wild Growth, Healing Touch",
        "/castsequence [@focus,exists][@Party1,exists] reset=15/combat Healing Touch, Healing Touch, Swiftmend",
        "/castsequence [@focus,exists][@Party1,exists] reset=15/combat Healing Touch, Regrowth, Rejuvenation, Ironbark",
      PostMacro={
      },
      KeyRelease={
      "/cast [@focus,dead,combat][@party1,dead,combat] Rebirth", -- only BR the tank or focus
      },
    },
  },
}
