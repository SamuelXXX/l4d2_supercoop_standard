Msg("Initiating Onslaught\n");
//巴塞罗那
DirectorOptions <-
{
AlwaysAllowWanderers = 0
	// This turns off tanks and witches.
	ProhibitBosses = true
ShouldAllowMobsWithTank = true

	
	//LockTempo = true
	MobSpawnMinTime = 7
	MobSpawnMaxTime = 10
	MobMinSize = 16
	MobMaxSize = 18
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 5
	RelaxMaxInterval = 10
	RelaxMaxFlowTravel = 500
	SpecialRespawnInterval = 1.0

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 2000
}

Director.ResetMobTimer()

