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

Convars.SetValue("sv_rescue_disabled",1)
Convars.SetValue("min_time_spawn_tank",360)
Convars.SetValue("max_time_spawn_tank",360)