Msg("\n\n\n");
Msg(">>>c1_mall_crescendo_wave\n");
Msg("\n\n\n");
//在vrescendo之后隔一定时间触发

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

	MobSpawnMinTime = 5
	MobSpawnMaxTime = 5
	MobMinSize = 20
	MobMaxSize = 40
	MobMaxPending = 90
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 5
	RelaxMaxInterval = 8
	RelaxMaxFlowTravel = 100
	ChargerLimit = 3
	SpecialRespawnInterval = 5.0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()