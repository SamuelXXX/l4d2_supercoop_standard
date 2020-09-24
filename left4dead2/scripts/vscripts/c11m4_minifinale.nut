Msg("\n\n\n");
Msg(">>>c11m4_minifinale\n");
Msg("\n\n\n");
//c11m4 开车触发

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 30
	MobMaxSize = 30
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 50
	SpecialRespawnInterval = 1
	PreferredMobDirection = SPAWN_NO_PREFERENCE
	ZombieSpawnRange = 1000
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()
