Msg(">>>Loading c4m5 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 10
	DominatorLimit = 8
	WitchLimit = 0

	weaponsToConvert =
	{
		weapon_vomitjar = "random_supply"
	}
}
Convars.SetValue("z_witch_always_kills","0")

Convars.SetValue("min_time_spawn_tank",9999)
Convars.SetValue("max_time_spawn_tank",9999)