Msg("wfp2_coop-------------------------------------------------------\n");

DirectorOptions <-
{
	 cm_MaxSpecials = 8
	 cm_DominatorLimit = 8
	 ChargerLimit = 1
	 SpitterLimit = 1
	 TankLimit = 24
	 PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	 PreferredSpecialDirection = SPAWN_SPECIALS_IN_FRONT_OF_SURVIVORS
	 ProhibitBosses = false
	 ZombieTankHealth = RandomInt(8000,20000)
	 WitchLimit = 24
	 TankHitDamageModifierCoop = RandomFloat(1,5)	 
	 RelaxMaxFlowTravel = RandomInt(800,1800)
}
Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","31")
Convars.SetValue("z_witch_always_kills","1")
Convars.SetValue("director_max_threat_areas","24")
Convars.SetValue("tongue_victim_max_speed","225")
Convars.SetValue("tongue_range","1500")
Convars.SetValue("director_relax_min_interval","99999")
Convars.SetValue("director_relax_max_interval","99999")
Convars.SetValue("director_force_tank","0")
Convars.SetValue("director_force_witch","0")