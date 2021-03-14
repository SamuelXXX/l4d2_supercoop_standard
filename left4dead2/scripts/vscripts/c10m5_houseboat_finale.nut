Msg("\n\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>Load c10 finale scripts<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n")
ERROR <- -1
PANIC <- 0
TANK <- 1
DELAY <- 2
SCRIPTED <- 3

DirectorOptions <-
{
	 A_CustomFinale1 = SCRIPTED
	 A_CustomFinaleValue1 = "c10m5_1.nut"

	 A_CustomFinale2 = PANIC
	 A_CustomFinaleValue2 = GetFinalePanicWaveCount()	 

	 A_CustomFinale3 = SCRIPTED
	 A_CustomFinaleValue3 = "off.nut" 
 
	 A_CustomFinale4 = TANK
	 A_CustomFinaleValue4 = RandomInt(2,4)


 
	 A_CustomFinale5 = SCRIPTED
	 A_CustomFinaleValue5 = "c10m5_2.nut"
 
	 A_CustomFinale6 = PANIC
	 A_CustomFinaleValue6 = GetFinalePanicWaveCount()

	 A_CustomFinale7 = SCRIPTED
	 A_CustomFinaleValue7 = "off.nut" 
 
	 A_CustomFinale8 = TANK
	 A_CustomFinaleValue8 = RandomInt(4,6) 


 
	 A_CustomFinale9 = SCRIPTED
	 A_CustomFinaleValue9 = "c10m5_3.nut" 

	 A_CustomFinale10 = PANIC
	 A_CustomFinaleValue10 = GetFinalePanicWaveCount() - 1

	 A_CustomFinale11 = SCRIPTED
	 A_CustomFinaleValue11 = "c10m5_4.nut"

	 A_CustomFinale12 = PANIC
	 A_CustomFinaleValue12 = GetFinalePanicWaveCount() - 1

	 A_CustomFinale13 = SCRIPTED
	 A_CustomFinaleValue13 = "off.nut" 

	 A_CustomFinale14 = TANK
	 A_CustomFinaleValue14 = RandomInt(6,10)

	 A_CustomFinale15 = SCRIPTED
	 A_CustomFinaleValue15 = "c10m5_4.nut"


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