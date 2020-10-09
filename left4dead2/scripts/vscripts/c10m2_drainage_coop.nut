Msg(">>>Loading c10m2 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 8
	DominatorLimit = 6

	//中途存在机关，防止Build Up时间沿用RelaxInterval
	RelaxMinInterval = 120
	RelaxMaxInterval = 120
}
