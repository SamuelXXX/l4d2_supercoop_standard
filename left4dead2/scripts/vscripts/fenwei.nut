Msg("Initiating Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 0
	MobSpawnMaxTime = 0
	MobMinSize = 0
	MobMaxSize = 0
	MobMaxPending = 0
	SustainPeakMinTime = 0
	SustainPeakMaxTime = 0
	IntensityRelaxThreshold = 0
	RelaxMinInterval = 0
	RelaxMaxInterval = 0
	RelaxMaxFlowTravel = 0
	SpecialRespawnInterval = 1
        SmokerLimit = 2
        JockeyLimit = 2
        BoomerLimit = 0
        HunterLimit = 2
        ChargerLimit = 2
	PreferredMobDirection = SPAWN_NO_PREFERENCE
	ZombieSpawnRange = 1300
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

