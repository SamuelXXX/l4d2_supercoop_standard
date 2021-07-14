Msg(">>>Loading c2m5 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 12
	DominatorLimit = 8

	weaponsToConvert =
	 {
		weapon_molotov = "random_supply"
		weapon_vomitjar = "random_supply"
		weapon_pipe_bomb = "random_supply"
		weapon_pistol = "weapon_pistol_magnum_spawn"
	 }
}

Convars.SetValue("min_time_spawn_tank",9999)
Convars.SetValue("max_time_spawn_tank",9999)