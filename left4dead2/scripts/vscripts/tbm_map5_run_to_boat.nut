Msg("The Bloody Moors - run to boat\n");

DirectorOptions <-
{
	//AlwaysAllowWanderers = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 25
	MobMaxSize = 30
	MobMaxPending = 50
	//SustainPeakMinTime = 5 //15?
	//SustainPeakMaxTime = 8 //18?
	//IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 5
	RelaxMaxInterval = 5
	//RelaxMaxFlowTravel = 850	
	//SpecialRespawnInterval = 30
	//NumReservedWanderers = 10
}

Director.ResetMobTimer()