//破晓
Msg("----------------------DAY BREAK FINALE SCRIPT------------------\n")
//-----------------------------------------------------
// Stage type enumerations
PANIC <- 0
TANK <- 1
DELAY <- 2
ONSLAUGHT <- 3
//-----------------------------------------------------
// Initialized tables along with stage settings
 
SharedOptions <-
// Base DirectorOptions
{
 	A_CustomFinale1 = ONSLAUGHT //Will be stopped with input to director, EndCustomScriptedStage
	A_CustomFinaleValue1 = "" //InitialOnslaughtOptions is slightly different from c1m4_delay
 
	A_CustomFinale2 = PANIC
	A_CustomFinaleValue2 = 1 //1 PANIC wave
 
	A_CustomFinale3 = ONSLAUGHT
	A_CustomFinaleValue3 = "c1m4_delay" //This onslaught also depends on timer
 
	A_CustomFinale4 = PANIC
	A_CustomFinaleValue4 = 1
 
	A_CustomFinale5 = ONSLAUGHT
	A_CustomFinaleValue5 = "c1m4_delay"
 
	A_CustomFinale6 = TANK
	A_CustomFinaleValue6 = 1
 
	A_CustomFinale7 = ONSLAUGHT
	A_CustomFinaleValue7 = "c1m4_delay"
 
 	A_CustomFinale8 = PANIC
	A_CustomFinaleValue8 = 1
 
	A_CustomFinale9 = ONSLAUGHT
	A_CustomFinaleValue9 = "c1m4_delay"
 
 	A_CustomFinale10 = PANIC
	A_CustomFinaleValue10 = 1
 
	A_CustomFinale11 = ONSLAUGHT
	A_CustomFinaleValue11 = "c1m4_delay"
 
	A_CustomFinale12 = PANIC
	A_CustomFinaleValue12 = 1
 
 	A_CustomFinale13 = ONSLAUGHT
	A_CustomFinaleValue13 = "c1m4_delay"
 
	A_CustomFinale14 = TANK
	A_CustomFinaleValue14 = 1 //1 TANK
 
 	A_CustomFinale15 = ONSLAUGHT
	A_CustomFinaleValue15 = "c1m4_delay"
 
	A_CustomFinale16 = PANIC
	A_CustomFinaleValue16 = 1  
 
 	A_CustomFinale17 = ONSLAUGHT
	A_CustomFinaleValue17 = "c1m4_delay"    
 
 	A_CustomFinale18 = PANIC
	A_CustomFinaleValue18 = 1  
 
 	A_CustomFinale19 = ONSLAUGHT
	A_CustomFinaleValue19 = "c1m4_delay"
 
	A_CustomFinale20 = PANIC
	A_CustomFinaleValue20 = 1   
 
 	A_CustomFinale21 = ONSLAUGHT
	A_CustomFinaleValue21 = "c1m4_delay"
 
	A_CustomFinale22 = TANK
	A_CustomFinaleValue22 = 1  
 
 	A_CustomFinale23 = ONSLAUGHT
	A_CustomFinaleValue23 = "c1m4_delay"    
 
 	A_CustomFinale24 = PANIC
	A_CustomFinaleValue24 = 1
 
 	A_CustomFinale25 = ONSLAUGHT
	A_CustomFinaleValue25 = "c1m4_delay"
 
	A_CustomFinale26 = PANIC
	A_CustomFinaleValue26 = 1   
 
 	A_CustomFinale27 = ONSLAUGHT
	A_CustomFinaleValue27 = "c1m4_delay"
 
	A_CustomFinale28 = PANIC
	A_CustomFinaleValue28 = 1  
 
 	A_CustomFinale29 = ONSLAUGHT
	A_CustomFinaleValue29 = "c1m4_delay"    
 
 	A_CustomFinale30 = PANIC
	A_CustomFinaleValue30 = 1
 
 	A_CustomFinale31 = ONSLAUGHT
	A_CustomFinaleValue31 = "c1m4_delay" 

	A_CustomFinale32 = TANK
	A_CustomFinaleValue32 = 2
                  
  	A_CustomFinale33 = ONSLAUGHT
	A_CustomFinaleValue33 = "c1m4_delay"
  	                     
  	A_CustomFinale34 = PANIC
	A_CustomFinaleValue34 = 1

  	A_CustomFinale35 = ONSLAUGHT
	A_CustomFinaleValue35 = "c1m4_delay"
        
	A_CustomFinale36 = PANIC
	A_CustomFinaleValue36 = 1
        
  	A_CustomFinale37 = ONSLAUGHT
	A_CustomFinaleValue37 = "c1m4_delay"
        
	A_CustomFinale38 = PANIC
	A_CustomFinaleValue38 = 1
                  
  	A_CustomFinale39 = ONSLAUGHT
	A_CustomFinaleValue39 = "c1m4_delay"
                       
  	A_CustomFinale40 = PANIC
	A_CustomFinaleValue40 = 1

  	A_CustomFinale41 = ONSLAUGHT
	A_CustomFinaleValue41 = "c1m4_delay"

	A_CustomFinale42 = TANK
	A_CustomFinaleValue42 = 1
                  
  	A_CustomFinale43 = ONSLAUGHT
	A_CustomFinaleValue43 = "c1m4_delay"
                       
  	A_CustomFinale44 = PANIC
	A_CustomFinaleValue44 = 1

  	A_CustomFinale45 = ONSLAUGHT
	A_CustomFinaleValue45 = "c1m4_delay"
        
	A_CustomFinale46 = PANIC
	A_CustomFinaleValue46 = 1
        
  	A_CustomFinale47 = ONSLAUGHT
	A_CustomFinaleValue47 = "c1m4_delay"
        
	A_CustomFinale48 = PANIC
	A_CustomFinaleValue48 = 1
                  
  	A_CustomFinale49 = ONSLAUGHT
	A_CustomFinaleValue49 = "c1m4_delay"
                       
  	A_CustomFinale50 = PANIC
	A_CustomFinaleValue50 = 1

  	A_CustomFinale51 = ONSLAUGHT
	A_CustomFinaleValue51 = "c1m4_delay"   
        // End of finale, regardless of gas cans filled
 
	//-----------------------------------------------------
        // More Default DirectorOptions
 
	PreferredMobDirection = SPAWN_LARGE_VOLUME
	PreferredSpecialDirection = SPAWN_LARGE_VOLUME
 
//	BoomerLimit = 0
//	SmokerLimit = 2
//	HunterLimit = 1
//	SpitterLimit = 1
//	JockeyLimit = 0
//	ChargerLimit = 1
 
	ProhibitBosses = false
	ZombieSpawnRange = 3000
	MobRechargeRate = 0.5
	HordeEscapeCommonLimit = 40
	BileMobSize = 15
 
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 2
	MusicDynamicMobScanStopSize = 1
} 
 
InitialOnslaughtOptions <-
// DirectorOptions for first onslaught
{
    LockTempo = 0
	IntensityRelaxThreshold = 1.1
	RelaxMinInterval = 2
	RelaxMaxInterval = 4
	SustainPeakMinTime = 25
	SustainPeakMaxTime = 30
 
	MobSpawnMinTime = 4
	MobSpawnMaxTime = 8
	MobMinSize = 5
	MobMaxSize = 10
	MobMaxPending = 10
	CommonLimit = 30
	
	cm_MaxSpecials = 8
	cm_DominatorLimit = 8
 
	SpecialRespawnInterval = 8
}
 
PanicOptions <-
// DirectorOptions when in a PANIC stage
{
 
	MegaMobSize = 0 // randomized in OnBeginCustomFinaleStage
	MegaMobMinSize = 20
	MegaMobMaxSize = 30
 
	CommonLimit = 30
	
	cm_MaxSpecials = 8
	cm_DominatorLimit = 8
 
	SpecialRespawnInterval = 8
}
 
TankOptions <-
// DirectorOptions when in a TANK stage
{
	ShouldAllowMobsWithTank = true
	ShouldAllowSpecialsWithTank = true
 
	MobSpawnMinTime = 10
	MobSpawnMaxTime = 20
	MobMinSize = 3
	MobMaxSize = 5
 
	CommonLimit = 0
 
	SpecialRespawnInterval = 60
}
 
 
DirectorOptions <- clone SharedOptions
// Start with SharedOptions
{
}
 
 
//-----------------------------------------------------
 
// number of cans needed to escape. again. (Later moved to c1m4_atrium.nut)
NumCansNeeded <- 13
 
// fewer cans in single player since bots do not help much
if ( Director.IsSinglePlayerGame() )
{
	NumCansNeeded <- 9
}
 
// duration of delay stage.
DelayMin <- 10
DelayMax <- 20
 
// Number of touches and/or pours allowed before a delay is aborted.
DelayPourThreshold <- 1
DelayTouchedOrPouredThreshold <- 2
 
 
// Once the delay is aborted, amount of time before it progresses to next stage.
AbortDelayMin <- 1
AbortDelayMax <- 3
 
// Number of touches and pours it takes to transition out of c1m4_finale_wave_1
GimmeThreshold <- 4
 
 
// console overrides
if ( Director.IsPlayingOnConsole() )
{
	DelayMin <- 20
	DelayMax <- 30
 
	// Number of touches and/or pours allowed before a delay is aborted.
	DelayPourThreshold <- 2
	DelayTouchedOrPouredThreshold <- 4
 
	TankOptions.ShouldAllowSpecialsWithTank = false
 
}
//-----------------------------------------------------
//      INIT
//-----------------------------------------------------
 
GasCansTouched          <- 0
GasCansPoured           <- 0
DelayTouchedOrPoured    <- 0
DelayPoured             <- 0
 
EntFire( "timer_delay_end", "LowerRandomBound", DelayMin )
EntFire( "timer_delay_end", "UpperRandomBound", DelayMax )
EntFire( "timer_delay_abort", "LowerRandomBound", AbortDelayMin )
EntFire( "timer_delay_abort", "UpperRandomBound", AbortDelayMax )
 
// this is occurs too late. moved to c1m4_atrium.nut
//EntFire( "progress_display", "SetTotalItems", NumCansNeeded )
 
function AbortDelay(){}  	// only defined during a delay, in c1m4_delay.nut
function EndDelay(){}		// only defined during a delay, in c1m4_delay.nut
 
NavMesh.UnblockRescueVehicleNav() // This is redundant since it was already done once
 
//-----------------------------------------------------
 
function GasCanTouched()
// This is called by weapon_scavenge_item_spawn OnItemPickedUp
{
    GasCansTouched++
    Msg(" Touched: " + GasCansTouched + "\n")   
 
    EvalGasCansPouredOrTouched()    
}
 
function GasCanPoured()
// In this map, it is called by the director OnTeamScored
{
    GasCansPoured++
    DelayPoured++
    Msg(" Poured: " + GasCansPoured + "\n")   
 
    if ( GasCansPoured == NumCansNeeded )
    {
        Msg(" needed: " + NumCansNeeded + "\n") 
        EntFire( "relay_start_heli", "trigger" )
    }
 
    EvalGasCansPouredOrTouched()
}
 
function EvalGasCansPouredOrTouched()
// Evaluate the number of times gas cans poured or touched
{
    TouchedOrPoured <- GasCansPoured + GasCansTouched
    Msg(" Poured or touched: " + TouchedOrPoured + "\n")
 
    DelayTouchedOrPoured++
    Msg(" DelayTouchedOrPoured: " + DelayTouchedOrPoured + "\n")
    Msg(" DelayPoured: " + DelayPoured + "\n")
 
    if (( DelayTouchedOrPoured >= DelayTouchedOrPouredThreshold ) || ( DelayPoured >= DelayPourThreshold ))
    // This is for c1m4_delay.nut (c1m4_delay.nut also resets the counter for Poured and TouchOrPoured)
    {
        AbortDelay()
    }
 
    switch( TouchedOrPoured ) //For stopping the InitialOnslaught (first stage)
    {
        case GimmeThreshold:
            EntFire( "@director", "EndCustomScriptedStage" )
            break
    }
}
//-----------------------------------------------------
 
function AddTableToTable( dest, src )
// This function is used to move table keys and values to other tables
{
	foreach( key, val in src )
	{
		dest[key] <- val
	}
}

function DisableFinaleMusic()
{
	printl( "Disabling Default Finale Music..." );

	MapScript.DirectorOptions.MusicDynamicMobSpawnSize <- 1000
}
 
function OnBeginCustomFinaleStage( num, type )
// Special Function every time a finale stage starts.
// Instructions in this function set DirectorOptions for PANIC and TANK
{
	printl( "Beginning custom finale stage " + num + " of type " + type );
 
	local waveOptions = null
	if ( num == 1 )
	{
		waveOptions = InitialOnslaughtOptions
		EntFire( "gnome_timer" "Enable" )
		EntFire( "gnome_spawn_timer" "Enable" )
	}
	else if ( type == PANIC )
	{
		waveOptions = PanicOptions
		waveOptions.MegaMobSize = PanicOptions.MegaMobMinSize + rand()%( PanicOptions.MegaMobMaxSize - PanicOptions.MegaMobMinSize )
 
		Msg("*************************" + waveOptions.MegaMobSize + "\n")
		EntFire( "gnome_timer" "Enable" )
		EntFire( "gnome_spawn_timer" "Enable" )
 
	}
	else if ( type == TANK )
	{
		waveOptions = TankOptions
	}
	else if ( type == ONSLAUGHT )
	{
		EntFire( "gnome_timer" "Disable" )
		EntFire( "gnome_spawn_timer" "Disable" )
	}
 
	//---------------------------------
 
 
	MapScript.DirectorOptions.clear()
 
 
	AddTableToTable( MapScript.DirectorOptions, SharedOptions );
 
	if ( waveOptions != null )
	{
		AddTableToTable( MapScript.DirectorOptions, waveOptions );
	}
 
 
	Director.ResetMobTimer()
 
	if ( developer() > 0 )
	{
		Msg( "\n*****\nMapScript.DirectorOptions:\n" );
		foreach( key, value in MapScript.DirectorOptions )
		{
			Msg( "    " + key + " = " + value + "\n" );
		}
 
		if ( LocalScript.rawin( "DirectorOptions" ) )
		{
			Msg( "\n*****\nLocalScript.DirectorOptions:\n" );
			foreach( key, value in LocalScript.DirectorOptions )
			{
				Msg( "    " + key + " = " + value + "\n" );
			}
		}
	}
}
 
//-----------------------------------------------------
 
 
if ( Director.GetGameMode() == "coop" )
{
}
else if ( Director.GetGameMode() == "versus" ) // Allow tanks and witches in VS
{
	SharedOptions.ProhibitBosses = false
}