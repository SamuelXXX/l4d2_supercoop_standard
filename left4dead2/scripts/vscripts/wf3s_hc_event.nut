Msg("Initiating hc Onslaught\n");
//白森林

DirectorOptions <-
{
	ProhibitBosses = true
	
	PreferredMobDirection = SPAWN_LARGE_VOLUME
	
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 2
	IntensityRelaxThreshold = 0.88
	RelaxMinInterval = 4
	RelaxMaxInterval = 5
	ZombieSpawnRange = 2500
	
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 2
	MusicDynamicMobScanStopSize = 1
	
}

Director.ResetMobTimer()

