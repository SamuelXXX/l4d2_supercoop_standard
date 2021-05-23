Msg(">>>Loading c5m4 Director Scripts\n");

DirectorOptions <-
{
	//CommonLimit=0
	cm_MaxSpecials = 11
	DominatorLimit = 8

	//中途有机关，保险起见防止build up持续时间过长
	RelaxMinInterval = 120
	RelaxMaxInterval = 120
}

Convars.SetValue("z_tank_speed",250)
