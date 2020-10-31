Msg("Initiating Onslaught\n");
//巴塞罗那
DirectorOptions <-
{
// This turns off tanks and witches.
ProhibitBosses = true
ShouldAllowMobsWithTank = true

//LockTempo = true
MobSpawnMinTime = 1
MobSpawnMaxTime = 4
MobMinSize = 30
MobMaxSize = 40
MobMaxPending = 30
SustainPeakMinTime = 5
SustainPeakMaxTime = 10
IntensityRelaxThreshold = 0.99
RelaxMinInterval = 1
RelaxMaxInterval = 5
RelaxMaxFlowTravel = 50
SpecialRespawnInterval = 1

ZombieSpawnRange = 2200
ZombieSpawnInFog = true



}

Director.ResetMobTimer()