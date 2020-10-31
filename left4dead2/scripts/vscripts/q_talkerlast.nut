function q_talkerlast()
{
	
	if(GetPlayerFromCharacter(0) == activator)
	{
		EntFire( EntityGroup[0].GetName(), "Start","",5)
	} else if(GetPlayerFromCharacter(1) == activator)
	{
		EntFire( EntityGroup[1].GetName(), "Start","",5)
	} else if(GetPlayerFromCharacter(2) == activator)
	{
		EntFire( EntityGroup[2].GetName(), "Start","",0 )
	} else if(GetPlayerFromCharacter(3) == activator)
	{
		EntFire( EntityGroup[3].GetName(), "Start","",5)
	}

}
//故乡