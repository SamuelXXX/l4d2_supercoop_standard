Msg(">>>Loading c3m4 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 12
	 cm_DominatorLimit = 12
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