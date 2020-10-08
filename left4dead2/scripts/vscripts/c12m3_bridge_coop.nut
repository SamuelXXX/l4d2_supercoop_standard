Msg(">>>Loading c12m3 Director Scripts\n");

DirectorOptions <-
{
	cm_MaxSpecials = 8
	DominatorLimit = 7
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	RelaxMaxFlowTravel = RandomInt(1000,1500)
	RelaxMinInterval = 99999
	RelaxMaxInterval = 99999
}

Msg("###Relax Max Flow Travel:"+DirectorOptions.RelaxMaxFlowTravel);
Msg("\n\n\n");