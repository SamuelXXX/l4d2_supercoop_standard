Msg(">>>Loading c5m4 Director Scripts\n");

DirectorOptions <-
{
	//CommonLimit=0
	cm_MaxSpecials = 11
	DominatorLimit = 8

	//中途有机关，保险起见防止build up持续时间过长
	RelaxMinInterval = 120
	RelaxMaxInterval = 120

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