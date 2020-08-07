Msg("Super Coop");

DirectorOptions <-
{
	 cm_MaxSpecials = 8
	 cm_DominatorLimit = 8
	 TankLimit = 24
	 PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	 PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	 ProhibitBosses = false
	 ZombieTankHealth = RandomInt(6000,12000)
	 WitchLimit = 24
	 TankHitDamageModifierCoop = RandomFloat(1,5)
}
Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","31")
Convars.SetValue("z_witch_always_kills","0")
Convars.SetValue("director_max_threat_areas","24")
Convars.SetValue("tongue_victim_max_speed","225")
Convars.SetValue("tongue_range","1500")
Convars.SetValue("director_relax_min_interval","99999")
Convars.SetValue("director_relax_max_interval","99999")
Convars.SetValue("director_force_tank","0")
Convars.SetValue("director_force_witch","0")