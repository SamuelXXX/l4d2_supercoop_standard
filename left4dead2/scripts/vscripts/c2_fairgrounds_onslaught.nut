Msg("\n\n\n");
Msg(">>>c2_fairgrounds_onslaught\n");
Msg("\n\n\n");
//开了c2m2的机关触发

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

	// PreferredMobDirection = SPAWN_ANYWHERE
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 30
	MobMinSize = 20
	MobMaxSize = 30
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.90
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 100

	MaxSpecials=14
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

