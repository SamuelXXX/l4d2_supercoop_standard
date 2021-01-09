Msg("\n\n\n");
Msg(">>>c12m3_onslaught\n");
Msg("\n\n\n");
//

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 0
	MobMinSize = 18
	MobMaxSize = 27
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 1
	RelaxMaxInterval = 3
	RelaxMaxFlowTravel = 100
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

