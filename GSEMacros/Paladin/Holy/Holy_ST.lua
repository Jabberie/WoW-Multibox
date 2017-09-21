Sequences['Holy_ST'] = {
  Author="Jabberie@Draka",
  SpecID=65,
  Talents = "1,2,2,1,2,3,2",
  Default=1,
  Icon='INV_MISC_QUESTIONMARK',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
      },
      PreMacro={
      },
        "/cast Judgment",
        "/cast [@focus, exists, nodead][@Party1, exists, nodead][] Holy Shock",
        "/cast Crusader Strike",        
        "/cast [@focus, exists, nodead][@Party1, exists, nodead][] Bestow Faith",
        "/cast [combat, mod] Consecration",
        "/cast [@focus, exists, nodead][@Party1, exists, nodead][] Holy Shock, Holy Shock, Light of Dawn",               
      PostMacro={
      },
      KeyRelease={
        "/cast [combat] Divine Protection",
        "/cast [combat] Avenging Wrath",
        "/cast [combat] Aura Mastery",
      },
    },
  },
}