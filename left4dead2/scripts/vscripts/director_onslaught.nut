Msg("\n\n\n");
Msg(">>>director_onslaught\n");
Msg("\n\n\n");
//c5m2 的机关

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	MobSpawnMinTime = 2
	MobSpawnMaxTime = 6
	MobMinSize = 20
	MobMaxSize = 40
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 2
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 100
}

Director.ResetMobTimer()

