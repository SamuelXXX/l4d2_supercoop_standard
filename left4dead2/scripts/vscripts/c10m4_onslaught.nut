Msg("\n\n\n");
Msg(">>>c10m4_onslaught\n");
Msg("\n\n\n");
//c10m4 跑图触发

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 30
	MobMinSize = 17
	MobMaxSize = 25
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.90
	RelaxMinInterval = 1
	RelaxMaxInterval = 3
	RelaxMaxFlowTravel = 100
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

