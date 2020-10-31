Msg("outskirt crescendo wave---------------------------------------------\n");
//天堂可待
DirectorOptions <-
{
// This turns off tanks and witches.
// ProhibitBosses = false

//LockTempo = true
MobSpawnMinTime = 3
MobSpawnMaxTime = 7
MobMinSize = 30
MobMaxSize = 30
MobMaxPending = 30
SustainPeakMinTime = 5
SustainPeakMaxTime = 10
IntensityRelaxThreshold = 0.99
RelaxMinInterval = 1
RelaxMaxInterval = 5
RelaxMaxFlowTravel = 50
SpecialRespawnInterval = 1.0
PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
ZombieSpawnRange = 2000

cm_MaxSpecials = 8
}

Director.ResetMobTimer()