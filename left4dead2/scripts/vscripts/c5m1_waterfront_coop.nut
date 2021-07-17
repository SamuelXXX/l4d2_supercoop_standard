Msg("\n\n\n");
Msg(">>>Loading c5m1 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 8
	DominatorLimit = 5

	ZombieTankHealth=30000
	RelaxMaxFlowTravel = 400

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

Convars.SetValue("z_witch_always_kills","0")

Convars.SetValue("sv_rescue_disabled",1)