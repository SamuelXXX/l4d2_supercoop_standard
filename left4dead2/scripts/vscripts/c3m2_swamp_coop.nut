Msg(">>>Loading c3m2 Director Scripts\n");

relax_max_flow_travel<-Convars.GetFloat("director_relax_max_flow_travel")

DirectorOptions <-
{
	 cm_MaxSpecials = 11
	 DominatorLimit = 6

	 RelaxMaxFlowTravel = relax_max_flow_travel
	 RelaxMinInterval = 99999
	 RelaxMaxInterval = 99999
}

Msg("###Relax Max Flow Travel:"+DirectorOptions.RelaxMaxFlowTravel);
Msg("\n\n\n");