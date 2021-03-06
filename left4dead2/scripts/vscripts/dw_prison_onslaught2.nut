Msg("Initiating Prison Onslaught 2\n");

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
	RelaxMinInterval = 1
	RelaxMaxInterval = 3
	RelaxMaxFlowTravel = 30
//	MaxSpecials = 0
	PreferredMobDirection = SPAWN_ANYWHERE
//	ZombieSpawnRange = 2000
	SpecialRespawnInterval = 15.0
	CommonLimit = 30
}

Director.ResetMobTimer()