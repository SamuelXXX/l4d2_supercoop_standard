Msg("\n\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>Load c2 finale scripts<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n")
ERROR <- -1
PANIC <- 0
TANK <- 1
DELAY <- 2
SCRIPTED <- 3

DirectorOptions <-
{
	 A_CustomFinale1 = SCRIPTED
	 A_CustomFinaleValue1 = "c2m5_1.nut"

	 A_CustomFinale2 = PANIC
	 A_CustomFinaleValue2 = GetFinalePanicWaveCount()	 

	 A_CustomFinale3 = SCRIPTED
	 A_CustomFinaleValue3 = "off.nut" 
 
	 A_CustomFinale4 = TANK
	 A_CustomFinaleValue4 = 3


 
	 A_CustomFinale5 = SCRIPTED
	 A_CustomFinaleValue5 = "c2m5_2.nut"
 
	 A_CustomFinale6 = PANIC
	 A_CustomFinaleValue6 = GetFinalePanicWaveCount()

	 A_CustomFinale7 = SCRIPTED
	 A_CustomFinaleValue7 = "off.nut" 
 
	 A_CustomFinale8 = TANK
	 A_CustomFinaleValue8 = 5 


 
	 A_CustomFinale9 = SCRIPTED
	 A_CustomFinaleValue9 = "c2m5_3.nut" 

	 A_CustomFinale10 = PANIC
	 A_CustomFinaleValue10 = GetFinalePanicWaveCount() - 1

	 A_CustomFinale11 = SCRIPTED
	 A_CustomFinaleValue11 = "c2m5_4.nut"

	 A_CustomFinale12 = PANIC
	 A_CustomFinaleValue12 = GetFinalePanicWaveCount() - 1

	 A_CustomFinale13 = SCRIPTED
	 A_CustomFinaleValue13 = "off.nut" 

	 A_CustomFinale14 = TANK
	 A_CustomFinaleValue14 = 8

	 A_CustomFinale15 = SCRIPTED
	 A_CustomFinaleValue15 = "c2m5_4.nut"
	 
	 PreferredMobDirection = SPAWN_NO_PREFERENCE
	 PreferredSpecialDirection = SPAWN_NO_PREFERENCE

}

ApplyCommonFinaleOptions(DirectorOptions)

// Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
// Convars.SetValue("l4d2_spawn_uncommons_autotypes","59")
Convars.SetValue("director_relax_min_interval","120")
Convars.SetValue("director_relax_max_interval","120")
Convars.SetValue("tongue_victim_max_speed","700")
Convars.SetValue("tongue_range","2000")
Convars.SetValue("z_tank_speed",210)
Convars.SetValue("l4d2_tankfire_boost_enable",1)

function OnBeginCustomFinaleStage( num, type )
{
	local dopts=GetDirectorOptions();
	if(type == TANK)
	{
		dopts.KillAllSpecialInfected()
	}
}

Msg("###Tank Health:"+DirectorOptions.ZombieTankHealth);