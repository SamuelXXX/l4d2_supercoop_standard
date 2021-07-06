Msg(">>>Loading c5m2 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 9
	DominatorLimit = 6

	weaponsToConvert =
	{
		weapon_defibrillator = "other_supply"
	}
}

Convars.SetValue("sv_rescue_disabled",1)