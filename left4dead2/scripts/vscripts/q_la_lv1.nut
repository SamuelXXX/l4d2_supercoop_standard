Msg("la_lv1-------------------------------------------\n");
DirectorOptions <-
{
	MobSpawnMinTime = 4
	MobSpawnMaxTime = 6
	MobMinSize = 10
	MobMaxSize = 10
	MobMaxPending = 15
	//SustainPeakMinTime = 5
	//SustainPeakMaxTime = 8
	//IntensityRelaxThreshold = 1
	//RelaxMinInterval = 4
	//RelaxMaxInterval = 6

	
	ShouldAllowMobsWithTank = 0
	
	CommonLimit = 40
}
Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()
//故乡