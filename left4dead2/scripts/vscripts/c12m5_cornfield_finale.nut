Msg("\n\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>Load c12 finale scripts<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n")
ERROR <- -1
PANIC <- 0
TANK <- 1
DELAY <- 2
SCRIPTED <- 3

DirectorOptions <-
{
	 A_CustomFinale1 = PANIC
	 A_CustomFinaleValue1 = GetFinalePanicWaveCount()

	 A_CustomFinale2 = SCRIPTED
	 A_CustomFinaleValue2 = "off.nut" 
 
	 A_CustomFinale3 = TANK
	 A_CustomFinaleValue3 = RandomInt(2,4)
 
	 A_CustomFinale4 = SCRIPTED
	 A_CustomFinaleValue4 = "c12m5_on.nut" 
 
	 A_CustomFinale5 = PANIC
	 A_CustomFinaleValue5 = GetFinalePanicWaveCount()

	 A_CustomFinale6 = SCRIPTED
	 A_CustomFinaleValue6 = "off.nut" 
 
	 A_CustomFinale7 = TANK
	 A_CustomFinaleValue7 = RandomInt(4,8)  
 
	 A_CustomFinale8 = SCRIPTED
	 A_CustomFinaleValue8 = "c12m5_on.nut"

	 A_CustomFinale9 = PANIC
	 A_CustomFinaleValue9 = GetFinalePanicWaveCount()

	 A_CustomFinale10 = SCRIPTED
	 A_CustomFinaleValue10 = "off.nut"

	 A_CustomFinale11 = TANK
	 A_CustomFinaleValue11 = RandomInt(6,10)
	 
	 A_CustomFinale12 = SCRIPTED
	 A_CustomFinaleValue12 = "c12m5_on.nut"	 

	 PreferredMobDirection = SPAWN_LARGE_VOLUME
	 PreferredSpecialDirection = SPAWN_LARGE_VOLUME
}

ApplyCommonFinaleOptions(DirectorOptions)
Convars.SetValue("l4d2_spawn_uncommons_autochance","3")
Convars.SetValue("l4d2_spawn_uncommons_autotypes","59")
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