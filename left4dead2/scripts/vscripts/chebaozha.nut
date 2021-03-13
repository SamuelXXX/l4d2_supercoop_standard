Msg("Initiating Onslaught\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = true
	
	//LockTempo = true
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 50
	MobMaxSize = 50
	MobMaxPending = 50
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 2
	RelaxMaxFlowTravel = 50
	SpecialRespawnInterval = 1.0
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

