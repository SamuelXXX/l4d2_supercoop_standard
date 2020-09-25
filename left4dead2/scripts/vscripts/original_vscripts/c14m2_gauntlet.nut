Msg("Beginning Lighthouse Scavenge.\n")

DirectorOptions <-
{
	CommonLimit = 25
	MobSpawnMinTime = 9
	MobSpawnMaxTime = 9
	MobSpawnSize = 8
	MobMaxPending = 15
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
	RelaxMaxInterval = 1
	RelaxMaxFlowTravel = 1
	SpecialRespawnInterval = 30
	LockTempo = true
	PreferredMobDirection = SPAWN_ANYWHERE
	PanicForever = true
}

if ( Director.GetGameModeBase() == "versus" )
	DirectorOptions.MobSpawnSize = 5;

Director.ResetMobTimer();