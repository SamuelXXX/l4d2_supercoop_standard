Msg("\n\n\n");
Msg(">>>c11m4_onslaught\n");
Msg("\n\n\n");
//c11m4过安检触发

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
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 1
	RelaxMaxInterval = 3
	RelaxMaxFlowTravel = 100
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

