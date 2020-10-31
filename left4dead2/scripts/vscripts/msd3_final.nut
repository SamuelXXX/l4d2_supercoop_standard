Msg("msd3_final---------------------------------------------------------------------\n")
ERROR <- -1
PANIC <- 0
TANK <- 1
DELAY <- 2
SCRIPTED <- 3
//晨茗
DirectorOptions <-
{

	 A_CustomFinale1 = PANIC
	 A_CustomFinaleValue1 = RandomInt(2,3)

	 A_CustomFinale2 = TANK
	 A_CustomFinaleValue2 = 8
 
 
	 A_CustomFinale3 = DELAY
	 A_CustomFinaleValue3 = RandomInt(5,10) 
 

	 A_CustomFinale4 = PANIC
	 A_CustomFinaleValue4 = RandomInt(2,3) 
 
	 A_CustomFinale5 = TANK
	 A_CustomFinaleValue5 = 8  
 

	 A_CustomFinale6 = DELAY
	 A_CustomFinaleValue6 = RandomInt(5,10)
	 

	 A_CustomFinale7 = TANK
	 A_CustomFinaleValue7 = 8
	 
	 HordeEscapeCommonLimit = 60
	 	
	 ZombieTankHealth = RandomInt(8000,20000)

	 cm_MaxSpecials = 10
	 cm_DominatorLimit = 10
	 BoomerLimit = 0
	 SmokerLimit = 2
	 JockeyLimit=0
	 ChargerLimit = 8
	 HunterLimit = 8
	 TankLimit = 12
	 PreferredMobDirection = SPAWN_ANYWHERE
	 PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
	 ProhibitBosses = false
	 WitchLimit = 0
	 SpecialRespawnInterval = 2
	 ZombieSpawnRange=60000
	 TankHitDamageModifierCoop = RandomFloat(2,5)
}

PanicOptions <-
{	
	CommonLimit = 50
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMinSize = 40
	MobMaxSize = 60
	MobMaxPending = 40
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 1
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 2
	RelaxMaxFlowTravel = 50
	
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 4
	MusicDynamicMobScanStopSize = 1
}

Convars.SetValue("l4d2_spawn_uncommons_autochance","1")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","59")
Convars.SetValue("tongue_victim_max_speed","700")
Convars.SetValue("tongue_range","6000")

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

