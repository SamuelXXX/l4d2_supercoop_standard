#include <sourcemod>
#include <sdktools>

#define TEAM_SPECTATOR	1
#define TEAM_SURVIVOR	2

ConVar Cvar_MagnumPossibility;

public Plugin myinfo =
{
	name = "Give Weapon When Player Spawn",
	author = "SamaelXXX",
	description = "As titled",
	version = "1",
	url = ""
};

public void OnPluginStart()
{
	Cvar_MagnumPossibility = CreateConVar("spawn_with_magnum_prob",  "1.0", "Probability of spawn with magnum", FCVAR_NOTIFY);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
	AutoExecConfig(true,"give_weapon_when_spawn");		
}

public void Event_PlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	if(SurvivorCount()>=8)//All survivors are ready
	{
		TryGiveMagnumsToTeam();
	}	
}

stock int SurvivorCount()
{
	int count=0;
	for(int i=0;i<MaxClients+1;i++)
	{
		if(IsSurvivor(i))
		{
			count++;
		}
	}
	return count;
}

stock void TryGiveMagnumsToTeam()
{
	if(!SurvivorTeamTooWeak())	
		return;

	PrintToServer("[Give Magnum When Spawn]Team Too Weak, Will Give Magnum!!!");

	for(int i=0;i<MaxClients+1;i++)
	{
		if(!IsSurvivor(i))
		{
			continue;
		}
		TryAssignMagnum(i);
	}
}

stock bool IsSurvivor(int client)
{
	return (client > 0 && client <= MaxClients && IsClientInGame(client) && GetClientTeam(client) == 2);
}

stock bool SurvivorTeamTooWeak()
{
	for(int i=0;i<MaxClients+1;i++)
	{
		if(!IsSurvivor(i))
		{
			continue;
		}

		int viceWeapon = GetPlayerWeaponSlot(i, 1);// 当前的副手武器
		if(viceWeapon==-1)
		{
			continue;
		}

		char viceName[32];
		GetEntityClassname(viceWeapon, viceName, sizeof(viceName));
		if(!StrEqual(viceName,"weapon_pistol"))
		{
			//PrintToServer(viceName);
			return false;
		}
	}

	return true;
}

stock void TryAssignMagnum(client)
{
	float random=GetURandomFloat();
	if(random>Cvar_MagnumPossibility.FloatValue)
		return;
	
	int newWeapon = -1;
	newWeapon = CreateEntityByName("weapon_pistol_magnum");
	if( newWeapon == -1 )
		ThrowError("Failed to create entity 'weapon_pistol_magnum'.");
	
	int old_weapon=GetPlayerWeaponSlot(client,1);
	if(old_weapon!=-1)
		RemovePlayerItem(client,old_weapon);

	if(DispatchSpawn(newWeapon))
	{
		ActivateEntity(newWeapon);
		EquipPlayerWeapon(client,newWeapon);
	}
}