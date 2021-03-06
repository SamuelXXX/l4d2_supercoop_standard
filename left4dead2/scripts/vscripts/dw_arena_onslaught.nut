Msg("Initiating Arena Onslaught\n");

DirectorOptions <-
{
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 3
	MobMinSize = 12
	MobMaxSize = 17
	MobMaxPending = 20
	SustainPeakMinTime = 2
	SustainPeakMaxTime = 4
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 3
	RelaxMaxFlowTravel = 30
	PreferredMobDirection = SPAWN_ANYWHERE
	ZombieSpawnRange = 3000
	SpecialRespawnInterval = 15.0
	CommonLimit = 30
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()

