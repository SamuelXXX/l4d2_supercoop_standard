Msg(">>>Loading c8m4 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 11
	DominatorLimit = 8

	// 避免开电梯无限刷特
	RelaxMinInterval = 120
	RelaxMaxInterval = 120
}

Convars.SetValue("z_tank_speed",250)