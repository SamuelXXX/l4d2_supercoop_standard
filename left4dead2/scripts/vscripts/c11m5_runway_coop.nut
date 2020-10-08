Msg(">>>Loading c11m5 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 8
	DominatorLimit = 8

	WitchLimit = 0

	weaponsToConvert =
	{
	weapon_vomitjar = "weapon_first_aid_kit"
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
