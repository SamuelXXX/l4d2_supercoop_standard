Msg("\n\n\n");
Msg(">>>c1_mall_onslaught\n");
Msg("\n\n\n");
//打开超市门触发

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

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
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	//ZombieSpawnRange = 1500
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()

