Msg("msd1_run---------------------------------------------------------------------\n");
//晨茗
DirectorOptions <-
{
	CommonLimit = 30
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 18
	MobMinSize = 20
	MobMaxSize = 40
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.99
	
	RelaxMinInterval = 2
	RelaxMaxInterval = 4
	
	 cm_MaxSpecials = 8
	 cm_DominatorLimit = 8
	 SpecialRespawnInterval = 2
	 PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	 PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	 ProhibitBosses = true
	 ZombieTankHealth = RandomInt(8000,20000)
	 TankHitDamageModifierCoop = RandomFloat(1,5)
	 
    MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 4
	MusicDynamicMobScanStopSize = 1 	 
}

Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","31")
Convars.SetValue("z_witch_always_kills","0")
Convars.SetValue("director_max_threat_areas","24")
Convars.SetValue("tongue_victim_max_speed","225")
Convars.SetValue("tongue_range","1500")
Convars.SetValue("director_force_tank","0")
Convars.SetValue("director_force_witch","0")

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

Msg("msd1_run Load Succeed---------------------------------------------------------------------\n");

