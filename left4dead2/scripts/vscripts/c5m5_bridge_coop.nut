Msg(">>>Loading c5m5 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 14
	 DominatorLimit = 8
	 ZombieTankHealth = RandomInt(20000,30000)
	 WitchLimit = 0
	 TankHitDamageModifierCoop = 5
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
Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","63")
Convars.SetValue("z_witch_always_kills","1")