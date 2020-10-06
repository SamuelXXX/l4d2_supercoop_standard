Msg("\n\n\n");
Msg(">>>Loading c14m1 Director Scripts\n");

relax_max_flow_travel<-Convars.GetFloat("director_relax_max_flow_travel")

DirectorOptions <-
{
	 cm_MaxSpecials = 8
	 DominatorLimit = 4
	 SmokerLimit = 1
	 ZombieTankHealth = RandomInt(6000,12000)
	 RelaxMaxFlowTravel = relax_max_flow_travel
	 RelaxMinInterval = 99999
	 RelaxMaxInterval = 99999
}

Msg("###Tank Health:"+DirectorOptions.ZombieTankHealth);
Msg("###Relax Max Flow Travel:"+DirectorOptions.RelaxMaxFlowTravel);
Msg("\n\n\n");

Convars.SetValue("z_witch_always_kills","0")

//第一关太难，就不刷第二只tank了
Convars.SetValue("min_time_spawn_tank",9900)
Convars.SetValue("max_time_spawn_tank",9900)