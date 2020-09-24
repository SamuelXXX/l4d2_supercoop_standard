Msg("\n\n\n");
Msg(">>>c1_mall_crescendo_cooldown\n");
Msg("\n\n\n");

DirectorOptions <-
{
	AlwaysAllowWanderers = true
	MobSpawnMinTime = 25
	MobSpawnMaxTime = 60
	MobMinSize = 10
	MobMaxSize = 25
	MobMaxPending = 5
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.9
	RelaxMinInterval = 20
	RelaxMaxInterval = 35
	RelaxMaxFlowTravel = 2000
	SmokerLimit = 2
	HunterLimit = 2
	ChargerLimit = 3
	SpecialRespawnInterval = 20.0
	ZombieSpawnRange = 2000
	NumReservedWanderers = 15
}

Director.ResetMobTimer()