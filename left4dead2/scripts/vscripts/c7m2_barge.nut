//-----------------------------------------------------
//
//
//-----------------------------------------------------
Msg("\n\n\n");
Msg(">>>c7m2_barge\n");
Msg("\n\n\n");

BargeCommonLimit <- 25	// use a lower common limit to combat infected related perf issues

if ( Director.IsPlayingOnConsole() )
{
	BargeCommonLimit <- 20
}


DirectorOptions <-
{
	CommonLimit = BargeCommonLimit	
}


