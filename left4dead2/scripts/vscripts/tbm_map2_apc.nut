Msg("The Bloody Moors - apc event\n");

//-----------------------------------------------------------------------------

PANIC <- 0
TANK <- 1
DELAY <- 2

//-----------------------------------------------------------------------------

SharedOptions <-
{
	A_CustomFinale_StageCount = 3
	
 	A_CustomFinale1 = PANIC
	A_CustomFinaleValue1 = 1

	A_CustomFinale2 = DELAY
	A_CustomFinaleValue2 = 1
	
 	A_CustomFinale3 = PANIC
	A_CustomFinaleValue3 = 1
	
	PreferredMobDirection = SPAWN_LARGE_VOLUME
	PreferredSpecialDirection = SPAWN_LARGE_VOLUME
	ShouldConstrainLargeVolumeSpawn = false
	ZombieSpawnRange = 3000
	SpecialRespawnInterval = 7
} 

InitialPanicOptions <-
{
	ShouldConstrainLargeVolumeSpawn = true
}

PanicOptions <-
{
	CommonLimit = 30
	SpecialRespawnInterval = 7
}

TankOptions <-
{
	ShouldAllowSpecialsWithTank = false
	SpecialRespawnInterval = 7
}

DirectorOptions <- clone SharedOptions
{
}

//-----------------------------------------------------------------------------

function AddTableToTable( dest, src )
{
	foreach( key, val in src )
	{
		dest[key] <- val
	}
}

//-----------------------------------------------------------------------------

function OnBeginCustomFinaleStage( num, type )
{

	local waveOptions = null
	if ( num == 1 )
	{
		waveOptions = InitialPanicOptions
	}
	else if ( type == PANIC )
	{
		waveOptions = PanicOptions
		if ( "MegaMobMinSize" in PanicOptions )
		{
			waveOptions.MegaMobSize <- RandomInt( PanicOptions.MegaMobMinSize, MegaMobMaxSize )
		}
	}
	else if ( type == TANK )
	{
		waveOptions = TankOptions
	}
	
	//---------------------------------

	MapScript.DirectorOptions.clear()

	AddTableToTable( MapScript.DirectorOptions, SharedOptions );

	if ( waveOptions != null )
	{
		AddTableToTable( MapScript.DirectorOptions, waveOptions );
	}

}