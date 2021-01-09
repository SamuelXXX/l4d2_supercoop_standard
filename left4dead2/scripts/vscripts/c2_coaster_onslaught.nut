Msg("\n\n\n");
Msg(">>>c2_coaster_onslaught\n");
Msg("\n\n\n");
//过山车开机关后触发
DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 20
	MobMaxSize = 30
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 4
	RelaxMaxInterval = 8
	RelaxMaxFlowTravel = 100

	SpecialRespawnInterval = 5.0
	PreferredMobDirection = SPAWN_ABOVE_SURVIVORS
	ZombieSpawnRange = 1000
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()

