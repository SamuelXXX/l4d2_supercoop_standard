Msg("Initiating Woods Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 3
	MobSpawnMaxTime = 6
	MobMinSize = 4
	MobMaxSize = 7
	MobMaxPending = 20
	SustainPeakMinTime = 4
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200
	SpecialRespawnInterval = 5
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 2200
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()

