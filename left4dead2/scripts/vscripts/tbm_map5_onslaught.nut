Msg("The Bloody Moors - map5 finale\n");

PANIC 		<- 0
TANK 		<- 1
DELAY 		<- 2

DirectorOptions <-
{

	A_CustomFinale_StageCount = 1
	
	A_CustomFinale1 = PANIC
	A_CustomFinaleValue1 = 9999
	
	TankLimit = 1
	WitchLimit = 0
	CommonLimit = 25	
	HordeEscapeCommonLimit = 30	
	EscapeSpawnTanks = true
	ZombieSpawnRange = 1500
	PreferredMobDirection = SPAWN_ANYWHERE

}
