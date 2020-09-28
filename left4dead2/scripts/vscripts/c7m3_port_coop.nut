Msg(">>>Loading c7m3 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 12
	 DominatorLimit = 7

	 WitchLimit = 0
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