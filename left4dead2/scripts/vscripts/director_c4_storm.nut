Msg("\n\n\n");
Msg(">>>director_c4_storm\n");
Msg("\n\n\n");
//在c4m3 m4开局触发


DirectorOptions <-
{
	// This turns off tanks and witches.
	//ProhibitBosses = true

	ZombieSpawnInFog = 1
	ZombieSpawnRange = 3000
        MobRechargeRate = 0.001
        
        FallenSurvivorPotentialQuantity = 6
        FallenSurvivorSpawnChance       = 0.75

        GasCansOnBacks = true

}


if ( Director.GetGameMode() == "versus" )
{
    DirectorOptions.ProhibitBosses <- true;
}
