Msg("Initiating q_fleshbridge2_finale\n");
ShowMessage("message");
//故乡
ERROR <- -1
PANIC <- 0
TANK <- 1
DELAY <- 2
SCRIPTED <- 3

DirectorOptions <-
{
	//-----------------------------------------------------
	 
	 A_CustomFinale1 = PANIC
	 A_CustomFinaleValue1 = RandomInt(1,3)
	 
	 A_CustomFinale2 = DELAY
	 A_CustomFinaleValue2 = 15
	 
	 A_CustomFinale3 = TANK
	 A_CustomFinaleValue3 = RandomInt(2,4)

	 A_CustomFinale4 = DELAY
	 A_CustomFinaleValue4 = 20
	 
	 A_CustomFinale5 = PANIC
	 A_CustomFinaleValue5 = RandomInt(1,3)
	 
	 A_CustomFinale6 = DELAY
	 A_CustomFinaleValue6 = 30
	 
	 A_CustomFinale7 = TANK
	 A_CustomFinaleValue7 = RandomInt(2,4)
	 
	 A_CustomFinale8 = DELAY
	 A_CustomFinaleValue8 = 60
	 
	 A_CustomFinale9 = PANIC
	 A_CustomFinaleValue9 = RandomInt(1,3)
	 
	 A_CustomFinale10 = DELAY
	 A_CustomFinaleValue10 = 20
	 
	 A_CustomFinale11 = TANK
	 A_CustomFinaleValue11 = RandomInt(2,6)
	 
	 A_CustomFinale12 = DELAY
	 A_CustomFinaleValue12 = 50
	 
	 PreferredMobDirection = SPAWN_FAR_AWAY_FROM_SURVIVORS 
	 PreferredSpecialDirection = SPAWN_ABOVE_SURVIVORS
	 
	 ShouldAllowSpecialsWithTank = true
	 
	 TankLimit = 24
	 MaxSpecials = 12
	 BoomerLimit = 0
	 SmokerLimit = 4
	 HunterLimit = 4
	 ChargerLimit = 4
	 SpitterLimit = 4
	 JockeyLimit = 4
	 CommonLimit = 60
	 SpecialRespawnInterval = 7
	 
	 HordeEscapeCommonLimit = 30
	 MegaMobSize = 90
	 ZombieTankHealth = RandomInt(8000,20000)
	 TankHitDamageModifierCoop = RandomFloat(1,5)
	 
	//-----------------------------------------------------
}
Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","59")
Convars.SetValue("director_relax_min_interval","120")
Convars.SetValue("director_relax_max_interval","120")
Convars.SetValue("tongue_victim_max_speed","700")
Convars.SetValue("tongue_range","2000")
//ZombieSpawnRange = 3000