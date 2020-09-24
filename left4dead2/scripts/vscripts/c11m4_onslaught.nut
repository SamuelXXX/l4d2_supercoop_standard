Msg("\n\n\n");
Msg(">>>c11m4_onslaught\n");
Msg("\n\n\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

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
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

