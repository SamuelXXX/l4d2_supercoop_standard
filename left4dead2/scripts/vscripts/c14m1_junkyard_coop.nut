Msg("\n\n\n");
Msg(">>>Loading c14m1 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 7
	 cm_DominatorLimit = 8
	 SmokerLimit = 0
	 ZombieTankHealth = RandomInt(6000,12000)
}

Msg("###Tank Health:"+DirectorOptions.ZombieTankHealth);
Msg("\n\n\n");

Convars.SetValue("z_witch_always_kills","0")

//第一关太难，就不刷第二只tank了
Convars.SetValue("min_time_spawn_tank",9900)
Convars.SetValue("max_time_spawn_tank",9900)