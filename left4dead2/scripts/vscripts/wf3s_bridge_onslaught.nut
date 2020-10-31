Msg("Initiating bridge Onslaught\n");
//白森林
DirectorOptions <-
{
	ProhibitBosses = true
	
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	
	CommonLimit = 20
	MobSpawnMinTime = 4
	MobSpawnMaxTime = 7
	MobMinSize = 18
	MobMaxSize = 20
	MobMaxPending = 19
	SustainPeakMinTime = 4
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.90
	RelaxMinInterval = 2
	RelaxMaxInterval = 4
	RelaxMaxFlowTravel = 270
	
	cm_MaxSpecials = 8
	cm_DominatorLimit = 8
	SpecialRespawnInterval = 7.0
	
	ZombieSpawnRange = 2000
	
	MusicDynamicMobSpawnSize = 16
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

