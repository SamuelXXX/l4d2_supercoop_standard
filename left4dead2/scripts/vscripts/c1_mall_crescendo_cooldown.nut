Msg("\n\n\n");
Msg(">>>c1_mall_crescendo_cooldown\n");
Msg("\n\n\n");
//关闭商场机关后触发
DirectorOptions <-
{
	AlwaysAllowWanderers = true

	MobMinSize = 20
	MobMaxSize = 40
	MobMaxPending = 20
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.95

	RelaxMinInterval = 9999
	RelaxMaxInterval = 9999
	RelaxMaxFlowTravel = 900

	SpecialRespawnInterval = 8
	ZombieSpawnRange = 2000
	NumReservedWanderers = 20
}

Director.ResetMobTimer()