Msg("msdcm_chongfeng---------------------------------------------------------------------\n");
//晨茗
DirectorOptions <-
{
    LockTempo = true
	CommonLimit = 30
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMaxPending = 9
	MobMinSize = 15
	MobMaxSize = 40
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 0.7
	
	 cm_MaxSpecials = 8
	 cm_DominatorLimit = 8

	 ProhibitBosses = true
}
Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","2")
Convars.SetValue("z_witch_always_kills","1")
Convars.SetValue("director_max_threat_areas","24")
Convars.SetValue("tongue_victim_max_speed","225")
Convars.SetValue("tongue_range","1500")
Convars.SetValue("director_relax_min_interval","10")
Convars.SetValue("director_relax_max_interval","20")
Convars.SetValue("director_force_tank","0")
Convars.SetValue("director_force_witch","0")

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

Msg("msdcm_chongfeng Load Succeed---------------------------------------------------------------------\n");

