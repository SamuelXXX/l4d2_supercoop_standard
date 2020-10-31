Msg("onroof2-------------------------------------------\n");
//故乡
DirectorOptions <-
{
	MobSpawnMinTime = 0
	MobSpawnMaxTime = 0
	MobMinSize = 20
	MobMaxSize = 25
	MobMaxPending = 5
	SustainPeakMinTime = 6
	LockTempo = true

	ZombieSpawnInFog = true
	
	ZombieDiscardRange = 3000
	WanderingZombieDensityModifier = 0
	
}
Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()
