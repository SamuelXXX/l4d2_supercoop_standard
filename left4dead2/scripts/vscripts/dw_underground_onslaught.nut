Msg("Initiating Underground Onslaught\n");

DirectorOptions <-
{
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 3
	MobMinSize = 5
	MobMaxSize = 9
	MobMaxPending = 15
	SustainPeakMinTime = 2
	SustainPeakMaxTime = 5
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 3
	RelaxMaxInterval = 6
	RelaxMaxFlowTravel = 100
	SpecialRespawnInterval = 20.0
	PreferredMobDirection = SPAWN_ANYWHERE
	//ZombieSpawnRange = 800
	PreferredSpecialDirection = SPAWN_ANYWHERE
	MaxSpecials = 2
	BoomerLimit = 0
	SmokerLimit = 1
	HunterLimit = 1
	ChargerLimit = 0
	SpitterLimit = 1
	JockeyLimit = 1
	//SpecialInitialSpawnDelayMin = 6
	//SpecialInitialSpawnDelayMax = 10
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()

