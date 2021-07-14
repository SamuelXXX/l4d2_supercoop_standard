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
}

Convars.SetValue("z_witch_always_kills","0")

Convars.SetValue("sv_rescue_disabled",1)