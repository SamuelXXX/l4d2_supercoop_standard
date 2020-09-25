Msg(">>>Loading c10m5 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 14
	 cm_DominatorLimit = 14

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
