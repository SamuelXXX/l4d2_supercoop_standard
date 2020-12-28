Msg("outskirt crescendo---------------------------------------------\n");
//天堂可待
DirectorOptions <-
{
	// This turns off tanks and witches.
	// ProhibitBosses = true

	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 120
	MobMaxSize = 120
	MobMaxPending = 90
	SustainPeakMinTime = 15
	SustainPeakMaxTime = 18
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 5
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 1000
	SmokerLimit = 2
	ChargerLimit = 3
	SpecialRespawnInterval = 3.0
	ZombieSpawnRange = 2000
	PreferredMobDirection = SPAWN_LARGE_VOLUME
	
	cm_MaxSpecials = 8
}


Director.ResetMobTimer()