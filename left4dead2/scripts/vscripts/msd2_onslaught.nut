Msg("msd2_onslaught---------------------------------------------------------------------\n");
//晨茗
DirectorOptions <-
{
    CommonLimit = 50
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 30
	MobMinSize = 30
	MobMaxSize = 50
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 1
	IntensityRelaxThreshold = 0.99
	
	RelaxMinInterval = 1
	RelaxMaxInterval = 2
	
	PreferredMobDirection = SPAWN_LARGE_VOLUME
	PreferredSpecialDirection = SPAWN_LARGE_VOLUME
        
	cm_MaxSpecials = 8
	cm_DominatorLimit = 8
	SpecialRespawnInterval = 1

	ProhibitBosses = false
	ZombieSpawnRange = 20000
	MobRechargeRate = 10
	
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 4
	MusicDynamicMobScanStopSize = 1 
}

Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","31")

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

Msg("msd2_onslaught Load Succeed---------------------------------------------------------------------\n");
