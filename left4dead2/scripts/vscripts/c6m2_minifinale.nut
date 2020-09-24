

Msg("\n\n\n");
Msg(">>>c6m2_minifinale\n");
Msg("\n\n\n");
//c6m2开完机关后刷

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true

	MobSpawnMinTime = 2
	MobSpawnMaxTime = 4
	MobMinSize = 25
	MobMaxSize = 25
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 3
	IntensityRelaxThreshold = 1.0
	RelaxMinInterval = 5
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200

	MobMaxPending = 15


	//-----------------------------------------------------
	// This is the variable that you have to set in order
	// to influence the direction of mob spawns.
	//-----------------------------------------------------
	PreferredMobDirection = 7

	ZombieSpawnRange = 3000

}

Director.ResetMobTimer()

