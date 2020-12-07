Msg(">>>Loading c2m5 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 12
	DominatorLimit = 8

	weaponsToConvert =
	 {
		weapon_vomitjar = "random_supply"
	 }
}

Convars.SetValue("min_time_spawn_tank",9999)
Convars.SetValue("max_time_spawn_tank",9999)