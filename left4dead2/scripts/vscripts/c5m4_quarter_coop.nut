Msg(">>>Loading c5m4 Director Scripts\n");

relax_max_flow_travel<-Convars.GetFloat("director_relax_max_flow_travel")

DirectorOptions <-
{
	 cm_MaxSpecials = 14
	 DominatorLimit = 8

	 RelaxMaxFlowTravel = relax_max_flow_travel
	 RelaxMinInterval = 99999
	 RelaxMaxInterval = 99999
}

Msg("###Relax Max Flow Travel:"+DirectorOptions.RelaxMaxFlowTravel);
Msg("\n\n\n");