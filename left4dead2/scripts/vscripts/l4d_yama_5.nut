Msg(" atrium map script "+"\n")
 //摩耶山危机
// number of cans needed to escape.
 
if ( Director.IsSinglePlayerGame() )
{
	NumCansNeeded <- 7
}
else
{
	NumCansNeeded <- 12
}
 
// This script is called on MapSpawn, so the CommonLimit is for play before the finale start.
DirectorOptions <-
{
 
CommonLimit = 15
 
}
 
NavMesh.UnblockRescueVehicleNav() // Unblock so humans can be rescued when incapped near nozzle
 
EntFire( "scav_progshower", "SetTotalItems", NumCansNeeded ) //Set number of cans with game_scavenge_scav_progshower
 
 
function GasCanPoured(){} // Declaration of function, but was moved to main finale script