Msg("\n\n\n");
Msg(">>>c1_mall_ambient\n");
Msg("\n\n\n");
//c1m3商场地图开局触发

DirectorOptions <-
{
	AlwaysAllowWanderers = true

	MobMinSize = 20
	MobMaxSize = 40
	MobMaxPending = 20
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.95

	ZombieSpawnRange = 2000
	NumReservedWanderers = 20
}

Director.ResetMobTimer()