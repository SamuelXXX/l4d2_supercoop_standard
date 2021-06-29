#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <weapons>
#include <colors>

#define MAX_WEAPON_NAME_LENGTH 32

public Plugin:myinfo =
{
	name = "L4D Weapon Limits",
	author = "CanadaRox, Stabby",
	description = "Restrict weapons individually or together",
	version = "1.3.3",
	url = "https://www.github.com/CanadaRox/sourcemod-plugins/tree/master/weapon_limits"
}

enum LimitArrayEntry
{
	LAE_iLimit,
	LAE_WeaponArray[_:WeaponId/32+1]
}

new Handle:hLimitArray;
new bIsLocked;
new bIsIncappedWithMelee[MAXPLAYERS + 1];

public OnPluginStart()
{
	hLimitArray = CreateArray(_:LimitArrayEntry);
	L4D2Weapons_Init();

	StartPrepSDKCall(SDKCall_Entity);

	// Client that used the ammo spawn
	PrepSDKCall_AddParameter(SDKType_CBasePlayer, SDKPass_Pointer);

	RegServerCmd("l4d_wlimits_add", AddLimit_Cmd, "Add a weapon limit");
	RegServerCmd("l4d_wlimits_lock", LockLimits_Cmd, "Locks the limits to improve search speeds");
	RegServerCmd("l4d_wlimits_clear", ClearLimits_Cmd, "Clears all weapon limits (limits must be locked to be cleared)");

	HookEvent("player_incapacitated_start", OnIncap);
	HookEvent("revive_success", OnRevive);
	HookEvent("round_end", RoundEndEvent);
}

public OnMapStart()
{
	PrecacheSound("player/suit_denydevice.wav");
}

public RoundEndEvent(Handle:event, const String:name[], bool:dontBroadcast)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		bIsIncappedWithMelee[i] = false;
	}
}

public OnPluginEnd()
{
	ClearLimits();
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_WeaponCanUse, WeaponCanUse);
}

public OnClientDisconnect(client)
{
	SDKUnhook(client, SDKHook_WeaponCanUse, WeaponCanUse);
}

public Action:AddLimit_Cmd(args)
{
	if (bIsLocked)
	{
		PrintToServer("Limits have been locked");
		return Plugin_Handled;
	}
	else if (args < 2)
	{
		PrintToServer("Usage: l4d_wlimits_add <limit> <weapon1> <weapon2> ... <weaponN>");
		return Plugin_Handled;
	}

	decl String:sTempBuff[MAX_WEAPON_NAME_LENGTH];
	GetCmdArg(1, sTempBuff, sizeof(sTempBuff));

	new newEntry[LimitArrayEntry];
	decl WeaponId:wepid;
	newEntry[LAE_iLimit] = StringToInt(sTempBuff);

	for (new i = 2; i <= args; ++i)
	{
		GetCmdArg(i, sTempBuff, sizeof(sTempBuff));
		wepid = WeaponNameToId(sTempBuff);
		newEntry[LAE_WeaponArray][_:wepid/32] |= (1 << (_:wepid % 32));
	}
	PushArrayArray(hLimitArray, newEntry[0]);
	return Plugin_Handled;
}

public Action:LockLimits_Cmd(args)
{
	if (bIsLocked)
	{
		PrintToServer("Weapon limits already locked");
	}
	else
	{
		bIsLocked = true;
	}
}

public Action:ClearLimits_Cmd(args)
{
	if (bIsLocked)
	{
		bIsLocked = false;
		PrintToChatAll("[L4D Weapon Limits] Weapon limits cleared!");
		ClearLimits();
	}
}

public Action:WeaponCanUse(client, weapon)
{
	if (GetClientTeam(client) != 2 || !bIsLocked) return Plugin_Continue;
	new WeaponId:wepid = IdentifyWeapon(weapon);

	decl arrayEntry[LimitArrayEntry];
	new size = GetArraySize(hLimitArray);
	decl wep_slot, player_weapon, WeaponId:player_wepid;
	for (new i = 0; i < size; ++i)
	{
		GetArrayArray(hLimitArray, i, arrayEntry[0]);
		if (arrayEntry[LAE_WeaponArray][_:wepid/32] & (1 << (_:wepid % 32)) && GetWeaponCount(arrayEntry[LAE_WeaponArray]) >= arrayEntry[LAE_iLimit])
		{
			wep_slot = GetSlotFromWeaponId(wepid);
			player_weapon = GetPlayerWeaponSlot(client, _:wep_slot);
			player_wepid = IdentifyWeapon(player_weapon);
			if (!player_wepid || wepid == player_wepid || !(arrayEntry[LAE_WeaponArray][_:player_wepid/32] & (1 << (_:player_wepid % 32))))
			{
				if (player_wepid == WEPID_MELEE && wepid == WEPID_MELEE) return Plugin_Continue;
				CPrintToChat(client, "{blue}[{default}Weapon Limits{blue}]{default} 团队已达到该武器最大装备数：{green}%d", arrayEntry[LAE_iLimit]);
				EmitSoundToClient(client, "player/suit_denydevice.wav");
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}

public Action:OnIncap(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (GetClientTeam(client) == 2 && IdentifyWeapon(GetPlayerWeaponSlot(client, 1)) == WEPID_MELEE)
	{
		bIsIncappedWithMelee[client] = true;
	}
}

public Action:OnRevive(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "subject"));
	if (bIsIncappedWithMelee[client])
	{
		bIsIncappedWithMelee[client] = false;
	}
}

stock GetWeaponCount(const mask[])
{
	new count;
	decl WeaponId:wepid, j;
	for (new i = 1; i <= MaxClients; ++i)
	{
		if (IsClientInGame(i) && GetClientTeam(i) == 2 && IsPlayerAlive(i))
		{
			for (j = 0; j < 5; ++j)
			{
				wepid = IdentifyWeapon(GetPlayerWeaponSlot(i, j));
				if (mask[_:wepid/32] & (1 << (_:wepid % 32)) || (j == 1 && bIsIncappedWithMelee[i] && wepid != WEPID_PISTOL_MAGNUM))
				{
					++count;
				}
			}
		}
	}
	return count;
}

stock ClearLimits()
{
	if (hLimitArray != INVALID_HANDLE)
		ClearArray(hLimitArray);
}

stock CloseLimits()
{
	if (hLimitArray != INVALID_HANDLE)
		CloseHandle(hLimitArray)
}