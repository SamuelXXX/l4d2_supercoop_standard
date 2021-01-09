Msg("\n\n\n");
Msg(">>>c1_gunshop_onslaught\n");
Msg("\n\n\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

	PreferredMobDirection = SPAWN_BEHIND_SURVIVORS
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 20
	MobMinSize = 20
	MobMaxSize = 40
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 2
	RelaxMaxFlowTravel = 50

}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()
