Msg("hf04 coop---------------------------------------------------------------------\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 14
	 DominatorLimit = 8
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

