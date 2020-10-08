Msg(">>>Loading c2m5 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 12
	DominatorLimit = 8

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	RelaxMaxFlowTravel = RandomInt(1000,1500)
	RelaxMinInterval = 99999
	RelaxMaxInterval = 99999

	 weaponsToConvert =
	 {
		weapon_vomitjar = "weapon_defibrillator"
	 }

	 function ConvertWeaponSpawn( classname )
	 {
		if ( classname in weaponsToConvert )
		{
			return weaponsToConvert[classname];
		}
		return 0;
	 }
}

Convars.SetValue("min_time_spawn_tank",9999)
Convars.SetValue("max_time_spawn_tank",9999)