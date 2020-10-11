
#include <sourcemod>
#include <sdktools>
#include <l4d2_InfectedSpawnApi>

#if defined InfectedApiVersion1_6
#else
	#error Plugin required Infected Api Version 1.6 (get it http://forums.alliedmods.net/showthread.php?t=114979)
#endif


/**
* ChangeLog
* 1.3.1 
* - Recompiled with new version of Infected API version 1.6.1
* 1.2
* - Speedup optimizations in InfectedSpawnApi
* 1.1
* - Fix IsPlayerAlive after ghost spawn (DLC bug)
* 1.0
* - Command sm_infectedchange allowed to use anytime with admin flag ROOT
* - Plugin name in plugins list corrected
* - Use Infected API version 1.5
* - Fix bug when plugin don't works correctly sometimes
* 0.8
* - Use Infected API version 1.4
* - Command sm_infectedchange compilation fixed
* - Simple fix compatiblity
* - Fixed MAXPLAYERS to MaxClients
* 0.7
* - Added cvar with version number. (l4d2_inffixspawn_version)
* - Added cvar for plugin wait(no actions) x seconds from round start. (sm_inffixspawn_wait)
* 0.6
* - All plugin code rewrited.
* - All bugs fixed.
* - Use Infected API version 1.3
* 0.5
* - Added debug log to file
* 0.4
* - Use Infected API version 1.2
* - Added cheking infected on finales
* - Added hard change class if director can't give another class more 5 times
* - Fixed bug with l4dtoolz and sv_force_normal_respawn (thanks to Visual77)
* - Added library for spawn ghost in finale without l4d2toolz (not required)
* 0.3
* - Fixed known bugs
* - Temporary infected not checked in finales
* 0.2
* -  Fix bug at round_end
* 0.1 
* - Initial release.
*/

#define PLUGIN_VERSION "1.3.1"
#define L4D_MAXPLAYERS 32
#define MAX_CLASS_RECHECKS 5
#define DEBUG 0

new LastClass;

public Plugin:myinfo =
{
	name = "[L4D2] Infected Fix Spawn",
	author = "V10",
	description = "Fixes the bug when infected spawn always same class",
	version = PLUGIN_VERSION,
	url = "http://forums.alliedmods.net/showthread.php?p=1048720"
}

public OnPluginStart()
{
	//Look up what game we're running,
	decl String:game[64]
	GetGameFolderName(game, sizeof(game))
	//and don't load if it's not L4D2.
	if (!StrEqual(game, "left4dead2", false)) SetFailState("Plugin supports Left 4 Dead 2 only.")
		
	HookEvent("round_start", Event_RoundStart);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post)

	InitInfectedSpawnAPI();
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	LastClass=-1;
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	int userid =  GetEventInt(event, "userid")
	int client =  GetClientOfUserId(userid);

	if (IsClientConnected(client) && IsClientInGame(client) && GetClientTeam(client)==TEAM_INFECTED) 
	{
		new ZombieClass=GetInfectedClass(client)
		if(ZombieClass!=LastClass)
		{
			LastClass=ZombieClass;
		}
		else
		{
			new CurrentClass=GenerateZombieId(ZombieClass);
			if(CurrentClass!=ZombieClass)
			{
				InfectedChangeClass(client,CurrentClass);
				//PrintToServer(">>>Convert %s to %s",g_sBossNames[ZombieClass],g_sBossNames[CurrentClass]);
				LastClass=CurrentClass;
			}	
		}
		
	}
}



