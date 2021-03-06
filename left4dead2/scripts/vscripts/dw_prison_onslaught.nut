Msg("Initiating Prison Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true
	DisallowThreatType = ZOMBIE_TANK
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMinSize = 15
	MobMaxSize = 20
	MobMaxPending = 20
	SustainPeakMinTime = 4
	SustainPeakMaxTime = 7
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 2
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 50
	SpecialRespawnInterval = 15.0
	PreferredMobDirection = SPAWN_BEHIND_SURVIVORS
	PreferredSpecialDirection = SPAWN_BEHIND_SURVIVORS
	//ZombieSpawnRange = 2000
	CommonLimit = 30
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()