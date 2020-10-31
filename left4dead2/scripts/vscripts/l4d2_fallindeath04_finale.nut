//坠入死亡
//-----------------------------------------------------
// This script handles the logic for the Port / Bridge
// finale in the River Campaign. 
//
//-----------------------------------------------------
Msg("Initiating l4d2_fallindeath04_finale script\n");

//-----------------------------------------------------
ERROR		<- -1
PANIC 		<- 0
TANK 		<- 1
DELAY 		<- 2

//-----------------------------------------------------

// This keeps track of the number of times the generator button has been pressed. 
// Init to 1, since one button press has been used to start the finale and run 
// this script. 
ButtonPressCount <- 1

// This stores the stage number that we last
// played the "Press the Button!" VO
LastVOButtonStageNumber <- 0

// We use this to keep from running a bunch of queued advances really quickly. 
// Init to true because we are starting a finale from a button press in the pre-finale script 
// see GeneratorButtonPressed in c7m3_port.nut
PendingWaitAdvance <- true	

// We use three generator button presses to push through
// 8 stages. We have to queue up state advances
// depending on the state of the finale when buttons are pressed
QueuedDelayAdvances <- 0


// Tracking current finale states
CurrentFinaleStageNumber <- ERROR
CurrentFinaleStageType <- ERROR

// The finale is 10 phases. 
// We randomize the event types in the first two
local RandomFinaleStage1 = 0
local RandomFinaleStage2 = 0
local RandomFinaleStage4 = 0
local RandomFinaleStage5 = 0
local RandomFinaleStage7 = 0
local RandomFinaleStage9 = 0
local RandomFinaleStage11 = 0
local RandomFinaleStage13 = 0



// PHASE 1 EVENTS
if ( RandomInt( 1, 100 ) < 50 )
{
	RandomFinaleStage1 = PANIC
	RandomFinaleStage2 = TANK
}
else
{
	RandomFinaleStage1 = TANK
	RandomFinaleStage2 = PANIC
}


// PHASE 2 EVENTS
if ( RandomInt( 1, 100 ) < 50 )
{
	RandomFinaleStage4 = PANIC
	RandomFinaleStage5 = TANK
}
else
{
	RandomFinaleStage4 = TANK
	RandomFinaleStage5 = PANIC
}



// PHASE 3 EVENTS
if ( RandomInt( 1, 100 ) < 50 )
{
	RandomFinaleStage7 = PANIC

}
else
{
	RandomFinaleStage7 = PANIC
}

// PHASE 4 EVENTS
if ( RandomInt( 1, 100 ) < 50 )
{
	RandomFinaleStage9 = PANIC
}
else
{
	RandomFinaleStage9 = PANIC
}

// PHASE 5 EVENTS
if ( RandomInt( 1, 100 ) < 50 )
{
	RandomFinaleStage11 = PANIC

}
else
{
	RandomFinaleStage11 = PANIC
}

// PHASE 6 EVENTS
if ( RandomInt( 1, 100 ) < 50 )
{
	RandomFinaleStage13 = TANK

}
else
{
	RandomFinaleStage13 = TANK

}



// We want to give the survivors a little of extra time to 
// get on their feet before the escape, since you have to fight through 
// the sacrifice.

PreEscapeDelay <- 0
if ( Director.GetGameMode() == "coop" )
{
	PreEscapeDelay <- 5
}
else if ( Director.GetGameMode() == "versus" )
{
	PreEscapeDelay <- 15
}


//----add----
PanicOptions <-
{
	ProhibitBosses = true
	
	CommonLimit = 50
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 2
	MobMinSize = 30
	MobMaxSize = 40
	MobMaxPending = 30
	SustainPeakMinTime = 1
	SustainPeakMaxTime = 1
	IntensityRelaxThreshold = 0.95
	RelaxMinInterval = 3
	RelaxMaxInterval = 5
	RelaxMaxFlowTravel = 50
	SpecialRespawnInterval = 2
	
	cm_MaxSpecials = 10
	cm_DominatorLimit = 10
	
	MusicDynamicMobSpawnSize = 8
	MusicDynamicMobStopSize = 4
	MusicDynamicMobScanStopSize = 1
}
//----end add----


DirectorOptions <-
{	
	 
	A_CustomFinale_StageCount = 15
	 
	// PHASE 1
	A_CustomFinale1 = PANIC
	A_CustomFinaleValue1 = RandomInt(1,2)
	A_CustomFinale2 = TANK
	A_CustomFinaleValue2 = RandomInt(1,3)
	A_CustomFinale3 = DELAY
	A_CustomFinaleValue3 = 9999
	
	// PHASE 2
	A_CustomFinale4 = PANIC
	A_CustomFinaleValue4 = RandomInt(1,3)
	A_CustomFinale5 = TANK
	A_CustomFinaleValue5 = RandomInt(1,4)	
	A_CustomFinale6 = DELAY
	A_CustomFinaleValue6 = 9999 	 
	
	// PHASE 3
	A_CustomFinale7 = PANIC
	A_CustomFinaleValue7 = RandomInt(2,3)	
	A_CustomFinale8 = DELAY
	A_CustomFinaleValue8 = 9999 	 
	
	// PHASE 4
	A_CustomFinale9 = TANK
	A_CustomFinaleValue9 = RandomInt(2,6)	
	A_CustomFinale10 = DELAY
	A_CustomFinaleValue10 = 9999 
	
	// PHASE 5
	A_CustomFinale11 = PANIC
	A_CustomFinaleValue11 = RandomInt(1,3)	
	A_CustomFinale12 = DELAY
	A_CustomFinaleValue12 = 9999 	

	// PHASE 6
	A_CustomFinale13 = TANK
	A_CustomFinaleValue13 = RandomInt(1,4)
	A_CustomFinale14 = PANIC
	A_CustomFinaleValue14 = RandomInt(1,4) 	 		 
	A_CustomFinale15 = DELAY
	A_CustomFinaleValue15 = PreEscapeDelay
	 
	 
	cm_MaxSpecials = 12
	cm_DominatorLimit = 12
	TankLimit = 4
	WitchLimit = 0
	CommonLimit = 30
	//----add----
	ZombieSpawnRange = 1024
	BileMobSize = 15
	//----end add----	
	HordeEscapeCommonLimit = 20	
	SpecialRespawnInterval = 2

}


function OnBeginCustomFinaleStage( num, type )
{
	printl( "*!* Beginning custom finale stage " + num + " of type " + type );
	printl( "*!* PendingWaitAdvance " + PendingWaitAdvance + ", QueuedDelayAdvances " + QueuedDelayAdvances );
	
	// Store off the state... 
	CurrentFinaleStageNumber = num
	CurrentFinaleStageType = type
	
	// Acknowledge the state advance
	PendingWaitAdvance = false
}


function AutoStartFinal()
{
	printl( "*!* AutoStartFinal finale stage " + CurrentFinaleStageNumber + " of type " +CurrentFinaleStageType );
	printl( "*!* PendingWaitAdvance " + PendingWaitAdvance + ", QueuedDelayAdvances " + QueuedDelayAdvances );
		
		
	ButtonPressCount++
		
		
	local ImmediateAdvances = 0
		
		
	if ( CurrentFinaleStageNumber == 1 || CurrentFinaleStageNumber == 4 || CurrentFinaleStageNumber == 13 )
	{		
		// First stage of a phase, so next stage is an "action" stage too.
		// Advance to next action stage, and then queue an advance to the 
		// next delay.
		QueuedDelayAdvances++
		ImmediateAdvances = 1
	}
	else if ( CurrentFinaleStageNumber == 2 || CurrentFinaleStageNumber == 5 || CurrentFinaleStageNumber == 7 || CurrentFinaleStageNumber == 9 || CurrentFinaleStageNumber == 11 || CurrentFinaleStageNumber == 14 )
	{
		// Second stage of a phase, so next stage is a "delay" stage.
		// We need to immediately advance past the delay and into an action state. 
			
		QueuedDelayAdvances++
		ImmediateAdvances = 1
	}
	else if ( CurrentFinaleStageNumber == 3 || CurrentFinaleStageNumber == 6 || CurrentFinaleStageNumber == 8 || CurrentFinaleStageNumber == 10 || CurrentFinaleStageNumber == 12 )
	{
		// Wait states... (very long delay)
		// Advance immediately into an action state
			
		QueuedDelayAdvances++
		ImmediateAdvances = 1
	}
	else
	{
		printl( "*!* Unhandled AutoStartFinal! " );
	}

	if ( ImmediateAdvances > 0 )
	{	
		EntFire( "autostartfinal_model", "Enable" )
			
		if ( ImmediateAdvances == 1 )
		{
			printl( "*!* AutoStartFinal Advancing State ONCE");
			EntFire( "autostartfinal_model", "AdvanceFinaleState" )
		}
		else if ( ImmediateAdvances == 2 )
		{
			printl( "*!* AutoStartFinal Advancing State TWICE");
			EntFire( "autostartfinal_model", "AdvanceFinaleState" )
			EntFire( "autostartfinal_model", "AdvanceFinaleState" )
		}
			
		EntFire( "autostartfinal_model", "Disable" )
			
		PendingWaitAdvance = true
	}
}

function Update()
{
	// Should we advance the finale state?
	// 1. If we're in a DELAY state
	// 2. And we have queued advances.... 
	// 3. And we haven't just tried to advance the advance the state.... 
	if ( CurrentFinaleStageType == DELAY && QueuedDelayAdvances > 0 && !PendingWaitAdvance )
	{
		// If things are calm (relatively), jump to the next state
		if ( !Director.IsTankInPlay() && !Director.IsAnySurvivorInCombat() )
		{
			if ( Director.GetPendingMobCount() < 1 && Director.GetCommonInfectedCount() < 5 )
			{
				printl( "*!* Update Advancing State finale stage " + CurrentFinaleStageNumber + " of type " +CurrentFinaleStageType );
				printl( "*!* PendingWaitAdvance " + PendingWaitAdvance + ", QueuedDelayAdvances " + QueuedDelayAdvances );
		
				QueuedDelayAdvances--
				EntFire( "autostartfinal_model", "Enable" )
				EntFire( "autostartfinal_model", "AdvanceFinaleState" )
				EntFire( "autostartfinal_model", "Disable" )
				PendingWaitAdvance = true
			}
		}
	}
	
	// Should we fire the director event to play the "Press the button!" Nag VO?	
	// If we're on an infinite delay stage...
	if ( CurrentFinaleStageType == DELAY && CurrentFinaleStageNumber > 1 && CurrentFinaleStageNumber < 11 )	
	{		
		// 1. We haven't nagged for this stage yet
		// 2. There are button presses remaining
		if ( CurrentFinaleStageNumber != LastVOButtonStageNumber && ButtonPressCount < 5 )
		{
			// We're not about to process a wait advance..
			if ( QueuedDelayAdvances == 0 && !PendingWaitAdvance )
			{
				// If things are pretty calm, run the event
				if ( Director.GetPendingMobCount() < 1 && Director.GetCommonInfectedCount() < 1 )
				{
					if ( !Director.IsTankInPlay() && !Director.IsAnySurvivorInCombat() )
					{
						printl( "*!* Update firing event 1 (VO Prompt)" )
						LastVOButtonStageNumber = CurrentFinaleStageNumber
						Director.UserDefinedEvent1()
					}
				}
			}
		}
	}
	
}


function EnableEscapeTanks()
{
	printl( "*!* EnableEscapeTanks finale stage " + CurrentFinaleStageNumber + " of type " + CurrentFinaleStageType );
	
	//Msg( "\n*****\nMapScript.DirectorOptions:\n" );
	//foreach( key, value in MapScript.DirectorOptions )
	//{
	//	Msg( "    " + key + " = " + value + "\n" );
	//}

	MapScript.DirectorOptions.EscapeSpawnTanks <- true
}