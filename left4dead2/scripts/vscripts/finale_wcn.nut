PANIC <- 0
TANK <- 1
DELAY <- 2
ONSLAUGHT <- 3
//巴塞罗那
DirectorOptions <-
{
	//-----------------------------------------------------

	 A_CustomFinale_StageCount = 2
	 
	 A_CustomFinale1 = DELAY
	 A_CustomFinaleValue1 = 7 // wait ten seconds ... rescue!

	 A_CustomFinale2 = ONSLAUGHT
	 A_CustomFinaleValue2 = "mnac_onslaught2.nut" // run our onslaught script
	 

	 


	//-----------------------------------------------------
}

function OnBeginCustomFinaleStage( num, type )
{
      printl( "Beginning custom finale stage " + num + " of type " + type );
      MapScript.DirectorOptions.CommonLimit = num * 10 // increase commons by 10 linearly with stages
}