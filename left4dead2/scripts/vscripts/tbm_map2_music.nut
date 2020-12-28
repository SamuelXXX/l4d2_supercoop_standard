Msg("The Bloody Moors - more mobs for music event\n");

DirectorOptions <-
{
	AlwaysAllowWanderers = true
	MobSpawnMinTime = 25
	MobSpawnMaxTime = 30
	MobMinSize = 20
	MobMaxSize = 30
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 8
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 10
	RelaxMaxInterval = 30
	RelaxMaxFlowTravel = 850	
	SpecialRespawnInterval = 7
	NumReservedWanderers = 10
	MaxSpecials = 2
	BoomerLimit = 2
	CommonLimit = 30
}

Director.ResetMobTimer()