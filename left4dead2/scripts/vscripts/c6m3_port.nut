
Msg("\n\n\n");
Msg(">>>c6m3_port\n");
Msg("\n\n\n");

// number of cans needed to escape.

if ( Director.IsSinglePlayerGame() )
{
	NumCansNeeded <- 10
}
else
{
	NumCansNeeded <- 16
}


DirectorOptions <-
{
	
CommonLimit = 30

}

NavMesh.UnblockRescueVehicleNav()

EntFire( "progress_display", "SetTotalItems", NumCansNeeded )


function GasCanPoured(){}