Msg("Junkyard mob spawn\n")

JunkyardCommonLimit <- 25;
if ( Director.GetGameModeBase() == "versus" )
	JunkyardCommonLimit = 18;

DirectorScript.MapScript.LocalScript.DirectorOptions.CommonLimit <- JunkyardCommonLimit;
ZSpawn({ type = 10, pos = Vector(0,0,0) });
delete DirectorScript.MapScript.LocalScript.DirectorOptions.CommonLimit;