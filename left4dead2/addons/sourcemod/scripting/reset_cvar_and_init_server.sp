#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

#define CVAR_PREFIX			""
#define CVAR_FLAGS			FCVAR_NONE

new Handle:g_ConVarHibernate;

static const String:customCfgDir[] = "";

static Handle:hCustomConfig;
static String:configsPath[PLATFORM_MAX_PATH];
static String:cfgPath[PLATFORM_MAX_PATH];
static String:customCfgPath[PLATFORM_MAX_PATH];
static DirSeparator;

public OnPluginStart()
{
	InitPaths();
	hCustomConfig = CreateConVarEx("customcfg", "", "DONT TOUCH THIS CVAR! This is more magic bullshit!",FCVAR_DONTRECORD|FCVAR_UNLOGGED);
	decl String:cfgString[64];
	GetConVarString(hCustomConfig, cfgString, sizeof(cfgString));
	SetCustomCfg(cfgString);
	ResetConVar(hCustomConfig);
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
	ServerCommand("map c5m1_waterfront");
}

bool:checkrealplayerinSV(client)
{
	for (new i = 1; i < MaxClients+1; i++)
		if(IsClientConnected(i)&&!IsFakeClient(i)&&i!=client)
			return true;
	return false;
}

InitPaths()
{
	BuildPath(Path_SM, configsPath, sizeof(configsPath), "configs/confogl/");
	BuildPath(Path_SM, cfgPath, sizeof(cfgPath), "../../cfg/");
	DirSeparator= cfgPath[strlen(cfgPath)-1];
}


bool:SetCustomCfg(const String:cfgname[])
{
	if(!strlen(cfgname))
	{
		customCfgPath[0]=0;
		ResetConVar(hCustomConfig);
		return true;
	}
	
	Format(customCfgPath, sizeof(customCfgPath), "%s%s%c%s", cfgPath, customCfgDir, DirSeparator, cfgname);
	if(!DirExists(customCfgPath))
	{
		LogError("[Configs] Custom config directory %s does not exist!", customCfgPath);
		// Revert customCfgPath
		customCfgPath[0]=0;
		return false;
	}
	new thislen = strlen(customCfgPath);
	if(thislen+1 < sizeof(customCfgPath))
	{
		customCfgPath[thislen] = DirSeparator;
		customCfgPath[thislen+1] = 0;
	}
	else
	{
		LogError("[Configs] Custom config directory %s path too long!", customCfgPath);
		customCfgPath[0]=0;
		return false;
	}
	
	SetConVarString(hCustomConfig, cfgname);
	
	return true;	
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

Handle:CreateConVarEx(const String:name[], const String:defaultValue[], const String:description[]="", flags=0, bool:hasMin=false, Float:min=0.0, bool:hasMax=false, Float:max=0.0)
{
	decl String:sBuffer[128], Handle:cvar;
	Format(sBuffer,sizeof(sBuffer),"%s%s",CVAR_PREFIX,name);
	flags = flags | CVAR_FLAGS;
	cvar = CreateConVar(sBuffer,defaultValue,description,flags,hasMin,min,hasMax,max);
	
	return cvar;
}