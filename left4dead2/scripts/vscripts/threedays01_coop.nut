Msg("\n\n\n");
Msg(">>>Loading threedays01 Director Scripts\n");

//遗忘之地
DirectorOptions <-
{
	cm_MaxSpecials = 8
	DominatorLimit = 4
	
	ZombieTankHealth=RandomInt(6000,12000)

	RelaxMinInterval = 180
	RelaxMaxInterval = 180 
}


Convars.SetValue("z_witch_always_kills","0")

Convars.SetValue("min_time_spawn_tank",9999)
Convars.SetValue("max_time_spawn_tank",9999)