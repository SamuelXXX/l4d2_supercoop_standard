//晨茗
function jueseguolv()
{
	
	Nick <- Entities.FindByModel(null,"models/survivors/survivor_gambler.mdl");
	Rochelle <- Entities.FindByModel(null,"models/survivors/survivor_producer.mdl");
	Coach <- Entities.FindByModel(null,"models/survivors/survivor_coach.mdl");
	Ellis <- Entities.FindByModel(null,"models/survivors/survivor_mechanic.mdl");
	
	if(activator == Nick)
	{
		EntFire( EntityGroup[0].GetName(), "Start", 0 )
	} else if(activator == Rochelle)
	{
		EntFire( EntityGroup[1].GetName(), "Start", 0 )
	} else if(activator == Coach)
	{
		EntFire( EntityGroup[2].GetName(), "Start", 0 )
	} else if(activator == Ellis)
	{
		EntFire( EntityGroup[3].GetName(), "Start", 0 )
	}
	
	Msg("Talk Start\n");
}

