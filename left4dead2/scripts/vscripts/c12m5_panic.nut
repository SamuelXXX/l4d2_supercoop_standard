Msg("\n\n\n");
Msg(">>>c12m5_panic\n");
Msg("\n\n\n");

DirectorOptions <-
{
MobSpawnMinTime = 3
MobSpawnMaxTime = 7
MobMinSize = 15
MobMaxSize = 15
MobMaxPending = 30
SustainPeakMinTime = 5
SustainPeakMaxTime = 10
IntensityRelaxThreshold = 0.99
RelaxMinInterval = 1
RelaxMaxInterval = 5
RelaxMaxFlowTravel = 50
SpecialRespawnInterval = 5
PreferredMobDirection = SPAWN_ANYWHERE
ZombieSpawnRange = 2000
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()