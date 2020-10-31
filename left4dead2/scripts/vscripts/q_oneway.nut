Msg("one way-------------------------------------------\n");
//故乡
DirectorOptions <-
{
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMinSize = 20
	MobMaxSize = 30
	MobMaxPending = 20
	
	SustainPeakMinTime = 4
	SustainPeakMaxTime = 6
	IntensityRelaxThreshold = 1
	RelaxMinInterval = 0
	RelaxMaxInterval = 1
	
	ProhibitBosses = true
	
	PreferredMobDirection = SPAWN_BEHIND_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 2000
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()