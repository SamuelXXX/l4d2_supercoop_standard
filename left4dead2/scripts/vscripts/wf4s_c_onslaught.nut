Msg("Initiating wf4 final Onslaught\n");
//白森林
DirectorOptions <-
{
	CommonLimit = 30

	MobSpawnMinTime = 3
	MobSpawnMaxTime = 4
	MobMinSize = 16
	MobMaxSize = 25
	MobMaxPending = 15
	
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 3
	RelaxMaxInterval = 4

	PreferredMobDirection = SPAWN_LARGE_VOLUME
	PreferredSpecialDirection = SPAWN_LARGE_VOLUME
	ShouldConstrainLargeVolumeSpawn = true
	ZombieSpawnRange = 1000	
	
	MaxSpecials = 12
	DominatorLimit = 12
	SpecialRespawnInterval = 4.0
	
	MusicDynamicMobSpawnSize = 16

}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

