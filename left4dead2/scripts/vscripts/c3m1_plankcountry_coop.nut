Msg("\n\n\n");
Msg(">>>Loading c3m1 Director Scripts\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 8
	 DominatorLimit = 5
	 ZombieTankHealth = RandomInt(6000,12000)
}

Msg("###Tank Health:"+DirectorOptions.ZombieTankHealth);
Msg("\n\n\n");

Convars.SetValue("z_witch_always_kills","0")