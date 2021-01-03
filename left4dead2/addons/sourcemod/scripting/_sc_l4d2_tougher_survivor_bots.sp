#pragma semicolon 1
#include <sourcemod> 
#include <sdkhooks>

public Plugin:myinfo =  
{
    name = "Tougher Survivor Bots;Cheat Survivor Bot", 
    author = "xQd", 
    description = "Makes the survivor bots be more resistant to damage", 
    version = "1.0", 
    url = "http://" 
}; 

public OnPluginStart(){
}

public OnClientPutInServer(client){ 
    SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage); 
} 

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype, &weapon, Float:damageForce[3], Float:damagePosition[3]){
	if (victim > 0 && victim <= MAXPLAYERS && IsClientConnected(victim) && IsClientInGame(victim) && GetClientTeam(victim) == 2 && IsFakeClient(victim))
	{
		damage = damage * 0.9;
		return Plugin_Changed;
	}
	return Plugin_Continue; 
}