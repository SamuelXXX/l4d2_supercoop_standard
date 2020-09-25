Msg("\n\n\n");
Msg(">>>c14_junkyard_crane\n");
Msg("\n\n\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 30
	MobMaxSize = 40
	MobMaxPending = 35
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 3
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 500
	SpecialRespawnInterval = 3.0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()