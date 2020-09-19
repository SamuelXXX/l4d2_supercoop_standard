Msg("Super Coop")
ERROR <- -1
PANIC <- 0
TANK <- 1
DELAY <- 2
SCRIPTED <- 3

DirectorOptions <-
{
	 A_CustomFinale1 = PANIC
	 A_CustomFinaleValue1 = RandomInt(1,3)

	 A_CustomFinale2 = SCRIPTED
	 A_CustomFinaleValue2 = "off.nut" 
	 
	 A_CustomFinale3 = DELAY
	 A_CustomFinaleValue3 = RandomInt(10,15)
 
	 A_CustomFinale4 = TANK
	 A_CustomFinaleValue4 = RandomInt(2,4)
 
	 A_CustomFinale5 = SCRIPTED
	 A_CustomFinaleValue5 = "c3m4_on.nut" 
 
	 A_CustomFinale6 = PANIC
	 A_CustomFinaleValue6 = RandomInt(1,3)

	 A_CustomFinale7 = SCRIPTED
	 A_CustomFinaleValue7 = "off.nut" 
	 
	 A_CustomFinale8 = DELAY
	 A_CustomFinaleValue8 = RandomInt(10,15)
 
	 A_CustomFinale9 = TANK
	 A_CustomFinaleValue9 = RandomInt(4,6)  
 
	 A_CustomFinale10 = SCRIPTED
	 A_CustomFinaleValue10 = "c3m4_on.nut" 

	 A_CustomFinale11 = PANIC
	 A_CustomFinaleValue11 = RandomInt(1,3)

	 A_CustomFinale12 = SCRIPTED
	 A_CustomFinaleValue12 = "off.nut"
	 
	 A_CustomFinale13 = DELAY
	 A_CustomFinaleValue13 = RandomInt(10,15)

	 A_CustomFinale14 = TANK
	 A_CustomFinaleValue14 = RandomInt(6,10)

	 A_CustomFinale15 = SCRIPTED
	 A_CustomFinaleValue15 = "c3m4_on.nut"

	 HordeEscapeCommonLimit = 30
	 ZombieTankHealth = RandomInt(8000,20000)
	 CommonLimit = 30
	 MegaMobSize = 90
	 cm_MaxSpecials = 14
	 cm_DominatorLimit = 14
	 TankLimit = 24
	 PreferredMobDirection = SPAWN_LARGE_VOLUME
	 PreferredSpecialDirection = SPAWN_LARGE_VOLUME
	 ProhibitBosses = false
	 WitchLimit = 0
	 SpecialRespawnInterval = 7
	 TankHitDamageModifierCoop = RandomFloat(1,5)
}
Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","59")
Convars.SetValue("director_relax_min_interval","120")
Convars.SetValue("director_relax_max_interval","120")
Convars.SetValue("tongue_victim_max_speed","700")
Convars.SetValue("tongue_range","2000")