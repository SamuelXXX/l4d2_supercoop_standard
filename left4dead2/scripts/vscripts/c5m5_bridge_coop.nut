Msg(">>>Loading c5m5 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 14
	DominatorLimit = 8
	ZombieTankHealth = RandomInt(20000,30000)
	WitchLimit = 0
	
	weaponsToConvert =
	{
		weapon_vomitjar = "random_supply"
	}

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	RelaxMaxFlowTravel = RandomInt(100,200)
	RelaxMinInterval = 2
	RelaxMaxInterval = 5
}

Msg("###Relax Max Flow Travel:"+DirectorOptions.RelaxMaxFlowTravel);
Convars.SetValue("z_witch_always_kills","1")