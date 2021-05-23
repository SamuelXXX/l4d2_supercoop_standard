Msg(">>>Loading c3m2 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 9
	DominatorLimit = 6

	//中途有机关，保险起见防止build up持续时间过长
	RelaxMinInterval = 120
	RelaxMaxInterval = 120
}

Convars.SetValue("tongue_range",1000)//Forever Dark, Need to weakening tones
Convars.SetValue("z_tank_speed",250)