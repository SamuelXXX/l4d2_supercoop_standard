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

#include "modules/ClientSettings.sp"

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
	CLS_OnModuleStart();
}

public OnPluginEnd()
{
}

public OnClientPutInServer(client)
{
}