Msg("\n\n\n");
Msg(">>>c14m2_gauntlet\n");
Msg("\n\n\n");


DirectorOptions <-
{
	CommonLimit = 30
	MobSpawnMinTime = 8
	MobSpawnMaxTime = 12
	MobSpawnSize = 30
	MobMaxPending = 20
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 1
	RelaxMaxFlowTravel = 1
	SpecialRespawnInterval = 5
	LockTempo = true
	PreferredMobDirection = SPAWN_ANYWHERE
	PanicForever = true
}

if ( Director.GetGameModeBase() == "versus" )
	DirectorOptions.MobSpawnSize = 5;

Director.ResetMobTimer();