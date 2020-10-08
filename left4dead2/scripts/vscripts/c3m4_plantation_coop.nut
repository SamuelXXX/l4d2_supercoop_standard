Msg(">>>Loading c3m4 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 8
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