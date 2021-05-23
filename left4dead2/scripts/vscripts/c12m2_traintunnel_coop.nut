Msg(">>>Loading c12m2 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 9
	DominatorLimit = 6

	//中途存在机关，防止Build Up时间沿用RelaxInterval
	RelaxMinInterval = 120
	RelaxMaxInterval = 120
}

Convars.SetValue("z_tank_speed",250)
