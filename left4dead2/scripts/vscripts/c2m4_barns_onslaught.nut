Msg("\n\n\n");
Msg(">>>c2m4_barns_onslaught\n");
Msg("\n\n\n");
//c2m4开机关触发


DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false
	
	//LockTempo = true
	MobSpawnMinTime = 3
	MobSpawnMaxTime = 7
	MobMinSize = 20
	MobMaxSize = 30
	MobMaxPending = 30
	SustainPeakMinTime = 5
	SustainPeakMaxTime = 10
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 50
	SpecialRespawnInterval = 5
	PreferredMobDirection = SPAWN_ANYWHERE
	PreferredSpecialDirection = SPAWN_LARGE_VOLUME
	ZombieSpawnRange = 2000
}

Director.ResetMobTimer()
//Director.PlayMegaMobWarningSounds()

