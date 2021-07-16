Msg(">>>Loading c5m5 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 14
	DominatorLimit = 8
	ZombieTankHealth = 50000
	WitchLimit = 0
	TankLimit = 3
	
	weaponsToConvert =
	{
		weapon_vomitjar = "other_supply"
		weapon_defibrillator = "other_supply"
	}

	weaponsToRemove =
	{
		weapon_defibrillator = 0
		weapon_sniper_awp = 0
		weapon_rifle_m60 = 0
		weapon_grenade_launcher = 0
	}

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	RelaxMaxFlowTravel = 100
	RelaxMinInterval = 2
	RelaxMaxInterval = 2
}

Msg("###Relax Max Flow Travel:"+DirectorOptions.RelaxMaxFlowTravel);
Convars.SetValue("z_witch_always_kills","1")
Convars.SetValue("z_tank_speed",210)
Convars.SetValue("sv_rescue_disabled",0)