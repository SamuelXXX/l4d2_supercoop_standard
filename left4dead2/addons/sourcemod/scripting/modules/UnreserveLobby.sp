#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <left4dhooks>

UL_OnModuleStart()
{
	RegAdminCmd("sm_killlobbyres", UL_KillLobbyRes, ADMFLAG_BAN, "Forces the plugin to kill lobby reservation");
}

UL_OnClientPutInServer()
{
	
	L4D_LobbyUnreserve();
}

public Action:UL_KillLobbyRes(client,args)
{
	L4D_LobbyUnreserve();
}