//坠入死亡
Msg("l4d2_fallindeath elevator event---------------------------------------------------------------------\n");
DirectorOptions <-
{
	ProhibitBosses = true
	
	CommonLimit = 50
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMinSize = 30
	MobMaxSize = 40
	MobMaxPending = 30
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 1
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 2
	RelaxMaxInterval = 3
	RelaxMaxFlowTravel = 50
	SpecialRespawnInterval = 2
	
	cm_MaxSpecials = 10
	cm_DominatorLimit = 10
	
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 4
	MusicDynamicMobScanStopSize = 1
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()