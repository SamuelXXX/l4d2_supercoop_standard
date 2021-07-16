Msg(">>>Loading c5m3 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 10
	DominatorLimit = 7

	weaponsToConvert =
	{
		weapon_defibrillator = "other_supply"
	}

	weaponsToRemove =
	{
		weapon_defibrillator = 0
		weapon_sniper_awp = 0
		weapon_rifle_m60 = 0
		weapon_grenade_launcher = 0
	}
}

Convars.SetValue("sv_rescue_disabled",1)