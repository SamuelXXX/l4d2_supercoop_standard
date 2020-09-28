Msg(">>>Loading c4m5 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 8
	 DominatorLimit = 8
	 WitchLimit = 0

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