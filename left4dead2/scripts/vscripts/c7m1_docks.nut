//-----------------------------------------------------
//
//
//-----------------------------------------------------
Msg("\n\n\n");
Msg(">>>c7m1_docks\n");
Msg("\n\n\n");
//c7m1开局触发w

DocksCommonLimit <- 40	// use a lower common limit to combat pathing related perf issues
DocksMegaMobSize <- 50	

if ( Director.IsPlayingOnConsole() )
{
	DocksCommonLimit <- 20
}

if ( Director.GetGameMode() == "coop" )
{
	DocksMegaMobSize <- 30	// use a smaller megamob for the panic event in the train car area. 
}

DirectorOptions <-
{
	ProhibitBosses = true
	CommonLimit = DocksCommonLimit	
	MegaMobSize = DocksMegaMobSize
}


