Msg(">>>Loading c14m2 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 12
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
}