Msg("Initiating Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 35
	MobMaxSize = 40
	MobMaxPending = 40
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 50
	PreferredMobDirection = SPAWN_NO_PREFERENCE
	ZombieSpawnRange = 2000
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

