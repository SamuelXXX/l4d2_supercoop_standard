Msg("Initiating Onslaught\n");
//巴塞罗那
DirectorOptions <-
{
AlwaysAllowWanderers = 0
	// This turns off tanks and witches.
	ProhibitBosses = true
ShouldAllowMobsWithTank = true

	
	//LockTempo = true
	MobSpawnMinTime = 3
	MobSpawnMaxTime = 7
	MobMinSize = 10
	MobMaxSize = 15
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 50
	SpecialRespawnInterval = 1.0

	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 2000
}

Director.ResetMobTimer()

