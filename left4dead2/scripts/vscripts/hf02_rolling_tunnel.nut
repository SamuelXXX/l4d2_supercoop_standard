Msg("hf04 Rolling tunnel---------------------------------------------------------------------\n");
//颤栗森林
DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	cm_MaxSpecials = 8
	cm_DominatorLimit = 8
	
	WitchLimit = 0

	//LockTempo = true
	MobSpawnMinTime = 3
	MobSpawnMaxTime = 6
	MobMinSize = 30
	MobMaxSize = 40
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 1
	RelaxMaxInterval = 3
	RelaxMaxFlowTravel = 50
	SpecialRespawnInterval = 2.0
	PreferredMobDirection = SPAWN_LARGE_VOLUME
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	ShouldConstrainLargeVolumeSpawn = false
	ZombieSpawnRange = 2000
	
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 4
	MusicDynamicMobScanStopSize = 1 
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()