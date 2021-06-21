#pragma semicolon 1

#if defined(AUTOVERSION)
#include "version.inc"
#else
#define PLUGIN_VERSION	"2.2.4"
#endif

#if !defined(DEBUG_ALL)
#define DEBUG_ALL 	0
#endif

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <left4dhooks>
#include <colors>

#include "modules/ClientSettings.sp"
#include "modules/UnreserveLobby.sp"

public Plugin:myinfo = 
{
	name = "Confogl's Competitive Mod",
	author = "Confogl Team",
	description = "A competitive mod for L4D2",
	version = PLUGIN_VERSION,
	url = "http://confogl.googlecode.com/"
}

public OnPluginStart()
{
	UL_OnModuleStart();
	
	CLS_OnModuleStart();
}

public OnPluginEnd()
{
}

public OnClientPutInServer(client)
{
	UL_OnClientPutInServer();
}