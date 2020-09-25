Msg("Beginning crane panic event.\n")

DirectorOptions <-
{
	ProhibitBosses = true
	CommonLimit = 18

	MobSpawnMinTime = 2
	MobSpawnMaxTime = 4
	MobMinSize = 15
	MobMaxSize = 20
	MobMaxPending = 35
	SustainPeakMinTime = 10
	SustainPeakMaxTime = 15
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 3
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 200
	BoomerLimit = 0
	SmokerLimit = 1
	HunterLimit = 1
	ChargerLimit = 1
	SpecialRespawnInterval = 5.0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()