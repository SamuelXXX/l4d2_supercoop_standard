Msg(">>>Loading c5m5 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 14
	DominatorLimit = 8
	ZombieTankHealth = 50000
	WitchLimit = 0
	TankLimit = 4
	
	weaponsToConvert =
	{
		weapon_vomitjar = "random_supply"
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