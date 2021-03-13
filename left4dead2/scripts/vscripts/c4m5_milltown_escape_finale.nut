Msg("\n\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>Load c5 finale scripts<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n")
ERROR <- -1
PANIC <- 0
TANK <- 1
DELAY <- 2
SCRIPTED <- 3

DirectorOptions <-
{
	 A_CustomFinale1 = SCRIPTED
	 A_CustomFinaleValue1 = "c4m5_1.nut"	 
 
	 A_CustomFinale2 = PANIC
	 A_CustomFinaleValue2 = GetFinalePanicWaveCount()

	 A_CustomFinale3 = TANK
	 A_CustomFinaleValue3 = 1
 
	 A_CustomFinale4 = SCRIPTED
	 A_CustomFinaleValue4 = "off.nut"
 
	 A_CustomFinale5 = DELAY
	 A_CustomFinaleValue5 = RandomInt(10,30) 
 
	 A_CustomFinale6 = SCRIPTED
	 A_CustomFinaleValue6 = "c4m5_2.nut"

	 A_CustomFinale7 = PANIC
	 A_CustomFinaleValue7 = GetFinalePanicWaveCount()
 
	 A_CustomFinale8 = TANK
	 A_CustomFinaleValue8 = 2 


	 PreferredMobDirection = SPAWN_LARGE_VOLUME
	 PreferredSpecialDirection = SPAWN_LARGE_VOLUME
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