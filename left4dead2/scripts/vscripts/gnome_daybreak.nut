// Locks on to the nearest survivor and points the entity running this at them. 
// By: Rectus
//破晓
Msg(" Gnome script activated "+"\n")
 
target <- null;
 
// Set the think function of the entity to 'PointEntity' for it to keep doing it.
function PointEntity()
{
	// Finds the closest survivor if we don't have a target yet.
	if(!target || !target.IsValid())
	{
		local bestTarget = null;
		local player = null;
 
		while(player = Entities.FindByClassname(player, "player"))
		{
			if(player.IsSurvivor())
			{
				if(!bestTarget || (player.GetOrigin() - self.GetOrigin()).Length() <
					(bestTarget.GetOrigin() - self.GetOrigin()).Length())
				{
					bestTarget = player;
				}
			}
		}
 
		if(bestTarget)
		{
			target = bestTarget;
		}
	}
 
	if(target)
	{
		self.SetForwardVector(target.GetOrigin() - self.GetOrigin());
	}
}