#pragma semicolon 1
#include <sourcemod>
#include <sdkhooks>

#define PLUGIN_VERSION "1"


public Plugin:myinfo =
{
	name = "L4D2 No Head Shake",
	author = "SamaelXXX",
	description = "Provides a method for disabling the shaking effect upon being shot in the head.",
	version = PLUGIN_VERSION,
	url = ""
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, Hook_OnTakeDamage);
}

stock bool:IsSurvivor(client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2);
}

public Action:Hook_OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if(IsSurvivor(attacker) && IsSurvivor(victim))
	{
		// char victimName[32];
		// GetClientName(victim,victimName,32);
		//PrintToChatAll("Friendly Fire To %s",victimName);
		SetEntPropVector(victim, Prop_Send, "m_vecPunchAngle", NULL_VECTOR);
		SetEntPropVector(victim, Prop_Send, "m_vecPunchAngleVel", NULL_VECTOR);
	}
	return Plugin_Continue;
}
