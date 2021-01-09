Msg("\n\n\n");
Msg(">>>c1_mall_crescendo\n");
Msg("\n\n\n");
//打碎玻璃机关触发

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 120
	MobMaxSize = 120
	MobMaxPending = 90
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 3
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 500
	SpecialRespawnInterval = 3.0
	PreferredMobDirection = SPAWN_ABOVE_SURVIVORS
}


Director.ResetMobTimer()