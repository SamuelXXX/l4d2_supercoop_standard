Msg(">>>Loading c9m2 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 10
	 cm_DominatorLimit = 10

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