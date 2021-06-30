Msg("\n\n\n");
Msg(">>>c2m4_finale_onslaught\n");
Msg("\n\n\n");

DirectorOptions <-
{
	// This turns off tanks and witches.
	ProhibitBosses = false

        LockTempo = 0
	MobSpawnMinTime = 3
	MobSpawnMaxTime = 3
	MobMinSize = 15
	MobMaxSize = 30
	MobRechargeRate  = 3
	SustainPeakMinTime = 10
	SustainPeakMaxTime = 30
	IntensityRelaxThreshold = 0.90
	RelaxMinInterval = 1
	RelaxMaxInterval = 1
	RelaxMaxFlowTravel = -1000
	MobMaxPending = 10
	SpecialRespawnInterval = 40.0
	ZombieSpawnRange = 3000

}

Director.ResetMobTimer()
 
if ( Director.GetGameMode() == "versus" )
{
    DirectorOptions.IntensityRelaxThreshold <- 0.8;
}
