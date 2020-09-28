#include <sourcemod>
#include <sdktools>

#define TEAM_SPECTATOR	1
#define TEAM_SURVIVOR	2

static char sViceWeaponTracking[MAXPLAYERS+1][PLATFORM_MAX_PATH];

public Plugin myinfo =
{
	name = "Drop Melee Weapon When Player Dead",
	author = "SamaelXXX",
	description = "Make Player Drop Melee Weapon When died",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent("defibrillator_used", Event_PlayerRevived, EventHookMode_Post);		
}

Handle mapTickHandler;
public void OnMapStart()
{
	delete mapTickHandler;
	mapTickHandler=CreateTimer(1,MapTickHandleRoutine,_,TIMER_REPEAT);
}

public Action MapTickHandleRoutine(Handle timer)
{
	for(int i=0;i<MaxClients+1;i++)
	{
		if (!IsSurvivor(i))
		{
			sViceWeaponTracking[i]="";
		} 
		else 
		{
			int viceWeapon = GetPlayerWeaponSlot(i, 1);// 当前的副手武器
			if(viceWeapon==-1)
			{
				sViceWeaponTracking[i]="";
				continue;
			}

			GetEntityClassname(viceWeapon, sViceWeaponTracking[i], PLATFORM_MAX_PATH);
		}
	}

	return Plugin_Continue;
}

stock bool IsSurvivor(int client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2);
}

public void OnMapEnd()
{
	delete mapTickHandler;
}

public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (!client || GetClientTeam(client) != TEAM_SURVIVOR)
	{
		return;
	} 

	DropViceWeapon(client);
}

public Action Event_PlayerRevived(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "subject"));

	if (!client || GetClientTeam(client) != TEAM_SURVIVOR)
	{
		return;
	} 

	ReplaceWithPistol(client);
}

stock void DropViceWeapon(int client)
{
	int newWeapon = -1;
	newWeapon = CreateEntityByName(sViceWeaponTracking[client]);
	if( newWeapon == -1 )
		return;
	
	float position[3];
	GetEntPropVector(client, Prop_Send, "m_vecOrigin", position);	
	position[2]+=200;
	TeleportEntity(newWeapon,position, NULL_VECTOR, NULL_VECTOR);

	if(DispatchSpawn(newWeapon))
	{
		ActivateEntity(newWeapon);
	}
}

stock void ReplaceWithPistol(client)
{
	int newWeapon = -1;
	newWeapon = CreateEntityByName("weapon_pistol");
	if( newWeapon == -1 )
		ThrowError("Failed to create entity 'weapon_pistol'.");
	
	RemovePlayerItem(client,GetPlayerWeaponSlot(client,1));

	if(DispatchSpawn(newWeapon))
	{
		ActivateEntity(newWeapon);
		EquipPlayerWeapon(client,newWeapon);
	}
}