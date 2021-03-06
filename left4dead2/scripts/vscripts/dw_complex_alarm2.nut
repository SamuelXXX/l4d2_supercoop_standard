Msg("Initiating Complex Onslaught\n");

DirectorOptions <-
{
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 3
	MobMinSize = 3
	MobMaxSize = 6
	MobMaxPending = 20
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 7
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 3
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 100
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	BoomerLimit = 0
	ChargerLimit = 0
	SpecialRespawnInterval = 20.0
	MaxSpecials = 2
	CommonLimit = 30
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()

