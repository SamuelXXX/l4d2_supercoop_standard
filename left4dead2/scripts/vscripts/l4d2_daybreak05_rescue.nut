//破晓
Msg(" Day Break Finale Script Detected----------------------------------------------------------- "+"\n")
 
// number of cans needed to escape.
 
if ( Director.IsSinglePlayerGame() )
{
	NumCansNeeded <- 9
}
else
{
	NumCansNeeded <- 13
}
 
// This script is called on MapSpawn, so the CommonLimit is for play before the finale start.
DirectorOptions <-
{
 
CommonLimit = 30
 
}
 
NavMesh.UnblockRescueVehicleNav() // Unblock so humans can be rescued when incapped near nozzle
 
EntFire( "progress_display", "SetTotalItems", NumCansNeeded ) //Set number of cans with game_scavenge_progress_display
 
 
function GasCanPoured(){} // Declaration of function, but was moved to main finale script