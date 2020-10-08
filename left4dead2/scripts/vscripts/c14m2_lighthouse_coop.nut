Msg(">>>Loading c14m2 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 8
	DominatorLimit = 7

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
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	RelaxMaxFlowTravel = RandomInt(1000,1500)
	RelaxMinInterval = 99999
	RelaxMaxInterval = 99999
}

Msg("###Relax Max Flow Travel:"+DirectorOptions.RelaxMaxFlowTravel);
Msg("\n\n\n");