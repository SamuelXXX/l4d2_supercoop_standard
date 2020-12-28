Msg("l4d2 yama 3 onslaught initiating------------------------------------------------------------\n");
//摩耶山危机
DirectorOptions <-
{
    CommonLimit = 40
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 20
	MobMinSize = 30
	MobMaxSize = 40
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 1
	IntensityRelaxThreshold = 0.95
	
	RelaxMinInterval = 2
	RelaxMaxInterval = 3
	
	PreferredMobDirection = SPAWN_LARGE_VOLUME
	PreferredSpecialDirection = SPAWN_LARGE_VOLUME
        
	cm_MaxSpecials = 8
	cm_DominatorLimit = 8
	SpecialRespawnInterval = 5

	ProhibitBosses = false
	ZombieSpawnRange = 20000
	MobRechargeRate = 2
	
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 4
	MusicDynamicMobScanStopSize = 1 
}

Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","31")

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()