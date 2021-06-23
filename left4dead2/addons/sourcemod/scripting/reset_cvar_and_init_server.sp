#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

new Handle:g_ConVarHibernate;

static String:cfgPath[PLATFORM_MAX_PATH];
static String:customCfgPath[PLATFORM_MAX_PATH];

public OnPluginStart()
{
	g_ConVarHibernate = FindConVar("sv_hibernate_when_empty");
	HookEvent("player_disconnect", Event_PlayerDisconnect, EventHookMode_Pre);
	ExecuteCfg("server.cfg");		//或加启动项+exec server.cfg
}

public Event_PlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!client || (IsClientConnected(client)&&!IsClientInGame(client))) return;
	if(client&&!IsFakeClient(client)&&!checkrealplayerinSV(client))
	{
		SetConVarInt(g_ConVarHibernate,0);
		CreateTimer(0.0,COLD_DOWN);
	}
}
public Action:COLD_DOWN(Handle:timer,any:client)
{
	if(checkrealplayerinSV(0)) return;
	
	LogMessage("Last one player left the server, Reset cvar now");
	SetConVarInt(FindConVar("sv_maxplayers"), 8);
	SetConVarInt(FindConVar("l4d_round_live_count"), -1);
	ServerCommand("map c2m1_highway");
}

bool:checkrealplayerinSV(client)
{
	for (new i = 1; i < MaxClients+1; i++)
		if(IsClientConnected(i)&&!IsFakeClient(i)&&i!=client)
			return true;
	return false;
}

ExecuteCfg(const String:sFileName[])
{
	if(strlen(sFileName) == 0)
	{
		return;
	}
	
	decl String:sFilePath[PLATFORM_MAX_PATH];
	
	if(customCfgPath[0])
	{
		Format(sFilePath, sizeof(sFilePath), "%s%s", customCfgPath, sFileName);
		if(FileExists(sFilePath))
		{
			ServerCommand("exec %s%s", customCfgPath[strlen(cfgPath)], sFileName);
			
			return;
		}
	}
	
	Format(sFilePath, sizeof(sFilePath), "%s%s", cfgPath, sFileName);
	
	
	if(FileExists(sFilePath))
	{
		ServerCommand("exec %s", sFileName);
	}
	else
	{
		LogError("[Configs] Could not execute server config \"%s\", file not found", sFilePath);
	}
}