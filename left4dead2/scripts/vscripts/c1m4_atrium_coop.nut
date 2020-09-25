Msg(">>>Loading c1m4 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 8
	 cm_DominatorLimit = 8

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
Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","59")