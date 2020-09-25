//-----------------------------------------------------
//
// This script encourages the director to generate the
// mega-mobs from positions in front of the survivors.
//
//-----------------------------------------------------
Msg("\n\n\n");
Msg(">>>c5m2_mob_from_front\n");
Msg("\n\n\n");
//c5m3 过停车场触发

DirectorOptions <-
{
	//-----------------------------------------------------
	// This is the variable that you have to set in order
	// to influence the direction of mob spawns.
	//-----------------------------------------------------
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS

	// Turn always wanderer on
	AlwaysAllowWanderers = 1

	// Set the number of infected that cannot be absorbed
	NumReservedWanderers = 20

	// More generous range for spawning infected makes it more
	// likely that we'll actually get our mob from the front
	ZombieSpawnRange = 2000
}


