if(Director.GetMapName() == "4_m4"){
Msg("loaded\n");
//local jkent = null;
local flags = 0;

function AllowTakeDamage(damageTable){
	
	local dmgtype = damageTable["DamageType"]
	
	local victim = damageTable["Victim"]
	
	if(victim.IsPlayer())
	{
		if(victim.GetZombieType() == 5 && flags == 0 && victim.GetHealth() >= 10000)
		{
			flags =1;
			victim.SetMaxHealth(12500);
		}
	}
	if(dmgtype & 2097152 && victim.GetMaxHealth()==12500)
	{
		damageTable.DamageDone = 0;
		return true;
	}
	return true;
}


}