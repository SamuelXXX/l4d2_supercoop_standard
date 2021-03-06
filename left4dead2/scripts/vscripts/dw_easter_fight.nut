//-----------------------------------------------------
//
//
//-----------------------------------------------------
Msg("Initiating Easter Fight\n");

//-----------------------------------------------------
ERROR		<- -1
PANIC 		<- 0
TANK 		<- 1
DELAY 		<- 2
ONSLAUGHT	<- 3 
//-----------------------------------------------------

DirectorOptions <-
{	
	 
	A_CustomFinale_StageCount = 8
	 
	A_CustomFinale1 		= PANIC
	A_CustomFinaleValue1 	= 1
	A_CustomFinale2 		= DELAY
	A_CustomFinaleValue2 	= 1	
	A_CustomFinale3 		= TANK
	A_CustomFinaleValue3 	= 1
	A_CustomFinale4 		= DELAY
	A_CustomFinaleValue4 	= 1	
	A_CustomFinale5 		= PANIC
	A_CustomFinaleValue5 	= 1	
	A_CustomFinale6 		= DELAY
	A_CustomFinaleValue6 	= 1		
	A_CustomFinale7 		= TANK
	A_CustomFinaleValue7 	= 2
	A_CustomFinale8 		= ONSLAUGHT
	A_CustomFinaleValue8 = "dw_easter_fight_end"
	 
	 
	TankLimit = 2
	CommonLimit = 40	
	EscapeSpawnTanks = false
	SpecialRespawnInterval = 1
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 20
	MobMaxSize = 30
	MobMaxPending = 0
	MaxSpecials = 4
	PreferredMobDirection = SPAWN_NEAR_IT_VICTIM
	PreferredSpecialDirection = SPAWN_NEAR_IT_VICTIM
	ShouldAllowSpecialsWithTank = true
}

Director.PlayMegaMobWarningSounds()
