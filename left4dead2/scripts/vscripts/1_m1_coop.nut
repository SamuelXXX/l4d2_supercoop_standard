Msg("\n\n\n");
Msg(">>>Loading 1m_1 Director Scripts\n");

//血腥荒野
DirectorOptions <-
{
	cm_MaxSpecials = 8
	DominatorLimit = 4
	
	ZombieTankHealth=RandomInt(6000,12000)

	RelaxMinInterval = 180
	RelaxMaxInterval = 180 //Relax时间设置为2min，因为中间有个机关需要开启
}


Convars.SetValue("z_witch_always_kills","0")

Convars.SetValue("min_time_spawn_tank",9999)
Convars.SetValue("max_time_spawn_tank",9999)