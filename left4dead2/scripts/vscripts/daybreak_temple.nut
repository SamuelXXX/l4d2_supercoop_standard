//破晓
Msg("Initiating Temple Onslaught------------------------------------------\n");

PANIC <- 0
TANK <- 1
DELAY <- 2
 
DirectorOptions <-
{
	//-----------------------------------------------------
	A_CustomFinale_StageCount = 5 // Number of stages. Used for calculating the Versus score.
 
	A_CustomFinale1 = PANIC
	A_CustomFinaleValue1 = 8   // ZOMBIES
 
	A_CustomFinale2 = DELAY
	A_CustomFinaleValue2 = 1  // Delay for twelve seconds in addition to stage delay.
 
	 A_CustomFinale3 = PANIC
	 A_CustomFinaleValue3 = 8 // JUST KIDDING MORE ZOMBIES
 
	A_CustomFinale4 = DELAY
	A_CustomFinaleValue4 = 1 // Wait some more.

	A_CustomFinale5 = PANIC
	A_CustomFinaleValue5 = 12  // Panic until end


	// This turns off tanks and witches (when true).
	ProhibitBosses = true
 
	//LockTempo = true
 
	// Sets the time between mob spawns. Mobs can only spawn when the pacing is in the BUILD_UP state.
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
 
	// How many zombies are in each mob.
	MobMinSize = 75
	MobMaxSize = 75
	MobMaxPending = 75
	CommonLimit = 75
	MusicDynamicMobSpawnSize = 1000
 
	// Modifies the length of the SUSTAIN_PEAK and RELAX states to shorten the time between mob spawns.
	//SustainPeakMinTime = 5
	//SustainPeakMaxTime = 10
	//IntensityRelaxThreshold = 0.99
	//RelaxMinInterval = 1
	//RelaxMaxInterval = 5
	//RelaxMaxFlowTravel = 50
 
	//Special infected options
	SpecialRespawnInterval = 1.0
        SmokerLimit = 2
        JockeyLimit = 1
        BoomerLimit = 1
        HunterLimit = 2
        ChargerLimit = 1
 
	// Valid spawn locations
	PreferredMobDirection = SPAWN_NO_PREFERENCE
	ZombieSpawnRange = 5000
	FarAcquireRange = 5000
	FarAcquireTime = 0.5
}
 
Director.ResetMobTimer()		// Sets the mob spawn timer to 0.
Director.PlayMegaMobWarningSounds()	// Plays the incoming mob sound effect.