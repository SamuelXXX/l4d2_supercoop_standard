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
 
	 A_CustomFinale3 = TANK
	 A_CustomFinaleValue3 = RandomInt(2,4)


 
	 A_CustomFinale4 = SCRIPTED
	 A_CustomFinaleValue4 = "c2m5_2.nut"
 
	 A_CustomFinale5 = PANIC
	 A_CustomFinaleValue5 = GetFinalePanicWaveCount()
 
	 A_CustomFinale6 = TANK
	 A_CustomFinaleValue6 = RandomInt(4,6) 


 
	 A_CustomFinale7 = SCRIPTED
	 A_CustomFinaleValue7 = "c2m5_3.nut" 

	 A_CustomFinale8 = PANIC
	 A_CustomFinaleValue8 = GetFinalePanicWaveCount() - 1

	 A_CustomFinale9 = SCRIPTED
	 A_CustomFinaleValue9 = "c2m5_4.nut"

	 A_CustomFinale10 = PANIC
	 A_CustomFinaleValue10 = GetFinalePanicWaveCount() - 1

	 A_CustomFinale11 = TANK
	 A_CustomFinaleValue11 = RandomInt(6,10)
	 
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

function OnBeginCustomFinaleStage( num, type )
{
	local dopts=GetDirectorOptions();
	if(type == TANK)
	{
		dopts.KillAllSpecialInfected()
	}
}

Msg("###Tank Health:"+DirectorOptions.ZombieTankHealth);