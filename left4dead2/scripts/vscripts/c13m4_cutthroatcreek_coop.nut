Msg(">>>Loading c13m4 Director Scripts\n");

DirectorOptions <-
{
	 cm_SpecialRespawnInterval = 8
	 cm_MaxSpecials = 10
	 cm_DominatorLimit = 10

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
}