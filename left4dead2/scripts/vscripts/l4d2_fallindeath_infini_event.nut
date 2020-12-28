//坠入死亡
Msg("l4d2_fallindeath infinite event---------------------------------------------------------------------\n");

DirectorOptions <-
{
// This turns off tanks and witches.
ProhibitBosses = true

cm_MaxSpecials = 8
cm_DominatorLimit = 8

//LockTempo = true
MobSpawnMinTime = 2
MobSpawnMaxTime = 6
MobMinSize = 30
MobMaxSize = 40
MobMaxPending = 30
SustainPeakMinTime = 5
SustainPeakMaxTime = 10
IntensityRelaxThreshold = 0.99
RelaxMinInterval = 1
RelaxMaxInterval = 5
RelaxMaxFlowTravel = 50
SpecialRespawnInterval = 1.0
PreferredMobDirection = SPAWN_LARGE_VOLUME
PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
ShouldConstrainLargeVolumeSpawn = false
ZombieSpawnRange = 2000
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()