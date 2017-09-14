local _, Sequences = ...
---------------------------
---------------------------
---------------------------
Sequences['Outlaw_ST'] = {
  Author="Jabberie@Draka",
  SpecID=260,
  Talents = "1111321",
  Default=1,
  Icon='INV_Sword_30',
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/cast [mod:ctrl] Pistol Shot",
        "/cancelaura Blade Flurry",
        "/cast [stealth] Ambush",
      },
      PreMacro={
        "/cast [nostealth,nocombat] Stealth",
        "/cast [stealth] Ambush",
      },
        "/cast [combat] Adrenaline Rush",
        "/cast [combat] Curse of the Dreadblades",
        "/castsequence  reset=1  Ghostly Strike, Saber Slash, !Slice and Dice, Saber Slash, Saber Slash, Run Through, Saber Slash, Saber Slash, Run Through, Ghostly Strike, Saber Slash, Run Through, Saber Slash, Run Through",
      PostMacro={
      },
      KeyRelease={
        "/cast [nostealth,nocombat] Stealth",
        "/click TotT",
      },
    },
  },
}