Msg("Initiating Complex Onslaught\n");

DirectorOptions <-
{
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 2
	MobSpawnMaxTime = 4
	MobMinSize = 3
	MobMaxSize = 4
	MobMaxPending = 3
	SustainPeakMinTime = 3
	SustainPeakMaxTime = 5
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 3
	RelaxMaxInterval = 4
	RelaxMaxFlowTravel = 100
	PreferredMobDirection = SPAWN_ABOVE_SURVIVORS
	MaxSpecials = 0
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()

