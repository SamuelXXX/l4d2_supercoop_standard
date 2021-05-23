Msg(">>>Loading c13m4 Director Scripts\n");

DirectorOptions <-
{
	cm_SpecialRespawnInterval = 5
	cm_MaxSpecials = 11
	DominatorLimit = 8

	WitchLimit = 0

	RelaxMaxFlowTravel = RandomInt(100,200)
	weaponsToConvert =
	{
		weapon_vomitjar = "random_supply"
	}
}

Convars.SetValue("z_tank_speed",250)