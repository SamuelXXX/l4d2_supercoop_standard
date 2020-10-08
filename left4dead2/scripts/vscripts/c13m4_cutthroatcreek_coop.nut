Msg(">>>Loading c13m4 Director Scripts\n");

DirectorOptions <-
{
	cm_SpecialRespawnInterval = 8
	cm_MaxSpecials = 10
	DominatorLimit = 8

	WitchLimit = 0

	RelaxMaxFlowTravel = RandomInt(100,200)
	weaponsToConvert =
	{
	weapon_vomitjar = "weapon_pain_pills"
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
	RelaxMinInterval = 99999
	RelaxMaxInterval = 99999
}

Msg("###Relax Max Flow Travel:"+DirectorOptions.RelaxMaxFlowTravel);
Msg("\n\n\n");