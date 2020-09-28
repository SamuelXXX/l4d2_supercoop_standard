Msg(">>>Loading c11m5 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 14
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
}
